//
//  MatrixController.swift
//  Simulator
//
//  Created by Карим Садыков on 06.05.2023.
//

import Foundation

struct Coordinate: Hashable, Equatable {
    let row: Int
    let col: Int
}

class MatrixController {
    private(set) var matrix: [[Int]]
    let numberOfRows: Int
    let numberOfColumns: Int
    private(set) var numberOfOnes: Int = 0
    private(set) var numberOfZeroes: Int
    private var elements: Int
    
    init(elements: Int) {
        let matrixSize = MatrixController.createMatrixWithZeroes(elements: elements)
        self.matrix = matrixSize.matrix
        self.numberOfRows = matrixSize.rows
        self.numberOfColumns = matrixSize.columns
        self.elements = elements
        numberOfZeroes = elements
    }
    
    static func createMatrixWithZeroes(elements: Int) -> (matrix: [[Int]], rows: Int, columns: Int) {
        let maxColumns = 28
        var numberOfRows = Int(ceil(sqrt(Double(elements))))
        var numberOfColumns = numberOfRows
        
        if numberOfColumns > maxColumns {
            numberOfColumns = maxColumns
            numberOfRows = Int(ceil(Double(elements) / Double(numberOfColumns)))
        }
        
        var matrix = [[Int]]()
        var elementsPlaced = 0
        
        for _ in 0..<numberOfRows {
            var row = [Int]()
            for _ in 0..<numberOfColumns {
                if elementsPlaced < elements {
                    row.append(0)
                    elementsPlaced += 1
                } else {
                    row.append(-1) // Заполняем ячейки вне заданного количества элементов значением -1
                }
            }
            matrix.append(row)
        }
        return (matrix, numberOfRows, numberOfColumns)
    }
    
    func resetMatrix() {
        let newMatrixSize = MatrixController.createMatrixWithZeroes(elements: elements)
        self.matrix = newMatrixSize.matrix
        numberOfOnes = 0
        numberOfZeroes = elements
    }
    
    func spreadOnes(startRow: Int, startColumn: Int, neighbors: Int, delay: TimeInterval, onChange: @escaping (Set<Coordinate>) -> Void, completion: @escaping () -> Void) {
        let queue: Set<Coordinate> = [Coordinate(row: startRow, col: startColumn)]
        spreadOnesRecursive(queue: queue, neighbors: neighbors, delay: delay, onChange: onChange, completion: completion)
    }
    
    private func isCoordinateValidAndNotInfected(_ row: Int, _ col: Int) -> Bool {
        return row >= 0 && row < self.matrix.count && col >= 0 && col < self.matrix[0].count && self.matrix[row][col] != 1 && self.matrix[row][col] != -1
    }
    
    func printMatrix(matrix: [[Int]]) {
        for row in matrix {
            print(row)
        }
        print("\n")
    }
    
    private func isValidCoordinate(_ coordinate: Coordinate) -> Bool {
        let newRow = coordinate.row
        let newCol = coordinate.col
        if self.matrix[newRow][newCol] == 0 {
            return true
        }
        
        let directions = [
            (0, 0),
            (0, 1), (1, 0), (0, -1), (-1, 0),
            (1, 1), (-1, -1), (1, -1), (-1, 1)
        ]
        
        return !directions.allSatisfy { direction in
            let surroundingRow = newRow + direction.0
            let surroundingCol = newCol + direction.1
            return surroundingRow >= 0 && surroundingRow < self.matrix.count &&
                surroundingCol >= 0 && surroundingCol < self.matrix[0].count &&
                (self.matrix[surroundingRow][surroundingCol] == 1 || self.matrix[surroundingRow][surroundingCol] == -1)
        }
    }
    
    private func spreadOnesRecursive(queue: Set<Coordinate>, neighbors: Int, delay: TimeInterval, onChange: @escaping (Set<Coordinate>) -> Void, completion: @escaping () -> Void) {
        
        let allOnes = !self.matrix.flatMap { $0 }.contains(0)
        
        if allOnes {
            completion()
            return
        }
        
        var newQueue: Set<Coordinate> = []
        // возвращает ячейки которые были изменены на 1
        queue.filter { isValidCoordinate($0) }.forEach { coordinate in
            let newOnes = setOnes(selectedRow: coordinate.row, selectedCol: coordinate.col, count: neighbors)
            newQueue.formUnion(newOnes)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.numberOfOnes = self.matrix.flatMap { $0 }.filter { $0 == 1 }.count
            self.numberOfZeroes = self.matrix.flatMap { $0 }.filter { $0 == 0 }.count
            onChange(newQueue)
            self.spreadOnesRecursive(queue: newQueue, neighbors: neighbors, delay: delay, onChange: onChange, completion: completion)
        }
    }

    
    private func setOnes(selectedRow: Int, selectedCol: Int, count: Int) -> Set<Coordinate> {
        let row = selectedRow
        let col = selectedCol
        
        if self.matrix[row][col] == -1 {
            return Set<Coordinate>()
        }
        
        let directions = [
            (0, 1), (1, 0), (0, -1), (-1, 0),
            (1, 1), (-1, -1), (1, -1), (-1, 1)
        ]
        
        self.matrix[row][col] = 1
        var changedCoordinates: Set<Coordinate> = [Coordinate(row: row, col: col)]
        
        // Проверка, если все элементы вокруг равны 1
        var allSurroundingOnes = true
        for direction in directions {
            let newRow = row + direction.0
            let newCol = col + direction.1
            if newRow >= 0 && newRow < self.matrix.count && newCol >= 0 && newCol < self.matrix[0].count && self.matrix[newRow][newCol] != 1 && self.matrix[newRow][newCol] != -1 {
                allSurroundingOnes = false
                break
            }
        }
        
        // Если все элементы вокруг равны 1 или -1, прекращаем работу функции
        if allSurroundingOnes {
            return changedCoordinates
        }
        
        
        var selectedDirections = [Int]()
        var maxAttempts = 0
        
        while selectedDirections.count < count && selectedDirections.count < directions.count && maxAttempts < directions.count * 2 {
            let index = Int.random(in: 0..<directions.count)
            if !selectedDirections.contains(index) {
                let direction = directions[index]
                let newRow = row + direction.0
                let newCol = col + direction.1
                if isCoordinateValidAndNotInfected(newRow, newCol) {
                    selectedDirections.append(index)
                }
            }
            maxAttempts += 1
        }
        
        for index in selectedDirections {
            let direction = directions[index]
            let newRow = row + direction.0
            let newCol = col + direction.1
            if isCoordinateValidAndNotInfected(newRow, newCol) {
                self.matrix[newRow][newCol] = 1
                changedCoordinates.insert(Coordinate(row: newRow, col: newCol))
            }
        }
        
        return changedCoordinates
    }
}
