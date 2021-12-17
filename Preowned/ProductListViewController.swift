import UIKit

class ProductListViewController: UIViewController {
    let collectionView = CollectionView.waterfall()
    let section = CollectionViewViewModel()
    var isFirstShow = true
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexColor: "#F5F7F8")
        //self.navigationController?.navigationBar.barTintColor=UIColor(hexColor: "#FFFF00")
        
        //self.navigationController?.hidesBarsOnSwipe=true
        
        title = "Discover"
        collectionView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navHeight - tabbarHeight)
        collectionView.allDelegate = self
        collectionView.backgroundColor = UIColor(hexColor: "#F5F7F8")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.contentInset.bottom = tabbarHeight
        
        section.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        section.columnCount = 2
        section.minimumColumnSpacing = 10
        section.minimumInteritemSpacing = 10
        section.items = [CollectionViewItemProtocol]()
        request()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFirstShow {
            request()
        }
        isFirstShow = false
        
        let name = UserDefaults.standard.string(forKey: "mine_name") ?? ""
        if name.count == 0 {
            LoginView().show()
        }
    }
    
    func request() {
        section.items?.removeAll()
        print("<<<")
        DispatchQueue.main.async {
            DataManager.shared.getData()
        }
        let array = DataManager.shared.dataSource
        for model in array {
            let cellModel = ProductCollectionViewCellModel()
            cellModel.model = model
            section.items?.append(cellModel)
        }
        collectionView.viewModel = [section]
    }
}

extension ProductListViewController: CollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let array = self.collectionView.viewModel.first?.items else { return }
        guard array.count > indexPath.row else { return }
        guard let item = array[indexPath.row] as? ProductCollectionViewCellModel else { return }
        let vc = ProductDetailViewController()
        vc.model = item.model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
