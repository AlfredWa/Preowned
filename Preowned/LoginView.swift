import UIKit
import FirebaseAuth
    
//登录界面
class LoginView: UIView {
    fileprivate let mainView = UIView()
    fileprivate let accountLabel = UILabel()
    fileprivate let accountTextField = UITextField()
    fileprivate let line1 = UIView()
    fileprivate let passwordLabel = UILabel()
    fileprivate var passwordTextField = UITextField()
    fileprivate let line2 = UIView()
    fileprivate let sureBtn = UIButton()
    var confirmAction: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        creatView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化
    func creatView() {
        mainView.backgroundColor = UIColor.white
        
        accountLabel.textColor = UIColor(hexColor: "#1A1A1A")
        accountLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        accountLabel.text = "Email Address:"
        accountTextField.backgroundColor = UIColor.white
        accountTextField.placeholder = "please enter your Emall"
        accountTextField.textColor = UIColor(hexColor: "#1A1A1A")
        accountTextField.font = UIFont.systemFont(ofSize:20, weight: .bold)
        line1.backgroundColor = UIColor(hexColor: "#C2C2CC")
        
        passwordLabel.textColor = UIColor(hexColor: "#1A1A1A")
        passwordLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        passwordLabel.text = "Password:"
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.placeholder = "please enter password"
        passwordTextField.textColor = UIColor(hexColor: "#1A1A1A")
        passwordTextField.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        line2.backgroundColor = UIColor(hexColor: "#C2C2CC")

        sureBtn.setTitle("Login", for: .normal)
        sureBtn.backgroundColor = UIColor(hexColor: "#F25555")
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.clipsToBounds = true
        sureBtn.layer.cornerRadius = 4
        sureBtn.addTarget(self, action: #selector(dealWithEventAction), for: .touchUpInside)
    
        addSubview(mainView)
        
        for item in [accountLabel, accountTextField, line1, passwordLabel, passwordTextField, line2, sureBtn] {
            mainView.addSubview(item)
        }
        //计算frame，自动触发sizeThatFits方法
        sizeToFit()
    }

    //计算frame
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let y = (screenHeight - 200)/2
        accountLabel.frame = CGRect(x: 20, y: y, width: 120, height: 30)
        accountTextField.frame = CGRect(x: 145, y: y, width: size.width - 165, height: 30)
        line1.frame = CGRect(x: 140, y: y + 30, width: size.width - 160, height: 1)

        passwordLabel.frame = CGRect(x: 20, y: y + 80, width: 120, height: 30)
        passwordTextField.frame = CGRect(x: 145, y: y + 80, width: size.width - 165, height: 30)
        line2.frame = CGRect(x: 140, y: y + 110, width: size.width - 160, height: 1)

        sureBtn.frame = CGRect(x: 20, y: y + 150, width: size.width - 40, height: 44)
        mainView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        return mainView.frame.size
    }
    
    //登录按钮点击
    @objc fileprivate func dealWithEventAction() {
        //本地存储账号
//        guard let account = accountTextField.text, account.count > 0 else {
//            return
//        }
//        guard let password = passwordTextField.text, password.count > 0 else {
//            return
//        }
//        UserDefaults.standard.setValue(account, forKey: "mine_name")
//        UserDefaults.standard.setValue(password, forKey: "mine_password")
//        UserDefaults.standard.synchronize()
//
//        dismiss()
        print("button tabbed")
        guard let email = accountTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else{
                  print("missing data")
                  return
              }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] result, error in
            
            guard let strongSelf = self else{
                return
            }
            
            guard error == nil else{
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                let uemail=user.email
                
                UserDefaults.standard.setValue(uemail, forKey: "mine_name")
                self?.dismiss()
            }
            
        })
        
//        UserDefaults.standard.setValue(password, forKey: "mine_password")
//        UserDefaults.standard.synchronize()
//
//        dismiss()
        
    }
    
    func showCreateAccount(email: String, password: String){
        let alert = UIAlertController(title: "Create account", message: "Would you like to create an account", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self]result, error in
                
                guard let strongSelf = self else{
                    return
                }
                
                guard error == nil else{
                    print("account creation failed")
                    return
                }
                print("you have signed in")
                
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    let uemail=user.email
                    
                    UserDefaults.standard.setValue(uemail, forKey: "mine_name")
                    self?.dismiss()
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in}))
        if let viewController = self.window?.rootViewController{
            viewController.present(alert, animated: true)
        }
    }
    
    //展示登录界面
    func show() {
        if self.superview == nil {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            UIView.animate(withDuration: 2.25, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0, options: .curveEaseInOut) {
                self.mainView.frame.origin.y = 0
            } completion: { (_) in
                UIWindow.defaultNormalLevel().addSubview(self)
            }
        }
    }
    
    //关闭登录界面
    func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.mainView.frame.origin.y = screenHeight
        } completion: { [weak self] (_) in
            self?.confirmAction?()
            self?.removeFromSuperview()
        }
    }
}

extension UIWindow {
    //获取window
    class func defaultNormalLevel() -> UIWindow {
        let nilWindow: () -> UIWindow = {
            let window = UIWindow(frame: UIScreen.main.bounds)
            return window
        }
        
        var returnNormal: UIWindow?
        
        if let APPDelegate = UIApplication.shared.delegate {
            if let window = APPDelegate.window {
                if window?.windowLevel == .normal {
                    returnNormal = window
                }
            }
        }
        
        if returnNormal == nil {
            for window in UIApplication.shared.windows where window.windowLevel == .normal {
                returnNormal = window
                break
            }
        }
        return returnNormal ?? nilWindow()
    }
}
