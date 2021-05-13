//
//  BaseViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/13.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        if self.isKind(of: ToolsViewController.classForCoder()) || self.isKind(of: MyToolsViewController.classForCoder()) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(setBtnAction))
        }
        upConfig()
        upView()
    }
    
    // 需要在初始化时,进行的操作
    open func upConfig() {}
    open func upView() {}
    
    
    /// 保存图片
    /// - Parameter image: 需要保存的图片
    open func saveImage(image: UIImage){
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError, contextInfo info: AnyObject){
        if error.code != 0 {
            view.makeToast(error.localizedDescription)
        }else{
            view.makeToast("保存成功")
        }
    }
    

    @objc func setBtnAction(){
        let setVC = SetViewController(style: .insetGrouped)
        let setNav = BaseNavigationController(rootViewController: setVC)
        present(setNav, animated: true, completion: nil)
    }

}
