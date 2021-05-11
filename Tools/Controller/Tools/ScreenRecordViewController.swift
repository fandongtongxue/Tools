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
        let asset = AVAsset(url: mediaURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let duration = CMTimeGetSeconds(asset.duration)
        var valueArray = [NSValue]()
        for i in 0...Int64(duration*25) {
            let point = CMTimeMake(value: i, timescale: 25) as! NSValue
            valueArray.append(point)
        }
        var imageArray = [UIImage]()
        var index = 0
        view.makeToastActivity(.center)
        imageGenerator.generateCGImagesAsynchronously(forTimes: valueArray) { (requestedTime, image, actualTime, result, error) in
            if result == .succeeded && image != nil {
                let finalImage = UIImage(cgImage: image!)
                
                let iphoneImgName = Device.current.safeDescription + " Silver"
                let iphoneImg = UIImage(named: iphoneImgName)
                let iphoneImgW = iphoneImg?.size.width ?? 0
                let iphoneImgH = iphoneImg?.size.height ?? 0
                
                let realRect = CGRect(x: (iphoneImgW - finalImage.size.width) / 2, y: (iphoneImgH - finalImage.size.height) / 2, width: finalImage.size.width, height: finalImage.size.height)
                
                UIGraphicsBeginImageContext(CGSize(width: iphoneImgW, height: iphoneImgH))
                finalImage.draw(in: realRect)
                iphoneImg?.draw(in: CGRect(x: 0, y: 0, width: iphoneImgW, height: iphoneImgH))
                let resultImg = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
                UIGraphicsEndImageContext()
                
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
                let dateStr = dateFormatter.string(from: date)
                
                let documentFilePath = documentDirectory.appendingPathComponent(dateStr+".mp4")
                
                let cachesDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! as NSString
                
                var cachesFilePath = cachesDirectory.appendingPathComponent("image0.jpg")
                let cachesFileDPath = cachesDirectory.appendingPathComponent("image%d.jpg")
                do {
                    cachesFilePath = cachesDirectory.appendingPathComponent("image"+"\(index)"+".jpg")
                    try resultImg.jpegData(compressionQuality: 1)?.write(to: URL(fileURLWithPath: cachesFilePath))
                    index = index + 1
                    debugPrint(cachesFilePath)
                } catch _ {
                    
                }
                                
                imageArray.append(resultImg)
                
                if imageArray.count == valueArray.count {
                    let command = "-f image2 -i "+cachesFileDPath+" "+"-vcodec h264 -r 25"+" "+documentFilePath
                    let session = FFmpegKit.executeAsync(command) { (session) in
                        debugPrint("FFMpeg结束")
                        DispatchQueue.main.async {
                            self.view.hideToastActivity()
                            debugPrint(documentFilePath)
                            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(documentFilePath) {
                                UISaveVideoAtPathToSavedPhotosAlbum(documentFilePath, self, #selector(self.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
                            }
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
            }else{
                self.view.makeToast(error?.localizedDescription)
            }
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
        let mediaURL = info[.mediaURL] as! URL
        getImagesFromVideo(mediaURL: mediaURL)
    }
}
