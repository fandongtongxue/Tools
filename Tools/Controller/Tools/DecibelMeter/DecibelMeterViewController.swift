//
//  DecibelMeterViewController.swift
//  Tools
//
//  Created by Mac on 2021/8/10.
//

import UIKit

class DecibelMeterViewController: BaseViewController {
    
    var recorder: AVAudioRecorder?
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "分贝仪"
        AudioRecorder.shareInstance().startRecord(withFilePath: self.getFilePathWithFileName(fileName: "DemoOneRecord.wav"))
        AudioRecorder.shareInstance().setRecorderDelegate(self)
        
        view.addSubview(waveView)
        view.addSubview(waveLabel)
        waveLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(120 + 20)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        waveView.frame = CGRect(x: 0, y: FD_TopHeight, width: FD_ScreenWidth, height: FD_ScreenHeight - FD_TopHeight - FD_SafeAreaBottomHeight - 40)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AudioRecorder.shareInstance().stopRecord()
        AudioRecorder.shareInstance().setRecorderDelegate(nil)
    }
    
    lazy var waveView: DDSoundWaveView = {
        let waveView = DDSoundWaveView()
        return waveView
    }()
    
    lazy var waveLabel: UILabel = {
        let waveLabel = UILabel()
        waveLabel.font = .systemFont(ofSize: 25, weight: .medium)
        return waveLabel
    }()
    
    func getFilePathWithFileName(fileName: String) -> String{
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        var filePathString = filePath as! NSString
        filePathString = filePathString.appendingPathComponent(fileName) as NSString
        return filePathString as! String
    }

}

extension DecibelMeterViewController: AudioRecorderDelegate{
    func audioRecorderDidVoiceChanged(_ recorder: AudioRecorder!, value: Double) {
        waveView.displayWave(value)
        waveLabel.text = "当前分贝:"+"\(Int(value * 120)) dbm"
    }
}
