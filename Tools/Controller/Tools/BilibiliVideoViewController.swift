//
//  BilibiliVideoViewController.swift
//  Tools
//
//  Created by Mac on 2021/7/28.
//

import UIKit
import AVKit
import Toast_Swift
import Alamofire
import GoogleMobileAds

class BilibiliVideoViewController: BaseViewController {
    
    var player: ZFPlayerController?

    var model = BilibiliVideoModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "哔哩哔哩视频解析下载"
        
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
        
        scrollView.addSubview(parseBtn)
        parseBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(FD_ScreenWidth - 30)
            make.top.equalTo(self.textView.snp.bottom).offset(15)
            make.height.equalTo(40)
        }
        
        
    }
    
    func setupPlayer(){
        let playerManager = ZFIJKPlayerManager()
        playerManager.shouldAutoPlay = true
        player = ZFPlayerController(playerManager: playerManager, containerView: containerView)
        player?.controlView = controlView
        player?.pauseWhenAppResignActive = false
        player?.allowOrentitaionRotation = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUIPasteboard()
        NotificationCenter.default.addObserver(self, selector: #selector(checkUIPasteboard), name: UIApplication.willEnterForegroundNotification, object: nil)
        player?.isViewControllerDisappear = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        player?.isViewControllerDisappear = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func addVideoView(){
        if !(scrollView.subviews.contains(containerView)) {
            scrollView.addSubview(containerView)
            containerView.frame = CGRect(x: 0, y: 150, width: FD_ScreenWidth - 30, height: (UIScreen.main.bounds.size.width - 30) * 9 / 16)
            containerView.addSubview(playVideoBtn)
            playVideoBtn.snp.makeConstraints { (make) in
                make.center.equalTo(self.containerView)
                make.width.equalTo(40)
                make.height.equalTo(40)
            }
            
            scrollView.addSubview(saveVideoBtn)
            saveVideoBtn.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.height.equalTo(40)
                make.width.equalTo(FD_ScreenWidth - 30)
                make.top.equalTo(self.parseBtn.snp.bottom).offset(30 + (UIScreen.main.bounds.size.width - 30) * 9 / 16)
            }
            scrollView.addSubview(bannerView)
            bannerView.snp.makeConstraints { (make) in
                make.top.equalTo(self.saveVideoBtn.snp.bottom).offset(15)
                make.centerX.equalToSuperview()
            }
            bannerView.load(GADRequest())
            setupPlayer()
        }
        containerView.kf.setImage(with: URL(string: model.cover))
        player?.assetURL = URL(string: model.url)!
        controlView.showTitle(model.title, coverURLString: model.cover, fullScreenMode: .automatic)
    }
    
    @objc func parseBtnAction(){
        if textView.text.count == 0 {
            return
        }
        view.endEditing(true)
        view.makeToastActivity(.center)
        let url = textView.text.getUrls().first ?? ""
        FDNetwork.GET(url: "https://tenapi.cn/bilivideo/", param: ["url":url], success: { (result) in
            let model = BilibiliVideoModel.deserialize(from: result) ?? BilibiliVideoModel()
            self.model = model
            //解析成功
            if model.code == 200{
                self.addVideoView()
            }
            self.view.hideToastActivity()
        }) { (msg) in
            self.view.hideToastActivity()
        }
    }
    
    @objc func playVideoBtnAction(){
        let playerVC = AVPlayerViewController()
        let player = AVPlayer(url: URL(string: model.url)!)
        playerVC.player = player
        player.play()
        present(playerVC, animated: true, completion: nil)
    }
    
    @objc func saveVideoBtnAction(sender :UIButton){
        sender.isUserInteractionEnabled = false
        view.makeToastActivity(.center)
        AF.download(model.url, to: { (url, urlResponse) -> (destinationURL: URL, options: DownloadRequest.Options) in
            let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let time = Date().timeIntervalSince1970
            let fileURL = docURL?.appendingPathComponent("\(time).mp4")
            return (fileURL!, [.removePreviousFile,.createIntermediateDirectories])
        }).responseData { (response) in
            if response.fileURL != nil{
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(response.fileURL?.path ?? "") {
                    UISaveVideoAtPathToSavedPhotosAlbum(response.fileURL?.path ?? "", self, #selector(self.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
                }
            }
            self.view.hideToastActivity()
            sender.isUserInteractionEnabled = true
        }
    }
    
    @objc func video(videoPath: String, didFinishSavingWithError error: NSError, contextInfo info: AnyObject){
        view.hideToastActivity()
        if error.code != 0 {
            view.makeToast("保存失败")
        }else{
            view.makeToast("保存成功")
        }
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
    
    lazy var bannerView: GADBannerView = {
        let bannerView = GADBannerView()
        bannerView.adUnitID = AdMobAdUnitID
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.adSize = kGADAdSizeBanner
        return bannerView
    }()
    
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
    
    lazy var parseBtn : UIButton = {
        let parseBtn = UIButton(frame: .zero)
        parseBtn.setTitle("开始解析", for: .normal)
        parseBtn.setTitleColor(.systemBlue, for: .normal)
        parseBtn.addTarget(self, action: #selector(parseBtnAction), for: .touchUpInside)
        parseBtn.layer.cornerRadius = 10
        parseBtn.clipsToBounds = true
        parseBtn.layer.borderWidth = 1
        parseBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return parseBtn
    }()
    
    
    
    lazy var playVideoBtn : UIButton = {
        let playVideoBtn = UIButton(frame: .zero)
        playVideoBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        playVideoBtn.setImage(#imageLiteral(resourceName: "play"), for: .highlighted)
        playVideoBtn.tintColor = .systemBackground
        playVideoBtn.addTarget(self, action: #selector(playVideoBtnAction), for: .touchUpInside)
        return playVideoBtn
    }()
    
    lazy var saveVideoBtn : UIButton = {
        let saveVideoBtn = UIButton(frame: .zero)
        saveVideoBtn.setTitle("保存视频", for: .normal)
        saveVideoBtn.setTitleColor(.systemBlue, for: .normal)
        saveVideoBtn.addTarget(self, action: #selector(saveVideoBtnAction(sender:)), for: .touchUpInside)
        saveVideoBtn.layer.cornerRadius = 10
        saveVideoBtn.clipsToBounds = true
        saveVideoBtn.layer.borderWidth = 1
        saveVideoBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return saveVideoBtn
    }()
    
    lazy var containerView: UIImageView = {
        let containerView = UIImageView(frame: .zero)
        return containerView
    }()
    
    lazy var controlView: ZFPlayerControlView = {
        let controlView = ZFPlayerControlView(frame: .zero)
        controlView.fastViewAnimated = true
        controlView.autoHiddenTimeInterval = 5
        controlView.autoFadeTimeInterval = 0.5
        controlView.prepareShowLoading = true
        controlView.prepareShowControlView = false
        return controlView
    }()

}

extension BilibiliVideoViewController : GADBannerViewDelegate{
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        bannerView.load(GADRequest())
    }
}
