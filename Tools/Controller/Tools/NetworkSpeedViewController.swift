//
//  NetworkSpeedViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/23.
//

import UIKit

class NetworkSpeedViewController: BaseViewController {
    
    var firstDownloadSize : Int64 = 0
    var totalDownloadSize : Int64 = 0
    var totalDownTime = 0
    var startTimeStamp : TimeInterval = 0
    var endTimeStamp : TimeInterval = 0
    
    var downloadTask = URLSessionDownloadTask()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "网速测试"
        view.addSubview(testBtn)
        testBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(FD_StatusBarHeight + FD_LargeTitleHeight)
            make.width.equalTo(FD_ScreenWidth - 30)
            make.height.equalTo(40)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        downloadTask.cancel()
    }
    

    @objc func start(){
        testBtn.isEnabled = false
        view.makeToastActivity(.center)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
        downloadTask = session.downloadTask(with: URL(string: "https://dldir1.qq.com/qqfile/QQforMac/QQ_6.7.5.dmg")!)
        downloadTask.resume()
    }
    
    func end(){
        let value = (totalDownloadSize - firstDownloadSize) / Int64((endTimeStamp - startTimeStamp))
        let speed = value / 1024 / 1024
        DispatchQueue.main.async {
            self.setData()
            self.testBtn.setTitle("当前网速"+"\(speed)"+"MB/s", for: .normal)
        }
    }
    
    func setData(){
        view.hideToastActivity()
        testBtn.isEnabled = true
    }
    
    lazy var testBtn : UIButton = {
        let testBtn = UIButton(frame: .zero)
        testBtn.setTitle("网速测试", for: .normal)
        testBtn.setTitleColor(.systemBlue, for: .normal)
        testBtn.addTarget(self, action: #selector(start), for: .touchUpInside)
        testBtn.layer.cornerRadius = 10
        testBtn.clipsToBounds = true
        testBtn.layer.borderWidth = 1
        testBtn.layer.borderColor = UIColor.systemBlue.cgColor
        return testBtn
    }()

}

extension NetworkSpeedViewController : URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        endTimeStamp = Date().timeIntervalSince1970
        do {
            try FileManager.default.removeItem(at: location)
        }catch (let error){
            view.makeToast(error.localizedDescription)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if firstDownloadSize < 1 {
            firstDownloadSize = bytesWritten
            startTimeStamp = Date().timeIntervalSince1970
        }
        totalDownloadSize = totalBytesWritten
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            totalDownloadSize = 0
            firstDownloadSize = 0
            DispatchQueue.main.async {
                self.testBtn.setTitle("测速失败", for: .normal)
                self.setData()
            }
        }else{
            end()
        }
    }
}
