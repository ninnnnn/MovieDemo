//
//  HomeModels.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/27.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import Foundation

enum PageType: String, Codable {
    case inTheaters = "1"
    case comingSoon = "2"
    case top250 = "3"
    case weekly = "4"
    case usBox = "5"
    case newMovies = "6"
}

struct InTheaterMovieModel: Codable {
    let subjects: [Subjects]
    let title: String
}

struct Subjects: Codable {
    let genres: [String]
    let title: String
    let durations: [String]
    let mainlandPubdate: String?
    let images: Images?
    
    enum SubjectsCodingKeys: String, CodingKey {
        case genres
        case title
        case durations
        case mainlandPubdate = "mainland_pubdate"
        case images
    }
}

struct Images: Codable {
    let small: String
    let large: String
    let medium: String
}
