//
//  ProductCollectionViewCell.swift
//  Preowned
//
//  Created by admin on 2021/10/2.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    fileprivate let imageView = UIImageView()
    fileprivate let titleLabel = UILabel()
    fileprivate let unitLabel = UILabel()
    fileprivate let priceLabel = UILabel()
    fileprivate weak var cellModel: ProductCollectionViewCellModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    //init
    private func createView() {
        backgroundColor = UIColor.white
        titleLabel.numberOfLines = 2
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.textColor = UIColor(hexColor: "#1A1A1A")
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        unitLabel.textColor = UIColor(hexColor: "#F25555")
        unitLabel.text = "$"
        unitLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        priceLabel.textColor = UIColor(hexColor: "#F25555")
        priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)

        for item in [imageView, titleLabel, unitLabel, priceLabel] {
            contentView.addSubview(item)
        }
    }
    //frame
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width: CGFloat = floor(size.width)
        var frame = CGRect.zero
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: width)

        let maxWidth: CGFloat = width - 30
        
        frame.origin = CGPoint(x: 15, y: imageView.frame.maxY + 10)
        frame.size = titleLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        titleLabel.frame = frame

        frame.origin = CGPoint(x: 15, y: titleLabel.frame.maxY + 13)
        frame.size = unitLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        unitLabel.frame = frame
        
        frame.origin = CGPoint(x: unitLabel.frame.maxX + 2, y: titleLabel.frame.maxY + 12)
        frame.size = priceLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        priceLabel.frame = frame
       
        return CGSize(width: width, height: priceLabel.frame.maxY)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProductCollectionViewCellModel: NSObject, CollectionViewItemDefaultProtocol {
    var itemSize: CGSize = CGSize.zero
    var model: Model?
    
    //填充数据
    func fillModel(reusableView: ProductCollectionViewCell) {
        reusableView.imageView.image = model?.images?.first
        let titleStr = NSMutableAttributedString()
        if let t = model?.title, t.count > 0 {
            if t.count > 10 {
                let tt = t.prefix(10)+"..."
                titleStr.append(NSAttributedString.init(string: String(tt)))
            }
            else{
                titleStr.append(NSAttributedString.init(string: t))
            }
        }
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        style.lineBreakMode = .byTruncatingTail
        
        titleStr.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: titleStr.length))
        reusableView.titleLabel.attributedText = titleStr
        reusableView.priceLabel.text = model?.price
    }
}
