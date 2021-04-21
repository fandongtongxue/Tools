//
//  ToolItemCell.swift
//  Tools
//
//  Created by Mac on 2021/4/15.
//

import UIKit

protocol ToolItemCellDelegate {
    func itemCell(itemCell :ToolItemCell, didClickInfoBtn: UIButton)
}

class ToolItemCell: UICollectionViewCell {
    
    var delegate : ToolItemCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        contentView.addSubview(colorBgView)
        colorBgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        colorBgView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        colorBgView.addSubview(infoBtn)
        infoBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        }
        colorBgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    @objc func infoBtnAction(sender :UIButton){
        if delegate != nil {
            delegate?.itemCell(itemCell: self, didClickInfoBtn: sender)
        }
    }
    
    lazy var colorBgView : UIView = {
        let colorBgView = UIView(frame: .zero)
        return colorBgView
    }()
    
    lazy var iconImageView : UIImageView = {
        let iconImageView = UIImageView(frame: .zero)
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        return iconImageView
    }()
    
    lazy var infoBtn : UIButton = {
        let infoBtn = UIButton(frame: .zero)
        infoBtn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        infoBtn.tintColor = .white
        infoBtn.addTarget(self, action: #selector(infoBtnAction(sender:)), for: .touchUpInside)
        return infoBtn
    }()
    
    lazy var nameLabel : UILabel = {
        let nameLabel = UILabel(frame: .zero)
        nameLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nameLabel.font = .systemFont(ofSize: 17, weight: .medium)
        return nameLabel
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var _model : ToolModel!
    public var model : ToolModel!{
        set{
            _model = newValue
            //设置数据
            colorBgView.backgroundColor = UIColor(hex: newValue.backgroundColorHex)
            nameLabel.text = newValue.name
            iconImageView.image = UIImage(systemName: newValue.icon)
            
        }
        get{
            return _model
        }
    }
}
