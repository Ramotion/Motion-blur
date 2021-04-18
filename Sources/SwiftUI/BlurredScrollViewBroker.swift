import Foundation
import UIKit
import Combine


public struct MotionBlurOptions {
    public let captureInterval: TimeInterval
    public let blurRatioDelta: Double
    public let speedLimit: CGFloat
    public let blurType: MotionBlurType
    
    public init(captureInterval: TimeInterval = 0.1,
                blurRatioDelta: Double = 0.07,
                speedLimit: CGFloat = 22,
                blurType: MotionBlurType = .default) {
        
        self.captureInterval = captureInterval
        self.blurRatioDelta = blurRatioDelta
        self.speedLimit = speedLimit
        self.blurType = blurType
    }
    
    public static let `default` = MotionBlurOptions()
}


public final class BlurredScrollViewBroker: ObservableObject {
    
    public private(set) var blurRatio: Double = 0
    
    public let blurRatioSubject = PassthroughSubject<Double,Never>()
    public let options: MotionBlurOptions
    
    private var previousContentOffset: CGFloat?
    private var previousCaptureTime: TimeInterval?
    
    private var displayLink: CADisplayLink?
    private var targetBlurRatio: Double = 0
        
    private var onTick: ((_ blurRatio: Double) -> Void)?
    
    public init(options: MotionBlurOptions = .default, onTick: ((_ blurRatio: Double) -> Void)? = nil) {
        self.options = options
        self.onTick = onTick
        startDisplayLink()
    }

    public func startDisplayLink() {
        stopDisplayLink()

        let displayLink = CADisplayLink(target: self, selector: #selector(self.tick(displayLink:)))
        displayLink.add(to: RunLoop.main, forMode: .common)
        self.displayLink = displayLink
    }

    public func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func tick(displayLink: CADisplayLink) {
        let delta = targetBlurRatio == 0 ? -options.blurRatioDelta : options.blurRatioDelta
        blurRatio = (blurRatio + delta).limited(0, 1)
        blurRatioSubject.send(blurRatio)
        onTick?(blurRatio)
    }
    
    func updateScrollOffset(_ offset: CGFloat) {
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        guard let previousTime = previousCaptureTime,
              let previousOffset = previousContentOffset else {
            previousCaptureTime = currentTime
            previousContentOffset = offset
            return
        }
                  
        previousContentOffset = offset
        
        let timeDiff = currentTime - previousTime
        if timeDiff > options.captureInterval {
            let scrollSpeed = abs(offset - previousOffset) /// points per seconds
            
            if scrollSpeed > options.speedLimit {
                targetBlurRatio = 1
            } else {
                targetBlurRatio = 0
            }
            previousCaptureTime = currentTime
        }
    }
}
