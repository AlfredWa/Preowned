import UIKit
import Photos

// Sale 发布界面
class SaleViewController: UIViewController {
    var imgArr = [UIImage]()
    let scrollView = UIScrollView()
    let titleLabel = UILabel()
    let titleTextField = UITextField()
    let line1 = UIView()
    let priceLabel = UILabel()
    let priceTextField = UITextField()
    let line2 = UIView()
    let phoneLabel = UILabel()
    let phoneTextField = UITextField()
    let line3 = UIView()
    let detailLabel = UILabel()
    let detailTextView = UITextView()
    let imageLabel = UILabel()
    let containerView = ImageContainerView()
    let sureBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post"
        view.backgroundColor = UIColor(hexColor: "#F5F7F8")
        scrollView.backgroundColor = UIColor(hexColor: "#F5F7F8")

        setUI()
        setFrame()
        containerView.addImageAction = { [weak self] in
            self?.chargeAuthorization(status: PHPhotoLibrary.authorizationStatus())
        }
        
        containerView.closure = { [weak self] index in
            self?.imgArr.remove(at: index)
            self?.reloadImageView()
        }
    }
    // ui
    func setUI() {
        //navigationController?.navigationBar.barTintColor=UIColor(hexColor: "#FFFF00")
        titleLabel.textColor = UIColor(hexColor: "#1A1A1A")
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        //titleLabel.text = "Title:"
        titleTextField.placeholder = "Title"
        titleTextField.textColor = UIColor(hexColor: "#1A1A1A")
        titleTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        line1.backgroundColor = UIColor(hexColor: "#C2C2CC")

        priceLabel.textColor = UIColor(hexColor: "#1A1A1A")
        priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        priceLabel.text = "Price: CAD $"
        priceTextField.placeholder = "please enter price"
        priceTextField.textColor = UIColor(hexColor: "#1A1A1A")
        priceTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        line2.backgroundColor = UIColor(hexColor: "#C2C2CC")

        phoneLabel.textColor = UIColor(hexColor: "#1A1A1A")
        phoneLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        phoneTextField.placeholder = "Phone Number"
        phoneTextField.textColor = UIColor(hexColor: "#1A1A1A")
        phoneTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        line3.backgroundColor = UIColor(hexColor: "#C2C2CC")

        detailLabel.textColor = UIColor(hexColor: "#1A1A1A")
        detailLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        detailLabel.text = "Description:"
        
        imageLabel.textColor = UIColor(hexColor: "#1A1A1A")
        imageLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        imageLabel.text = "Add photos (Maximum 6 photos):"
        
        detailTextView.backgroundColor = UIColor.white
        detailTextView.clipsToBounds = true
        detailTextView.layer.cornerRadius = 4
        detailTextView.textColor = UIColor(hexColor: "#1A1A1A")
        detailTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        sureBtn.setTitle("Publish", for: .normal)
        sureBtn.backgroundColor = UIColor(hexColor: "#F25555")
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.clipsToBounds = true
        sureBtn.layer.cornerRadius = 4
        sureBtn.addTarget(self, action: #selector(publish), for: .touchUpInside)
    
        for item in [titleLabel, titleTextField, priceLabel, priceTextField, phoneLabel, phoneTextField, detailLabel, detailTextView, containerView, line1, line2, line3, imageLabel] {
            scrollView.addSubview(item)
        }
        for item in [scrollView, sureBtn] {
            view.addSubview(item)
        }
    }
    //frame
    func setFrame() {
        var frame = CGRect.zero
        let maxWidth = screenWidth - 30
        frame.origin = CGPoint(x: 15, y: 20)
        frame.size = titleLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        titleLabel.frame = frame

        titleTextField.frame = CGRect(x: 20, y: titleLabel.frame.maxY + 10, width: screenWidth - 40, height: 30)
        line1.frame = CGRect(x: 15, y: titleTextField.frame.maxY, width: screenWidth - 30, height: 1)
        
        frame.origin = CGPoint(x: 15, y: line1.frame.maxY + 20)
        frame.size = detailLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        detailLabel.frame = frame
        
        detailTextView.frame = CGRect(x: 15, y: detailLabel.frame.maxY + 10, width: maxWidth, height: 120)

        frame.origin = CGPoint(x: 15, y: detailTextView.frame.maxY + 20)
        frame.size = imageLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        imageLabel.frame = frame

        frame.origin = CGPoint(x: 15, y: imageLabel.frame.maxY + 10)
        frame.size = containerView.sizeThatFits(CGSize(width: screenWidth, height: 0))
        containerView.frame = frame
        
        frame.origin = CGPoint(x: 15, y: containerView.frame.maxY + 20)
        frame.size = priceLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        priceLabel.frame = frame
        
        priceTextField.frame = CGRect(x: 20, y: priceLabel.frame.maxY + 10, width: screenWidth - 40, height: 30)
        line2.frame = CGRect(x: 15, y: priceTextField.frame.maxY, width: screenWidth - 30, height: 1)

        frame.origin = CGPoint(x: 15, y: line2.frame.maxY + 20)
        frame.size = phoneLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        phoneLabel.frame = frame
        
        phoneTextField.frame = CGRect(x: 20, y: phoneLabel.frame.maxY + 10, width: screenWidth - 40, height: 30)
        line3.frame = CGRect(x: 15, y: phoneTextField.frame.maxY, width: screenWidth - 30, height: 1)

        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - tabbarHeight - navHeight)
        scrollView.contentSize = CGSize(width: screenWidth, height: line3.frame.maxY + 20)
        
        sureBtn.frame = CGRect(x: 15, y: screenHeight - tabbarHeight - navHeight - 54, width: maxWidth, height: 44)
    }
    //发布按钮点击
    @objc func publish() {
        guard let title = titleTextField.text, title.count > 0 else {
            alert(title: "please enter product name")
            return
        }
        guard let price = priceTextField.text, price.count > 0 else {
            alert(title: "please enter product price")
            return
        }
        guard let phone = phoneTextField.text, phone.count > 0 else {
            alert(title: "please enter phone number")
            return
        }
        guard let detail = detailTextView.text, detail.count > 0 else {
            alert(title: "please enter product Detail")
            return
        }
        guard imgArr.count > 0 else {
            alert(title: "please add product Image")
            return
        }
        //组装数据
        var model = Model()
        model.userName = UserDefaults.standard.string(forKey: "mine_name")
        model.title = title
        model.price = price
        model.images = imgArr
        model.phone = phone
        model.detail = detail
        //保存数据
        DataManager.shared.save(model: model)
        //跳转到详情
        let vc = ProductDetailViewController()
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
        //清空界面数据
        cleanData()
    }
    
    func cleanData() {
        titleTextField.text = nil
        priceTextField.text = nil
        phoneTextField.text = nil
        detailTextView.text = nil
        imgArr.removeAll()
        reloadImageView()
    }
    //提示框
    func alert(title: String) {
        let v = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        v.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(v, animated: true, completion: nil)
    }
    
    func reloadImageView() {
        containerView.addImgs(self.imgArr)
    }
    //相册权限
    func chargeAuthorization(status: PHAuthorizationStatus) {
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                self.fromAlbum()
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                guard status != .notDetermined else { return }
                DispatchQueue.main.async { () -> Void in
                    self.chargeAuthorization(status: status)
                }
            })
        default:
            break
        }
    }
    
    func fromAlbum() {
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(picker, animated: true, completion: nil)
        }else{
            print("读取相册错误")
        }
    }
}

extension SaleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //相册选中的图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let img = info[.originalImage] as? UIImage else {
            print("选择失败")
            return
        }
        imgArr.append(img)
        reloadImageView()
        picker.dismiss(animated: true, completion: nil)
    }
}
