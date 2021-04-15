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
            let addAction = UIAction(title: "添加", image: UIImage(systemName: "add"), state: .off) { (action) in
                print("点击了添加")
            }
            return UIMenu(title: "", children: [addAction])
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        let detailVC = ToolDetailViewController()
        show(detailVC, sender: nil)
    }
}

extension ToolsViewController : UISearchControllerDelegate{
    
}
