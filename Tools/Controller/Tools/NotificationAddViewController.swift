//
//  NativeEventExample.swift
//  Example
//
//  Created by Mathias Claassen on 3/15/18.
//  Copyright © 2018 Xmartlabs. All rights reserved.
//

import Eureka

class NotificationAddViewController : FormViewController {
    
    var nTitle = ""
    var subTitle = ""
    var body = ""
    var date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "添加日期提醒"

        initializeForm()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addTapped(_:)))
    }

    private func initializeForm() {

        form +++

            TextRow("Title").cellSetup { cell, row in
                cell.textField.placeholder = row.tag
            }
            .onChange({ [weak self] row in
                self?.nTitle = row.value ?? ""
            })

            <<< TextRow("Sub Title").cellSetup {
                $1.cell.textField.placeholder = $0.row.tag
            }
            .onChange({ [weak self] row in
                self?.subTitle = row.value ?? ""
            })
            
            <<< TextRow("Content").cellSetup {
                $1.cell.textField.placeholder = $0.row.tag
            }
            .onChange({ [weak self] row in
                self?.body = row.value ?? ""
            })

            +++

            DateTimeInlineRow("Starts") {
                $0.title = $0.tag
                $0.value = Date()
                }
                .onChange { [weak self] row in
                    self?.date = row.value ?? Date()
                }
                .onExpandInlineRow { [weak self] cell, row, inlineRow in
                    inlineRow.cellUpdate() { cell, row in
                        cell.datePicker.datePickerMode = .dateAndTime
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }

    }

    @objc func cancelTapped(_ barButtonItem: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addTapped(_ barButtonItem: UIBarButtonItem) {
        if nTitle.count == 0 || subTitle.count == 0 && body.count == 0 && date.timeIntervalSinceNow == 0 {
            return
        }
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = self.nTitle
        content.subtitle = self.subTitle
        content.body = self.body
        content.sound = .default
        content.badge = NSNumber(value: 1)
        let time = date.timeIntervalSince(Date())
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        let timestamp = date.timeIntervalSince1970
        let identifier = String(timestamp)
        debugPrint(identifier)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { error in
            if error != nil{
                DispatchQueue.main.async {
                    self.view.makeToast(error?.localizedDescription)
                }
            }else{
                DispatchQueue.main.async {
                    self.view.makeToast("添加成功")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
