//
//  SetViewController.swift
//  Tools
//
//  Created by Mac on 2021/5/8.
//

import UIKit
import MessageUI
import DeviceKit
import StoreKit
import SafariServices

class SetViewController: UITableViewController {
    
    var appArray = [AppModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = NSLocalizedString("Set", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBtnAction))
        requestData()
    }
    
    func requestData(){
        FDNetwork.GET(url: "http://img.app.xiaobingkj.com/apps.json", param: nil) { result in
            let resultDict = result as! [String: Any]
            let data = resultDict["data"] as! [[String:Any]]
            self.appArray.removeAll()
            for dict in data{
                let model = AppModel.deserialize(from: dict) ?? AppModel()
                if model.name != "快捷工具" {
                    self.appArray.append(model)
                }
            }
            self.tableView.reloadSections(IndexSet.init(arrayLiteral: 2), with: .automatic)
        } failure: { error in
            self.view.makeToast(error)
        }

    }
    
    @objc func closeBtnAction(){
        dismiss(animated: true, completion: nil)
    }
    
    lazy var syncSwitch: UISwitch = {
        let syncSwitch = UISwitch(frame: .zero)
        syncSwitch.addTarget(self, action: #selector(syncSwitchAction(sender:)), for: .valueChanged)
        let isSaveiCloud = UserDefaults.standard.bool(forKey: iCloudSwitchKey)
        syncSwitch.isOn = isSaveiCloud
        return syncSwitch
    }()
    
    @objc func syncSwitchAction(sender: UISwitch){
        UserDefaults.standard.setValue(sender.isOn, forKey: iCloudSwitchKey)
        UserDefaults.standard.synchronize()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 3
        }
        if section == 3 {
            return 2
        }
        return appArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        }
        switch indexPath.section {
        case 0:
            cell?.textLabel?.text = NSLocalizedString("iCloud Sync", comment: "")
            cell?.accessoryView = syncSwitch
            break
        case 1:
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = NSLocalizedString("Version", comment: "")
                let infoDict = Bundle.main.infoDictionary
                let version = infoDict?["CFBundleShortVersionString"] as! String
                let build = infoDict?["CFBundleVersion"] as! String
                cell?.detailTextLabel?.text = version + "(" + build + ")"
                break
            case 1:
                cell?.textLabel?.text = NSLocalizedString("Evaluate", comment: "")
                break
            case 2:
                cell?.textLabel?.text = NSLocalizedString("Feedback", comment: "")
                break
            default:
                break
            }
            break
        case 2:
            if indexPath.row < appArray.count {
                let model = appArray[indexPath.row]
                cell?.textLabel?.text = model.name
            }
            break
        case 3:
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = NSLocalizedString("Privacy", comment: "")
                break
            case 1:
                cell?.textLabel?.text = NSLocalizedString("Agreement", comment: "")
                break
            default:
                break
            }
            break
        default:
            break
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return NSLocalizedString("Our apps", comment: "")
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 1 {
            SKStoreReviewController.requestReview()
        }else if indexPath.section == 1 && indexPath.row == 2 {
            if !MFMailComposeViewController.canSendMail() {
                view.makeToast(NSLocalizedString("No Emal Account", comment: ""))
                return
            }
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["admin@fandong.me"])
            mailVC.setSubject(NSLocalizedString("Tools Feedback", comment: ""))
            var debugInfo = ""
            let infoDict = Bundle.main.infoDictionary
            let version = infoDict?["CFBundleShortVersionString"] as! String
            let build = infoDict?["CFBundleVersion"] as! String
            debugInfo.append("\n")
            debugInfo.append("\n")
            debugInfo.append("\n")
            debugInfo.append("App Version："+version+"("+build+")\n")
            debugInfo.append("iOS Version："+(Device.current.systemVersion ?? "")+"\n")
            debugInfo.append("Device："+(Device.current.description))
            mailVC.setMessageBody(debugInfo, isHTML: false)
            present(mailVC, animated: true, completion: nil)
        }else if indexPath.section == 2{
            let model = appArray[indexPath.row]
            UIApplication.shared.openURL(URL(string: model.url)!)
        }else if indexPath.section == 3{
            if indexPath.row == 0 {
                //隐私政策
                let sfVC = SFSafariViewController(url: URL(string: "http://api.tools.app.xiaobingkj.com/privacy.html")!)
                present(sfVC, animated: true, completion: nil)
            }else{
                //使用手册
                let sfVC = SFSafariViewController(url: URL(string: "http://api.tools.app.xiaobingkj.com/service.html")!)
                present(sfVC, animated: true, completion: nil)
            }
        }
    }

}

extension SetViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            view.makeToast(error?.localizedDescription)
        }else{
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

