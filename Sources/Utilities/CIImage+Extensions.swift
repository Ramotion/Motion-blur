import Foundation
import CoreImage


extension CIImage {
    
    var width: CGFloat {
        return extent.width
    }
    
    var height: CGFloat {
        return extent.height
    }
}
