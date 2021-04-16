//
//  ToolDetailViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/15.
//

import UIKit
import WebKit
import AVKit

class ToolDetailViewController: BaseViewController {
    var model = ToolModel()
    
    lazy var webView : WKWebView = {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = model.name
        
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        webView.load(URLRequest(url: URL(string: model.desc_url)!))
        
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
