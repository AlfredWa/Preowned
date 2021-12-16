import UIKit

//  Product Detail 界面
class ProductDetailViewController: UIViewController {
    var model: Model?
    fileprivate let scrollView = UIScrollView()
    fileprivate let titleLabel = UILabel()
    fileprivate let unitLabel = UILabel()
    fileprivate let priceLabel = UILabel()
    fileprivate let detailLabel = UILabel()
    fileprivate let imagesView = ImagesView()
    fileprivate let phoneLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = super.title
        setUI()
        setData()
        setFrame()
    }
    
    // ui
    func setUI() {
        //self.navigationController?.navigationBar.barTintColor=UIColor(hexColor: "#FFFF00")
        view.backgroundColor = UIColor(hexColor: "#F5F7F8")
        scrollView.backgroundColor = UIColor(hexColor: "#F5F7F8")

        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor(hexColor: "#1A1A1A")
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        unitLabel.textColor = UIColor(hexColor: "#F25555")
        unitLabel.text = "CAD"
        unitLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        priceLabel.textColor = UIColor(hexColor: "#F25555")
        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        detailLabel.numberOfLines = 0
        detailLabel.textColor = UIColor(hexColor: "#1A1A1A")
        detailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        phoneLabel.textColor = UIColor(hexColor: "#1A1A1A")
        phoneLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        let width = floor((screenWidth - 40)/2)
        imagesView.itemSizeToFit = { v in
            v.frame.size = CGSize(width: width, height: width)
        }
        for item in [imagesView, titleLabel, unitLabel, priceLabel, detailLabel, phoneLabel] {
            scrollView.addSubview(item)
        }
        view.addSubview(scrollView)
    }
    
    // frame
    func setFrame() {
        let maxWidth: CGFloat = screenWidth - 30
        var frame = CGRect.zero
        frame.origin = CGPoint(x: 15, y: 15)
        frame.size = titleLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        titleLabel.frame = frame

        frame.origin = CGPoint(x: 15, y: titleLabel.frame.maxY + 13)
        frame.size = unitLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        unitLabel.frame = frame
        
        frame.origin = CGPoint(x: unitLabel.frame.maxX + 2, y: titleLabel.frame.maxY + 12)
        frame.size = priceLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        priceLabel.frame = frame
        
        frame.origin = CGPoint(x: 15, y: priceLabel.frame.maxY + 20)
        frame.size = phoneLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        phoneLabel.frame = frame
        
        frame.origin = CGPoint(x: 15, y: phoneLabel.frame.maxY + 20)
        frame.size = detailLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        detailLabel.frame = frame
        
        frame.origin = CGPoint(x: 15, y: detailLabel.frame.maxY + 20)
        frame.size = imagesView.sizeThatFits(CGSize(width: maxWidth, height: 0))
        imagesView.frame = frame
                
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navHeight)
        scrollView.contentSize = CGSize(width: screenWidth, height: imagesView.frame.maxY + 100)
    }
    
    //填充数据
    func setData() {
        let titleStr = NSMutableAttributedString()
        if let t = model?.title, t.count > 0 {
            titleStr.append(NSAttributedString.init(string: t))
        }
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        style.lineBreakMode = .byTruncatingTail
        titleStr.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: titleStr.length))
        titleLabel.attributedText = titleStr
        
        priceLabel.text = model?.price
        let str = NSMutableAttributedString()
        if let n = model?.userName, n.count > 0 {
            str.append(NSAttributedString.init(string: "\(model?.userName ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]))
            str.append(NSAttributedString(string: "`s "))
        }
        str.append(NSAttributedString(string: "mobile: "))
        str.append(NSAttributedString.init(string: "\(model?.phone ?? "--")", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold)]))
        phoneLabel.attributedText = str
        
        let detailStr = NSMutableAttributedString()
        if let t = model?.detail, t.count > 0 {
            detailStr.append(NSAttributedString.init(string: t))
        }
        detailStr.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: detailStr.length))
        detailLabel.attributedText = detailStr
        
        let width = floor((screenWidth - 40)/2)
        imagesView.fillModel(model?.images) {
            let v = UIImageView()
            v.contentMode = .scaleAspectFit
            return v
        } config: { v, data, _ in
            if let view = v as? UIImageView, let img = data {
                view.image = img
                view.frame.size = CGSize(width: width, height: width)
            }
        }
    }
}
