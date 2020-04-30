//
//  MovieDetailModels.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/30.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import Foundation

struct MovieObject: Codable {
    let title: String
    let directors: [Director]
    let genres: [String]
    let year: String
    let countries: [String]
    let summary: String
    let rating: Rating
    let popularComments: [PopularComments]
    let casts: [Cast]
    
    enum CodingKeys: String, CodingKey {
        case title
        case directors
        case genres
        case year
        case countries
        case summary
        case rating
        case popularComments = "popular_comments"
        case casts
    }
}

struct Director: Codable {
    let avatars: Images
    let name: String
}

struct Rating: Codable {
    let average: Double
}

struct PopularComments: Codable {
    let usefulCount: Int
    let author: Author
    let content: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case usefulCount = "useful_count"
        case author
        case content
        case createdAt = "created_at"
    }
}

struct Author: Codable {
    let avatar: String
    let name: String
}

struct Cast: Codable {
    let avatars: Images
    let name: String
}
