//
//  SimulatorViewController.swift
//  Simulator
//
//  Created by Карим Садыков on 04.05.2023.
//

import UIKit

class SimulatorViewController: UIViewController {
    
    var timer: Timer?
    let selectedColor = UIColor.red
    
    let numberOfRows = 10
    let numberOfColumns = 10
    lazy var matrixController = MatrixController(rows: numberOfRows, columns: numberOfColumns)
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: GroupCollectionViewCell.identifier)
        collView.showsHorizontalScrollIndicator = false
        collView.showsVerticalScrollIndicator = false
        return collView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(topView)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        collectionView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 600)
    }
}

extension SimulatorViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return matrixController.matrix.count
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matrixController.matrix[section].count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCollectionViewCell.identifier, for: indexPath) as! GroupCollectionViewCell
        cell.backgroundColor = .blue
        cell.nameCategoryLabel.text = "\(matrixController.matrix[indexPath.section][indexPath.item])"
                return cell
        return cell
    }
}

extension SimulatorViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedCell = collectionView.cellForItem(at: IndexPath(row: viewModel.indexSelectedItem, section: 0)) as! CategoryCollectionViewCell
//        selectedCell.viewModel.didSelectedCell()
//
//        viewModel.didSelectedItem(at: indexPath.row)
//        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
//        cell.viewModel.didSelectedCell()
//    }
        
    func shouldChangeColor(for indexPath: IndexPath, selectedIndexPath: IndexPath) -> Bool {
           return indexPath.section == selectedIndexPath.section || indexPath.item == selectedIndexPath.item
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Отменяем предыдущий таймер, если он был запущен
        timer?.invalidate()
        timer = nil
           
        let neighbors = 3
        matrixController.spreadOnes(startRow: indexPath.section, startColumn: indexPath.item, neighbors: neighbors, delay: 1.0) { [weak self] changedCoordinates in
            guard let self = self else { return }
            let changedIndexPaths = changedCoordinates.map { IndexPath(item: $0.col, section: $0.row) }
            DispatchQueue.main.async {
                collectionView.reloadItems(at: changedIndexPaths)
            }
        }
//        let changedCoordinates = matrixController.setOnes(selectedRow: indexPath.section, selectedCol: indexPath.item, count: neighbors)
        
//        let changedCoordinates = matrixController.spreadOnes(startRow: indexPath.section, startColumn: indexPath.item, neighbors: neighbors)
//        let changedIndexPaths = changedCoordinates.map { IndexPath(item: $0.col, section: $0.row) }
//        collectionView.reloadItems(at: changedIndexPaths)
        
        // Получить массив индексов всех секций коллекции
//        let sections = Array(0..<collectionView.numberOfSections)
//        // Получить массив индексов всех ячеек в секции, которую нажали
//        let items = Array(0..<collectionView.numberOfItems(inSection: indexPath.section))
//
//        // Запускаем таймер, который будет изменять цвет ячеек с определенной задержкой
//        var counter = 0
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
//            guard let self = self else {
//                timer.invalidate()
//                return
//            }
//
//            // Если все ячейки были изменены, останавливаем таймер
//            if counter >= sections.count * items.count {
//                timer.invalidate()
//                return
//            }
//
//            // Получить индекс ячейки, которую нужно изменить
//            let sectionIndex = counter / items.count
//            let itemIndex = counter % items.count
//            let cellIndexPath = IndexPath(item: itemIndex, section: sectionIndex)
//
//            // Если ячейка соответствует правилу, изменить ее цвет
//            if self.shouldChangeColor(for: cellIndexPath, selectedIndexPath: indexPath) {
//                let cell = collectionView.cellForItem(at: cellIndexPath)
//                cell?.backgroundColor = self.selectedColor
//            }
//
//            counter += 1
//        })
    }

}

extension SimulatorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}

