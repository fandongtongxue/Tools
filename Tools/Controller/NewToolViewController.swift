//
//  NewToolViewController.swift
//  Tools
//
//  Created by Mac on 2021/7/29.
//

import UIKit

class NewToolViewController: BaseViewController {
    
    var dataArray = [ToolModel]()
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = NSLocalizedString("Pick New Tool", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnAction))
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerRefresh()
    }
    
    @objc func addBtnAction(){
        let addVC = NewToolAddViewController()
        addVC.delegate = self
        let addNav = BaseNavigationController(rootViewController: addVC)
        present(addNav, animated: true, completion: nil)
    }
    
    @objc func headerRefresh(){
        page = 1
        requestData()
    }
    
    @objc func footerRefresh(){
        page = page + 1
        requestData()
    }
    
    func requestData(){
//        http://api.tools.app.xiaobingkj.com/?s=App.Examples_Tool.GetList
        FDNetwork.GET(url: "http://api.tools.app.xiaobingkj.com/", param: ["s":"App.Examples_Tool.GetList","page":"\(page)"]) { result in
            if self.page == 1{
                self.dataArray.removeAll()
            }
            let dataDict = result["data"] as! [String:Any]
            let items = dataDict["items"] as! [[String: Any]]
            for item in items{
                let model = ToolModel.deserialize(from: item) ?? ToolModel()
                self.dataArray.append(model)
            }
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        } failure: { error in
            self.view.makeToast(error)
            self.collectionView.refreshControl?.endRefreshing()
        }

    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(headerRefresh), for: .valueChanged)
        return refreshControl
    }()

    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(NewToolItemCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(NewToolItemCell.classForCoder()))
        collectionView.refreshControl = refreshControl
        return collectionView
    }()

}

extension NewToolViewController: NewToolAddViewControllerDelegate{
    func addVC(addVC: NewToolAddViewController, didSave: ToolModel) {
//        http://api.tools.app.xiaobingkj.com/?s=App.Examples_Tool.Insert
        FDNetwork.GET(url: "http://api.tools.app.xiaobingkj.com/", param: ["s":"App.Examples_Tool.Insert","name":didSave.name,"content":didSave.content]) { result in
            self.view.makeToast(NSLocalizedString("In Review", comment: ""))
            self.headerRefresh()
        } failure: { error in
            self.view.makeToast(error)
        }

    }
}

extension NewToolViewController: NewToolItemCellDelegate{
    func itemCell(itemCell: NewToolItemCell, didClickHandBtn: UIButton) {
        FDNetwork.POST(url: "http://api.tools.app.xiaobingkj.com/", param: ["s":"App.Examples_Tool.Update","name":itemCell.model.name,"content":itemCell.model.content,"id":"\(itemCell.model.id)","vote":"\(itemCell.model.vote + 1)"]) { result in
            self.headerRefresh()
        } failure: { error in
            self.view.makeToast(error)
        }
    }
}

extension NewToolViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(NewToolItemCell.classForCoder()), for: indexPath) as! NewToolItemCell
        if indexPath.item < dataArray.count {
            cell.model = dataArray[indexPath.item]
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = dataArray[indexPath.item]
        let nameStr = model.name as NSString
        let contentStr = model.content as NSString
        let height = nameStr.boundingRect(with: CGSize(width: FD_ScreenWidth - 60, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .medium)], context: nil).height + contentStr.boundingRect(with: CGSize(width: FD_ScreenWidth - 60, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 13)], context: nil).height + 35
        return CGSize(width: FD_ScreenWidth - 30, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}
