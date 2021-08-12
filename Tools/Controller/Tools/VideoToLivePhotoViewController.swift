//
//  ScreenShotViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/26.
//

import UIKit
import MobileCoreServices
import DeviceKit
import Photos

class VideoToLivePhotoViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "视频转Live Photo"
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
        picker.mediaTypes = ["public.movie"]
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
    
    func previewImage(videoURL: URL) -> UIImage? {
        let asset = AVURLAsset(url: videoURL, options: nil)
        let assetGen = AVAssetImageGenerator(asset: asset)
        assetGen.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: 0, timescale: 600)
        do {
            let image = try assetGen.copyCGImage(at: time, actualTime: nil)
            let videoImage = UIImage(cgImage: image)
            return videoImage
        } catch let error {
            debugPrint(error.localizedDescription)
            return nil
        }
    }

}

extension VideoToLivePhotoViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let videoURL = info[.mediaURL] as! URL
        let image = previewImage(videoURL: videoURL)
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let documentPathStr = documentPath as! NSString
        let imagePath = documentPathStr.appendingPathComponent("temp.png")
        let imageURL = URL(fileURLWithPath: imagePath)
        do {
            let imageData = try Data(contentsOf: imageURL)
            try image?.jpegData(compressionQuality: 1)?.write(to: imageURL)
            PHLivePhoto.request(withResourceFileURLs: [videoURL,imageURL], placeholderImage: image, targetSize: .zero, contentMode: .default) { photo, result in
                debugPrint(photo)
                debugPrint(result)
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        
    }
}
