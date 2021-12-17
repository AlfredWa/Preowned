import UIKit
import FirebaseFirestore
import FirebaseStorage

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let topSafeAreaInset: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
let bottomSafeAreaInset: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
let navHeight = 44 + statusBarHeight
let bottomOffset: CGFloat = statusBarHeight > 20 ? 34 : 0
let tabbarHeight:CGFloat = statusBarHeight > 20 ? 83 : 49

struct Model: Identifiable{
    var id: String
    var userName: String?
    var images: [UIImage]?
    var title: String?
    var price: String?
    var detail: String?
    var phone: String?
}

class DataManager: NSObject {
    static let shared = DataManager()
    var dataSource = [Model]()
    var storage = Storage.storage().reference()


    func save(model: Model) {
        dataSource.append(model)
    }
    
    func changeName(name: String) {
        for (index, item) in dataSource.enumerated() {
            var model = item
            if model.userName == UserDefaults.standard.string(forKey: "mine_name") {
                model.userName = name
                dataSource[index] = model
            }
        }
    }
    
    func addData(model: Model){
        let db = Firestore.firestore()
        var imageURLArray = [String]()
        
        if let imageArr=model.images{
            for imageData in imageArr{
                if let imagePNG = imageData.pngData(){
                    let id=NSUUID().uuidString
                    storage.child(id).putData(imagePNG, metadata: nil) { _, error in
                        if error == nil{
                            self.storage.child(id).downloadURL { url, error in
                                if error==nil{
                                    if let url = url{
                                        let urlString = url.absoluteString
                                        imageURLArray.append(urlString)
                                        db.collection("models").addDocument(data: ["userName" : model.userName,
                                                                            "title" : model.title,
                                                                            "price" : model.price,
                                                                            "image" : imageURLArray,
                                                                            "phone" : model.phone,
                                                                            "detail" : model.detail
                                        ]){ error in
                                            if error == nil{
                                                self.getData()
                                            }
                                            else{
                                                
                                            }
                                        }
                                    }
                                }
                                else{
                                    return
                                }
                            }
                        }
                        else{

                        }
                    }
                }
            }
        }
    }
    
    func getImageArr(stringArr : [String]) -> [UIImage]{
        var imageArray=[UIImage]()
        for urlString in stringArr{
            print("DEBUG")
            let url = URL(string: urlString)
            if let url = url{
                do {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    if let image = image{
                        print(image)
                        imageArray.append(image)
                    }
                }catch let error as NSError {
                    print(error)
                }
            }
            else{
                return imageArray
            }
        }
        return imageArray
    }
    
    func getData(){
        print("????????????")
        let database = Firestore.firestore()
        database.collection("models").getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        print("!!!!!!!!!!!")
                        self.dataSource = snapshot.documents.map { d in
                            return Model(id: d.documentID,
                                         userName: d["userName"] as? String ?? "",
                                         images: self.getImageArr(stringArr: d["image"] as? [String] ?? []),
                                         title: d["title"] as? String ?? "",
                                         price: d["price"] as? String ?? "",
                                         detail: d["detail"] as? String ?? "",
                                         phone: d["phone"] as? String ?? "")
                        }
                    }
                }
            }
            else{
                
            }
        }
    }
}
    
