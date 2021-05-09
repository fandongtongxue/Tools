//
//  UnsplashDetailViewController.swift
//  Tools
//
//  Created by Mac on 2021/5/8.
//

import UIKit
import UnsplashPhotoPicker

class UnsplashDetailViewController: BaseViewController {
    
    var photo: UnsplashPhoto?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnAction))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(FD_NavigationHeight + 15)
            make.height.equalTo(FD_ScreenHeight - 200)
            make.width.equalTo(FD_ScreenWidth)
        }
        view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(self.imageView.snp.bottom).offset(15)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp.right).offset(10)
            make.centerY.equalTo(self.iconImageView)
        }
        imageView.kf.setImage(with: photo?.urls.first?.value)
        iconImageView.kf.setImage(with: photo?.user.profileImage[.medium])
        nameLabel.text = photo?.user.name
    }
    
    @objc func cancelBtnAction(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveBtnAction(){
        UIImageWriteToSavedPhotosAlbum(imageView.image ?? UIImage(), self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError, contextInfo info: AnyObject){
        if error.code != 0 {
            view.makeToast("保存失败")
        }else{
            view.makeToast("保存成功")
        }
    }

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 25
        return iconImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel(frame: .zero)
        return nameLabel
    }()

}
