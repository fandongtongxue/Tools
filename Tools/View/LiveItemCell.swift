//
//  LiveItemCell.swift
//  InkeLive
//
//  Created by Mac on 2021/8/19.
//

import UIKit

class LiveItemCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    var _model : InkeResponseModelData!
    public var model : InkeResponseModelData!{
        set{
            _model = newValue
            //设置数据
            imageView.kf.setImage(with: URL(string: newValue.live_info.creator.portrait))
        }
        get{
            return _model
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
}
