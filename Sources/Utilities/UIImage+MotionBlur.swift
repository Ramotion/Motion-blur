import Foundation
import UIKit
import SwiftUI


public enum MotionBlurType {
    case custom(angle: Angle, radius: Float = 40, samplesCount: Int = 5)
    case buildIn(angle: Angle, radius: Float = 20)
    case motionDistorsion(angle: Angle, scale: Float, radius: Float = 40, samplesCount: Int = 5)
    
    public static let `default` = MotionBlurType.custom(angle: Angle(degrees: 90))
}


extension UIImage {
    
    public func applyMotionBlur(type: MotionBlurType) -> CGImage? {
        if let ciImage: CIImage = applyMotionBlur(type: type) {
            let context = CIContext(options: [CIContextOption.priorityRequestLow: NSNumber(value: true)])
            let blurredImageRef = context.createCGImage(ciImage, from: ciImage.extent)
            return blurredImageRef
        } else {
            return nil
        }
    }
    
    public func applyMotionBlur(type: MotionBlurType) -> CIImage? {
        guard let inputImage: CIImage = ciImage ?? cgImage.map({ CIImage(cgImage: $0) }) else {
            return nil
        }
        
        switch type {
        case let .custom(angle, radius, samplesCount):
            let f = CIFilter.customMotionBlur(image: inputImage, radius: radius, angle: angle, samplesCount: samplesCount)
            return inputImage |> f
            
        case let .buildIn(angle, radius):
            let f = CIFilter.motionBlur(image: inputImage, angle: angle, radius: radius)
            return inputImage |> f
            
        case let .motionDistorsion(angle, scale, radius, samplesCount):
            let f = CIFilter.motionDistorsion(image: inputImage, radius: radius, angle: angle, samplesCount: samplesCount, scale: scale)
            return inputImage |> f
        }
    }
}
