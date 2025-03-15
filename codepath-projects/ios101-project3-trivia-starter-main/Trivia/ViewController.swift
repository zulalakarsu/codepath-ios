
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var questionDetailLabel: UILabel!
    @IBOutlet weak var didTap1Button: UIButton!
    @IBOutlet weak var didTap2Button: UIButton!
    @IBOutlet weak var didTap3Button: UIButton!
    @IBOutlet weak var didTap4Button: UIButton!
    
    var currentQuestionIndex = 0

    let questions: [TriviaQuestion] = [
        TriviaQuestion(
            question: "What was the first weapon pack for 'PAYDAY'?",
            category: "Video Games",
            answers: ["The Gage Weapon Pack #1", "The Overkill Pack", "The Gage Chivalry Pack", "The Gage Historical Pack"],
            correctAnswer: "The Gage Weapon Pack #1"
        ),
        TriviaQuestion(
            question: "Who is the main character in The Legend of Zelda series?",
            category: "Video Games",
            answers: ["Zelda", "Link", "Ganon", "Epona"],
            correctAnswer: "Link"
        ),
        TriviaQuestion(
            question: "Which company developed the first iPhone?",
            category: "Technology",
            answers: ["Apple", "Samsung", "Google", "Microsoft"],
            correctAnswer: "Apple"
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        loadQuestion()
    }
    
    func setupButtons() {
        didTap1Button.addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        didTap2Button.addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        didTap3Button.addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        didTap4Button.addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
    }

    func loadQuestion() {
        let currentQuestion = questions[currentQuestionIndex]

        questionLabel.text = "Question \(currentQuestionIndex + 1)/\(questions.count)"
        categoryLabel.text = "Entertainment: \(currentQuestion.category)"
        questionDetailLabel.text = currentQuestion.question

        let buttons = [didTap1Button, didTap2Button, didTap3Button, didTap4Button]
        for (index, button) in buttons.enumerated() {
            button?.setTitle(currentQuestion.answers[index], for: .normal)
            button?.backgroundColor = UIColor.systemBlue
            button?.setTitleColor(UIColor.white, for: .normal)
            button?.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            button?.isEnabled = true
        }
    }

    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            loadQuestion()
        } else {
            let alert = UIAlertController(title: "Game Over", message: "You have completed the quiz!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
                self.currentQuestionIndex = 0
                self.loadQuestion()
            }))
            present(alert, animated: true)
        }
    }
    
    @objc func didTapAnswer(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let selectedAnswer = sender.currentTitle

        if selectedAnswer == currentQuestion.correctAnswer {
            sender.backgroundColor = UIColor.green
        } else {
            sender.backgroundColor = UIColor.red
        }

        let buttons = [didTap1Button, didTap2Button, didTap3Button, didTap4Button]
        buttons.forEach { $0?.isEnabled = false }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.nextQuestion()
        }
    }
}
