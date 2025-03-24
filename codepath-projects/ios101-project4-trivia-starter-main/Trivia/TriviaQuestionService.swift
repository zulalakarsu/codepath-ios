//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Zulal Akarsu on 24/03/2025.
//

import Foundation

class TriviaQuestionService {
    
    private let urlString = "https://opentdb.com/api.php?amount=5&type=multiple"
    
    func fetchQuestions(completion: @escaping ([TriviaQuestion]) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(TriviaResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(decodedResponse.results)
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }
        task.resume()
    }
}

extension String {
    func htmlDecoded() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
        return attributedString?.string ?? self
    }
}
