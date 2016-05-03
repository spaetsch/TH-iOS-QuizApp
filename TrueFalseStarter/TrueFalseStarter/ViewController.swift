//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Sarah Paetsch on 4/18/16.
//  Copyright © 2016 Sarah Paetsch. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox
import TriviaFact

class ViewController: UIViewController {
    
    let questionsPerRound = 4
    let timeLimit = 15   // number of seconds
    
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var timerCounter: Int = 0
    
    var timer = NSTimer()
    
    var currSoundID: SystemSoundID = 0
    
    var shuffled: [TriviaFact] = []
    
    let quiz: [TriviaFact] = [
        TriviaFact(question: "This was the only US President to serve more than two consecutive terms.", option1: "George Washington", option2: "Franklin D. Roosevelt", option3: "Woodrow Wilson", option4: "Andrew Jackson", correctAnswer: 2 ),
        TriviaFact(question:"Which of the following countries has the most residents?", option1: "Nigeria", option2: "Russia", option3: "Iran", correctAnswer: 1),
        TriviaFact(question:"In what year was the United Nations founded?", option1:"1918", option2:"1919", option3:"1945", option4: "1954", correctAnswer: 3),
        TriviaFact(question:"The Titanic departed from the United Kingdom, where was it supposed to arrive?", option1: "Paris", option2: "Washington D.C.", option3: "New York City", option4:"Boston", correctAnswer: 3),
        TriviaFact(question:"Which nation produces the most oil?", option1:"Iran", option2:"Iraq", option3:"Brazil", option4: "Canada", correctAnswer: 4),
        TriviaFact(question:"Which country has most recently won consecutive World Cups in Soccer?", option1: "Italy", option2: "Brazil", option3: "Argentina", correctAnswer: 2),
        TriviaFact(question:"Which of the following rivers is longest?", option1:"Yangtze", option2:"Mississippi", option3:"Congo", option4: "Mekong", correctAnswer: 2),
        TriviaFact(question:"Which city is the oldest?", option1:"Mexico City", option2:"Cape Town", option3:"San Juan", option4: "Sydney", correctAnswer: 1),
        TriviaFact(question:"Which country was the first to allow women to vote in national elections?", option1: "Poland", option2: "United States", option3: "Sweden", option4: "Senegal", correctAnswer: 1),
        TriviaFact(question:"Which of these countries won the most medals in the 2012 Summer Games?", option1:"France", option2:"Germany", option3:"Japan", option4: "Great Britain", correctAnswer: 4)
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
        option1Button.layer.cornerRadius = 8    // round button edges
        option2Button.layer.cornerRadius = 8
        option3Button.layer.cornerRadius = 8
        option4Button.layer.cornerRadius = 8
        nextButton.layer.cornerRadius = 8
        playAgainButton.layer.cornerRadius = 8
        
        shuffled = shuffleQuiz(quiz)            //Shuffles trivia array so that a question will not be asked more than once in a given playthru
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        let currentFact = shuffled[questionsAsked] // Selects currentFact from randomly shuffled array at the index = # of questions asked

        timerCounter = timeLimit
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        loadSound("/sounds/Next", soundID: &currSoundID, type: "wav")   //Loads and plays "new question" beep
        AudioServicesPlaySystemSound(currSoundID)
        
        countdownLabel.text = String(timerCounter)
        questionField.text = currentFact.question
        
        feedbackField.hidden = false
        countdownLabel.hidden = false
        
        option1Button.setTitle(currentFact.option1, forState: UIControlState.Normal)
        option2Button.setTitle(currentFact.option2, forState: UIControlState.Normal)
        option3Button.setTitle(currentFact.option3, forState: UIControlState.Normal)
        
        // If there is not a fourth answer option, hide the button; otherwise set label and display
        if currentFact.option4 == nil {
            option4Button.hidden = true
        } else {
            option4Button.hidden = false
            option4Button.setTitle(currentFact.option4, forState: UIControlState.Normal)
        }
        feedbackField.textColor = UIColor.whiteColor()
        feedbackField.text = "Time left:"
        playAgainButton.hidden = true
        enableOptions(true)
    }
    
