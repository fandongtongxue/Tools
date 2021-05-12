//
//  ScreenRecordViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/26.
//

import UIKit
import MobileCoreServices
import AVFoundation
import DeviceKit
import AVKit
import PhotosUI

class ScreenRecordViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "录屏套壳"
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
    
    @objc func selectBtnAction(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    

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
    
    func getImagesFromVideo(mediaURL: URL){
        view.makeToastActivity(.center)
        let iphoneImgName = Device.current.safeDescription + " Silver"
        let iphoneImg = UIImage(named: iphoneImgName)
        let iphoneImgW = iphoneImg?.size.width ?? 0
        let iphoneImgH = iphoneImg?.size.height ?? 0
        let avAsset = AVAsset(url: mediaURL)
        let duration = avAsset.duration
        let durationFloatValue = floor(CMTimeGetSeconds(duration))
        let avMutableComposition = AVMutableComposition()
        let avMutableCompositionTrack = avMutableComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let avAssetTrack = avAsset.tracks(withMediaType: .video).first
        let videoSize = CGSize(width: (avAssetTrack?.naturalSize.width ?? 0) * 2, height: (avAssetTrack?.naturalSize.height ?? 0) * 2)
        debugPrint(videoSize)
        do {
            try avMutableCompositionTrack?.insertTimeRange(CMTimeRange(start: CMTime(value: 0, timescale: 30), end: CMTimeMakeWithSeconds(durationFloatValue, preferredTimescale: 30)), of: avAssetTrack!, at: CMTime(value: 0, timescale: 30))
            let audioCompositionTrack = avMutableComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            let audioSetList = avAsset.tracks(withMediaType: .audio)
            if audioSetList.count > 0 {
                let audioAssetTrack = avAsset.tracks(withMediaType: .audio).first
                do {
                    try audioCompositionTrack?.insertTimeRange(CMTimeRange(start: CMTime(value: 0, timescale: 30), end: CMTimeMakeWithSeconds(durationFloatValue, preferredTimescale: 30)), of: audioAssetTrack!, at: CMTime(value: 0, timescale: 30))
                } catch let error {
                    view.makeToast(error.localizedDescription)
                }
                let avMutableVideoComposition = AVMutableVideoComposition()
                avMutableVideoComposition.renderSize = CGSize(width: iphoneImgW, height: iphoneImgH)
                avMutableVideoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
                let parentLayer = CALayer()
                let videoLayer = CALayer()
                parentLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: iphoneImgW, height: iphoneImgH))
                debugPrint(parentLayer.frame)
                let realRect = CGRect(x: (iphoneImgW - videoSize.width) / 2, y: (iphoneImgH - videoSize.height) / 2, width: videoSize.width, height: videoSize.height)
                videoLayer.frame = realRect
                debugPrint(realRect)
                parentLayer.addSublayer(videoLayer)
                let waterMarkLayer = CALayer()
                waterMarkLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: iphoneImgW, height: iphoneImgH))
                waterMarkLayer.contents = iphoneImg?.cgImage!
                parentLayer.addSublayer(waterMarkLayer)
                avMutableVideoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
                let avMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
                avMutableVideoCompositionInstruction.timeRange = CMTimeRangeMake(start: CMTimeMake(value: 0, timescale: 30), duration: avMutableComposition.duration)
                let avMutableVideoCompositionLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: avMutableCompositionTrack!)
                avMutableCompositionTrack?.preferredTransform = avAssetTrack!.preferredTransform
                avMutableVideoCompositionInstruction.layerInstructions = [avMutableVideoCompositionLayerInstruction]
                avMutableVideoComposition.instructions = [avMutableVideoCompositionInstruction]
                let fm = FileManager.default
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
                let filePath = documentDirectory.appendingPathComponent("output.mp4")
                
                if fm.fileExists(atPath: filePath) {
                    do {
                        try fm.removeItem(at: URL(fileURLWithPath: filePath))
                    } catch let error {
                        view.makeToast(error.localizedDescription)
                    }
                }
                let avAssetExportSession = AVAssetExportSession(asset: avMutableComposition, presetName: AVAssetExportPresetHighestQuality)
                avAssetExportSession?.videoComposition = avMutableVideoComposition
                avAssetExportSession?.outputURL = URL(fileURLWithPath: filePath)
                var isMp4 = false
                for string in avAssetExportSession?.supportedFileTypes ?? [] {
                    if string == AVFileType.mp4 {
                        isMp4 = true
                    }
                }
                if isMp4 {
                    avAssetExportSession?.outputFileType = .mp4
                }else{
                    avAssetExportSession?.outputFileType = .mov
                }
                avAssetExportSession?.shouldOptimizeForNetworkUse = false
                avAssetExportSession?.exportAsynchronously(completionHandler: {
                    DispatchQueue.main.async {
                        self.view.hideToastActivity()
                        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath){
                            UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, #selector(self.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
                        }
                    }
                })
            }
        } catch let error {
            view.makeToast(error.localizedDescription)
        }
        
        
        
        
    }
    
    @objc func video(videoPath: String, didFinishSavingWithError error: NSError, contextInfo info: AnyObject){
        if error.code != 0 {
            view.makeToast("保存失败")
        }else{
            view.makeToast("保存成功")
        }
    }

}

extension ScreenRecordViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if info[.mediaURL] != nil {
            let mediaURL = info[.mediaURL] as! URL
            getImagesFromVideo(mediaURL: mediaURL)
        }else{
            let phAsset = info[.phAsset] as! PHAsset
            let options = PHVideoRequestOptions()
            options.version = .current
            options.deliveryMode = .automatic
            let manager = PHImageManager.default()
            manager.requestAVAsset(forVideo: phAsset, options: options) { (asset, audioMix, info) in
                let urlAsset = asset as! AVURLAsset
                let mediaURL = urlAsset.url
                self.getImagesFromVideo(mediaURL: mediaURL)
            }
        }
        
    }
}
