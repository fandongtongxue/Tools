//
//  ChelaileLineListCell.swift
//  Tools
//
//  Created by Mac on 2021/8/17.
//

import UIKit

class ChelaileLineListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
        }
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(self.nameLabel)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
        }
        contentView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel(frame: .zero)
        nameLabel.font = .systemFont(ofSize: 15, weight: .medium)
        return nameLabel
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel(frame: .zero)
        contentLabel.font = .systemFont(ofSize: 13)
        return contentLabel
    }()
    
    lazy var statusLabel: UILabel = {
        let statusLabel = UILabel(frame: .zero)
        statusLabel.font = .systemFont(ofSize: 17, weight: .medium)
        statusLabel.textColor = .systemBlue
        return statusLabel
    }()

}
