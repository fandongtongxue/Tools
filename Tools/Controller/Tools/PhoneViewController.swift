//
//  PhoneViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/23.
//

import UIKit

class PhoneViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "手机号归属地查询"
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(FD_TopHeight)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }
        scrollView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(FD_ScreenWidth - 30)
        }
        
        scrollView.addSubview(queryBtn)
        queryBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(FD_ScreenWidth - 30)
            make.top.equalTo(self.textField.snp.bottom).offset(15)
            make.height.equalTo(40)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUIPasteboard()
        NotificationCenter.default.addObserver(self, selector: #selector(checkUIPasteboard), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @objc func checkUIPasteboard(){
        let pasteboardStr = UIPasteboard.general.string
        if pasteboardStr?.count ?? 0 > 0 && pasteboardStr != textField.text {
            let alert = UIAlertController(title: "是否将剪贴板填入网址中", message: pasteboardStr, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                self.textField.text = pasteboardStr
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func queryBtnAction(){
        if textField.text?.count != 11 {
            return
        }
        FDNetwork.GET(url: api_phone, param: ["key":api_phone_key,"phone":textField.text!]) { (result) in
            let responseModel = JuHePhoneResponseModel.deserialize(from: result)
        } failure: { (error) in
            self.view.makeToast(error)
        }

    }

    lazy var textField : UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemFill.cgColor
        textField.font = .systemFont(ofSize: 15)
        textField.placeholder = "请输入手机号"
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftView = leftView
        textField.leftViewMode = .always
        return textField
    }()
    
    lazy var queryBtn : UIButton = {
        let queryBtn = UIButton(frame: .zero)
        queryBtn.setTitle("查询", for: .normal)
        queryBtn.setTitleColor(.systemBlue, for: .normal)
        queryBtn.addTarget(self, action: #selector(queryBtnAction), for: .touchUpInside)
        queryBtn.layer.cornerRadius = 10
        queryBtn.clipsToBounds = true
        queryBtn.layer.borderWidth = 1
        queryBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return queryBtn
    }()
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentSize = CGSize(width: 0, height: 40 * 3 + FD_ScreenWidth - 30 + 3 * 15 + FD_SafeAreaBottomHeight)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -FD_SafeAreaBottomHeight, right: 0)
        return scrollView
    }()

}
