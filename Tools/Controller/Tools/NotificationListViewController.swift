//
//  NotificationListViewController.swift
//  Tools
//
//  Created by Mac on 2021/5/14.
//

import UIKit

class NotificationListViewController: BaseViewController {
    
    var dataArray = [UNNotificationRequest]()

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
        NotificationCenter.default.addObserver(self, selector: #selector(requestData), name: NSNotification.Name.init(.addNotification), object: nil)
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
                        let alert = UIAlertController(title: "提示", message: "您未通过我们的通知权限，请到设置页面修改", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "去修改", style: .destructive, handler: { action in
                            DispatchQueue.main.async {
                                let app = UIApplication.shared
                                let url = URL(string: UIApplication.openSettingsURLString)
                                app.open(url!, options: [:], completionHandler: nil)
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
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
    
    @objc func requestData(){
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            self.dataArray = requests
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
        }
        let request = dataArray[indexPath.row]
        cell?.textLabel?.text = request.content.title
        cell?.detailTextLabel?.text = request.content.subtitle
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "确定要删除此提醒吗？", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { action in
                let request = self.dataArray[indexPath.row]
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                self.requestData()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
