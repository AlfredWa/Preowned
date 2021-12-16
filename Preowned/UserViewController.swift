import UIKit
import Firebase

//mine 界面
class UserViewController: UIViewController {
    let tableView = BaseTableView()
    var isFirstShow = true

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My PreOwned"
        view.backgroundColor = UIColor(hexColor: "#F5F7F8")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "back"), style: .done, target: self, action: #selector(loginout))
        
        tableView.allDelegate = self
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset.bottom = bottomSafeAreaInset
        tableView.isScrollEnabled = false
        tableView.backgroundColor = UIColor(hexColor: "#F5F7F8")

        view.addSubview(tableView)
        
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navHeight - tabbarHeight)
        
        request()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //判断是否刷新数据
        if !isFirstShow {
            request()
        }
        isFirstShow = false
    }
    //退出登录
    @objc func loginout() {
        let v = UIAlertController.init(title: "Are you sure to log out of the account?", message: nil, preferredStyle: .alert)
        v.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        v.addAction(UIAlertAction.init(title: "YES", style: .default, handler: { _ in
//            UserDefaults.standard.removeObject(forKey: "mine_name")
//            UserDefaults.standard.removeObject(forKey: "mine_password")
//            UserDefaults.standard.synchronize()
//            let view = LoginView()
//            view.confirmAction = { [weak self] in
//                self?.request()
//            }
//            view.show()
            do{
                try FirebaseAuth.Auth.auth().signOut()
                UserDefaults.standard.removeObject(forKey: "mine_name")
                let view = LoginView()
                view.confirmAction = { [weak self] in
                    self?.request()
                }
                view.show()
            }
            
            catch{
                
            }
        }))
        self.present(v, animated: true, completion: nil)
        
    }
    //组装数据
    func request() {
        let section = TableViewViewModel()
        section.items = [TableViewCellProtocol]()
        
        let mineItem = MineTableViewCellModel()
        mineItem.price = "0"
        section.items?.append(mineItem)
        
        for item in DataManager.shared.dataSource {
            if item.userName == UserDefaults.standard.string(forKey: "mine_name") {
                let productItem = ProductTableViewCellModel()
                productItem.model = item
                section.items?.append(productItem)
            }
        }
        tableView.viewModel = [section]
    }
}

extension UserViewController: TableViewDelegate {
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let array = self.tableView.viewModel.first?.items else { return }
        guard array.count > indexPath.row else { return }
        guard let item = array[indexPath.row] as? ProductTableViewCellModel else { return }
        let vc = ProductDetailViewController()
        vc.model = item.model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
