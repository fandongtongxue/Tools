//
//  NewToolItemCell.swift
//  Tools
//
//  Created by Mac on 2021/7/29.
//

import UIKit

class NewToolItemCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(hex: "4665c5")
        contentView.layer.cornerRadius = 10
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
        }
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(5)
        }
    }
    
    var _model : ToolModel!
    public var model : ToolModel!{
        set{
            _model = newValue
            //设置数据
            nameLabel.text = newValue.name
            contentLabel.text = newValue.content
        }
        get{
            return _model
        }
    }
    
    lazy var nameLabel : UILabel = {
        let nameLabel = UILabel(frame: .zero)
        nameLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nameLabel.font = .systemFont(ofSize: 17, weight: .medium)
        nameLabel.numberOfLines = 0
        return nameLabel
    }()
    
    lazy var contentLabel : UILabel = {
        let contentLabel = UILabel(frame: .zero)
        contentLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        contentLabel.font = .systemFont(ofSize: 13)
        contentLabel.numberOfLines = 0
        return contentLabel
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
