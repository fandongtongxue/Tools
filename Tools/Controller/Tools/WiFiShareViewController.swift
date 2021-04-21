//
//  WiFiShareViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/21.
//

import UIKit

class WiFiShareViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "WiFi分享"
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(FD_LargeTitleHeight + FD_NavigationHeight)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }
        scrollView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(FD_ScreenWidth - 30)
        }
        scrollView.addSubview(passTextField)
        passTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(self.nameTextField.snp.bottom).offset(15)
            make.height.equalTo(40)
            make.width.equalTo(FD_ScreenWidth - 30)
        }
        
        scrollView.addSubview(generateBtn)
        generateBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(FD_ScreenWidth - 30)
            make.top.equalTo(self.passTextField.snp.bottom).offset(15)
            make.height.equalTo(40)
        }
        
    }
    
    @objc func generateBtnAction(){
        view.endEditing(true)
//        WIFI:S:604;P:sjt159357;T:WPA/WPA2;
        var text = "WIFI:S:"
        text.append(nameTextField.text ?? "")
        text.append(";P:")
        text.append(passTextField.text ?? "")
        text.append(";T:WPA/WPA2;")
        let context = CIContext()
        let data = text.data(using: .utf8)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 7, y: 7)
            if let output = filter.outputImage?.transformed(by: transform), let cgImage = context.createCGImage(output, from: output.extent) {
                let image = UIImage(cgImage: cgImage)
                if !scrollView.subviews.contains(imageView) {
                    scrollView.addSubview(imageView)
                    imageView.snp.makeConstraints { (make) in
                        make.left.right.equalTo(self.generateBtn);
                        make.top.equalTo(self.generateBtn.snp.bottom).offset(15)
                        make.height.equalTo(self.generateBtn.snp.width)
                    }
                }
                imageView.image = image
                self.view.makeToast("快让朋友扫码加入你的WiFi")
            }
        }
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError, contextInfo info: AnyObject){
        if error.code != 0 {
            view.makeToast("保存失败")
        }else{
            view.makeToast("保存成功")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    lazy var nameTextField : UITextField = {
        let nameTextField = UITextField(frame: .zero)
        nameTextField.layer.cornerRadius = 10
        nameTextField.clipsToBounds = true
        nameTextField.layer.borderWidth = 0.5
        nameTextField.layer.borderColor = UIColor.systemFill.cgColor
        nameTextField.font = .systemFont(ofSize: 15)
        nameTextField.placeholder = "WiFi名称"
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        nameTextField.leftView = leftView
        nameTextField.leftViewMode = .always
        return nameTextField
    }()
    
    lazy var passTextField : UITextField = {
        let passTextField = UITextField(frame: .zero)
        passTextField.layer.cornerRadius = 10
        passTextField.clipsToBounds = true
        passTextField.layer.borderWidth = 0.5
        passTextField.layer.borderColor = UIColor.systemFill.cgColor
        passTextField.font = .systemFont(ofSize: 15)
        passTextField.placeholder = "WiFi密码"
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        passTextField.leftView = leftView
        passTextField.leftViewMode = .always
        return passTextField
    }()
    
    lazy var generateBtn : UIButton = {
        let generateBtn = UIButton(frame: .zero)
        generateBtn.setTitle("生成", for: .normal)
        generateBtn.setTitleColor(.systemBlue, for: .normal)
        generateBtn.addTarget(self, action: #selector(generateBtnAction), for: .touchUpInside)
        generateBtn.layer.cornerRadius = 10
        generateBtn.clipsToBounds = true
        generateBtn.layer.borderWidth = 1
        generateBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return generateBtn
    }()
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentSize = CGSize(width: 0, height: UIScreen.main.bounds.size.width - 30 + 40 + 80 + 40 + 3 * 15)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -FD_SafeAreaBottomHeight, right: 0)
        return scrollView
    }()

}

