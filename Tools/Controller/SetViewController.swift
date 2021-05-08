//
//  SetViewController.swift
//  Tools
//
//  Created by Mac on 2021/5/8.
//

import UIKit

class SetViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = NSLocalizedString("Set", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnAction))
    }
    
    @objc func doneBtnAction(){
        dismiss(animated: true, completion: nil)
    }
    
    lazy var syncSwitch: UISwitch = {
        let syncSwitch = UISwitch(frame: .zero)
        syncSwitch.addTarget(self, action: #selector(syncSwitchAction(sender:)), for: .valueChanged)
        return syncSwitch
    }()
    
    @objc func syncSwitchAction(sender: UISwitch){
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        }
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = NSLocalizedString("iCloud Sync", comment: "")
            cell?.accessoryView = syncSwitch
            break
        case 1:
            cell?.textLabel?.text = NSLocalizedString("Version", comment: "")
            let infoDict = Bundle.main.infoDictionary
            let version = infoDict?["CFBundleShortVersionString"] as! String
            let build = infoDict?["CFBundleVersion"] as! String
            cell?.detailTextLabel?.text = version + "(" + build + ")"
            break
        default:
            break
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
