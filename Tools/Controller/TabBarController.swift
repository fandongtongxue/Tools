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
        let myItem = UITabBarItem(title: NSLocalizedString("My Tools", comment: ""), image: UIImage(systemName: "rectangle.grid.2x2.fill"), selectedImage: UIImage(systemName: "rectangle.grid.2x2.fill"))
        myNav.tabBarItem = myItem
        
        let newVC = NewToolViewController()
        let newNav = BaseNavigationController(rootViewController: newVC)
        let newItem = UITabBarItem(title: NSLocalizedString("Pick New Tool", comment: ""), image: UIImage(systemName: "figure.wave"), selectedImage: UIImage(systemName: "figure.wave"))
        newNav.tabBarItem = newItem
        
        let toolsVC = ToolsViewController()
        let toolsNav = BaseNavigationController(rootViewController: toolsVC)
        let toolsItem = UITabBarItem(title: NSLocalizedString("Tools Center", comment: ""), image: UIImage(systemName: "square.2.stack.3d.top.fill"), selectedImage: UIImage(systemName: "square.2.stack.3d.top.fill"))
        toolsNav.tabBarItem = toolsItem
        
        viewControllers = [myNav,newNav,toolsNav]
        
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