    func displayScore() {
        
        //Hide feedback and countdown fields and game buttons
        feedbackField.hidden = true
        countdownLabel.hidden = true
        option1Button.hidden = true
        option2Button.hidden = true
        option3Button.hidden = true
        option4Button.hidden = true
        nextButton.hidden = true
        
        // Display play again button and total score
        playAgainButton.hidden = false
        
        if correctQuestions == 0 {
            loadSound("/sounds/Honk", soundID: &currSoundID, type: "mp3")     //Loads and plays "honk" for getting zero correct
            AudioServicesPlaySystemSound(currSoundID)
            questionField.text = "You got \(correctQuestions) out of \(questionsPerRound) correct. \nBetter luck next time!"
        } else {
            loadSound("/sounds/Achieve", soundID: &currSoundID, type: "wav")  //Loads and plays fanfare for achievement
            AudioServicesPlaySystemSound(currSoundID)
            questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"

        }
    }
    
    @IBAction func checkAnswer(sender: UIButton) {
        
        let selectedFact = shuffled[questionsAsked]     // selectedFact is at the index = # of questions asked
        let correctAnswer = selectedFact.correctAnswer
        questionsAsked += 1                             // Increment the questions asked counter AFTER getting the selectedFact
        stopTimer()
        
        if (sender === option1Button &&  correctAnswer == 1) || (sender === option2Button && correctAnswer == 2) || (sender === option3Button && correctAnswer == 3) || (sender === option4Button && correctAnswer == 4){
            correctQuestions += 1
            feedbackField.textColor = UIColor.greenColor()
            feedbackField.text = "Correct!"
            loadSound("/sounds/Success", soundID: &currSoundID, type: "wav")    //Loads and plays "correct answer" sound
            AudioServicesPlaySystemSound(currSoundID)
        } else {
            feedbackField.textColor = UIColor.orangeColor()
            loadSound("/sounds/Fail", soundID: &currSoundID, type: "wav")       //Loads and plays "incorrect answer" sound
            AudioServicesPlaySystemSound(currSoundID)
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
        enableOptions(false)
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
    
    @IBAction func playAgain() {
        // Show answer buttons
        option1Button.hidden = false
        option2Button.hidden = false
        option3Button.hidden = false
        option4Button.hidden = false
        nextButton.hidden = false
        
        // Reset counts for questionsAsked and correctQuestions
        questionsAsked = 0
        correctQuestions = 0
        
        // Create a new randomly shuffled array so the player will not get the same series of questions
        shuffled = shuffleQuiz(quiz)
        nextRound(self)
    }
    
    // MARK: Helper Methods
    
    // Takes the original array of trivia questions, returns a randomly shuffled array
    // Guarantees no question will be repeated in a given playthru
    func shuffleQuiz(original: [TriviaFact]) -> [TriviaFact]{
        return GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(original) as! [TriviaFact]
    }

    // Toggles between the states where
    // options are enabled and nextButton is disabled 
    // vs. options disabled and nextButton enabled
    func enableOptions(toggle: Bool) {
        if toggle {
            option1Button.enabled = true
            option2Button.enabled = true
            option3Button.enabled = true
            option4Button.enabled = true
            nextButton.enabled = false
        } else {
            option1Button.enabled = false
            option2Button.enabled = false
            option3Button.enabled = false
            option4Button.enabled = false
            nextButton.enabled = true
        }
    }
    
    // Decrements the timer counter and displays to countdownLabel
    // Changes countdown color to red when less than 5 sec remain
    // Stops the timer if it reaches zero, increments questionsAsked, and enables nextQuestion
    func updateCounter(){
        timerCounter -= 1
        countdownLabel.text = String(timerCounter)

        if timerCounter == 0 {
            feedbackField.text = "Time's up!"
            loadSound("/sounds/Fail", soundID: &currSoundID, type: "wav")       //Loads and plays "incorrect answer" sound when time runs out
            AudioServicesPlaySystemSound(currSoundID)
            questionsAsked += 1
            stopTimer()
            enableOptions(false)
        } else if timerCounter == 5 {
            loadSound("/sounds/Warning", soundID: &currSoundID, type: "wav")    //Loads and plays "warning" sound when countdown reaches 5 sec remaining

            AudioServicesPlaySystemSound(currSoundID)
            countdownLabel.textColor = UIColor.redColor()
        } else if timerCounter < 5{
            countdownLabel.textColor = UIColor.redColor()
        }
    
    }
    
    // Stops the timer, resets color to white, resets timerCounter to full time
    func stopTimer(){
        timer.invalidate()
        countdownLabel.textColor = UIColor.whiteColor()
        timerCounter = timeLimit
    }
    
    // Loads sound file at given path of given file type
    func loadSound(path:String, soundID: UnsafeMutablePointer<SystemSoundID>, type:String){
        let pathToSoundFile = NSBundle.mainBundle().pathForResource(path, ofType: type)
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, soundID)
    }
}
