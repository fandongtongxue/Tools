//
//  MyToolsViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/13.
//

import UIKit
import SafariServices
import UnsplashPhotoPicker

class MyToolsViewController: BaseViewController {
    
    var dataArray = [ToolModel]()
    
    var isEdit = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = NSLocalizedString("My Tools", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnAction))
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func editBtnAction(){
        isEdit = true
        collectionView.reloadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeBtnAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnAction))
    }
    
    @objc func cancelBtnAction(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnAction))
        navigationItem.leftBarButtonItem = nil
        isEdit = false
        collectionView.reloadData()
    }
    
    @objc func removeBtnAction(){
        isEdit = false
        collectionView.reloadData()
        let isSaveiCloud = UserDefaults.standard.bool(forKey: iCloudSwitchKey)
        var storageArray = UserDefaults.standard.array(forKey: MyToolSaveKey) as! [[String : Any]]
        if isSaveiCloud {
            storageArray = NSUbiquitousKeyValueStore.default.array(forKey: MyToolSaveKey) as! [[String : Any]]
        }
        for subModel in dataArray {
            for i in 0...storageArray.count - 1{
                if i < storageArray.count {
                    let subObject = storageArray[i]
                    let model = ToolModel.deserialize(from: subObject)
                    if model?.id == subModel.id && subModel.selected {
                        storageArray.remove(at: i)
                        let isSaveiCloud = UserDefaults.standard.bool(forKey: iCloudSwitchKey)
                        if isSaveiCloud {
                            NSUbiquitousKeyValueStore.default.set(storageArray, forKey: MyToolSaveKey)
                            NSUbiquitousKeyValueStore.default.synchronize()
                        }else{
                            UserDefaults.standard.setValue(storageArray, forKey: MyToolSaveKey)
                            UserDefaults.standard.synchronize()
                        }
                        self.refreshData()
                    }
                }
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnAction))
        navigationItem.leftBarButtonItem = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    func refreshData(){
        dataArray.removeAll()
        var storageObject = UserDefaults.standard.array(forKey: MyToolSaveKey)
        let isSaveiCloud = UserDefaults.standard.bool(forKey: iCloudSwitchKey)
        if isSaveiCloud {
            storageObject = NSUbiquitousKeyValueStore.default.array(forKey: MyToolSaveKey)
        }
        if storageObject != nil {
            let storageArray = storageObject as! [[String : Any]]
            if storageArray.count > 0 {
                for subObject in storageArray {
                    let model = ToolModel.deserialize(from: subObject) ?? ToolModel()
                    dataArray.append(model)
                }
            }
        }
        collectionView.reloadData()
    }
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ToolItemCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(ToolItemCell.classForCoder()))
        return collectionView
    }()
    

    @objc func presentDetailVC(object: Any){
        let photo = object as! UnsplashPhoto
        let detailVC = UnsplashDetailViewController()
        detailVC.photo = photo
        let detailNav = BaseNavigationController(rootViewController: detailVC)
        present(detailNav, animated: true, completion: nil)
    }

}


