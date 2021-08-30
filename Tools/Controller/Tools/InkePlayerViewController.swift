//
//  InkePlayerViewController.swift
//  Tools
//
//  Created by Mac on 2021/8/30.
//

import UIKit

class InkePlayerViewController: BaseViewController {
    
    var player: PLPlayer?
    
    var data = InkeResponseModelData()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initPlayer()
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-FD_SafeAreaBottomHeight - 10)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.stop()
    }
    

    func initPlayer(){
        let option = PLPlayerOption.default()
        option.setOptionValue(15, forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets)
        option.setOptionValue(2000, forKey:PLPlayerOptionKeyMaxL1BufferDuration)
        option.setOptionValue(1000, forKey:PLPlayerOptionKeyMaxL2BufferDuration)
        option.setOptionValue(false, forKey:PLPlayerOptionKeyVideoToolbox)
        option.setOptionValue(3, forKey:PLPlayerOptionKeyLogLevel)
        
        player = PLPlayer(url: URL(string: data.live_info.stream_addr), option: option)
//        player?.delegate = self
        player?.playerView?.contentMode = .scaleAspectFill
        view.addSubview((player?.playerView)!)
        player?.play()
    }
    
    @objc func closeBtnAction(){
        dismiss(animated: true, completion: nil)
    }
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton(frame: .zero)
        closeBtn.addTarget(self, action: #selector(closeBtnAction), for: .touchUpInside)
        closeBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        return closeBtn
    }()

}

//extension InkePlayerViewController: PLPlayerDelegate{
//
//}
