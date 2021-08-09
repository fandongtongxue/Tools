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
        searchRC.nav = navigationController as? BaseNavigationController
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
        navigationItem.title = NSLocalizedString("Tools Center", comment: "")
        navigationItem.searchController = searchC
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLocalData()
    }
    
    func loadLocalData(){
        dataArray.removeAll()
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
            debugPrint(error)
        }
    }
    
    func requestData(){
//        http://img.app.xiaobingkj.com/tools.json
        FDNetwork.GET(url: "http://api.tools.app.xiaobingkj.com/tools.json", param: nil) { result in
            self.dataArray.removeAll()
            let resultArray = result["data"] as! [[String: Any]]
            for dict in resultArray{
                let model = ToolModel.deserialize(from: dict)
                self.dataArray.append(model ?? ToolModel())
            }
            self.searchRC.dataArray = self.dataArray
            self.collectionView.reloadData()
        } failure: { error in
            self.view.makeToast(error)
        }

    }
    

    var dataArray = [ToolModel]()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
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
        let model = dataArray[indexPath.item]
        let detailVC = ToolDetailViewController()
        detailVC.model = model
        detailVC.hidesBottomBarWhenPushed = true
        let detailNav = BaseNavigationController(rootViewController: detailVC)
        present(detailNav, animated: true, completion: nil)
    }
}

extension ToolsViewController : UISearchControllerDelegate{
    
}
