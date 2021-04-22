//
//  TTSViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/21.
//

import UIKit
import AVFoundation

class TTSViewController: BaseViewController {
    
    let syntesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "文字转语音"
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
        
        scrollView.addSubview(generateBtn)
        generateBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(FD_ScreenWidth - 30)
            make.top.equalTo(self.textView.snp.bottom).offset(15)
            make.height.equalTo(40)
        }
        
    }
    
    @objc func generateBtnAction(){
        if textView.text.count == 0 {
            return
        }
        view.endEditing(true)
        utterance = AVSpeechUtterance(string: textView.text)
        utterance.rate = 0.1
        syntesizer.delegate = self
        syntesizer.speak(utterance)
        
        if !scrollView.subviews.contains(playBtn) {
            scrollView.addSubview(playBtn)
            playBtn.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalTo(self.generateBtn.snp.bottom).offset(15)
                make.height.equalTo(40)
                make.width.equalTo((FD_ScreenWidth - 30 - 15)/2)
            }
            scrollView.addSubview(stopBtn)
            stopBtn.snp.makeConstraints { (make) in
                make.left.equalTo(self.playBtn.snp.right).offset(15)
                make.top.equalTo(self.generateBtn.snp.bottom).offset(15)
                make.height.equalTo(40)
                make.width.equalTo((FD_ScreenWidth - 30 - 15)/2)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        syntesizer.stopSpeaking(at: .word)
    }
    
    @objc func playBtnAction(sender: UIButton){
        sender.isSelected = !sender.isSelected
        if !sender.isSelected {
            syntesizer.pauseSpeaking(at: .word)
        }else{
            if syntesizer.isPaused {
                syntesizer.continueSpeaking()
            }else{
                syntesizer.speak(utterance)
            }
        }
    }
    
    @objc func stopBtnAction(){
        syntesizer.stopSpeaking(at: .word)
        playBtn.isSelected = false
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
    
    lazy var generateBtn : UIButton = {
        let generateBtn = UIButton(frame: .zero)
        generateBtn.setTitle("生成", for: .normal)
        generateBtn.setTitleColor(.systemBlue, for: .normal)
        generateBtn.addTarget(self, action: #selector(generateBtnAction), for: .touchUpInside)
        generateBtn.layer.cornerRadius = 10
        generateBtn.clipsToBounds = true
        generateBtn.layer.borderWidth = 1
        generateBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return generateBtn
    }()
    
    lazy var playBtn : UIButton = {
        let playBtn = UIButton(frame: .zero)
        playBtn.addTarget(self, action: #selector(playBtnAction(sender:)), for: .touchUpInside)
        playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playBtn.setImage(UIImage(systemName: "pause.fill"), for: .selected)
        playBtn.layer.cornerRadius = 10
        playBtn.clipsToBounds = true
        playBtn.layer.borderWidth = 1
        playBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return playBtn
    }()
    
    lazy var stopBtn : UIButton = {
        let stopBtn = UIButton(frame: .zero)
        stopBtn.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        stopBtn.addTarget(self, action: #selector(stopBtnAction), for: .touchUpInside)
        stopBtn.layer.cornerRadius = 10
        stopBtn.clipsToBounds = true
        stopBtn.layer.borderWidth = 1
        stopBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return stopBtn
    }()
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentSize = CGSize(width: 0, height: 40 + 80 + 40 + 3 * 15 + FD_SafeAreaBottomHeight)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -FD_SafeAreaBottomHeight, right: 0)
        return scrollView
    }()

}

extension TTSViewController : AVSpeechSynthesizerDelegate{
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        playBtn.isSelected = true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        playBtn.isSelected = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        playBtn.isSelected = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
    }
}
