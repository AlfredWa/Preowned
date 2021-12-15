//
//  Model.swift
//  Preowned
//
//  Created by admin on 2021/10/2.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let topSafeAreaInset: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
let bottomSafeAreaInset: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
let navHeight = 44 + statusBarHeight
let bottomOffset: CGFloat = statusBarHeight > 20 ? 34 : 0
let tabbarHeight:CGFloat = statusBarHeight > 20 ? 83 : 49

// 数据结构
struct Model {
    var userName: String?
    var images: [UIImage]?
    var title: String?
    var price: String?
    var detail: String?
    var phone: String?
}

//数据存储方式~单例
class DataManager: NSObject {
    static let shared = DataManager()
    var dataSource = [Model]()

    //假数据
    override init() {
        let m1 = Model.init(userName: "Jone", images: [UIImage.init(named: "car")!], title: "a", price: "4999", detail: "test", phone: "0011111111")
        let m2 = Model.init(userName: "Lily", images: [UIImage.init(named: "car2")!], title: "b", price: "28888", detail: "test", phone: "999999999")
        let m3 = Model.init(userName: "Lily", images: [UIImage.init(named: "car2")!], title: "car", price: "288889", detail: "test", phone: "999999999")
        let m4 = Model.init(userName: "Lily", images: [UIImage.init(named: "car2")!], title: "d", price: "288888", detail: "test", phone: "999999999")
        let m5 = Model.init(userName: "Jone", images: [UIImage.init(named: "car")!], title: "e", price: "7999", detail: "test", phone: "0011111111")
        dataSource.append(m2)
        dataSource.append(m1)
        dataSource.append(m3)
        dataSource.append(m4)
        dataSource.append(m5)
    }
    
    //储存新数据
    func save(model: Model) {
        dataSource.append(model)
    }
    
    //换名字后对应发布的商品也要改名字
    func changeName(name: String) {
        for (index, item) in dataSource.enumerated() {
            var model = item
            if model.userName == UserDefaults.standard.string(forKey: "mine_name") {
                model.userName = name
                dataSource[index] = model
            }
        }
    }
}
    
