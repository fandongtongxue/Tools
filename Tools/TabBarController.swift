//
//  TabBarController.swift
//  Tools
//
//  Created by Mac on 2021/4/13.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let myVC = MyToolsViewController()
        let myNav = BaseNavigationController(rootViewController: myVC)
        let myItem = UITabBarItem(title: "我的工具", image: #imageLiteral(resourceName: "tab_my_tool"), selectedImage: #imageLiteral(resourceName: "tab_my_tool"))
        myNav.tabBarItem = myItem
        
        let toolsVC = ToolsViewController()
        let toolsNav = BaseNavigationController(rootViewController: toolsVC)
        let toolsItem = UITabBarItem(title: "工具中心", image: #imageLiteral(resourceName: "tab_my_tool"), selectedImage: #imageLiteral(resourceName: "tab_my_tool"))
        toolsNav.tabBarItem = toolsItem
        
        viewControllers = [myNav,toolsNav]
        
        delegate = self
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

extension TabBarController : UITabBarControllerDelegate{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}
