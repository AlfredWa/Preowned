import UIKit

class MineTableViewCell: UITableViewCell, UITextFieldDelegate {
    let nameLabel = UILabel()
    let nameTextField = UILabel()
    let priceLabel = UILabel()
    let detailLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUI()
    }
    
    func setUI() {
        contentView.backgroundColor = UIColor(hexColor: "#F5F6F8")
        nameLabel.textColor = UIColor(hexColor: "#1A1A1A")
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.text = "My Name:"
        //nameTextField.backgroundColor = UIColor.white
        nameTextField.clipsToBounds = true
        nameTextField.layer.cornerRadius = 4
        //nameTextField.placeholder = "please enter your name"
        nameTextField.textColor = UIColor(hexColor: "#1A1A1A")
        nameTextField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        //nameTextField.delegate = self

        priceLabel.textColor = UIColor(hexColor: "#1A1A1A")
        priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        detailLabel.textColor = UIColor(hexColor: "#1A1A1A")
        detailLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        detailLabel.text = "My Post"
        
        for item in [nameLabel, nameTextField, priceLabel, detailLabel] {
            contentView.addSubview(item)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var frame = CGRect.zero
        let maxWidth = size.width - 30
        frame.origin = CGPoint(x: 15, y: 20)
        frame.size = nameLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        nameLabel.frame = frame

        nameTextField.frame = CGRect(x: nameLabel.frame.maxX + 10, y: 0, width: size.width - nameLabel.frame.maxX - 25, height: 30)
        nameTextField.center.y = nameLabel.center.y
        
        frame.origin = CGPoint(x: 15, y: nameLabel.frame.maxY + 20)
        frame.size = priceLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        priceLabel.frame = frame
        
        frame.origin = CGPoint(x: 15, y: priceLabel.frame.maxY + 20)
        frame.size = detailLabel.sizeThatFits(CGSize(width: maxWidth, height: 0))
        detailLabel.frame = frame
        
        return CGSize(width: size.width, height: detailLabel.frame.maxY + 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserDefaults.standard.setValue(textField.text, forKey: "mine_name")
        UserDefaults.standard.synchronize()
        DataManager.shared.changeName(name: textField.text ?? "My PreOwned")
    }
    
}

class MineTableViewCellModel: NSObject, TableViewCellDefaultProtocol {
    var price = "0.00"
    func fillModel(reusableView: MineTableViewCell) {
        if let name = UserDefaults.standard.string(forKey: "mine_name"), name.count > 0 {
            reusableView.nameTextField.text = name
        } else {
            reusableView.nameTextField.text = nil
        }
        reusableView.priceLabel.text = "You made CAD \(price) in PreOwned"
    }
}
