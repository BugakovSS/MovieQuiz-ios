//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Admin on 17.12.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
