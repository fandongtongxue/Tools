//
//  PhoneViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/23.
//

import UIKit

class PhoneViewController: BaseViewController {
    
    var responseModel = JuHePhoneResponseModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "手机号归属地查询"
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(FD_TopHeight)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        scrollView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(15)
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
        textField.resignFirstResponder()
        view.makeToastActivity(.center)
        FDNetwork.GET(url: api_phone, param: ["key":api_phone_key,"phone":textField.text!]) { (result) in
            self.responseModel = JuHePhoneResponseModel.deserialize(from: result) ?? JuHePhoneResponseModel()
            if !self.scrollView.subviews.contains(self.tableView){
                self.scrollView.addSubview(self.tableView)
                self.tableView.snp.makeConstraints { (make) in
                    make.left.equalToSuperview()
                    make.width.equalTo(FD_ScreenWidth)
                    make.top.equalTo(self.queryBtn.snp.bottom).offset(15)
                    make.height.equalTo(self.responseResultArray.count * 44)
                }
            }
            self.tableView.reloadData()
            self.view.hideToastActivity()
        } failure: { (error) in
            self.view.hideToastActivity()
            self.view.makeToast(error)
        }

    }
    
    lazy var responseResultArray : [[String : Any]] = {
        var responseResultArray = [[String : Any]]()
        let responseDict = responseModel.result?.toJSON() ?? [:]
        for index in 0...responseDict.count - 1{
            let key = Array(responseDict.keys)[index]
            let value = Array(responseDict.values)[index]
            responseResultArray.append([key:value])
        }
        return responseResultArray
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()

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
        textField.keyboardType = .phonePad
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

extension PhoneViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseResultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = (transfromDict[responseResultArray[indexPath.row].keys.first!] ?? "") + "-" +  (responseResultArray[indexPath.row].values.first as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIPasteboard.general.string = cell?.textLabel?.text
        view.makeToast("已复制到剪贴板")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
