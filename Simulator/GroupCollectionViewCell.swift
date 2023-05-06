//
//  GroupCollectionViewCell.swift
//  Simulator
//
//  Created by Карим Садыков on 04.05.2023.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GroupCollectionViewCell"
    
    private let iconView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.933, green: 0.937, blue: 0.957, alpha: 1)
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 0.086, green: 0.094, blue: 0.149, alpha: 1)
        return imageView
    }()
    
     let nameCategoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.651, green: 0.655, blue: 0.671, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        backgroundColor = .none
        addSubview(iconView)
        addSubview(iconImageView)
        contentView.addSubview(nameCategoryLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = CGRect(x: 4, y: 0, width: 42, height: 38)
        iconImageView.frame = CGRect(x: 14, y: 8, width: 22, height: 22)
        nameCategoryLabel.frame = CGRect(x: 14, y: 8, width: 22, height: 22)
        iconImageView.clipsToBounds = true
        iconView.layer.cornerRadius = iconView.frame.width / 2
    }
    
    private func select(isSelect: Bool) {
        if isSelect {
            
            iconImageView.tintColor = .gray
        } else {
            
            iconImageView.tintColor = UIColor(red: 0.086, green: 0.094, blue: 0.149, alpha: 1)
        }
    }
}
