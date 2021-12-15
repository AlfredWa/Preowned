//
//  ImageContainerView.swift
//  Preowned
//
//  Created by admin on 2021/10/3.
//

import UIKit
// 相册选图后展示的view
class ImageContainerView: UIView {
    var closure: ((Int) -> Void)?
    let addBtn = UIButton()
    var imgArr = [UIImageView]()
    var closeArr = [UIButton]()
    private var maxCount = 6
    var addImageAction: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        addSubview(addBtn)
        addBtn.setImage(UIImage.init(named: "plus"), for: .normal)
        addBtn.addTarget(self, action: #selector(addImage), for: .touchUpInside)
    }
    
    @objc func addImage() {
        addImageAction?()
    }
    //根据图片数量初始化对应的view和删除按钮
    //超过最大数量，添加图片按钮隐藏
    func addImgs(_ imgs: [UIImage]) {
        imgArr.forEach { (v) in
            v.removeFromSuperview()
        }
        imgArr.removeAll()
        closeArr.forEach { (v) in
            v.removeFromSuperview()
        }
        closeArr.removeAll()
        
        for i in 0..<imgs.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            addSubview(imageView)
            imgArr.append(imageView)
            imageView.image = imgs[i]
            imageView.tag = i
            imageView.isUserInteractionEnabled = true
            imageView.layer.cornerRadius = 4
            let closeBtn = UIButton()
            closeBtn.tag = i
            closeBtn.setImage(UIImage.init(named: "delete"), for: .normal)
            closeBtn.addTarget(self, action: #selector(delImage(_:)), for: .touchUpInside)
            closeArr.append(closeBtn)
            addSubview(closeBtn)
        }
        addBtn.isHidden = imgArr.count >= maxCount
        sizeToFit()
    }
    
    @objc func delImage(_ sender: UIButton) {
        closure?(sender.tag)
    }
    //frame
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        for i in 0..<imgArr.count {
            imgArr[i].frame = CGRect(x: CGFloat(62*i), y: 11, width: 56, height: 56)
        }
        
        for i in 0..<closeArr.count {
            closeArr[i].frame = CGRect(x: CGFloat(62*i) + 42, y: 9, width: 16, height: 16)
        }
        let originX = imgArr.last?.frame.maxX ?? 0
        let addOriginX = originX == 0 ? 0 : originX + 6
        addBtn.frame = CGRect(x: addOriginX, y: 11, width: 56, height: 56)
        return CGSize(width: size.width, height: 83)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

