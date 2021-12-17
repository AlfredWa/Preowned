import UIKit

protocol TableViewCellProtocol: ListItemProtocol {
}

protocol TableViewCellDefaultProtocol: TableViewCellProtocol, ListItemDefaultProtocol { }

class TableViewViewModel: NSObject {
    var tag: String?
    var header: TableViewCellProtocol?
    var items: [TableViewCellProtocol]?
    var footer: TableViewCellProtocol?
}

protocol TableViewDelegate: NSObjectProtocol {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

extension TableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}


class BaseTableView: UITableView {
    weak var allDelegate: TableViewDelegate?
    
    var viewModel = [TableViewViewModel]() {
        didSet {
            for section in viewModel {
                if let header = section.header, header.registClass.isSubclass(of: UITableViewHeaderFooterView.self) {
                    register(header.registClass, forHeaderFooterViewReuseIdentifier: header.identifa)
                }
                if let cells = section.items {
                    for cell in cells {
                        register(cell.registClass, forCellReuseIdentifier: cell.identifa)
                    }
                }
                if let footer = section.footer, footer.registClass.isSubclass(of: UITableViewHeaderFooterView.self) {
                    register(footer.registClass, forHeaderFooterViewReuseIdentifier: footer.identifa)
                }
            }
            reloadData()
        }
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        keyboardDismissMode = .onDrag
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        dataSource = self
        keyboardDismissMode = .onDrag
    }
}

extension BaseTableView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let defReturn: Int = {
            return 0
        }()

        guard section < viewModel.count else {
            return defReturn
        }

        return viewModel[section].items?.count ?? defReturn
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let defReturn = {
            return UITableViewCell()
        }

        guard indexPath.section < viewModel.count, indexPath.row < viewModel[indexPath.section].items?.count ?? 0 else {
            return defReturn()
        }

        guard let viewModel = viewModel[indexPath.section].items?[indexPath.row] else {
            return defReturn()
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.identifa) else {
            return defReturn()
        }
        cell.frame = tableView.bounds
        viewModel.fillModel(item: cell)
        cell.sizeToFit()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let defReturn: CGFloat = {
            return 0
        }()

        guard indexPath.section < viewModel.count, indexPath.row < viewModel[indexPath.section].items?.count ?? 0 else {
            return defReturn
        }

        guard let viewModel = viewModel[indexPath.section].items?[indexPath.row] else {
            return defReturn
        }
        guard let cell = dequeueCacheCell(withIdentifier: viewModel.identifa) else {
            return defReturn
        }

        viewModel.fillModel(item: cell)
        return cell.sizeThatFits(tableView.frame.size).height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.keyWindow?.endEditing(true)
        allDelegate?.tableView(tableView, didSelectRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < viewModel.count else {
            return nil
        }

        guard let header = viewModel[section].header else {
            return nil
        }

        guard let view = dequeueReusableHeaderFooterView(withIdentifier: header.identifa) else {
            return nil
        }

        view.frame = tableView.bounds
        header.fillModel(item: view)
        view.sizeToFit()
        return view
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section < viewModel.count else {
            return nil
        }

        guard let footer = viewModel[section].footer else {
            return nil
        }

        guard let view = dequeueReusableHeaderFooterView(withIdentifier: footer.identifa) else {
            return nil
        }

        view.frame = tableView.bounds
        footer.fillModel(item: view)
        view.sizeToFit()
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let defReturn: CGFloat = {
            return 0.0000000001
        }()

        guard section < viewModel.count else {
            return defReturn
        }

        guard let viewModel = viewModel[section].header else {
            return defReturn
        }

        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: viewModel.identifa) else {
            return defReturn
        }

        viewModel.fillModel(item: cell)
        return cell.sizeThatFits(tableView.frame.size).height
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let defReturn: CGFloat = {
            return 0.0000000001
        }()

        guard section < viewModel.count else {
            return defReturn
        }

        guard let viewModel = viewModel[section].footer else {
            return defReturn
        }
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: viewModel.identifa) else {
            return defReturn
        }

        viewModel.fillModel(item: cell)
        return cell.sizeThatFits(tableView.frame.size).height
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(cellClass: T.Type, cellStyle: UITableViewCell.CellStyle = .default) -> T {
        let cellIdentifier = "\(cellClass)"
        return self.dequeueReusableCell(withIdentifier: cellIdentifier) as? T
            ?? T(style: cellStyle, reuseIdentifier: cellIdentifier)
    }
}

extension UITableView {
    fileprivate struct StaticKeys {
        static var cacheForHeaderFooterAndCell = "UITableView.cacheForHeaderFooterAndCell"
    }

    fileprivate var uitableview_cacheForHeaderFooterAndCell: NSCache<NSString, UIView> {
        if let cache = objc_getAssociatedObject(self, &StaticKeys.cacheForHeaderFooterAndCell) as? NSCache<NSString, UIView> {
            return cache
        } else {
            let cache = NSCache<NSString, UIView>()
            objc_setAssociatedObject(self, &StaticKeys.cacheForHeaderFooterAndCell, cache, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return cache
        }
    }
    
    func dequeueCacheCell<T: UITableViewCell>(withIdentifier identifier: String) -> T? {
        if let cell = uitableview_cacheForHeaderFooterAndCell.object(forKey: identifier as NSString) {
            return cell as? T
        }

        if let cell = dequeueReusableCell(withIdentifier: identifier) {
            uitableview_cacheForHeaderFooterAndCell.setObject(cell, forKey: identifier as NSString)
            return cell as? T
        }

        return nil
    }
    
    func dequeueCacheHeaderFooterView<T: UITableViewHeaderFooterView>(withIdentifier identifier: String) -> T? {
        if let cell = uitableview_cacheForHeaderFooterAndCell.object(forKey: identifier as NSString) {
            return cell as? T
        }

        if let cell = dequeueReusableHeaderFooterView(withIdentifier: identifier) {
            uitableview_cacheForHeaderFooterAndCell.setObject(cell, forKey: identifier as NSString)
            return cell as? T
        }

        return nil
    }
}
