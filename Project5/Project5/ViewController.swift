//
//  ViewController.swift
//  Project5
//
//  Created by gtxtreme on 05/08/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords :[String] = []
    var usedWords :[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
    }
    
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: UIAlertController.Style.alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac,animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        let errorTitle: String
        let errorMsg : String
        
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    if isAcceptable(word: lowerAnswer){
                        usedWords.insert(lowerAnswer, at: 0)
                        
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)
                    } else {
                        errorTitle = "Word not acceptable!"
                        errorMsg = "It should be greater than 3 letters and not the same as the start word"
                    }
                    return
                } else {
                    errorTitle = "Word not recognised"
                    errorMsg = "You can't just make them up, you know!"
                }
            } else {
                errorTitle = "Word used already"
                errorMsg = "Be more original!"
            }
        } else {
            guard let title = title?.lowercased() else { return }
            errorTitle = "Word not possible"
            errorMsg = "You can't spell that word from \(title)"
        }
        showErrorMsg(errorTitle: errorTitle, errorMsg: errorMsg)
       
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else {
            return false
        }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isAcceptable(word: String) ->  Bool {
        guard let title = title?.lowercased() else {return false}
        return !(word.count < 3) || word == title.lowercased()
    }
    
    func showErrorMsg(errorTitle: String, errorMsg: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

