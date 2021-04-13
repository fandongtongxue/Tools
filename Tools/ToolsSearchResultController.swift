//
//  ToolsSearchResultController.swift
//  Tools
//
//  Created by Mac on 2021/4/13.
//

import UIKit

class ToolsSearchResultController: BaseViewController {
    
    var dataArray = [ToolModel]()
    var resultArray = [ToolModel]()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ToolListCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(ToolListCell.classForCoder()))
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ToolsSearchResultController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ToolListCell.classForCoder()), for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ToolsSearchResultController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let inputStr = searchController.searchBar.text
        resultArray.removeAll()
    }
}

extension ToolsSearchResultController : UISearchBarDelegate{
    
}
