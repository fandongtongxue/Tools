//
//  ShotOnViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/26.
//

import UIKit
import MobileCoreServices
import DeviceKit

class ShotOnViewController: BaseViewController {
    
    var originImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "相机水印"
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
    
    @objc func promptPhoto() {
        
        let prompt = UIAlertController(title: "选取一张照片",
                                       message: nil,
                                       preferredStyle: .actionSheet)
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        func presentCamera(_ _: UIAlertAction) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true)
        }
        
        let cameraAction = UIAlertAction(title: "拍照",
                                         style: .default,
                                         handler: presentCamera)
        
        func presentLibrary(_ _: UIAlertAction) {
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }
        
        let libraryAction = UIAlertAction(title: "从相册中选取",
                                          style: .default,
                                          handler: presentLibrary)
        
        func presentAlbums(_ _: UIAlertAction) {
            imagePicker.sourceType = .savedPhotosAlbum
            self.present(imagePicker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "取消",
                                         style: .cancel,
                                         handler: nil)
        
        prompt.addAction(cameraAction)
        prompt.addAction(libraryAction)
        prompt.addAction(cancelAction)
        
        self.present(prompt, animated: true, completion: nil)
    }
    
    @objc func saveImageBtnAction(){
        
    }
    
    func addMarkImageView(isShotOn: Bool){
        let image = getImageFromDevice(isShotOn: isShotOn)
        let scale = imageView.bounds.size.width / originImage.size.width
        if !imageView.subviews.contains(markImageView) {
            imageView.addSubview(markImageView)
            markImageView.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: image.size.width * scale / 2, height: image.size.height * scale / 2))
                make.center.equalToSuperview()
            }
        }
        markImageView.image = image
    }
    
    @objc func shotOnBtnAction(){
        addMarkImageView(isShotOn: true)
    }
    
    @objc func fromBtnAction(){
        addMarkImageView(isShotOn: false)
    }
    
    @objc func markImageViewPanAction(sender: UIPanGestureRecognizer){
        
    }
    
    func getImageFromDevice(isShotOn: Bool) -> UIImage{
        let device = Device.current
        var imageName = ""
        switch device {
        case .iPhone6:
            imageName = "6"
            break
        case .iPhone6Plus:
            imageName = "6plus"
            break
        case .iPhone6s:
            imageName = "6s"
            break
        case .iPhone6sPlus:
            imageName = "6splus"
            break
        case .iPhone7:
            imageName = "7"
            break
        case .iPhone7Plus:
            imageName = "7plus"
            break
        case .iPhone8:
            imageName = "8"
            break
        case .iPhone8Plus:
            imageName = "8plus"
            break
        case .iPhoneX:
            imageName = "x"
            break
        case .iPhoneXS:
            imageName = "xs"
            break
        case .iPhoneXSMax:
            imageName = "xsmax"
            break
        case .iPhoneXR:
            imageName = "xr"
            break
        case .iPhone11:
            imageName = "11"
            break
        case .iPhone11Pro:
            imageName = "11pro"
            break
        case .iPhone11ProMax:
            imageName = "11promax"
            break
        case .iPhone12:
            imageName = "12"
            break
        case .iPhone12Pro:
            imageName = "12pro"
            break
        default:
            view.makeToast("暂无此机型素材")
            break
        }
        let suffix = (isShotOn ? "3" : "1") + ".png"
        imageName = imageName.appending(suffix)
        return UIImage(named: imageName) ?? UIImage()
    }
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var markImageView : UIImageView = {
        let markImageView = UIImageView(frame: .zero)
        markImageView.isUserInteractionEnabled = true
        markImageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(markImageViewPanAction(sender:))))
        return markImageView
    }()
    
    lazy var shotOnBtn : UIButton = {
        let shotOnBtn = UIButton(frame: .zero)
        shotOnBtn.addTarget(self, action: #selector(shotOnBtnAction), for: .touchUpInside)
        shotOnBtn.setTitle("Shot On iPhone", for: .normal)
        shotOnBtn.setTitleColor(.systemBlue, for: .normal)
        shotOnBtn.layer.cornerRadius = 10
        shotOnBtn.clipsToBounds = true
        shotOnBtn.layer.borderWidth = 1
        shotOnBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return shotOnBtn
    }()
    
    lazy var fromBtn : UIButton = {
        let fromBtn = UIButton(frame: .zero)
        fromBtn.setTitle("由iPhone拍摄", for: .normal)
        fromBtn.setTitleColor(.systemBlue, for: .normal)
        fromBtn.addTarget(self, action: #selector(fromBtnAction), for: .touchUpInside)
        fromBtn.layer.cornerRadius = 10
        fromBtn.clipsToBounds = true
        fromBtn.layer.borderWidth = 1
        fromBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return fromBtn
    }()
    
    lazy var saveImageBtn : UIButton = {
        let saveImageBtn = UIButton(frame: .zero)
        saveImageBtn.setTitle("保存", for: .normal)
        saveImageBtn.setTitleColor(.systemBlue, for: .normal)
        saveImageBtn.addTarget(self, action: #selector(saveImageBtnAction), for: .touchUpInside)
        saveImageBtn.layer.cornerRadius = 10
        saveImageBtn.clipsToBounds = true
        saveImageBtn.layer.borderWidth = 1
        saveImageBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return saveImageBtn
    }()

    lazy var selectBtn : UIButton = {
        let selectBtn = UIButton(frame: .zero)
        selectBtn.setTitle("选取图片", for: .normal)
        selectBtn.setTitleColor(.systemBlue, for: .normal)
        selectBtn.addTarget(self, action: #selector(promptPhoto), for: .touchUpInside)
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

extension ShotOnViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        originImage = info[.originalImage] as! UIImage
        
        if !scrollView.subviews.contains(imageView) {
            scrollView.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.width.equalTo(FD_ScreenWidth - 30)
                make.height.equalTo((FD_ScreenWidth - 30) * 4 / 3)
                make.top.equalTo(self.selectBtn.snp.bottom).offset(15)
            }
            scrollView.addSubview(shotOnBtn)
            shotOnBtn.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalTo(self.imageView.snp.bottom).offset(15)
                make.height.equalTo(40)
                make.width.equalTo((FD_ScreenWidth - 30 - 15)/2)
            }
            scrollView.addSubview(fromBtn)
            fromBtn.snp.makeConstraints { (make) in
                make.left.equalTo(self.shotOnBtn.snp.right).offset(15)
                make.top.equalTo(self.imageView.snp.bottom).offset(15)
                make.height.equalTo(40)
                make.width.equalTo((FD_ScreenWidth - 30 - 15)/2)
            }
            scrollView.addSubview(saveImageBtn)
            saveImageBtn.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.width.equalTo(FD_ScreenWidth - 30)
                make.height.equalTo(40)
                make.top.equalTo(self.fromBtn.snp.bottom).offset(15)
            }
        }
        imageView.image = originImage
    }
}
