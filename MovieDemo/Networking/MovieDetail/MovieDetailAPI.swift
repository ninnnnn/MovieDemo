//
//  MovieDetail.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/30.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import Foundation
import Moya

protocol MovieDetailAPITargetType: ApiTargetType {}

extension MovieDetailAPITargetType {}

enum MovieDetailAPI {
    
    struct GetMovieDetail: MovieDetailAPITargetType {
        typealias ResponseDataType = MovieObject
        
        var movieId: String
        var path: String { return "/subject/\(movieId)" }
        var task: Task { return .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        
        private let parameters: [String: String] = ["apikey": "0b2bdeda43b5688921839c8ecb20399b"]
        init(movieId: String) {
            self.movieId = movieId
        }
    }
}
