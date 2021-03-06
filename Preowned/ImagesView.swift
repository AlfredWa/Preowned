import UIKit

class ImagesView: UIView {
    var numberOfLines: Int = 0
    
    var space: (lr: CGFloat, tb: CGFloat) = (lr: 10, tb: 10)
    
    var edgeInset = UIEdgeInsets.zero
    
    var itemSize = CGSize.zero
    var tags = [UIView]()
    
    var itemSizeToFit: ((UIView) -> Void) = { $0.sizeToFit() }

    func fillModel<T>(_ model: [T]?, new: (() -> UIView), config: @escaping ((_ v: UIView, _ d: T?, _ i: Int) -> Void)) {
        formatViewList(superView: self, views: tags, datas: model, newView: new, configView: config) { (views) in
            tags = views
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard tags.count != 0 else {
            return CGSize.zero
        }

        var minItemsWidth: CGFloat = 0

        let maxX = size.width-edgeInset.right

        var frame = CGRect.zero

        frame.origin = CGPoint(x: edgeInset.left, y: edgeInset.top)

        var maxY: CGFloat = -space.tb
        var line = 0
        for view in tags {
            view.frame = CGRect(x: 0, y: 0, width: maxX-edgeInset.left-itemSize.width, height: size.height)
            itemSizeToFit(view)
            frame.size = CGSize(width: view.frame.width+itemSize.width, height: view.frame.height+itemSize.height)
            if frame.maxX > maxX {
                frame.origin.x = edgeInset.left
                frame.origin.y = maxY + space.tb
                line += 1
            }

            if numberOfLines > 0, numberOfLines <= line {
                frame = CGRect.zero
            }
            view.frame = frame

            maxY = max(view.frame.maxY, maxY)
            frame.origin.x += frame.width + space.lr

            minItemsWidth = max(minItemsWidth, view.frame.maxX)
        }

        return CGSize(width: size.width, height: maxY+edgeInset.bottom)
    }
}

///
/// - parameter superView
/// - parameter views
/// - parameter datas
/// - parameter newView
/// - parameter configView
/// - parameter completion
public func formatViewList<T>(superView: UIView?,
                              views: [UIView],
                              datas: [T]?,
                              newView: (() -> UIView),
                              configView: ((_ view: UIView, _ data: T?, _ idx: Int) -> Void)? = nil,
                              completion: (([UIView]) -> Void) ) {
    guard let superView = superView else { return }
    var cacheViews = superView.formatViewList_cacheViews
    var mViews = views
    if let datas = datas {
        let datasCount = datas.count
        let mViewsCount = mViews.count
        if datasCount < mViewsCount {
            for _ in datasCount..<mViewsCount {
                mViews.last?.isHidden = true
                cacheViews.append(mViews.removeLast())
            }
        } else if datasCount > mViewsCount {
            for _ in mViewsCount..<datasCount {
                var tag: UIView
                if cacheViews.isEmpty == false {
                    tag = cacheViews.removeLast()
                } else {
                    tag = newView()
                    superView.addSubview(tag)
                }
                mViews.append(tag)
            }
        }
        
        if let configView = configView {
            for idx in 0 ..< mViews.count {
                let data = datas[idx]
                let view = mViews[idx]
                view.isHidden = false
                configView(view, data, idx)
            }
        }
    } else {
        for view in mViews {
            view.isHidden = true
        }
        cacheViews = mViews + cacheViews
        mViews.removeAll()
    }
    
    superView.formatViewList_cacheViews = cacheViews
    completion(mViews)
}

fileprivate extension UIView {
    /**
     Keys used for associated objects.
     */
    struct FormatViewListKeys {
        static var cacheViews = "UIView.FormatViewListKeys.cacheViews"
    }
    
    var formatViewList_cacheViews: [UIView] {
        set {
            objc_setAssociatedObject(self, FormatViewListKeys.cacheViews, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, FormatViewListKeys.cacheViews) as? [UIView]) ?? []
        }
    }
}
