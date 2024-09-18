//
//  ExerciseModel.swift
//  GymondoCodeChallenge
//
//  Created by Amjad Oudeh on 28.08.22.
//

import Foundation

struct ExerciseList: Decodable {
    var results: [Exercise]
}

struct Exercise: Identifiable, Decodable {
    var id: Int
    var name: String
    var exercise_base_id: Int
    var description: String
    var variations: [Int]
    var images: [ExecrciseImage]?
}

struct ExerciseImageList: Decodable {
    var results: [ExecrciseImage]?
}

struct ExecrciseImage: Identifiable, Decodable {
    var id: Int
    var exercise_base: Int
    var image: String
    var is_main: Bool
}
