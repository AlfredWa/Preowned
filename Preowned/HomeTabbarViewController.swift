import UIKit

public enum Item : Int {
    case home
    case sale
    case user
}
//tabbar 界面
public class HomeTabbarViewController : UITabBarController {
    
    static var defaultSelectedItem: Item = .home
            
    public init() {
        super.init(nibName: nil, bundle: nil)
    
        self.tabBar.backgroundColor = UIColor.white
        
        let homeVC = ProductListViewController()
        homeVC.hidesBottomBarWhenPushed = false

        let homeVCNav = NavigationController.init(rootViewController: homeVC)
        homeVC.tabBarItem = tabBarItem(image: UIImage(named: "productList_unselected"), selectedImage: UIImage(named: "productList_selected"), title: "Discover")
        
        let saleVC = SaleViewController()
        saleVC.hidesBottomBarWhenPushed = false
        let saleVCNav = NavigationController.init(rootViewController: saleVC)
        saleVC.tabBarItem = tabBarItem(image: UIImage(named: "sale_unselected"), selectedImage: UIImage(named: "sale_selected"), title: "Post")
        
        let userVC = UserViewController()
        userVC.hidesBottomBarWhenPushed = false
        let userVCNav = NavigationController.init(rootViewController: userVC)
        userVC.tabBarItem = tabBarItem(image: UIImage(named: "my_unselected"), selectedImage: UIImage(named: "my_selected"), title: "My PreOwned")
        
        self.viewControllers = [homeVCNav, saleVCNav, userVCNav]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        //去除导航栏下面的线
        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        navigationBar.backIndicatorImage = newImage?.withRenderingMode(.alwaysOriginal)
        navigationBar.backIndicatorTransitionMaskImage = navigationBar.backIndicatorImage
        navigationBar.shadowImage = .init()
        
        navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:UIColor(hexColor: "#F25555"), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        
        //tabbar字体颜色
        tabBar.tintColor = UIColor(hexColor: "#F25555")
    }
}

extension HomeTabbarViewController {
    var selectedItem: Item? {
        get {
            Item(rawValue: selectedIndex)
        } set {
            guard let item = newValue, item.rawValue < (tabBar.items?.count ?? 0) else {
                return
            }
            selectedIndex = item.rawValue
        }
    }

    @discardableResult
   func forceSwitch(atNewItem item: Item) -> UINavigationController {
        let selectedViewController = self.selectedViewController as? UINavigationController
        selectedItem = item
        selectedViewController?.popViewController(animated: false)
        while presentedViewController != nil {
            dismiss(animated: false)
        }
        return selectedViewController!
    }
    
    func tabBarItem(image: UIImage?, selectedImage: UIImage?, title: String) -> UITabBarItem {
        let item = UITabBarItem.init(title: title, image: image?.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        return item
    }
}

extension HomeTabbarViewController : UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController) ?? 0
        selectedItem = Item(rawValue: index)
    }
}
