import UIKit

class NavigationController : UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.responds(to: #selector(getter:interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        topViewController?.navigationItem.backBarButtonItem = .init(title: "", style: .plain, target: nil, action: nil)
        viewController.hidesBottomBarWhenPushed = !viewControllers.isEmpty
        super.pushViewController(viewController, animated: animated)
    }
}

extension NavigationController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if gestureRecognizer == self.interactivePopGestureRecognizer {
                if self.viewControllers.count < 2 ||
                    self.visibleViewController == viewControllers.first {
                    return false
                }
            }
            return true
    }
}
