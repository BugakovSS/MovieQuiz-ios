//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Admin on 20.12.2023.
//

import Foundation


final class StatisticServiceImpl {
    
    private let userDefaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let dateProvider: () -> Date
    
    private enum Keys: String {
        case correct, total, bestGame, gemesCount
    }
   
    init(userDefaults: UserDefaults = .standard,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder(),
         dateProvider: @escaping () -> Date =  {Date()}
    ) {
        self.userDefaults = userDefaults
        self.decoder = decoder
        self.encoder = encoder
        self.dateProvider = dateProvider
    }
}

extension StatisticServiceImpl: StatisticServiceProtocol {
    
    var total: Int {
        get{
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get{
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var gamesCount: Int {
        get{
            userDefaults.integer(forKey: Keys.gemesCount.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.gemesCount.rawValue)
        }
    }
        
    var bestGame: GameRecord? {
        get {
            guard
                let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? decoder.decode(GameRecord.self, from: data)
            else {
                return .init(correct: 0, total: 0, date: Date())
                }
            return record
            }
        set {
             let data = try? encoder.encode(newValue)
             userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            }
        }
    
    var totalAccurancy: Double {
        Double(correct) / Double(total) * 100
    }
    
    func store(correct: Int, total: Int) {
        self.correct += correct
        self.total += total
        self.gamesCount += 1
        
        let date = dateProvider()
        
        let currentBestGame = GameRecord(correct: correct, total: total, date: date)
        
       if let previousBestGame = bestGame {
           if currentBestGame.correct > previousBestGame.correct {
                bestGame = currentBestGame
            } else {
                bestGame = currentBestGame
            }
            
        }
    }
}
