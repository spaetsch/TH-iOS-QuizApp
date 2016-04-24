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
    let timeLimit = 15
    
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var timerCounter: Int = 0
    
    var timer = NSTimer()
    
    var gameSound: SystemSoundID = 0
    
    var shuffled: [TriviaFact] = []
    
    class TriviaFact {
        var question: String
        var option1: String
        var option2: String
        var option3: String
        var option4: String?
        var correctAnswer: Int
        
        init(question: String, option1: String, option2: String, option3: String, correctAnswer: Int){
            self.question = question
            self.option1 = option1
            self.option2 = option2
            self.option3 = option3
            self.correctAnswer = correctAnswer
        }
        init(question: String, option1: String, option2: String, option3: String, option4: String, correctAnswer: Int){
            self.question = question
            self.option1 = option1
            self.option2 = option2
            self.option3 = option3
            self.option4 = option4
            self.correctAnswer = correctAnswer
        }
    }
    
    let quiz: [TriviaFact] = [
        TriviaFact(question: "This was the only US President to serve more than two consecutive terms.", option1: "George Washington", option2: "Franklin D. Roosevelt", option3: "Woodrow Wilson", option4: "Andrew Jackson", correctAnswer: 2 ),
        TriviaFact(question:"Which of the following countries has the most residents?", option1: "Nigeria", option2: "Russia", option3: "Iran", correctAnswer: 1),
        TriviaFact(question:"In what year was the United Nations founded?", option1:"1918", option2:"1919", option3:"1945", option4: "1954", correctAnswer: 3),
        TriviaFact(question:"The Titanic departed from the United Kingdom, where was it supposed to arrive?", option1: "Paris", option2: "Washington D.C.", option3: "New York City", option4:"Boston", correctAnswer: 3),
        TriviaFact(question:"Which nation produces the most oil?", option1:"Iran", option2:"Iraq", option3:"Brazil", option4: "Canada", correctAnswer: 4),
        TriviaFact(question:"Which country has most recently won consecutive World Cups in Soccer?", option1: "Italy", option2: "Brazil", option3: "Argentina", correctAnswer: 2),
        TriviaFact(question:"Which of the following rivers is longest?", option1:"Yangtze", option2:"Mississippi", option3:"Congo", option4: "Mekong", correctAnswer: 2)
    ]
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var feedbackField: UILabel!
    
    @IBOutlet weak var countdownLabel: UILabel!
    
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        option1Button.layer.cornerRadius = 8 // round button edges
        option2Button.layer.cornerRadius = 8
        option3Button.layer.cornerRadius = 8
        option4Button.layer.cornerRadius = 8
        nextButton.layer.cornerRadius = 8

        playAgainButton.layer.cornerRadius = 8

        loadGameStartSound()
        // Start game
        //playGameStartSound() //ANNOYING
        
        //shuffles trivia array to guarantee the same question will not be asked more than once in a given playthru
        shuffled = shuffleQuiz(quiz)
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        // currentFact is selected from randomly shuffled array at the index equal to number of questions already asked
        // this iterates thru the array and guarantees the same question will not be asked more than once in a given playthru
        let currentFact = shuffled[questionsAsked]
        
        timerCounter = timeLimit
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        countdownLabel.text = String(timerCounter)
        questionField.text = currentFact.question
        
        option1Button.setTitle(currentFact.option1, forState: UIControlState.Normal)
        option2Button.setTitle(currentFact.option2, forState: UIControlState.Normal)
        option3Button.setTitle(currentFact.option3, forState: UIControlState.Normal)
        
        if currentFact.option4 == nil {
            option4Button.hidden = true
        } else {
            option4Button.hidden = false
            option4Button.setTitle(currentFact.option4, forState: UIControlState.Normal)
        }
        feedbackField.hidden = true
        playAgainButton.hidden = true
        enableChoices()
    }
    
    func displayScore() {
        
        //hide feedback field and game buttons
        feedbackField.hidden = true
        option1Button.hidden = true
        option2Button.hidden = true
        option3Button.hidden = true
        option4Button.hidden = true
        nextButton.hidden = true
        
        // Display play again button
        playAgainButton.hidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
    }
    
    @IBAction func checkAnswer(sender: UIButton) {
        
        // selectedFact is at the index equal to number of questions already asked
        let selectedFact = shuffled[questionsAsked]
        let correctAnswer = selectedFact.correctAnswer

        // Increment the questions asked counter AFTER getting the selectedFact
        questionsAsked += 1

        stopTimer()
        
        if (sender === option1Button &&  correctAnswer == 1) || (sender === option2Button && correctAnswer == 2) || (sender === option3Button && correctAnswer == 3) || (sender === option4Button && correctAnswer == 4){
            correctQuestions += 1
            feedbackField.hidden = false
            feedbackField.textColor = UIColor.greenColor()
            feedbackField.text = "Correct!"
        } else {
            feedbackField.hidden = false
            feedbackField.textColor = UIColor.orangeColor()
            switch correctAnswer{
                case 1:
                    feedbackField.text = "Sorry! \(selectedFact.option1) is the correct answer."
                case 2:
                    feedbackField.text = "Sorry! \(selectedFact.option2) is the correct answer."
                case 3:
                    feedbackField.text = "Sorry! \(selectedFact.option3) is the correct answer."
                case 4:
                    feedbackField.text = "Sorry! \(selectedFact.option4!) is the correct answer."
                default:
                    feedbackField.text = "Sorry, wrong answer!"
            }
        }
        
        //loadNextRoundWithDelay(seconds: 1)
        
        disableChoices()
        
    }
    
    @IBAction func nextRound(sender: AnyObject) {
        nextButton.enabled = false
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    func newGame() {
        nextButton.enabled = false
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
        nextButton.hidden = false
        
        // reset counts for questionsAsked and correctQuestions
        questionsAsked = 0
        correctQuestions = 0
        
        // create a new randomly shuffled array so the player will not get the same series of questions
        shuffled = shuffleQuiz(quiz)
        newGame()
    }
    

    
    // MARK: Helper Methods
    
//    func loadNextRoundWithDelay(seconds seconds: Int) {
//        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
//        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
//        // Calculates a time value to execute the method given current time and delay
//        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
//        
//        // Executes the nextRound method at the dispatch time on the main queue
//        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
//            self.nextRound()
//        }
//    }
    

    func disableChoices(){
        option1Button.enabled = false
        option2Button.enabled = false
        option3Button.enabled = false
        option4Button.enabled = false
        
        nextButton.enabled = true
    }
    
    func enableChoices(){
        option1Button.enabled = true
        option2Button.enabled = true
        option3Button.enabled = true
        option4Button.enabled = true
        
        nextButton.enabled = false
    }
    
    func updateCounter(){
        timerCounter -= 1
        if timerCounter == 0 {
            countdownLabel.text = "Time's up!"
            stopTimer()
            disableChoices()
            questionsAsked += 1
        } else {
            countdownLabel.text = String(timerCounter)
        }
    }
    func stopTimer(){
        timer.invalidate()
        timerCounter = timeLimit
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = NSBundle.mainBundle().pathForResource("GameSound", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    // takes the original array of trivia questions, returns a randomly shuffled array
    // guarantees no question will be repeated in a given playthru
    func shuffleQuiz(original: [TriviaFact]) -> [TriviaFact]{
        return GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(original) as! [TriviaFact]
    }
}

