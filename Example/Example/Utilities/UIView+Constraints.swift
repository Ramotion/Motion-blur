import Foundation
import UIKit


extension UIView {
    func edgesToSuperview() {
        guard let superview = superview else {
            assertionFailure("View is not in the hierarchy")
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }

    
    func centerInSuperview() {
        guard let superview = superview else {
            assertionFailure("View is not in the hierarchy")
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints([
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
        ])
    }
}
