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
    }
    

    @objc func setBtnAction(){
        let setVC = SetViewController(style: .insetGrouped)
        let setNav = BaseNavigationController(rootViewController: setVC)
        present(setNav, animated: true, completion: nil)
    }

}
