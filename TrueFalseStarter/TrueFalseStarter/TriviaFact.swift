//
//  TriviaFact.swift
//  TrueFalseStarter
//
//  Created by Sarah Paetsch on 5/2/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

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

