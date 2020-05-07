//
//  HomeModels.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/27.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import Foundation

struct MovieModel: Codable {
    let subjects: [Subjects]
}

struct WeeklyAndUSMovieModel: Codable {
    let subjects: [Subjects2]
}

struct Subjects2: Codable {
    let subject: Subject
}

struct Subjects: Codable {
    let genres: [String]
    let title: String
    let durations: [String]
    let mainlandPubdate: String?
    let images: Images?
    let casts: [Cast]
    let directors: [Director]
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case genres
        case title
        case durations
        case mainlandPubdate = "mainland_pubdate"
        case images
        case casts
        case directors
        case id
    }
}

struct Subject: Codable {
    let genres: [String]
    let title: String
    let durations: [String]
    let mainlandPubdate: String?
    let images: Images?
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case genres
        case title
        case durations
        case mainlandPubdate = "mainland_pubdate"
        case images
        case id
    }
}

struct Images: Codable {
    let small: String
    let large: String
    let medium: String
}
