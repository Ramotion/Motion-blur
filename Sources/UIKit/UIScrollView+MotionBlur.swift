import Foundation
import UIKit
import Combine


extension UIScrollView {
    
    public enum Axis {
        case vertical
        case horizontal
        
        var angle: Float {
            return self == .vertical ? Float.pi / 2 : 0
        }
    }
    
    private static var kContentOffsetObserver: UInt8 = 0
    private static var kOpacityObserver: UInt8 = 0
    private static var kMotionBlurAxis: UInt8 = 0
    private static var kScrollViewBroker: UInt8 = 0
    
    private(set) var contentOffsetObserver: NSKeyValueObservation? {
        get { getAssociatedObject(&UIScrollView.kContentOffsetObserver) }
        set { setAssociatedObject(&UIScrollView.kContentOffsetObserver, newValue) }
    }
    
    private(set) var opacityObserver: AnyCancellable? {
        get { getAssociatedObject(&UIScrollView.kOpacityObserver) }
        set { setAssociatedObject(&UIScrollView.kOpacityObserver, newValue) }
    }
    
    private(set) var motionBlurAxis: Axis? {
        get { getAssociatedObject(&UIScrollView.kMotionBlurAxis) }
        set { setAssociatedObject(&UIScrollView.kMotionBlurAxis, newValue) }
    }
    
    private var scrollBroker: BlurredScrollViewBroker? {
        get { getAssociatedObject(&UIScrollView.kScrollViewBroker) }
        set { setAssociatedObject(&UIScrollView.kScrollViewBroker, newValue) }
    }
    
    open override func addSubview(_ view: UIView) {
        super.addSubview(view)
        if let broker = scrollBroker {
            view.addMotionBlur(type: broker.options.blurType, initialOpacity: 0)
        }
    }
    
    public func enableMotionBlur(axis: Axis = .vertical, options: MotionBlurOptions = .default) {
        disableMotionBlur()
        
        motionBlurAxis = axis
        let broker = BlurredScrollViewBroker(options: options)
        scrollBroker = broker
        
        opacityObserver = broker.blurRatioSubject.sink {[weak self] opacity in
            self?.subviews.forEach { $0.blurLayer?.opacity = Float(opacity) }
        }
        
        contentOffsetObserver = observe(\.contentOffset, options: [.new]) {[weak broker] (sv, value) in
            guard let v = value.newValue else { return }
            let offset: CGFloat = axis == .vertical ? v.y : v.x
            broker?.updateScrollOffset(offset)
        }
    
        subviews.forEach { $0.addMotionBlur(type: options.blurType, initialOpacity: 0) }
    }
    
    public func disableMotionBlur() {
        motionBlurAxis = nil
        contentOffsetObserver = nil
        opacityObserver = nil
        scrollBroker = nil
        subviews.forEach { $0.removeMotionBlur() }
    }
}
