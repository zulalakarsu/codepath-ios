//
//  ViewController.swift
//  Trivia
//

import UIKit

class TriviaViewController: UIViewController {
  
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  
  private var questions = [TriviaQuestion]()
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        questionContainerView.layer.cornerRadius = 8.0
        
        // Reset Button programmatically
            let resetButton = UIButton(type: .system)
            resetButton.setTitle("Reset Game", for: .normal)
            resetButton.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)
            resetButton.frame = CGRect(x: 50, y: 700, width: 300, height: 50) // Adjust position/size
            
            view.addSubview(resetButton)
            
        // Fetch the trivia questions
        let service = TriviaQuestionService()
        service.fetchQuestions { [weak self] fetchedQuestions in
            guard let self = self else { return }
            self.questions = fetchedQuestions
            self.currQuestionIndex = 0
            
            // Only call updateQuestion AFTER questions are fetched
            self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
        }
    }

    
    @objc private func didTapResetButton() {
        currQuestionIndex = 0
        numCorrectQuestions = 0

        let service = TriviaQuestionService()
        service.fetchQuestions { [weak self] fetchedQuestions in
            guard let self = self else { return }
            self.questions = fetchedQuestions
            DispatchQueue.main.async {
                self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
            }
        }
    }
    
    
    
    
    
    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        guard questionIndex < questions.count else {
            print("⚠️ Tried to access questionIndex \(questionIndex) but only have \(questions.count) questions")
            return
        }
        
        currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
        let question = questions[questionIndex]
        questionLabel.text = question.question.htmlDecoded()
        categoryLabel.text = question.category.htmlDecoded()
        let answers = ([question.correctAnswer] + question.incorrectAnswers).map { $0.htmlDecoded() }.shuffled()

        // Hide all buttons first
        answerButton0.isHidden = true
        answerButton1.isHidden = true
        answerButton2.isHidden = true
        answerButton3.isHidden = true

        // Check if the question is True/False (boolean)
        if question.type.lowercased() == "boolean" {
            // Show only 2 buttons
            answerButton0.setTitle(answers[0], for: .normal)
            answerButton0.isHidden = false
            
            answerButton1.setTitle(answers[1], for: .normal)
            answerButton1.isHidden = false
        } else {
            // Normal multiple choice (up to 4 options)
            if answers.count > 0 {
                answerButton0.setTitle(answers[0], for: .normal)
                answerButton0.isHidden = false
            }
            if answers.count > 1 {
                answerButton1.setTitle(answers[1], for: .normal)
                answerButton1.isHidden = false
            }
            if answers.count > 2 {
                answerButton2.setTitle(answers[2], for: .normal)
                answerButton2.isHidden = false
            }
            if answers.count > 3 {
                answerButton3.setTitle(answers[3], for: .normal)
                answerButton3.isHidden = false
            }
        }
    }

    
    
    private func updateToNextQuestion(answer: String, sender: UIButton) {
        let correct = isCorrectAnswer(answer)
        
        // Visual feedback
        if correct {
            sender.backgroundColor = .systemGreen
            numCorrectQuestions += 1
        } else {
            sender.backgroundColor = .systemRed
        }
        
        // Disable all answer buttons temporarily
        [answerButton0, answerButton1, answerButton2, answerButton3].forEach { $0.isUserInteractionEnabled = false }
        
        // Wait 0.8s before moving to the next question
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self else { return }
            sender.backgroundColor = .systemBlue // Reset button color
            
            self.currQuestionIndex += 1
            if self.currQuestionIndex < self.questions.count {
                self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
            } else {
                self.showFinalScore()
            }
            
            // Re-enable buttons
            [self.answerButton0, self.answerButton1, self.answerButton2, self.answerButton3].forEach { $0.isUserInteractionEnabled = true }
        }
    }

    
    
    
    
    private func isCorrectAnswer(_ answer: String) -> Bool {
        guard currQuestionIndex < questions.count else {
            print("Index out of bounds for currQuestionIndex: \(currQuestionIndex)")
            return false
        }
        return answer == questions[currQuestionIndex].correctAnswer
    }
    
  
    
    
    
    private func showFinalScore() {
        let alertController = UIAlertController(
            title: "Game over!",
            message: "Final score: \(numCorrectQuestions)/\(questions.count)",
            preferredStyle: .alert
        )

        let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
            currQuestionIndex = 0
            numCorrectQuestions = 0

            let service = TriviaQuestionService()
            service.fetchQuestions { [weak self] fetchedQuestions in
                guard let self = self else { return }
                self.questions = fetchedQuestions
                DispatchQueue.main.async {
                    self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
                }
            }
        }

        alertController.addAction(resetAction)
        present(alertController, animated: true, completion: nil)
    }

    
    
    
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
      updateToNextQuestion(answer: sender.titleLabel?.text ?? "", sender: sender)
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
      updateToNextQuestion(answer: sender.titleLabel?.text ?? "", sender: sender)
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
      updateToNextQuestion(answer: sender.titleLabel?.text ?? "", sender: sender)
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
      updateToNextQuestion(answer: sender.titleLabel?.text ?? "", sender: sender)
  }
}

