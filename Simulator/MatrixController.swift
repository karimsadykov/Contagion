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
    
    init(rows: Int, columns: Int) {
        self.matrix = Array(repeating: Array(repeating: 0, count: columns), count: rows)
    }
    
    func spreadOnes(startRow: Int, startColumn: Int, neighbors: Int, delay: TimeInterval, completion: @escaping (Set<Coordinate>) -> Void) {
        var queue: Set<Coordinate> = [Coordinate(row: startRow, col: startColumn)]
        spreadOnesRecursive(queue: queue, neighbors: neighbors, delay: delay, completion: completion)
    }

    private func spreadOnesRecursive(queue: Set<Coordinate>, neighbors: Int, delay: TimeInterval, completion: @escaping (Set<Coordinate>) -> Void) {
        var allOnes = matrix.flatMap { $0 }.allSatisfy { $0 == 1 }
        
        if allOnes {
            return
        }
        
        var newQueue: Set<Coordinate> = []
        queue.forEach { coordinate in
            let newOnes = setOnes(selectedRow: coordinate.row, selectedCol: coordinate.col, count: neighbors)
            newQueue.formUnion(newOnes)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(newQueue)
            self.spreadOnesRecursive(queue: newQueue, neighbors: neighbors, delay: delay, completion: completion)
        }
    }

    
//    func spreadOnes(startRow: Int, startColumn: Int, neighbors: Int, completion: @escaping (Set<Coordinate>) -> Void) {
//        var allOnes = false
//        var queue: Set<Coordinate> = [Coordinate(row: startRow, col: startColumn)]
//
//        while !allOnes {
//            var newQueue: Set<Coordinate> = []
//            queue.forEach { coordinate in
//                let newOnes = setOnes(selectedRow: coordinate.row, selectedCol: coordinate.col, count: neighbors)
//                newQueue.formUnion(newOnes)
//            }
//            queue = newQueue
//            allOnes = matrix.flatMap { $0 }.allSatisfy { $0 == 1 }
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                completion(newQueue)
//            }
//        }
//    }
    
//    func spreadOnes(matrix: inout [[Int]], startRow: Int, startColumn: Int, neighbors: Int, completion: @escaping (Set<Coordinate>) -> Void) {
//        var allOnes = false
//        var queue: Set<Coordinate> = [Coordinate(row: startRow, col: startColumn)]
//
//        while !allOnes {
//            var newQueue: Set<Coordinate> = []
//            queue.forEach { coordinate in
//                let newOnes = setOnes(selectedRow: coordinate.row, selectedCol: coordinate.col, count: neighbors)
//                newQueue.formUnion(newOnes)
//            }
//            queue = newQueue
//            printMatrix()
//            completion(newQueue)
//            allOnes = self.matrix.flatMap { $0 }.allSatisfy { $0 == 1 }
//        }
//        print(allOnes)
//    }
    
    func setOnes(selectedRow: Int, selectedCol: Int, count: Int) -> Set<Coordinate> {
        let row = selectedRow
        let col = selectedCol
        
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
            if newRow >= 0 && newRow < self.matrix.count && newCol >= 0 && newCol < self.matrix[0].count && self.matrix[newRow][newCol] != 1 {
                allSurroundingOnes = false
                break
            }
        }
        
        // Если все элементы вокруг равны 1, прекращаем работу функции
        if allSurroundingOnes {
            return changedCoordinates
        }
        
        var selectedDirections = [Int]()
        var maxAttempts = 0
        
        while selectedDirections.count < count && selectedDirections.count < directions.count && maxAttempts < directions.count * 3 {
            let index = Int.random(in: 0..<directions.count)
            if !selectedDirections.contains(index) {
                let direction = directions[index]
                let newRow = row + direction.0
                let newCol = col + direction.1
                if newRow >= 0 && newRow < self.matrix.count && newCol >= 0 && newCol < self.matrix[0].count && self.matrix[newRow][newCol] != 1 {
                    selectedDirections.append(index)
                }
            }
            maxAttempts += 1
        }
        
        for index in selectedDirections {
            let direction = directions[index]
            let newRow = row + direction.0
            let newCol = col + direction.1
            
            if newRow >= 0 && newRow < self.matrix.count && newCol >= 0 && newCol < self.matrix[0].count {
                self.matrix[newRow][newCol] = 1
                changedCoordinates.insert(Coordinate(row: newRow, col: newCol))
            }
        }
        
        return changedCoordinates
    }
    
    func printMatrix() {
        for row in self.matrix {
            print(row.map { String($0) }.joined(separator: " "))
        }
        print("\n")
    }
}
