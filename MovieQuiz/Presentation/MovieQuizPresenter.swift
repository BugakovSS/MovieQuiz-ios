
import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showFinalResults()
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func notHighlightImageBorder()
    
    func activateButton()

    func showNetworkError(message: String)
} 

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    //MARK: Переменные
    var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewControllerProtocol?
    var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticServiceProtocol!
    
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var correctAnswers = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticServiceImpl()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    //MARK: Расчетные функции
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func didAnswer(isCorrectAnswer: Bool) {
        correctAnswers += 1
    }
    
    //MARK: бизнес функции
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
                image: UIImage(data: model.image) ?? UIImage(),
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
            return questionStep
    }
    
    func yesButtonCliked() {
        didAnswer(isYes: true)
    }
    
    func noButtonCliked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if currentQuestion.correctAnswer == isYes {
            self.proceedWithAnswer(isCorrect: true)
        } else {
            self.proceedWithAnswer(isCorrect: false)
        }
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
            currentQuestion = question
            let viewModel = convert(model: question)
        
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.show(quiz: viewModel)
        }
    }
    
    private func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            viewController?.showFinalResults()
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func makeTextMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
                
        let bestGame = statisticService.bestGame
        
        let totalPlaysCount = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResult = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfo = "Рекорд \(bestGame!.correct)\\\(bestGame!.total) "
        + "(\(bestGame!.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccurancy))%"
        
        let resultMessage =  [currentGameResult, totalPlaysCount, bestGameInfo, averageAccuracyLine].joined(separator: "\n")
        
        return resultMessage
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        if isCorrect == true {
            viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
            self.didAnswer(isCorrectAnswer: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
                guard let self = self else {return}
                self.viewController?.notHighlightImageBorder()
                self.proceedToNextQuestionOrResults()
                self.viewController?.activateButton()
            }
        }
        else {
            viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else {return}
                self.viewController?.notHighlightImageBorder()
                self.proceedToNextQuestionOrResults()
                self.viewController?.activateButton()
            }
        }
    }
}
