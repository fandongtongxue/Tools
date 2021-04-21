//
//  ToolsViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/13.
//

import UIKit
import HandyJSON

class ToolsViewController: BaseViewController {
    
    lazy var searchRC : ToolsSearchResultController = {
        let searchRC = ToolsSearchResultController()
        searchRC.nav = navigationController as! BaseNavigationController
        return searchRC
    }()
    
    lazy var searchC : UISearchController = {
        let searchC = UISearchController(searchResultsController: searchRC)
        searchC.searchBar.delegate = searchRC
        searchC.searchResultsUpdater = searchRC
        searchC.delegate = self
        searchC.view.addSubview(searchRC.view)
        return searchC
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "工具中心"
        navigationItem.searchController = searchC
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let path = Bundle.main.path(forResource: "tools", ofType: "json") ?? ""
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let jsonObject =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
            let jsonDataArray = jsonObject["data"] as! [[String:Any]]
            for dict in jsonDataArray {
                let model = ToolModel.deserialize(from: dict)
                dataArray.append(model ?? ToolModel())
            }
            searchRC.dataArray = dataArray
            collectionView.reloadData()
        } catch {
            print(error)
        }
    }
    

    var dataArray = [ToolModel]()
    
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

extension ToolsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
        let detailVC = ToolDetailViewController()
        detailVC.model = dataArray[indexPath.item]
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: String(indexPath.item) as NSCopying) { () -> UIViewController? in
            let detailVC = ToolDetailViewController()
            detailVC.model = self.dataArray[indexPath.item]
            return detailVC
        } actionProvider: { (element) -> UIMenu? in
            
            let storageObject = NSUbiquitousKeyValueStore.default.array(forKey: MyToolSaveKey)
            var ret = false
            if storageObject != nil{
                let storageArray = storageObject as! [[String : Any]]
                for subObject in storageArray{
                    let model = ToolModel.deserialize(from: subObject)
                    if model?.id == self.dataArray[indexPath.item].id {
                        ret = true
                    }
                }
            }
            if ret {
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
                            break
                        }
                    }
                }
                return UIMenu(title: "", children: [removeAction])
            }else{
                let addAction = UIAction(title: "添加", image: UIImage(systemName: "plus.app"), state: .off) { (action) in
                    print("点击了添加")
                    let storageObject = NSUbiquitousKeyValueStore.default.array(forKey: MyToolSaveKey)
                    if storageObject != nil {
                        var storageArray = storageObject as! [[String : Any]]
                        storageArray.append(self.dataArray[indexPath.item].toJSON()!)
                        NSUbiquitousKeyValueStore.default.set(storageArray, forKey: MyToolSaveKey)
                    }else{
                        NSUbiquitousKeyValueStore.default.set([self.dataArray[indexPath.item].toJSON()], forKey: MyToolSaveKey)
                    }
                    NSUbiquitousKeyValueStore.default.synchronize()
                }
                return UIMenu(title: "", children: [addAction])
            }
            
            
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        let item = Int(configuration.identifier as! String) ?? 0
        let detailVC = ToolDetailViewController()
        detailVC.model = dataArray[item]
        show(detailVC, sender: nil)
    }
}

extension ToolsViewController : UISearchControllerDelegate{
    
}

extension ToolsViewController : ToolItemCellDelegate{
    func itemCell(itemCell: ToolItemCell, didClickInfoBtn: UIButton) {
        let detailVC = ToolDetailViewController()
        detailVC.model = itemCell.model
        detailVC.hidesBottomBarWhenPushed = true
        show(detailVC, sender: nil)
    }
}
