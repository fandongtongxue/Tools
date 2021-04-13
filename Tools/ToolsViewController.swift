//
//  ToolsViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/13.
//

import UIKit

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

extension ToolsViewController : UISearchControllerDelegate{
    
}
