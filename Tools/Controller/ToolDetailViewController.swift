//
//  ToolDetailViewController.swift
//  Tools
//
//  Created by Mac on 2021/4/15.
//

import UIKit
import MarkdownView
import AVKit

class ToolDetailViewController: BaseViewController {
    var model = ToolModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = model.name
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playVideo))
        
        let mdView = MarkdownView()
        view.addSubview(mdView)
        mdView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mdView.load(markdown: model.desc, enableImage: true)
        
    }
    
    @objc func playVideo(){
        let playerVC = AVPlayerViewController()
        let player = AVPlayer(url: URL.init(fileURLWithPath: Bundle.main.path(forResource: "RPReplay_Final1618477631", ofType: "MP4")!))
        playerVC.player = player
        player.play()
        present(playerVC, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
