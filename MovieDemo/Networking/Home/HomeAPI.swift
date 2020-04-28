//
//  HomeAPI.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/27.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import Foundation
import Moya

protocol HomeAPITargetType: ApiTargetType {}

extension HomeAPITargetType {}

enum HomeAPI {
    
    struct GetHotMovies: HomeAPITargetType {
        
        typealias ResponseDataType = InTheaterMovieModel
        
        var path: String { return "/in_theaters" }
        var task: Task { return .requestParameters(parameters: parameters, encoding: URLEncoding.default)}
        
        private let parameters: [String: String] = ["apikey": "0b2bdeda43b5688921839c8ecb20399b"]
        init(pageType: PageType) {
           // self.parameters = ["pageType": pageType.rawValue]
        }
    }
}
