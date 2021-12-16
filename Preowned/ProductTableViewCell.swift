import UIKit

class ProductTableViewCell: UITableViewCell {
    fileprivate var mainView = UIView()
    fileprivate let imageV = UIImageView()
    fileprivate let titleLabel = UILabel()
    fileprivate let unitLabel = UILabel()
    fileprivate let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createView()
    }
    
    private func createView() {
        contentView.backgroundColor = UIColor(hexColor: "#F5F7F8")
        
        mainView.backgroundColor = UIColor.white
        mainView.layer.cornerRadius = 4
        mainView.clipsToBounds = true
        
        titleLabel.numberOfLines = 2
        imageV.contentMode = .scaleAspectFit
        
        titleLabel.textColor = UIColor(hexColor: "#1A1A1A")
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.numberOfLines = 2
        
        unitLabel.textColor = UIColor(hexColor: "#F25555")
        unitLabel.text = "$"
        unitLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        priceLabel.textColor = UIColor(hexColor: "#F25555")
        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        for item in [imageV, titleLabel, unitLabel, priceLabel] {
            mainView.addSubview(item)
        }
        
        contentView.addSubview(mainView)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var frame = CGRect.zero
        imageV.frame = CGRect(x: 15, y: 10, width: 100, height: 100)

        let maxWidth: CGFloat = size.width - 170
        let maxX = imageV.frame.maxX + 10
        frame.origin = CGPoint(x: maxX, y: 20)
        frame.size = titleLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        titleLabel.frame = frame

        frame.origin = CGPoint(x: maxX, y: 75)
        frame.size = unitLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        unitLabel.frame = frame
        
        frame.origin = CGPoint(x: unitLabel.frame.maxX + 2, y: 74)
        frame.size = priceLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        priceLabel.frame = frame
       
        mainView.frame = CGRect(x: 15, y: 10, width: size.width - 30, height: imageV.frame.maxY + 10)
        return CGSize(width: size.width, height: mainView.frame.maxY + 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProductTableViewCellModel: NSObject, TableViewCellDefaultProtocol {
    var model: Model?
    //填充数据
    func fillModel(reusableView: ProductTableViewCell) {
        reusableView.imageV.image = model?.images?.first
        let titleStr = NSMutableAttributedString()
        if let t = model?.title, t.count > 0 {
            titleStr.append(NSAttributedString.init(string: t))
        }
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        style.lineBreakMode = .byTruncatingTail
        titleStr.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: titleStr.length))
        reusableView.titleLabel.attributedText = titleStr
        reusableView.priceLabel.text = model?.price
    }
}
