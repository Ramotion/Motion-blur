import Foundation
import UIKit


public extension UIView {

    /// good explanation of differences between drawViewHierarchyInRect:afterScreenUpdates: and renderInContext: https://github.com/radi/LiveFrost/issues/10#issuecomment-28959525
    
    func snapshotImage(opaque: Bool = true, scale: CGFloat = UIScreen.main.scale, afterScreenUpdates: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, scale)
        drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }

    func snapshotLayer(opaque: Bool = true, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
