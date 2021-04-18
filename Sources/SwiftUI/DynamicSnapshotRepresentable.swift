import Foundation
import SwiftUI


public struct DynamicSnapshotRepresentable<Content: View>: UIViewControllerRepresentable {
    
    public typealias UIViewControllerType = DynamicSnapshotController<Content>
    
    private let axis: Axis
    private let opacity: Double
    private let scale: Double
    private let content: () -> Content
    
    public init(axis: Axis = .vertical,
         opacity: Double,
         scale: Double,
         @ViewBuilder content: @escaping () -> Content) {
        
        self.axis = axis
        self.opacity = opacity
        self.scale = scale
        self.content = content
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    public func makeUIViewController(context: Context) -> DynamicSnapshotController<Content> {
        let vc = DynamicSnapshotController(rootView: content())
        vc.axis = axis
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.opacity = opacity
        uiViewController.scale = scale
    }

    public final class Coordinator { }
}


//MARK: - Hosting view controller
public final class DynamicSnapshotController<T: View>: UIHostingController<T> {
    
    private let metalImageView = MetalImageView()
    fileprivate var axis: Axis = .vertical
    fileprivate var opacity: Double = 0
    fileprivate var scale: Double = 1
    
    override init(rootView: T) {
        super.init(rootView: rootView)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private var displayLink: CADisplayLink?
    
    private func setup() {
        view.addSubview(metalImageView)
        metalImageView.isUserInteractionEnabled = false
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startDisplayLink()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopDisplayLink()
    }

    private func startDisplayLink() {
        stopDisplayLink()

        let displayLink = CADisplayLink(target: self, selector: #selector(self.tick(displayLink:)))
        displayLink.add(to: .main, forMode: .tracking)
        self.displayLink = displayLink
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func tick(displayLink: CADisplayLink) {
        self.updateBlurOverlay()
    }
    
    private func updateBlurOverlay() {
        metalImageView.isHidden = true
        
        let angle = axis == .vertical ? Angle(degrees: 90) : Angle.zero
        let type = MotionBlurType.motionDistorsion(angle: angle, scale: Float(scale))
        
        guard let snapshot = view.snapshotLayer(scale: 0),
              let blurred: CIImage = snapshot.applyMotionBlur(type: type) else {
            return
        }
        
        let scale = UIScreen.main.scale
        let difference = CGSize(width: CGFloat(blurred.extent.width) / scale - view.frame.width, height: CGFloat(blurred.extent.height) / scale - view.frame.height)
        
        let blurFrame = view.bounds.insetBy(dx: -difference.width / 2, dy: -difference.height / 2)
        metalImageView.frame = blurFrame
        metalImageView.alpha = CGFloat(opacity)
        metalImageView.isHidden = false
        metalImageView.image = blurred
    }
}
