//
//  VideoExtractAudioViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/21.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit

class VideoExtractAudioViewController: BaseViewController {
    
    var url : URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "视频提取音频"
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(FD_TopHeight)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }
        scrollView.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(FD_ScreenWidth - 30)
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    @objc func playVideoBtnAction(){
        let playerVC = AVPlayerViewController()
        let player = AVPlayer(url: url!)
        playerVC.player = player
        player.play()
        present(playerVC, animated: true, completion: nil)
    }
    
    @objc func generateBtnAction(){
        let asset = AVAsset(url: url!)
        let composition = AVMutableComposition()
        let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        do {
            try audioTrack?.insertTimeRange(CMTimeRange(start: CMTimeMake(value: 0, timescale: 0), end: asset.duration), of: asset.tracks(withMediaType: .audio).first!, at: CMTimeMake(value: 0, timescale: 0))
        }catch let error as NSError{
            debugPrint(error)
        }
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let time = Date().timeIntervalSince1970
        let fileURL = docURL?.appendingPathComponent("\(time).mp4")
        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        exporter?.outputURL = fileURL
        exporter?.outputFileType = .m4a
        exporter?.shouldOptimizeForNetworkUse = true
        exporter?.exportAsynchronously(completionHandler: {
            if exporter?.status == AVAssetExportSession.Status.completed {
                let activity = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                self.present(activity, animated: true, completion: nil)
            }else{
                self.view.makeToast("提取失败")
            }
        })
    }
    
    @objc func selectBtnAction(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    lazy var generateBtn : UIButton = {
        let generateBtn = UIButton(frame: .zero)
        generateBtn.setTitle("提取", for: .normal)
        generateBtn.setTitleColor(.systemBlue, for: .normal)
        generateBtn.addTarget(self, action: #selector(generateBtnAction), for: .touchUpInside)
        generateBtn.layer.cornerRadius = 10
        generateBtn.clipsToBounds = true
        generateBtn.layer.borderWidth = 1
        generateBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return generateBtn
    }()
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var playVideoBtn : UIButton = {
        let playVideoBtn = UIButton(frame: .zero)
        playVideoBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        playVideoBtn.setImage(#imageLiteral(resourceName: "play"), for: .highlighted)
        playVideoBtn.tintColor = .systemBackground
        playVideoBtn.addTarget(self, action: #selector(playVideoBtnAction), for: .touchUpInside)
        return playVideoBtn
    }()
    
    lazy var selectBtn : UIButton = {
        let selectBtn = UIButton(frame: .zero)
        selectBtn.setTitle("从相册选取视频", for: .normal)
        selectBtn.setTitleColor(.systemBlue, for: .normal)
        selectBtn.addTarget(self, action: #selector(selectBtnAction), for: .touchUpInside)
        selectBtn.layer.cornerRadius = 10
        selectBtn.clipsToBounds = true
        selectBtn.layer.borderWidth = 1
        selectBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return selectBtn
    }()
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentSize = CGSize(width: 0, height: (FD_ScreenWidth - 30) * 9 / 16 + 40 + 40 + 2 * 15 + FD_SafeAreaBottomHeight)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -FD_SafeAreaBottomHeight, right: 0)
        return scrollView
    }()

}

extension VideoExtractAudioViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if !scrollView.subviews.contains(generateBtn) {
            scrollView.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.width.equalTo(FD_ScreenWidth - 30)
                make.top.equalTo(self.selectBtn.snp.bottom).offset(15)
                make.height.equalTo((FD_ScreenWidth - 30) * 9 / 16)
            }
            scrollView.addSubview(playVideoBtn)
            playVideoBtn.snp.makeConstraints { (make) in
                make.width.equalTo(40)
                make.center.equalTo(self.imageView)
                make.height.equalTo(40)
            }
            scrollView.addSubview(generateBtn)
            generateBtn.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.width.equalTo(FD_ScreenWidth - 30)
                make.top.equalTo(self.imageView.snp.bottom).offset(15)
                make.height.equalTo(40)
            }
        }
        url = info[.mediaURL] as! URL
        let asset = AVAsset(url: url!)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        var actualTime = CMTimeMake(value: 0, timescale: 0)
        let imageRef = try! generator.copyCGImage(at: CMTimeMakeWithSeconds(0, preferredTimescale: 1), actualTime: &actualTime)
        let image = UIImage(cgImage: imageRef)
        imageView.image = image
    }
}
