import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol?
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenterImpl(viewController: self)
        presenter = MovieQuizPresenter(viewController: self)
    }
    
   //MARK: Demonstration function
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func notHighlightImageBorder() {
        imageView.layer.borderWidth = 0
    }
    
    // MARK: Button
    @IBAction private func noButtonCliked(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        presenter.noButtonCliked()
    }
    
    @IBAction private func yesButtonCliked(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        presenter.yesButtonCliked()
    }
    
    func activateButton() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    // MARK: Indicator
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    //MARK: SHOW АЛЕРТЫ
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertError = AlertModel(
            title: "Ошибка", 
            message: message,
            buttonText: "Попробуйте ещё раз",
            completion: { [weak self] in
                    guard let self = self else { return }
                    self.presenter.resetGame()
            })
        alertPresenter?.show(alertModel: alertError)
    }
    
    func showFinalResults() {
        let message = presenter.makeTextMessage()
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
                self?.presenter.resetGame()
            }
        )
        alertPresenter?.show(alertModel: alertModel)
    }
}
