//
//  WebViewController.swift
//  Tools
//
//  Created by Mac on 2021/5/13.
//

import UIKit
import WebKit
import SwViewCapture

class WebViewController: BaseViewController {
    lazy var isShare = false
    var url: URL?
    func loadUrl(_ urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        self.url = url
        webView.load(URLRequest(url: url))
    }
    func getScriptNames() -> [String] { [] }
    deinit {
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
    }
    lazy var webView = loadWebView()
    lazy var isJScript = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    init(_ urlStr: String) {
        super.init(nibName: nil, bundle: nil)
        self.url = URL(string: urlStr)
        webView.load(URLRequest(url: URL(string: urlStr)!))
    }
    init(fileURL : URL, allowingReadAccessTo : URL){
        super.init(nibName: nil, bundle: nil)
        webView.loadFileURL(fileURL, allowingReadAccessTo: allowingReadAccessTo)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for name in getScriptNames() {
            webView.configuration.userContentController.add(self, name: name)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for name in getScriptNames() {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: name)
        }
    }
    
    override func upConfig() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    override func upView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "截图", style: .plain, target: self, action: #selector(captureBtnAction))
        view.addSubview(webView)
        webView.frame = view.bounds
    }
    
    @objc func captureBtnAction(){
        view.makeToastActivity(.center)
        webView.swContentCapture { (image) in
            self.view.hideToastActivity()
            if image != nil {
                self.saveImage(image: image!)
            }
        }
    }
    
    private func loadWebView() -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: loadConfiguration())
        webView.isOpaque = false
        webView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        webView.scrollView.bounces = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        let types = Set(arrayLiteral: WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache)
        WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: Date(timeIntervalSince1970: 0)) {}
        return webView
    }
    private func loadConfiguration() -> WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        config.allowsInlineMediaPlayback = true
        config.userContentController = loadUserContentController()
        config.processPool = WKProcessPool()
        return config
    }
    private func loadUserContentController() -> WKUserContentController {
        let userContent = WKUserContentController()
        if isJScript {
            let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
            let userScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            userContent.addUserScript(userScript)
        }
        return userContent
    }
}

extension WebViewController: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        debugPrint(message.name)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let urlStr = navigationAction.request.url?.absoluteString, urlStr.hasPrefix("objc://share"), urlStr.hasSuffix(":back") else {
            decisionHandler(.allow)
            return
        }
        if let nav = navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: true)
        } else {
            navigationController?.dismiss(animated: true)
            dismiss(animated: true)
        }
        decisionHandler(.cancel)
    }
}

