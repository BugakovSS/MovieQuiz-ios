//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Admin on 17.12.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject { 
    func didReceiveNextQuestion(question: QuizQuestion?)
}
