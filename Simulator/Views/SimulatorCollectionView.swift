//
//  SimulatorCollectionView.swift
//  Simulator
//
//  Created by Карим Садыков on 07.05.2023.
//

import UIKit

class SimulatorCollectionView: UICollectionView {
    var cellSize: CGFloat = 50 {
        didSet {
            (collectionViewLayout as? UICollectionViewFlowLayout)?.invalidateLayout()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        addGestureRecognizer(pinchGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let newCellSize = cellSize * sender.scale
            
            if newCellSize >= 10 && newCellSize <= 100 {
                cellSize = newCellSize
            }
            
            sender.scale = 1.0
        }
    }
}
