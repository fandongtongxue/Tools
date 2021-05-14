//
//  NotificationListViewController.swift
//  Tools
//
//  Created by Mac on 2021/5/14.
//

import UIKit

class NotificationListViewController: BaseViewController {
    
    var dataArray = [NotificationListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "日期提醒"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNotification))
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func addNotification(){
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            if setting.notificationCenterSetting == .enabled{
                self.presentAddVC()
            }else{
                self.requestAuth()
            }
        }
    }
    
    func requestAuth(){
        UNUserNotificationCenter.current().requestAuthorization(options: .alert) { granted, error in
            if error != nil{
                DispatchQueue.main.async {
                    self.view.makeToast(error?.localizedDescription)
                }
            }else{
                if granted {
                    self.presentAddVC()
                }else{
                    DispatchQueue.main.async {
                        let app = UIApplication.shared
                        let url = URL(string: UIApplication.openSettingsURLString)
                        app.open(url!, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
    
    func presentAddVC(){
        DispatchQueue.main.async {
            let vc = NotificationAddViewController()
            let nav = BaseNavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }

    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: FD_SafeAreaBottomHeight, right: 0)
        return tableView
    }()

}

extension NotificationListViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
