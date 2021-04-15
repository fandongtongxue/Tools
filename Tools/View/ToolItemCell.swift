//
//  ToolItemCell.swift
//  Tools
//
//  Created by Mac on 2021/4/15.
//

import UIKit

class ToolItemCell: UICollectionViewCell {
    lazy var colorBgView : UIView = {
        let colorBgView = UIView(frame: .zero)
        colorBgView.layer.cornerRadius = 10
        colorBgView.clipsToBounds = true
        return colorBgView
    }()
    
    lazy var nameLabel : UILabel = {
        let nameLabel = UILabel(frame: .zero)
        nameLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 17, weight: .medium)
        return nameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(colorBgView)
        colorBgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
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
        }
        get{
            return _model
        }
    }
}
