//
//  Quiz.swift
//  TrueFalseStarter
//
//  Created by Sarah Paetsch on 5/2/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

class Quiz {
    var questions: [TriviaFact]
    
    init(facts: [TriviaFact]){
        self.questions = facts
    }
    
    // sets given question list as default values for a Quiz
    init(){
        self.questions = [
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
    }
}

