//
//  MyToolsViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/13.
//

import UIKit

class MyToolsViewController: BaseViewController {
    
    var dataArray = [ToolModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "我的工具"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    func refreshData(){
        dataArray.removeAll()
        let storageObject = NSUbiquitousKeyValueStore.default.array(forKey: MyToolSaveKey)
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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ToolItemCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(ToolItemCell.classForCoder()))
        return collectionView
    }()
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MyToolsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ToolItemCell.classForCoder()), for: indexPath) as! ToolItemCell
        cell.model = dataArray[indexPath.item]
        cell.delegate = self
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
        switch model.id {
        case 1:
            let toolVC = ParseShortVideoController()
            toolVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(toolVC, animated: true)
            break
        case 2:
            let toolVC = QRCodeViewController()
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
        default:
            view.makeToast("未完成的功能")
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: String(indexPath.item) as NSCopying) { () -> UIViewController? in
            let detailVC = ToolDetailViewController()
            detailVC.model = self.dataArray[indexPath.item]
            return detailVC
        } actionProvider: { (element) -> UIMenu? in
            let removeAction = UIAction(title: "移除", image: UIImage(systemName: "minus.square"), state: .off) { (action) in
                print("点击了移除")
                var storageArray = NSUbiquitousKeyValueStore.default.array(forKey: MyToolSaveKey) as! [[String : Any]]
                for i in 0...storageArray.count - 1{
                    let subObject = storageArray[i]
                    let model = ToolModel.deserialize(from: subObject)
                    if model?.id == self.dataArray[indexPath.item].id {
                        storageArray.remove(at: i)
                        NSUbiquitousKeyValueStore.default.set(storageArray, forKey: MyToolSaveKey)
                        NSUbiquitousKeyValueStore.default.synchronize()
                        self.refreshData()
                        break
                    }
                }
            }
            return UIMenu(title: "", children: [removeAction])
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        let item = Int(configuration.identifier as! String) ?? 0
        let detailVC = ToolDetailViewController()
        detailVC.model = dataArray[item]
        show(detailVC, sender: nil)
    }
}

extension MyToolsViewController : ToolItemCellDelegate{
    func itemCell(itemCell: ToolItemCell, didClickInfoBtn: UIButton) {
        let detailVC = ToolDetailViewController()
        detailVC.model = itemCell.model
        detailVC.hidesBottomBarWhenPushed = true
        show(detailVC, sender: nil)
    }
}
