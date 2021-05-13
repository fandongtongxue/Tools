//
//  WebpageShotViewController.swift
//  Tools
//
//  Created by Mac on 2021/5/13.
//

import UIKit

class WebpageShotViewController: BaseViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "网页截图"
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(FD_TopHeight)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }
        scrollView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.equalTo(80)
            make.width.equalTo(FD_ScreenWidth - 30)
        }
        
        scrollView.addSubview(goBtn)
        goBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(FD_ScreenWidth - 30)
            make.top.equalTo(self.textView.snp.bottom).offset(15)
            make.height.equalTo(40)
        }
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
    
    
    
    @objc func goBtnAction(){
        if textView.text.count == 0 {
            return
        }
        view.endEditing(true)
        let webVC = WebViewController()
        webVC.title = "预览"
        webVC.loadUrl(textView.text)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    
    
    @objc func checkUIPasteboard(){
        let pasteboardStr = UIPasteboard.general.string
        if pasteboardStr?.count ?? 0 > 0 && pasteboardStr != textView.text {
            let alert = UIAlertController(title: "是否将剪贴板填入网址中", message: pasteboardStr, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                self.textView.text = pasteboardStr
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentSize = CGSize(width: 0, height: (UIScreen.main.bounds.size.width - 30) * 9 / 16 + 40 + 80 + 40 + 40 + 4 * 15 + 50 + FD_SafeAreaBottomHeight)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -FD_SafeAreaBottomHeight, right: 0)
        return scrollView
    }()

    lazy var textView : UITextView = {
        let textView = UITextView(frame: .zero)
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.systemFill.cgColor
        textView.font = .systemFont(ofSize: 15)
        return textView
    }()
    
    lazy var goBtn : UIButton = {
        let goBtn = UIButton(frame: .zero)
        goBtn.setTitle("前往", for: .normal)
        goBtn.setTitleColor(.systemBlue, for: .normal)
        goBtn.addTarget(self, action: #selector(goBtnAction), for: .touchUpInside)
        goBtn.layer.cornerRadius = 10
        goBtn.clipsToBounds = true
        goBtn.layer.borderWidth = 1
        goBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return goBtn
    }()

}
