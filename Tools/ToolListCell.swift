//
//  ToolListCell.swift
//  Tools
//
//  Created by Mac on 2021/4/13.
//

import UIKit
import SnapKit

class ToolListCell: UITableViewCell {
    
    lazy var colorBgView : UIView = {
        let colorBgView = UIView(frame: .zero)
        colorBgView.backgroundColor = UIColorEx.randomColor()
        colorBgView.layer.cornerRadius = 10
        colorBgView.clipsToBounds = true
        colorBgView.isUserInteractionEnabled = true
        colorBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colorBgViewTapAction(sender:))))
        return colorBgView
    }()
    
    @objc func colorBgViewTapAction(sender: UITapGestureRecognizer){
        switch sender.state {
        case .changed:
            sender.view?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            break
        case .cancelled:
            sender.view?.transform = CGAffineTransform.identity
            break
        default:
            break
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(colorBgView)
        colorBgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(120)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
