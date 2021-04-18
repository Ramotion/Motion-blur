import Foundation
import SwiftUI
import Combine


struct StaticSnapshotRepresentable<Content: View>: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = StaticShapshotController<Content>
    
    private let blurType: MotionBlurType
    private let opacitySubject: PassthroughSubject<Double,Never>
    private let content: () -> Content
    
    init(blurType: MotionBlurType,
         opacitySubject: PassthroughSubject<Double,Never>,
         @ViewBuilder content: @escaping () -> Content) {
        
        self.blurType = blurType
        self.opacitySubject = opacitySubject
        self.content = content
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIViewController(context: Context) -> StaticShapshotController<Content> {
        let vc = StaticShapshotController(rootView: content(), blurType: blurType)
        vc.opacitySubject = opacitySubject
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    final class Coordinator { }
}


final class StaticShapshotController<T: View>: UIHostingController<T> {
    
    private var opacityObserver: AnyCancellable?
    
    var opacitySubject: PassthroughSubject<Double,Never>? {
        didSet {
            opacityObserver?.cancel()
            opacityObserver = nil
            
            guard let subject = opacitySubject else { return }
            opacityObserver = subject.sink {[weak self] value in
                self?.blurLayer.opacity = Float(value)
            }
        }
    }
    
    private let blurLayer = CALayer()
    private let blurType: MotionBlurType
    
    init(rootView: T, blurType: MotionBlurType) {
        self.blurType = blurType
        super.init(rootView: rootView)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.blurType = MotionBlurType.custom(angle: Angle.zero, radius: 20, samplesCount: 5)
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = false
        view.layer.addSublayer(blurLayer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ///it is better to place it in viewDidLoad, but it doesn't calls for UIHostingController
        renderMotionLayer()
    }
    
    private func renderMotionLayer(opacity: Float = 0) {
        blurLayer.isHidden = true
        guard let snapshot = view.snapshotLayer(opaque: false, scale: 0) else { return }
        guard let blurred: CGImage = snapshot.applyMotionBlur(type: blurType) else { return }
        
        let scale = UIScreen.main.scale
        let difference = CGSize(width: CGFloat(blurred.width) / scale - view.frame.width, height: CGFloat(blurred.height) / scale - view.frame.height)
        blurLayer.frame = view.bounds.insetBy(dx: -difference.width / 2, dy: -difference.height / 2)
        blurLayer.contents = blurred
        blurLayer.opacity = opacity
        blurLayer.removeAllAnimations()
        blurLayer.isHidden = false
    }
}
