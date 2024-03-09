
import UIKit

protocol StatisticServiceProtocol {
    var totalAccurancy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }
    
    func store(correct: Int, total: Int)
}
