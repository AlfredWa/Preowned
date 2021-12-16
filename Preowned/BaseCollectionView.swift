import UIKit

//基于协议创建collectionview数据源，自动设置identifa，注册cell，同时推断cell类型，使用时只要数据源遵循协议，只需要实现对应的fillModel方法来填充cell对应的数据即可。

public protocol ListItemProtocol {
    var identifa: String { get }
    var newItem: AnyObject { get }
    var registClass: AnyClass { get }
    func fillModel(item: AnyObject)
}

public protocol CollectionViewItemProtocol: ListItemProtocol {
    var itemSize: CGSize { get set }
}

public protocol ListItemDefaultProtocol: ListItemProtocol {
    associatedtype ItemType: UIView
    func fillModel(reusableView: ItemType)
}

public extension ListItemDefaultProtocol {
    var identifa: String { return  NSStringFromClass(ItemType.self) }
    var newItem: AnyObject { return ItemType() }
    var registClass: AnyClass { return ItemType.self }
    func fillModel(item: AnyObject) {
        if let reusableView = item as? ItemType {
            fillModel(reusableView: reusableView)
        }
    }
}

public protocol CollectionViewItemDefaultProtocol: CollectionViewItemProtocol, ListItemDefaultProtocol { }

//collectionView数据源
public class CollectionViewViewModel: NSObject {

    public var identifier = ""

    public var sectionInset = UIEdgeInsets.zero

    public var minimumColumnSpacing = 0.0

    public var minimumInteritemSpacing = 0.0

    public var columnCount: Int?

    public var header: CollectionViewItemProtocol?

    public var items: [CollectionViewItemProtocol]?

    public var footer: CollectionViewItemProtocol?
}

//点击cell的协议
public protocol CollectionViewDelegate: NSObjectProtocol {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

public extension CollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { }
}

//自定义CollectionView
public class CollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {

    public weak var allDelegate: CollectionViewDelegate?

    /// 设置数据源，触发didset，加载界面
    public var viewModel = [CollectionViewViewModel]() {
        didSet {
            for section in viewModel {
                if let header = section.header {
                    self.register(header.registClass,
                                  forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                  withReuseIdentifier: header.identifa)
                }
                if let footer = section.footer {
                    self.register(footer.registClass,
                                  forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                  withReuseIdentifier: footer.identifa)
                }
                if let items = section.items {
                    for item in items {
                        self.register(item.registClass, forCellWithReuseIdentifier: item.identifa)
                    }
                }
            }
            self.reloadData()
        }
    }

    private var viewCache = NSCache<AnyObject, AnyObject>()

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    /// 基础配置
    private func setup() {
        self.delegate = self
        self.dataSource = self
        self.keyboardDismissMode = .onDrag
    }

    // MARK: - UICollectionViewDataSource

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items = 0
        if section < viewModel.count {
            items = viewModel[section].items?.count ?? 0
        }
        return items
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var returnCell: UICollectionViewCell?
        if indexPath.section < viewModel.count,
            indexPath.row < (viewModel[indexPath.section].items?.count ?? 0),
            let item = viewModel[indexPath.section].items?[indexPath.row] {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.identifa, for: indexPath)
            item.fillModel(item: cell)
            cell.sizeToFit()
            returnCell = cell
        }
        return returnCell ??  collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var returnView: UICollectionReusableView?
        var item: CollectionViewItemProtocol?

        if  indexPath.section < viewModel.count {
            if kind == UICollectionView.elementKindSectionHeader {
                item = viewModel[indexPath.section].header
            } else if kind == UICollectionView.elementKindSectionFooter {
                item = viewModel[indexPath.section].footer
            }
        }

        if let item = item {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: item.identifa, for: indexPath)
            item.fillModel(item: view)
            returnView = view
        }
        return returnView ?? collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionViewCell", for: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.allDelegate?.collectionView(self, didSelectItemAt: indexPath)
    }
}

