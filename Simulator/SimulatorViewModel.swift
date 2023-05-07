//
//  SimulatorViewModel.swift
//  Simulator
//
//  Created by Карим Садыков on 06.05.2023.
//

import Foundation

class SimulatorViewModel {
    
    private(set) var matrixController: MatrixController
    let neighbors: Int
    let delay: Double
    
    init(elements: Int, neighbors: Int, delay: Double) {
        self.neighbors = neighbors
        self.delay = delay
        matrixController = MatrixController(elements: elements)
    }
    
    var alertTitle: String { return LocalizableStrings.alertSTitle}
    var restartButtonTitle: String { return LocalizableStrings.alertSRestart }
    var returnButtonTitle: String { return LocalizableStrings.alertSReturn }
    func alertMessage(timeLabelText: String) -> String {
        return "\(LocalizableStrings.alertSMessage)\(timeLabelText)"
    }

    func spreadOnes(startRow: Int, startColumn: Int, neighbors: Int, delay: TimeInterval, onChange: @escaping (Set<Coordinate>) -> Void, completion: @escaping () -> Void) {
        matrixController.spreadOnes(startRow: startRow, startColumn: startColumn, neighbors: neighbors, delay: delay, onChange: onChange, completion: completion)
    }

    func resetMatrix() {
        matrixController.resetMatrix()
    }
    
    var numberOfZeroes: Int {
        return matrixController.numberOfZeroes
    }
    
    var numberOfOnes: Int {
        return matrixController.numberOfOnes
    }
    
    var numberOfColumns: Int {
        return matrixController.numberOfColumns
    }
}
