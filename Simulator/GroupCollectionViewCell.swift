//
//  GroupCollectionViewCell.swift
//  Simulator
//
//  Created by Карим Садыков on 04.05.2023.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    static let identifier = "GroupCollectionViewCell"
    private let circleView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(circleView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        circleView.layer.cornerRadius = contentView.frame.size.width / 2
    }
    
    func select(value: Int) {
        switch value {
            case 0: // Здоровые
            return circleView.backgroundColor =  #colorLiteral(red: 0, green: 0.8421530128, blue: 0, alpha: 1)
            case 1: // Зараженные
            return circleView.backgroundColor = .red
            default: // Все остальные значения (например, -1)
            return circleView.backgroundColor = nil
            }
    }
}
