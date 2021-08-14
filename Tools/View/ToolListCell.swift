//
//  ToolListCell.swift
//  Tools
//
//  Created by Mac on 2021/4/13.
//

import UIKit
import SnapKit
import Hue

class ToolListCell: UITableViewCell {
    
    lazy var colorBgView : UIView = {
        let colorBgView = UIView(frame: .zero)
        colorBgView.layer.cornerRadius = 10
        colorBgView.clipsToBounds = true
        return colorBgView
    }()
    
    lazy var nameLabel : UILabel = {
        let nameLabel = UILabel(frame: .zero)
        nameLabel.textColor = .systemBlue
        nameLabel.textAlignment = .left
        nameLabel.font = .systemFont(ofSize: 17, weight: .medium)
        nameLabel.numberOfLines = 0
        return nameLabel
    }()
    
    lazy var iconImageView : UIImageView = {
        let iconImageView = UIImageView(frame: .zero)
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        return iconImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(colorBgView)
        colorBgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(120)
        }
        colorBgView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.colorBgView).offset(15)
            make.top.equalTo(self.colorBgView).offset(10)
        }
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.colorBgView.snp.right).offset(10)
            make.top.equalTo(self.colorBgView.snp.top).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    var _model : ToolModel!
    public var model : ToolModel!{
        set{
            _model = newValue
            //设置数据
            colorBgView.backgroundColor = UIColor(hex: newValue.backgroundColorHex)
            if Locale.preferredLanguages.first?.contains("zh") ?? false {
                //中文
                nameLabel.text = newValue.name
            }else{
                nameLabel.text = newValue.name_en
            }
            iconImageView.image = UIImage(systemName: newValue.icon)
        }
        get{
            return _model
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
