//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    
    var gameSound: SystemSoundID = 0
    
    struct TriviaFact {
        var question = String()
        var option1 = String()
        var option2 = String()
        var option3 = String()
        var option4 = String()
        var correctAnswer = Int()
    }
    
    let quiz: [TriviaFact] = [
        TriviaFact(question: "This was the only US President to serve more than two consecutive terms.", option1: "George Washington", option2: "Franklin D. Roosevelt", option3: "Woodrow Wilson", option4: "Andrew Jackson", correctAnswer: 2 ),
        TriviaFact(question:"Which of the following countries has the most residents?", option1: "Nigeria", option2: "Russia", option3: "Iran", option4: "Vietnam", correctAnswer: 1 ),
        TriviaFact(question:"In what year was the United Nations founded?", option1:"1918", option2:"1919", option3:"1945", option4: "1954", correctAnswer: 3)
    ]
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var feedbackField: UILabel!
    
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    
    @IBOutlet weak var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        option1Button.layer.cornerRadius = 8 // round button edges
        option2Button.layer.cornerRadius = 8 // round button edges
        option3Button.layer.cornerRadius = 8 // round button edges
        option4Button.layer.cornerRadius = 8 // round button edges
        playAgainButton.layer.cornerRadius = 8 // round button edges

        loadGameStartSound()
        // Start game
        //playGameStartSound() //ANNOYING
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(quiz.count)
        let currentFact = quiz[indexOfSelectedQuestion]
        
        questionField.text = currentFact.question
        
        option1Button.setTitle(currentFact.option1, forState: UIControlState.Normal)
        option2Button.setTitle(currentFact.option2, forState: UIControlState.Normal)
        option3Button.setTitle(currentFact.option3, forState: UIControlState.Normal)
        option4Button.setTitle(currentFact.option4, forState: UIControlState.Normal)
        
        feedbackField.hidden = true
        playAgainButton.hidden = true
    }
    
    func displayScore() {
        
        feedbackField.hidden = true
        // Hide the answer buttons
        option1Button.hidden = true
        option2Button.hidden = true
        option3Button.hidden = true
        option4Button.hidden = true
        
        // Display play again button
        playAgainButton.hidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedFact = quiz[indexOfSelectedQuestion]
        let correctAnswer = selectedFact.correctAnswer

        if (sender === option1Button &&  correctAnswer == 1) || (sender === option2Button && correctAnswer == 2) || (sender === option3Button && correctAnswer == 3) || (sender === option4Button && correctAnswer == 4){
            correctQuestions += 1
            feedbackField.hidden = false
            feedbackField.text = "Correct!"

        } else {
            feedbackField.hidden = false
            feedbackField.text = "Sorry, wrong answer!"
        }
        
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        option1Button.hidden = false
        option2Button.hidden = false
        option3Button.hidden = false
        option4Button.hidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        
        // Executes the nextRound method at the dispatch time on the main queue
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = NSBundle.mainBundle().pathForResource("GameSound", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}

