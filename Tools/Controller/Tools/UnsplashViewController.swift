//
//  UnsplashViewController.swift
//  Tools
//
//  Created by Mac on 2021/5/8.
//

import UIKit
import UnsplashPhotoPicker

class UnsplashViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Unsplash"
        view.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(FD_StatusBarHeight + FD_LargeTitleHeight)
            make.width.equalTo(FD_ScreenWidth - 30)
            make.height.equalTo(40)
        }
    }
    
    @objc func selectBtnAction(){
        let configuration = UnsplashPhotoPickerConfiguration(
            accessKey: "522f34661134a2300e6d94d344a7ab6424e028a51b31353363b7a8cce11d73b6",
            secretKey: "eb12dda638ceb799db5d221bc0952b236777e77d5ffbeb4b4aef5841e0ab442d",
            query: "",
            allowsMultipleSelection: false
        )
        let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: configuration)
        unsplashPhotoPicker.photoPickerDelegate = self

        present(unsplashPhotoPicker, animated: true, completion: nil)
    }

    lazy var selectBtn : UIButton = {
        let selectBtn = UIButton(frame: .zero)
        selectBtn.setTitle("选取Unsplash图片", for: .normal)
        selectBtn.setTitleColor(.systemBlue, for: .normal)
        selectBtn.addTarget(self, action: #selector(selectBtnAction), for: .touchUpInside)
        selectBtn.layer.cornerRadius = 10
        selectBtn.clipsToBounds = true
        selectBtn.layer.borderWidth = 1
        selectBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return selectBtn
    }()

    @objc func presentDetailVC(object: Any){
        let photo = object as! UnsplashPhoto
        let detailVC = UnsplashDetailViewController()
        detailVC.photo = photo
        let detailNav = BaseNavigationController(rootViewController: detailVC)
        present(detailNav, animated: true, completion: nil)
    }
}

// MARK: - UnsplashPhotoPickerDelegate
extension UnsplashViewController: UnsplashPhotoPickerDelegate {
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
        print("Unsplash photo picker did select \(photos.count) photo(s)")
        perform(#selector(presentDetailVC), with: photos.first, afterDelay: 0.25)
    }

    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        print("Unsplash photo picker did cancel")
    }
}
