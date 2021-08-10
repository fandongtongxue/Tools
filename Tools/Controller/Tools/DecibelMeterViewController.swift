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
        let url = URL(fileURLWithPath: "/dev/null")
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        } catch let error {
            self.view.makeToast(error.localizedDescription)
        }
        let setting = [AVSampleRateKey:NSNumber(floatLiteral: 44100.0),AVFormatIDKey:NSNumber(floatLiteral: Double(kAudioFormatAppleLossless)),AVNumberOfChannelsKey:NSNumber(floatLiteral: 2),AVEncoderAudioQualityKey:NSNumber(integerLiteral: AVAudioQuality.max.rawValue)]
        do {
            try recorder = AVAudioRecorder(url: url, settings: setting)
            if recorder != nil {
                recorder?.prepareToRecord()
                recorder?.isMeteringEnabled = true
                recorder?.record()
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            }
        } catch let error {
            self.view.makeToast(error.localizedDescription)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    

    @objc func timerAction(){
        recorder?.updateMeters()
        let level: Float
        let minDecibels: Float = -80.0
        let decibels: Float = recorder?.averagePower(forChannel: 0) ?? 0
        if decibels < minDecibels {
            level = 0
        }else if decibels >= 0.0{
            level = 1
        }else{
            let root: Float = 2
            let minAmp: Float = powf(10, 0.05 * minDecibels)
            let inverseAmpRange: Float = 1 / (1 - minAmp)
            let amp = powf(10, 0.05 * decibels)
            let adjAmp = (amp - minAmp) * inverseAmpRange;
            level = powf(adjAmp, 1 / root)
        }
        debugPrint("\(level * 120)")
    }

}
