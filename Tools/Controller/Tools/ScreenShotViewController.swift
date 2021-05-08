//
//  ScreenShotViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/26.
//

import UIKit
import MobileCoreServices
import DeviceKit

class ScreenShotViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "带壳截图"
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
    
    @objc func selectBtnAction(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    

    lazy var selectBtn : UIButton = {
        let selectBtn = UIButton(frame: .zero)
        selectBtn.setTitle("从相册选取图片", for: .normal)
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
    
    func generateShot(imageName: String, originImage: UIImage, radius: CGFloat){
        
        let radiusImage = originImage.roundImage(cornerRadi: radius)
        
        let iphoneImg = UIImage(named: imageName)
        let iphoneImgW = iphoneImg?.size.width ?? 0
        let iphoneImgH = iphoneImg?.size.height ?? 0
        
        let maskImg = UIImage(named: "iPhone 11 Mask.jpeg")
        let maskImgW = maskImg?.size.width ?? 0
        let maskImgH = maskImg?.size.height ?? 0
        
        let realRect = CGRect(x: (iphoneImgW - maskImgW ) / 2, y: (iphoneImgH - maskImgH ) / 2, width: maskImgW, height: maskImgH)
        
        UIGraphicsBeginImageContext(CGSize(width: iphoneImgW, height: iphoneImgH))
        iphoneImg?.draw(in: CGRect(x: 0, y: 0, width: iphoneImgW, height: iphoneImgH))
        radiusImage?.draw(in: realRect)
        let resultImg = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        
        saveImageBtnAction(image: resultImg)
    }

}

extension ScreenShotViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[.originalImage] as! UIImage
        
        var iphoneImgName = ""
        
        let device = Device.current
        if device.isFaceIDCapable {
            if device == .iPhone12 || device == .iPhone12Pro || device == .iPhone12ProMax {
                let alert = UIAlertController(title: "选择不同款式", message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "iPhone 12 黑", style: .default, handler: { (action) in
                    iphoneImgName = "12-Black.png"
                    self.generateShot(imageName: iphoneImgName, originImage: image, radius: 90)
                }))
                alert.addAction(UIAlertAction(title: "iPhone 12 蓝", style: .default, handler: { (action) in
                    iphoneImgName = "12-Blue.png"
                    self.generateShot(imageName: iphoneImgName, originImage: image, radius: 90)
                }))
                alert.addAction(UIAlertAction(title: "iPhone 12 绿", style: .default, handler: { (action) in
                    iphoneImgName = "12-Green.png"
                    self.generateShot(imageName: iphoneImgName, originImage: image, radius: 90)
                }))
                alert.addAction(UIAlertAction(title: "iPhone 12 红", style: .default, handler: { (action) in
                    iphoneImgName = "12-Red.png"
                    self.generateShot(imageName: iphoneImgName, originImage: image, radius: 90)
                }))
                alert.addAction(UIAlertAction(title: "iPhone 12 白", style: .default, handler: { (action) in
                    iphoneImgName = "12-White.png"
                    self.generateShot(imageName: iphoneImgName, originImage: image, radius: 90)
                }))
                alert.addAction(UIAlertAction(title: "iPhone 12 Pro 黑", style: .default, handler: { (action) in
                    iphoneImgName = "12P-Black.png"
                    self.generateShot(imageName: iphoneImgName, originImage: image, radius: 90)
                }))
                alert.addAction(UIAlertAction(title: "iPhone 12 Pro 蓝", style: .default, handler: { (action) in
                    iphoneImgName = "12P-Blue.png"
                    self.generateShot(imageName: iphoneImgName, originImage: image, radius: 90)
                }))
                alert.addAction(UIAlertAction(title: "iPhone 12 Pro 金", style: .default, handler: { (action) in
                    iphoneImgName = "12P-Gold.png"
                    self.generateShot(imageName: iphoneImgName, originImage: image, radius: 90)
                }))
                alert.addAction(UIAlertAction(title: "iPhone 12 Pro 白", style: .default, handler: { (action) in
                    iphoneImgName = "12P-White.png"
                    self.generateShot(imageName: iphoneImgName, originImage: image, radius: 90)
                }))
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }else{
                iphoneImgName = "iPhone 11.jpeg"
                generateShot(imageName: iphoneImgName, originImage: image, radius: 70)
            }
        }else{
            self.view.makeToast("由于无相关机型素材，目前仅支持全面屏设备")
            return
        }
    }
}
