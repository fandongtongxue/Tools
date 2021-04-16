//
//  ParseShortVideoViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/16.
//  解析短视频URL功能

import UIKit
import AVKit

class ParseShortVideoController: BaseViewController {
    
    var model = ParseShortVideoModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "解析短视频"
        
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(132 + 15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(80)
        }
        
        view.addSubview(parseBtn)
        parseBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.textView)
            make.top.equalTo(self.textView.snp.bottom).offset(15)
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
    
    func addVideoView(){
        if !(view.layer.sublayers?.contains(playerLayer) ?? false) {
            view.layer.addSublayer(playerLayer)
            view.addSubview(playVideoBtn)
            playVideoBtn.snp.makeConstraints { (make) in
                make.left.equalTo(self.textView)
                make.width.equalTo((UIScreen.main.bounds.size.width - 45) / 2)
                make.height.equalTo(40)
                make.top.equalTo(self.parseBtn.snp.bottom).offset(30 + (UIScreen.main.bounds.size.width - 30) * 9 / 16)
            }
            
            view.addSubview(saveVideoBtn)
            saveVideoBtn.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-15)
                make.width.equalTo((UIScreen.main.bounds.size.width - 45) / 2)
                make.height.equalTo(40)
                make.top.equalTo(self.parseBtn.snp.bottom).offset(30 + (UIScreen.main.bounds.size.width - 30) * 9 / 16)
            }
        }
        let item = AVPlayerItem(url: URL(string: (model.data?.url)!)!)
        player.replaceCurrentItem(with: item)
    }
    
    @objc func parseBtnAction(){
//        http://api.tools.app.xiaobingkj.com/parseVideo.php?url=http://v.douyin.com/eMKj42N/
        FDNetwork.GET(url: "http://api.tools.app.xiaobingkj.com/parseVideo.php", param: ["url":textView.text], success: { (result) in
            let model = ParseShortVideoModel.deserialize(from: result) ?? ParseShortVideoModel()
            self.model = model
            if model.code == 200 {
                //解析成功
                self.addVideoView()
            }
        }) { (msg) in
            print(msg)
        }
    }
    
    @objc func playVideoBtnAction(){
        let playerVC = AVPlayerViewController()
        let player = AVPlayer(url: URL(string: model.data?.url ?? "")!)
        playerVC.player = player
        player.play()
        present(playerVC, animated: true, completion: nil)
    }
    
    @objc func saveVideoBtnAction(){
        
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
        parseBtn.layer.borderWidth = 0.5
        parseBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return parseBtn
    }()
    
    
    
    lazy var playVideoBtn : UIButton = {
        let playVideoBtn = UIButton(frame: .zero)
        playVideoBtn.setTitle("播放视频", for: .normal)
        playVideoBtn.setTitleColor(.systemBlue, for: .normal)
        playVideoBtn.addTarget(self, action: #selector(playVideoBtnAction), for: .touchUpInside)
        playVideoBtn.layer.cornerRadius = 10
        playVideoBtn.clipsToBounds = true
        playVideoBtn.layer.borderWidth = 0.5
        playVideoBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return playVideoBtn
    }()
    
    lazy var saveVideoBtn : UIButton = {
        let saveVideoBtn = UIButton(frame: .zero)
        saveVideoBtn.setTitle("保存视频", for: .normal)
        saveVideoBtn.setTitleColor(.systemBlue, for: .normal)
        saveVideoBtn.addTarget(self, action: #selector(saveVideoBtnAction), for: .touchUpInside)
        saveVideoBtn.layer.cornerRadius = 10
        saveVideoBtn.clipsToBounds = true
        saveVideoBtn.layer.borderWidth = 0.5
        saveVideoBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return saveVideoBtn
    }()
    
    lazy var player : AVPlayer = {
        let item = AVPlayerItem(url: URL(string: (model.data?.url)!)!)
        let player = AVPlayer(playerItem: item)
        return player
    }()
    
    lazy var playerLayer : AVPlayerLayer = {
        let playerLayer = AVPlayerLayer(player: player)
        let width = UIScreen.main.bounds.size.width - 30
        playerLayer.frame = CGRect(x: 15, y: self.parseBtn.frame.origin.y + self.parseBtn.frame.size.height + 15, width: width, height: width * 9 / 16)
        playerLayer.backgroundColor = UIColor.systemGray6.cgColor
        playerLayer.cornerRadius = 10
        return playerLayer
    }()

}
