//
//  ViewController.swift
//  Project2
//
//  Created by gtxtreme on 16/07/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        countries += ["estonia", "france","germany","ireland","italy","monaco","nigeria","poland","russia", "spain", "uk","us"]
        

        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        button1.layer.cornerRadius = 8
        button2.layer.cornerRadius = 8
        button3.layer.cornerRadius = 8
        
        
        
        askQuestion(action: nil)
        
    }

    func askQuestion(action: UIAlertAction! = nil){
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "\(countries[correctAnswer].uppercased()) Your score:\(score)"
        
        questionsAsked += 1
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        print(questionsAsked)
        
        var title: String
        var message : String
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            message = "Your score is \(score)"
        } else {
            title = "Wrong!"
            if score != 0 {
                score -= 1
            }
            message = "That's the flag of \(countries[sender.tag].uppercased())\n Your score is \(score)"
        }
        
        
        let ac = UIAlertController(title: "", message: "", preferredStyle: .alert)
        if questionsAsked == 10 {
            ac.title = "Hurray! 10 questions answered"
        } else {
            ac.title = title
        }
        
        ac.message = message
        ac.addAction(UIAlertAction(title: "Continue?", style: .default, handler: askQuestion))
        
        present(ac, animated: true)
       
        
    }
}

