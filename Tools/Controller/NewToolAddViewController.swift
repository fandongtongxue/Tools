//
//  AddViewController.swift
//  AppCollection
//
//  Created by Mac on 2021/5/27.
//

import UIKit

protocol NewToolAddViewControllerDelegate {
    func addVC(addVC: NewToolAddViewController, didSave: ToolModel)
}

class NewToolAddViewController: BaseViewController {
    
    var delegate: NewToolAddViewControllerDelegate?
    var model = ToolModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = NSLocalizedString("Add New Tool", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBtnAction))
        
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(FD_LargeTitleHeight + 15)
            make.height.equalTo(50)
        }
        
        view.addSubview(descTextView)
        descTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(self.nameTextField.snp.bottom).offset(15)
            make.height.equalTo(100)
        }
        view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(self.descTextView.snp.bottom).offset(15)
            make.height.equalTo(50)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    

    @objc func closeBtnAction(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveBtnAction(){
        if model.name.count == 0{
            view.makeToast(NSLocalizedString("No name", comment: ""))
            return
        }
        if model.content.count == 0{
            view.makeToast(NSLocalizedString("No content", comment: ""))
            return
        }
        if delegate != nil {
            delegate?.addVC(addVC: self, didSave: model)
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    lazy var nameTextField: UITextField = {
        let nameTextField = UITextField(frame: .zero)
        nameTextField.backgroundColor = .systemGray6
        nameTextField.layer.cornerRadius = 10
        nameTextField.clipsToBounds = true
        nameTextField.placeholder = NSLocalizedString("Name", comment: "")
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        nameTextField.leftView = leftView
        nameTextField.leftViewMode = .always
        nameTextField.delegate = self
        return nameTextField
    }()
    
    lazy var descTextView: UITextView = {
        let descTextView = UITextView(frame: .zero)
        descTextView.backgroundColor = .systemGray6
        descTextView.layer.cornerRadius = 10
        descTextView.clipsToBounds = true
        descTextView.font = .systemFont(ofSize: 16)
        descTextView.delegate = self
        return descTextView
    }()
    
    lazy var saveBtn: UIButton = {
        let saveBtn = UIButton(frame: .zero)
        saveBtn.backgroundColor = .systemBlue
        saveBtn.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        saveBtn.layer.cornerRadius = 10
        saveBtn.clipsToBounds = true
        saveBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        saveBtn.addTarget(self, action: #selector(saveBtnAction), for: .touchUpInside)
        return saveBtn
    }()

}

extension NewToolAddViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        model.name = textField.text ?? ""
    }
}

extension NewToolAddViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        model.content = textView.text ?? ""
    }
}

