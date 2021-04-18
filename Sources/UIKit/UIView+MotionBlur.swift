import UIKit
import CoreImage


extension UIView {
    
    private static var kBlurLayer: UInt8 = 0
    private static var kDisplayLink: UInt8 = 0
    private static var kLastPosition: UInt8 = 0

    private(set) var blurLayer: CALayer? {
        get { getAssociatedObject(&UIView.kBlurLayer) }
        set { setAssociatedObject(&UIView.kBlurLayer, newValue) }
    }

    private var displayLink: CADisplayLink? {
        get { getAssociatedObject(&UIView.kDisplayLink) }
        set { setAssociatedObject(&UIView.kDisplayLink, newValue) }
    }

    private var lastPosition: NSValue? {
        get { getAssociatedObject(&UIView.kLastPosition) }
        set { setAssociatedObject(&UIView.kLastPosition, newValue) }
    }

    public func enablePositionMotionBlur(type: MotionBlurType, completion: ((Bool) -> Void)? = nil) {
        addMotionBlur(type: type) { success in
            guard success else { completion?(success); return }
            self.blurLayer?.opacity = 0
            
            let displayLink = CADisplayLink(target: self, selector: #selector(self.tick(displayLink:)))
            displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
            self.displayLink = displayLink

            completion?(success)
        }
    }

    public func disablePositionMotionBlur() {
        displayLink?.invalidate()
        displayLink = nil
        blurLayer?.removeFromSuperlayer()
    }

    @objc private func tick(displayLink: CADisplayLink) {
        let realPosition = layer.presentation()?.position ?? layer.position

        if let lastPostionValue = lastPosition {
            /// TODO: there's an assumption that the animation has constant FPS. The following code should also use a timestamp of the previous frame.

            let lastPositionPoint = lastPostionValue.cgPointValue
            let dx = Float(abs(realPosition.x - lastPositionPoint.x))
            let dy = Float(abs(realPosition.y - lastPositionPoint.y))
            let delta = sqrtf(powf(dx, 2) + powf(dy, 2))

            /// A rough approximation of a good looking blur. The larger the speed, the larger opacity of the blur layer.
            let unboundedOpacity = log2f(delta) / 5
            let opacity = unboundedOpacity.limited(0, 1)
            blurLayer?.opacity = opacity
            
            ///print("realPosition: \(realPosition), delta: \(delta), opacity: \(opacity)")
        }

        lastPosition = NSValue(cgPoint: realPosition)
    }
}


//MARK: - Static motion blur
extension UIView {
    
    public func addMotionBlur(type: MotionBlurType, initialOpacity: Float = 1, completion: ((Bool) -> Void)? = nil) {
        guard let snapshot = self.snapshotLayer(opaque: false, scale: 0) else {
            completion?(false)
            return
        }

        DispatchQueue.global(qos: .default).async {
            guard let blurredImageRef: CGImage = snapshot.applyMotionBlur(type: type) else {
                completion?(false)
                return
            }

            DispatchQueue.main.async {
                self.removeMotionBlur()

                let blurLayer = CALayer()
                blurLayer.contents = blurredImageRef
                blurLayer.opacity = initialOpacity

                let scale = UIScreen.main.scale
                let difference = CGSize(width: CGFloat(blurredImageRef.width) / scale - self.frame.width, height: CGFloat(blurredImageRef.height) / scale - self.frame.height)
                blurLayer.frame = self.bounds.insetBy(dx: -difference.width / 2, dy: -difference.height / 2)

                blurLayer.actions = [ "opacity": NSNull() ]
                self.layer.addSublayer(blurLayer)
                self.blurLayer = blurLayer
                
                completion?(true)
            }
        }
    }
    
    public func updateMotionBlur(type: MotionBlurType, opacity: Float = 1, completion: ((Bool) -> Void)? = nil) {
        guard let blurLayer = self.blurLayer else {
            completion?(false)
            return
        }
    
        blurLayer.isHidden = true
        guard let snapshot = self.snapshotLayer(opaque: false, scale: 0) else {
            completion?(false)
            return
        }

        blurLayer.isHidden = false
        DispatchQueue.global(qos: .default).async {
            guard let blurredImageRef: CGImage = snapshot.applyMotionBlur(type: type) else {
                completion?(false)
                return
            }
            
            DispatchQueue.main.async {
                blurLayer.contents = blurredImageRef
                blurLayer.opacity = opacity
                
                let scale = UIScreen.main.scale
                let difference = CGSize(width: CGFloat(blurredImageRef.width) / scale - self.frame.width, height: CGFloat(blurredImageRef.height) / scale - self.frame.height)
                blurLayer.frame = self.bounds.insetBy(dx: -difference.width / 2, dy: -difference.height / 2)
                completion?(true)
            }
        }
    }
    
    public func removeMotionBlur() {
        blurLayer?.removeFromSuperlayer()
    }
}
