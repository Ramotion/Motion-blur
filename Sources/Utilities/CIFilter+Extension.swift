import Foundation
import CoreImage
import SwiftUI


typealias Filter = (CIImage?) -> CIImage?


infix operator >>> : ApplyPrecedence


func >>> (lhs: @escaping Filter, rhs: @escaping Filter) -> Filter {
    return { image in rhs(lhs(image)) }
}


infix operator |> : ApplyPrecedence


precedencegroup ApplyPrecedence {
    associativity: left
    lowerThan: BitwiseShiftPrecedence
    higherThan: MultiplicationPrecedence
}


extension CIImage {
    static func |> (lhs: CIImage, rhs: CIFilter) -> CIImage {
        rhs.setValue(lhs, forKey: kCIInputImageKey)
        return rhs.outputImage ?? lhs
    }
    
    static func |> (lhs: CIImage, rhs: CIFilter?) -> CIImage {
        guard let filter = rhs else { return lhs }
        filter.setValue(lhs, forKey: kCIInputImageKey)
        return filter.outputImage ?? lhs
    }
    
    static func |> (lhs: CIImage, rhs: (CIImage) -> CIImage) -> CIImage {
        return rhs(lhs)
    }
}


extension CIFilter {
    
    func apply(to image: CIImage) -> CIImage {
        setValue(image, forKey: kCIInputImageKey)
        return outputImage ?? image
    }
}


extension CIFilter {
    /// [CIMotionBlur](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIMotionBlur)
    /// - Parameters:
    ///   - image: CIImage source
    ///   - angle: Motion angle
    ///   - radius: Blur radius
    /// - Returns: Generated CIFilter (you can get result with ["outputImage"])
    static func motionBlur(image: CIImage,
                           angle: Angle,
                           radius: Float) -> CIFilter? {
        
        guard let filter = CIFilter(name: "CIMotionBlur") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(NSNumber(value: radius), forKey: kCIInputRadiusKey)
        filter.setValue(NSNumber(value: angle.radians), forKey: kCIInputAngleKey)
        return filter
    }
    
    
    /// Custom motion blur filter
    /// - Parameters:
    ///   - image: CIImage source
    ///   - radius: Blur radius
    ///   - angle: Motion angle
    ///   - samplesCount: Pixels shifting iterations count
    /// - Returns: Generated CIFilter (you can get result with ["outputImage"])
    static func customMotionBlur(image: CIImage,
                                 radius: Float,
                                 angle: Angle,
                                 samplesCount: Int) -> CIFilter {
        
        let filter = MotionBlurFilter()
        filter.setDefaults()
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(NSNumber(value: radius), forKey: kCIInputRadiusKey)
        filter.setValue(NSNumber(value: angle.radians), forKey: kCIInputAngleKey)
        filter.setValue(NSNumber(value: samplesCount), forKey: kMotionBlurSamplesCountKey)
        return filter
    }
    
    
    /// Custom distorsion motion blur filter
    /// - Parameters:
    ///   - image: CIImage source
    ///   - radius: Blur radius
    ///   - angle: Motion angle
    ///   - samplesCount: Pixels shifting iterations count
    ///   - scale: Distorsion scale ratio (`0` - without distorsion)
    /// - Returns: Generated CIFilter (you can get result with ["outputImage"])
    static func motionDistorsion(image: CIImage,
                                 radius: Float,
                                 angle: Angle,
                                 samplesCount: Int,
                                 scale: Float) -> CIFilter {
        
        let filter = MotionDistorsion()
        filter.setDefaults()
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(NSNumber(value: radius), forKey: kCIInputRadiusKey)
        filter.setValue(NSNumber(value: angle.radians), forKey: kCIInputAngleKey)
        filter.setValue(NSNumber(value: samplesCount), forKey: kMotionBlurSamplesCountKey)
        filter.setValue(NSNumber(value: scale), forKey: kCIInputScaleKey)
        return filter
    }
}