extension MyToolsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ToolItemCell.classForCoder()), for: indexPath) as! ToolItemCell
        cell.model = dataArray[indexPath.item]
        cell.isEditing = isEdit
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: floor((UIScreen.main.bounds.size.width - 45) / 2), height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArray[indexPath.item]
        if isEdit {
            model.selected = !model.selected
            collectionView.reloadData()
            return
        }
        goToolVC(model: model)
    }
    
    func goToolVC(model: ToolModel){
        switch model.id {
        case 1:
            let toolVC = ParseShortVideoController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 2:
            let toolVC = QRCodeGenerateViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 3:
            let toolVC = TTSViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 4:
            let toolVC = WiFiShareViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 5:
            let toolVC = VideoExtractAudioViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 6:
            let toolVC = OCRViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 7:
            let toolVC = IPViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 8:
            let toolVC = PhoneViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 9:
            let toolVC = NetworkSpeedViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 10:
            let toolVC = SFSafariViewController(url: URL(string: "https://m.tb.cn/h.4qdNE8W")!)
            present(toolVC, animated: true, completion: nil)
            break
        case 11:
            let toolVC = BilibiliCoverViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 12:
            let toolVC = QRCodeScanViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 13:
            let toolVC = ScreenShotViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 15:
            let toolVC = ShotOnViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 16:
            let configuration = UnsplashPhotoPickerConfiguration(
                accessKey: "522f34661134a2300e6d94d344a7ab6424e028a51b31353363b7a8cce11d73b6",
                secretKey: "eb12dda638ceb799db5d221bc0952b236777e77d5ffbeb4b4aef5841e0ab442d",
                query: "",
                allowsMultipleSelection: false
            )
            let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: configuration)
            unsplashPhotoPicker.photoPickerDelegate = self

            present(unsplashPhotoPicker, animated: true, completion: nil)
            break
        case 17:
            let toolVC = WebpageShotViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 18:
            let toolVC = NotificationListViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 19:
            let toolVC = BilibiliVideoViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 20:
            let toolVC = DecibelMeterViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 21:
            let toolVC = RelativeCalculatorViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 22:
            let toolVC = ChelaileViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 23:
            let toolVC = CurrencyConverterViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 24:
            let toolVC = VideoToLivePhotoViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 25:
            let toolVC = InkeViewController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        default:
            view.makeToast("未完成的功能")
            break
        }
    }
    
    func returnToolVC(model: ToolModel) -> UIViewController{
        switch model.id {
        case 1:
            let toolVC = ParseShortVideoController()
            return toolVC
        case 2:
            let toolVC = QRCodeGenerateViewController()
            return toolVC
        case 3:
            let toolVC = TTSViewController()
            return toolVC
        case 4:
            let toolVC = WiFiShareViewController()
            return toolVC
        case 5:
            let toolVC = VideoExtractAudioViewController()
            return toolVC
        case 6:
            let toolVC = OCRViewController()
            return toolVC
        case 7:
            let toolVC = IPViewController()
            return toolVC
        case 8:
            let toolVC = PhoneViewController()
            return toolVC
        case 9:
            let toolVC = NetworkSpeedViewController()
            return toolVC
        case 10:
            let toolVC = SFSafariViewController(url: URL(string: "https://m.tb.cn/h.4qdNE8W")!)
            return toolVC
            break
        case 11:
            let toolVC = BilibiliCoverViewController()
            return toolVC
        case 12:
            let toolVC = QRCodeScanViewController()
            return toolVC
        case 13:
            let toolVC = ScreenShotViewController()
            return toolVC
        case 15:
            let toolVC = ShotOnViewController()
            return toolVC
        case 16:
            let configuration = UnsplashPhotoPickerConfiguration(
                accessKey: "522f34661134a2300e6d94d344a7ab6424e028a51b31353363b7a8cce11d73b6",
                secretKey: "eb12dda638ceb799db5d221bc0952b236777e77d5ffbeb4b4aef5841e0ab442d",
                query: "",
                allowsMultipleSelection: false
            )
            let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: configuration)
            return unsplashPhotoPicker
        case 17:
            let toolVC = WebpageShotViewController()
            return toolVC
        case 18:
            let toolVC = NotificationListViewController()
            return toolVC
        case 19:
            let toolVC = BilibiliVideoViewController()
            return toolVC
        case 20:
            let toolVC = DecibelMeterViewController()
            return toolVC
        case 21:
            let toolVC = RelativeCalculatorViewController()
            return toolVC
        case 22:
            let toolVC = RelativeCalculatorViewController()
            return toolVC
        case 23:
            let toolVC = CurrencyConverterViewController()
            return toolVC
        case 24:
            let toolVC = VideoToLivePhotoViewController()
            return toolVC
        case 25:
            let toolVC = InkeViewController()
            return toolVC
        default:
            view.makeToast("未完成的功能")
            return UIViewController()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: String(indexPath.item) as NSCopying) { () -> UIViewController? in
            return self.returnToolVC(model: self.dataArray[indexPath.item])
        } actionProvider: { (element) -> UIMenu? in
            let removeAction = UIAction(title: "移除", image: UIImage(systemName: "minus.square"), state: .off) { (action) in
                debugPrint("点击了移除")
                let isSaveiCloud = UserDefaults.standard.bool(forKey: iCloudSwitchKey)
                var storageArray = UserDefaults.standard.array(forKey: MyToolSaveKey) as! [[String : Any]]
                if isSaveiCloud {
                    storageArray = NSUbiquitousKeyValueStore.default.array(forKey: MyToolSaveKey) as! [[String : Any]]
                }
                for i in 0...storageArray.count - 1{
                    if i < storageArray.count {
                        let subObject = storageArray[i]
                        let model = ToolModel.deserialize(from: subObject)
                        if model?.id == self.dataArray[indexPath.item].id {
                            storageArray.remove(at: i)
                            let isSaveiCloud = UserDefaults.standard.bool(forKey: iCloudSwitchKey)
                            if isSaveiCloud {
                                NSUbiquitousKeyValueStore.default.set(storageArray, forKey: MyToolSaveKey)
                                NSUbiquitousKeyValueStore.default.synchronize()
                            }else{
                                UserDefaults.standard.setValue(storageArray, forKey: MyToolSaveKey)
                                UserDefaults.standard.synchronize()
                            }
                            self.refreshData()
                            break
                        }
                    }
                }
            }
            return UIMenu(title: "", children: [removeAction])
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        let item = Int(configuration.identifier as! String) ?? 0
        let detailVC = returnToolVC(model: dataArray[item])
        show(detailVC, sender: nil)
    }
}

// MARK: - UnsplashPhotoPickerDelegate
extension MyToolsViewController: UnsplashPhotoPickerDelegate {
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
        perform(#selector(presentDetailVC), with: photos.first, afterDelay: 0.25)
    }

    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        
    }
}
