//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Admin on 24.12.2023.
//

import Foundation

protocol StatisticServiceProtocol {
    var totalAccurancy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }
    
    func store(correct: Int, total: Int)
}
