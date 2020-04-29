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

struct Subjects: Codable {
    let genres: [String]
    let title: String
    let durations: [String]
    let mainlandPubdate: String?
    let images: Images?
    let subject: Subject?
    
    enum CodingKeys: String, CodingKey {
        case genres
        case title
        case durations
        case mainlandPubdate = "mainland_pubdate"
        case images
        case subject
    }
}

struct Images: Codable {
    let small: String
    let large: String
    let medium: String
}

struct Subject: Codable {
    let genres: [String]
    let title: String
    let durations: [String]
    let mainlandPubdate: String?
    let images: Images?
    
    enum CodingKeys: String, CodingKey {
        case genres
        case title
        case durations
        case mainlandPubdate = "mainland_pubdate"
        case images
    }
}
