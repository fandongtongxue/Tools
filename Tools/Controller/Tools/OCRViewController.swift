//
//  OCRViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/22.
//

import UIKit

class OCRViewController: BaseViewController {
    
    var pathLayer: CALayer?
    // Image parameters for reuse throughout app
    var imageWidth: CGFloat = 0
    var imageHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "OCR"
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
        let alert = UIAlertController(title: "选择一张照片", message: nil, preferredStyle: .actionSheet)
        let picker = UIImagePickerController()
        picker.delegate = self
        alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (action) in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "从相册选取", style: .default, handler: { (action) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func generateBtnAction(){
        
    }
    
    lazy var generateBtn : UIButton = {
        let generateBtn = UIButton(frame: .zero)
        generateBtn.setTitle("提取", for: .normal)
        generateBtn.setTitleColor(.systemBlue, for: .normal)
//        generateBtn.addTarget(self, action: #selector(generateBtnAction), for: .touchUpInside)
        generateBtn.layer.cornerRadius = 10
        generateBtn.clipsToBounds = true
        generateBtn.layer.borderWidth = 1
        generateBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return generateBtn
    }()
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    lazy var selectBtn : UIButton = {
        let selectBtn = UIButton(frame: .zero)
        selectBtn.setTitle("选取图片", for: .normal)
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
        scrollView.contentSize = CGSize(width: 0, height: 40 + 15 + FD_SafeAreaBottomHeight)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -FD_SafeAreaBottomHeight, right: 0)
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

}

extension OCRViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[.originalImage] as! UIImage
        if !scrollView.subviews.contains(imageView) {
            scrollView.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.width.equalTo(FD_ScreenWidth - 30)
                make.height.equalTo((FD_ScreenWidth - 30) * image.size.height / image.size.width)
                make.top.equalTo(self.selectBtn.snp.bottom).offset(15)
            }
            scrollView.addSubview(generateBtn)
            generateBtn.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.width.equalTo(FD_ScreenWidth - 30)
                make.height.equalTo(40)
                make.top.equalTo(self.imageView.snp.bottom).offset(15)
            }
        }
        imageView.image = image
        scrollView.contentSize = CGSize(width: 0, height: 40 + 15 + (FD_ScreenWidth - 30) * image.size.height / image.size.width + 15 + 40 + FD_SafeAreaBottomHeight)
    }
}
