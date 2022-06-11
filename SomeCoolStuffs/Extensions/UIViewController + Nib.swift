import UIKit

extension UIViewController {
 
    static func loadNib<T: UIViewController>() -> T {
        return T(nibName: String(describing: T.self), bundle: nil)
    }
}
