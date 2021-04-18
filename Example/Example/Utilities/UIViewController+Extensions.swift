import Foundation
import UIKit


extension UIViewController {

    public static var current: UIViewController? {
        if let controller = UIWindow.current?.rootViewController {
            return findCurrent(controller)
        }
        return nil
    }

    private static func findCurrent(_ controller: UIViewController) -> UIViewController {
        if let controller = controller.presentedViewController {
            return findCurrent(controller)
        } else if let controller = controller as? UISplitViewController, let lastViewController = controller.viewControllers.first, controller.viewControllers.count > 0 {
            return findCurrent(lastViewController)
        } else if let controller = controller as? UINavigationController, let topViewController = controller.topViewController, controller.viewControllers.count > 0 {
            return findCurrent(topViewController)
        } else if let controller = controller as? UITabBarController, let selectedViewController = controller.selectedViewController, (controller.viewControllers?.count ?? 0) > 0 {
            return findCurrent(selectedViewController)
        } else {
            return controller
        }
    }
}
