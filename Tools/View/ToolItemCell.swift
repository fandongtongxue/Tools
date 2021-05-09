//
//  ToolItemCell.swift
//  Tools
//
//  Created by Mac on 2021/4/15.
//

import UIKit

class ToolItemCell: UICollectionViewCell {
    
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
        colorBgView.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
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
    
    @objc func selectBtnAction(sender :UIButton){
        selectBtn.isSelected = !sender.isSelected
        model.selected = sender.isSelected
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
    
    lazy var selectBtn : UIButton = {
        let selectBtn = UIButton(frame: .zero)
        selectBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        selectBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        selectBtn.tintColor = .white
        selectBtn.isHidden = true
        selectBtn.addTarget(self, action: #selector(selectBtnAction(sender:)), for: .touchUpInside)
        return selectBtn
    }()
    
    lazy var nameLabel : UILabel = {
        let nameLabel = UILabel(frame: .zero)
        nameLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nameLabel.font = .systemFont(ofSize: 17, weight: .medium)
        nameLabel.numberOfLines = 0
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
            if Locale.preferredLanguages.first?.contains("zh") ?? false {
                //中文
                nameLabel.text = newValue.name
            }else{
                nameLabel.text = newValue.name_en
            }
            iconImageView.image = UIImage(systemName: newValue.icon)
            selectBtn.isSelected = newValue.selected
        }
        get{
            return _model
        }
    }
    
    var _isEditing = false
    public var isEditing : Bool{
        set{
            _isEditing = newValue
            selectBtn.isHidden = !newValue
            model.selected = false
            selectBtn.isSelected = false
        }
        get{
            return _isEditing
        }
    }
}
