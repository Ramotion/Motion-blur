import Foundation
import MotionBlur
import SwiftUI


extension MotionBlurType {
    static var useCustom: Bool = true
    
    init(angle: Float) {
        if MotionBlurType.useCustom {
            self = MotionBlurType.custom(angle: Angle(radians: Double(angle)))
        } else {
            self = MotionBlurType.buildIn(angle: Angle(radians: Double(angle)))
        }
    }
}
