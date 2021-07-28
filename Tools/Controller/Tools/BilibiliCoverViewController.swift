//
//  BilibiliCoverViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/24.
//

import UIKit
import Kingfisher

class BilibiliCoverViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "小破站封面获取"
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(FD_TopHeight)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        scrollView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(FD_ScreenWidth - 30)
        }
        
        scrollView.addSubview(queryBtn)
        queryBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(FD_ScreenWidth - 30)
            make.top.equalTo(self.textField.snp.bottom).offset(15)
            make.height.equalTo(40)
        }
    }
    
    @objc func queryBtnAction(){
        if textField.text?.count == 0 {
            return
        }
        textField.resignFirstResponder()
        view.makeToastActivity(.center)
        FDNetwork.GET(url: "http://api.tools.app.xiaobingkj.com/bilibili_api.php", param: ["AV_number":textField.text!]) { (result) in
//            self.imageView.kf.setImage(with: URL(string: result))
            self.view.hideToastActivity()
        } failure: { (error) in
            self.view.hideToastActivity()
            self.view.makeToast(error)
        }

    }
    
    @objc func saveImageBtnAction(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUIPasteboard()
        NotificationCenter.default.addObserver(self, selector: #selector(checkUIPasteboard), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    lazy var saveImageBtn : UIButton = {
        let saveImageBtn = UIButton(frame: .zero)
        saveImageBtn.setTitle("保存", for: .normal)
        saveImageBtn.setTitleColor(.systemBlue, for: .normal)
        saveImageBtn.addTarget(self, action: #selector(saveImageBtnAction), for: .touchUpInside)
        saveImageBtn.layer.cornerRadius = 10
        saveImageBtn.clipsToBounds = true
        saveImageBtn.layer.borderWidth = 1
        saveImageBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return saveImageBtn
    }()
    

    lazy var textField : UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemFill.cgColor
        textField.font = .systemFont(ofSize: 15)
        textField.placeholder = "请输入A、BV号"
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
        scrollView.contentSize = CGSize(width: 0, height: 40 + 15)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -FD_SafeAreaBottomHeight, right: 0)
        return scrollView
    }()

}
