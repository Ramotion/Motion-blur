import Foundation
import CoreImage


let kMotionBlurSamplesCountKey = "kMotionBlurSamplesCountKey"


final class MotionBlurFilter: CIFilter {
    
    static var kernel: CIKernel? = { () -> CIKernel in
        guard let url = Bundle(for: BundleToken.self).url(forResource: "MotionBlur", withExtension: "metallib"),
              let data = try? Data(contentsOf: url),
              let result = try? CIKernel(functionName: "motionBlur", fromMetalLibraryData: data)
        else { fatalError("Coudn't load filter kernel sources") }
        return result
    }()
    
    private(set) var inputImage: CIImage?
    private(set) var angle: Float = Float.pi / 2
    private(set) var radius: Float = 40
    private(set) var numberOfSample: Int = 5
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == kMotionBlurSamplesCountKey {
            if let number = value as? NSNumber {
                numberOfSample = number.intValue
            }
        } else if key == kCIInputRadiusKey {
            if let number = value as? NSNumber {
                radius = number.floatValue
            }
        } else if key == kCIInputAngleKey {
            if let number = value as? NSNumber {
                angle = number.floatValue
            }
        } else if key == kCIInputImageKey {
            if let image = value as? CIImage {
                inputImage = image
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func value(forKey key: String) -> Any? {
        
        if key == kMotionBlurSamplesCountKey {
            return NSNumber(value: numberOfSample)
        } else if key == kCIInputRadiusKey {
            return NSNumber(value: radius)
        } else if key == kCIInputAngleKey {
            return NSNumber(value: angle)
        } else if key == kCIInputImageKey {
            return inputImage
        } else {
            return super.value(forKey: key)
        }
    }
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage, let kernel = MotionBlurFilter.kernel else { return nil }
        
        let x = CGFloat(radius * cosf(angle))
        let y = CGFloat(radius * sin(angle))
        let extent = inputImage.extent.insetBy(dx: -abs(x), dy: -abs(y))
        
        return kernel.apply(extent: extent, roiCallback: { (index, rect) -> CGRect in
            rect.insetBy(dx: -abs(x), dy: -abs(y))
        }, arguments: [inputImage, CIVector(x: x, y: y), numberOfSample])
    }
}
