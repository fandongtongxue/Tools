//
//  QRCodeScanViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/25.
//

import UIKit
import AVFoundation

class QRCodeScanViewController: BaseViewController {
    
    var scanSession = AVCaptureSession()
    var dataArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "二维码扫描"
        view.addSubview(bgView)
        setUpScan()
        scanSession.startRunning()
    }
    
    lazy var bgView : UIView = {
        let bgView = UIView(frame: CGRect(x: 15, y: FD_StatusBarHeight + FD_LargeTitleHeight, width: FD_ScreenWidth - 30, height: FD_ScreenWidth - 30))
        return bgView
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: FD_SafeAreaBottomHeight, right: 0)
        return tableView
    }()
    

    func setUpScan(){
        let device = AVCaptureDevice.default(for: .video)!
        do {
            let input = try AVCaptureDeviceInput(device: device)
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: .main)
            scanSession.canSetSessionPreset(.high)
            if scanSession.canAddInput(input) {
                scanSession.addInput(input)
            }
            if scanSession.canAddOutput(output) {
                scanSession.addOutput(output)
            }
            output.metadataObjectTypes = [.qr,.code39,.code128,.code39Mod43,.ean13,.ean8,.code93]
            let scanPreviceLayer = AVCaptureVideoPreviewLayer(session: scanSession)
            scanPreviceLayer.videoGravity = .resizeAspectFill
            scanPreviceLayer.frame = bgView.layer.bounds
            bgView.layer.insertSublayer(scanPreviceLayer, at: 0)
            
            NotificationCenter.default.addObserver(forName: .AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: .main) { (noti) in
                output.rectOfInterest = scanPreviceLayer.metadataOutputRectConverted(fromLayerRect: self.bgView.bounds)
            }
        } catch let error {
            self.view.makeToast(error.localizedDescription)
        }
        
    }
}

extension QRCodeScanViewController : AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        debugPrint("metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)")
        scanSession.stopRunning()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        if metadataObjects.count > 0 {
            if !view.subviews.contains(tableView) {
                view.addSubview(tableView)
                tableView.snp.makeConstraints { (make) in
                    make.left.equalToSuperview()
                    make.top.equalTo(self.bgView.snp.bottom).offset(15)
                    make.bottom.equalToSuperview()
                    make.width.equalTo(FD_ScreenWidth)
                }
            }
            let result = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            dataArray.append(result.stringValue ?? "")
            tableView.reloadData()
            scanSession.startRunning()
        }
    }
}

extension QRCodeScanViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIPasteboard.general.string = cell?.textLabel?.text
        view.makeToast("已复制到剪贴板")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

