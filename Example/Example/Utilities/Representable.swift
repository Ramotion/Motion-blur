import Foundation
import SwiftUI


struct ViewRepresentable<V : UIView>: UIViewRepresentable {
    typealias Updater = (V, Context) -> Void

    private let make: () -> V
    private let update: (V) -> Void

    init(view make: @escaping @autoclosure () -> V, update: @escaping (V) -> Void = { _ in }) {
        self.make = make
        self.update = update
    }

    func makeUIView(context: Context) -> V {
        make()
    }

    func updateUIView(_ view: V, context: Context) {
        update(view)
    }
}


struct VCRepresentable<VC: UIViewController>: UIViewControllerRepresentable {
    
    private let make: () -> VC
    private let update: (VC) -> Void
    
    init(vc make: @escaping @autoclosure () -> VC, update: @escaping (VC) -> Void = { _ in }) {
        self.make = make
        self.update = update
    }

    func makeUIViewController(context: Context) -> VC {
        make()
    }

    func updateUIViewController(_ uiViewController: VC, context: Context) {
        update(uiViewController)
    }
}
