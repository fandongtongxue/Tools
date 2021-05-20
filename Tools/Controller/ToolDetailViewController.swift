//
//  ToolDetailViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/15.
//

import UIKit
import WebKit
import AVKit
import MarkdownView

class ToolDetailViewController: BaseViewController {
    var model = ToolModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = model.name
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnAction))
        
        let mdView = MarkdownView()
        view.addSubview(mdView)
        mdView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-FD_TabBarHeight)
        }
        view.addSubview(operateBtn)
        operateBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4.5 - FD_SafeAreaBottomHeight)
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        if Locale.preferredLanguages.first?.contains("zh") ?? false {
            mdView.load(markdown: model.desc_md, enableImage: true)
        }else{
            mdView.load(markdown: model.desc_en_md, enableImage: true)
        }
        
        let isSaveiCloud = UserDefaults.standard.bool(forKey: iCloudSwitchKey)
        var storageObject = UserDefaults.standard.array(forKey: MyToolSaveKey)
        if isSaveiCloud {
            storageObject = NSUbiquitousKeyValueStore.default.array(forKey: MyToolSaveKey)
        }
        var ret = false
        if storageObject != nil{
            let storageArray = storageObject as! [[String : Any]]
            for subObject in storageArray{
                let subModel = ToolModel.deserialize(from: subObject)
                if subModel?.id == model.id {
                    ret = true
                }
            }
        }
        if ret {
            operateBtn.setTitle("移除", for: .normal)
        }else{
            operateBtn.setTitle("添加", for: .normal)
        }
        
    }
    
    @objc func cancelBtnAction(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func operateBtnAction(){
        if operateBtn.titleLabel?.text == "移除" {
            let isSaveiCloud = UserDefaults.standard.bool(forKey: iCloudSwitchKey)
            var storageArray = UserDefaults.standard.array(forKey: MyToolSaveKey) as! [[String : Any]]
            if isSaveiCloud {
                storageArray = NSUbiquitousKeyValueStore.default.array(forKey: MyToolSaveKey) as! [[String : Any]]
            }
            for i in 0...storageArray.count - 1{
                if i < storageArray.count {
                    let subObject = storageArray[i]
                    let subModel = ToolModel.deserialize(from: subObject)
                    if subModel?.id == model.id {
                        storageArray.remove(at: i)
                        if isSaveiCloud {
                            NSUbiquitousKeyValueStore.default.set(storageArray, forKey: MyToolSaveKey)
                            NSUbiquitousKeyValueStore.default.synchronize()
                        }else{
                            UserDefaults.standard.setValue(storageArray, forKey: MyToolSaveKey)
                            UserDefaults.standard.synchronize()
                        }
                        break
                    }
                }
            }
            view.makeToast("移除成功")
        }else{
            let isSaveiCloud = UserDefaults.standard.bool(forKey: iCloudSwitchKey)
            var storageObject = UserDefaults.standard.array(forKey: MyToolSaveKey)
            if isSaveiCloud {
                storageObject = NSUbiquitousKeyValueStore.default.array(forKey: MyToolSaveKey)
            }
            if storageObject != nil {
                var storageArray = storageObject as! [[String : Any]]
                storageArray.append(model.toJSON()!)
                if isSaveiCloud {
                    NSUbiquitousKeyValueStore.default.set(storageArray, forKey: MyToolSaveKey)
                }else{
                    UserDefaults.standard.setValue(storageArray, forKey: MyToolSaveKey)
                }
                
            }else{
                if isSaveiCloud {
                    NSUbiquitousKeyValueStore.default.set([model.toJSON() ?? ""], forKey: MyToolSaveKey)
                }else{
                    UserDefaults.standard.setValue([model.toJSON() ?? [:]], forKey: MyToolSaveKey)
                }
                
            }
            UserDefaults.standard.synchronize()
            NSUbiquitousKeyValueStore.default.synchronize()
            view.makeToast("添加成功")
        }
        perform(#selector(cancelBtnAction), with: self, afterDelay: 2)
    }
    
    lazy var operateBtn: UIButton = {
        let operateBtn = UIButton(frame: .zero)
        operateBtn.backgroundColor = .systemBlue
        operateBtn.layer.cornerRadius = 10
        operateBtn.clipsToBounds = true
        operateBtn.addTarget(self, action: #selector(operateBtnAction), for: .touchUpInside)
        return operateBtn
    }()

}
