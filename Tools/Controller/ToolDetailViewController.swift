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
        
        let mdView = MarkdownView()
        view.addSubview(mdView)
        mdView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if Locale.preferredLanguages.first?.contains("zh") ?? false {
            mdView.load(markdown: model.desc_md, enableImage: true)
        }else{
            mdView.load(markdown: model.desc_en_md, enableImage: true)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
