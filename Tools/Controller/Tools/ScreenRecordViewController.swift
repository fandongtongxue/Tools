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
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let dateStr = dateFormatter.string(from: date)
        
        let documentFilePath = documentDirectory.appendingPathComponent(dateStr+".mp4")
        
        let cachesDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! as NSString
        
        var cachesFilePath = cachesDirectory.appendingPathComponent("image0.jpg")
        let cachesFileDPath = cachesDirectory.appendingPathComponent("image%d.jpg")
        
        //先切割图片
        let command = "-i "+mediaURL.absoluteString+" -r 30 -q:v 2 -f image2 "+cachesFileDPath
        let session = FFmpegKit.executeAsync(command) { (session) in
            debugPrint("FFMpeg切割结束")
            //图片合成视频
            let command2 = "-f image2 -i "+cachesFileDPath+" "+"-vcodec h264 -r 25 "+documentFilePath
            let session2 = FFmpegKit.executeAsync(command2) { (session) in
                debugPrint("FFMpeg合成结束")
                DispatchQueue.main.async {
                    debugPrint(documentFilePath)
                    if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(documentFilePath) {
                        UISaveVideoAtPathToSavedPhotosAlbum(documentFilePath, self, #selector(self.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
                    }
                }
            }
            let code2 = session?.getReturnCode()
            if ReturnCode.isSuccess(code2) {
                debugPrint("ReturnCode.isSuccess(code)")
            }else if ReturnCode.isCancel(code2){
                debugPrint("ReturnCode.isCancel(code)")
            }else{
                debugPrint("ReturnCode.isFailure(code)")
            }
        }
        let code = session?.getReturnCode()
        if ReturnCode.isSuccess(code) {
            debugPrint("ReturnCode.isSuccess(code)")
        }else if ReturnCode.isCancel(code){
            debugPrint("ReturnCode.isCancel(code)")
        }else{
            debugPrint("ReturnCode.isFailure(code)")
        }
        
        
        
        
    }
    
    @objc func video(videoPath: String, didFinishSavingWithError error: NSError, contextInfo info: AnyObject){
        if error.code != 0 {
            view.makeToast("保存失败")
        }else{
            view.makeToast("保存成功")
        }
    }
    
    func saveImageBtnAction(image: UIImage){
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError, contextInfo info: AnyObject){
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