// MARK: - CollectionViewLayout 瀑布流协议
extension CollectionView: CollectionViewLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        var columnCount = 0
        if section < viewModel.count {
            columnCount = viewModel[section].columnCount ?? 1
        }
        return columnCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumColumnSpacingFor section: Int) -> CGFloat {
        if section < viewModel.count {
            return CGFloat(viewModel[section].minimumColumnSpacing)
        }
        return  0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingFor section: Int) -> CGFloat {
        if section < viewModel.count {
            return CGFloat(viewModel[section].minimumInteritemSpacing)
        }
        return  0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForHeaderIn section: Int) -> CGFloat {
        var returloat: CGFloat?

        if section < viewModel.count,
            var item = viewModel[section].header {
            if item.itemSize.height > 0 {
                returloat = item.itemSize.height
            } else {
                if let cell = (viewCache.object(forKey: item.identifa as AnyObject) ?? item.newItem) as? UIView {
                    cell.frame = collectionView.bounds
                    item.fillModel(item: cell)
                    cell.sizeToFit()
                    item.itemSize = cell.frame.size
                    returloat = cell.frame.height
                    viewCache.setObject(cell, forKey: item.identifa as AnyObject)
                } else {
                    returloat = 0
                }
            }
        }
        return returloat ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForFooterIn section: Int) -> CGFloat {
        
        var returloat: CGFloat?

        if section < viewModel.count,
            var item = viewModel[section].footer {
            
            if item.itemSize.height > 0 {
                returloat = item.itemSize.height
            } else {
                if let cell = (viewCache.object(forKey: item.identifa as AnyObject) ?? item.newItem) as? UIView {
                    cell.frame = collectionView.bounds
                    item.fillModel(item: cell)
                    cell.sizeToFit()
                    item.itemSize = cell.frame.size
                    returloat = cell.frame.height
                    viewCache.setObject(cell, forKey: item.identifa as AnyObject)
                } else {
                    returloat = 0
                }
            }
        }

        return returloat ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsFor section: Int) -> UIEdgeInsets {
        if section < viewModel.count {
            return viewModel[section].sectionInset
        }

        return UIEdgeInsets.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var returnSize: CGSize?

        if indexPath.section < viewModel.count,
            indexPath.row < (viewModel[indexPath.section].items?.count ?? 0),
            var item = viewModel[indexPath.section].items?[indexPath.row] {

            if item.itemSize.height > 0 {
                returnSize = item.itemSize
            } else {
                if let cell = (viewCache.object(forKey: item.identifa as AnyObject) ?? item.newItem)
                    as? UICollectionViewCell {
                    
                    let section = viewModel[indexPath.section]
                    if let columnCount = section.columnCount,
                        columnCount > 1 {
                        var width = collectionView.bounds.width
                            - section.sectionInset.left
                            - section.sectionInset.right
                            - CGFloat(columnCount-1) * CGFloat(section.minimumColumnSpacing)
                        width /= CGFloat(columnCount)
                        cell.frame = CGRect(x: 0, y: 0, width: width, height: collectionView.bounds.height)
                    } else {
                        cell.frame = CGRect(x: 0,
                                            y: 0,
                                            width: collectionView.bounds.width
                                                - section.sectionInset.left
                                                - section.sectionInset.right,
                                            height: collectionView.bounds.height)
                    }
                    item.fillModel(item: cell)
                    cell.frame.size = cell.sizeThatFits(CGSize(width: cell.frame.width, height: 0))
                    returnSize = cell.frame.size
                    viewCache.setObject(cell, forKey: item.identifa as AnyObject)
                } else {
                    returnSize = CGSize.zero
                }
            }
            item.itemSize = returnSize ?? CGSize.zero
        }
        return returnSize ?? CGSize.zero
    }
}

extension CollectionView {
    //瀑布流初始化
    public class func waterfall() -> CollectionView {
        let layout = CollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumColumnSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = CollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        return collectionView
    }
    var waterfallLayout: CollectionViewWaterfallLayout? {
        return self.collectionViewLayout as? CollectionViewWaterfallLayout
    }
}
