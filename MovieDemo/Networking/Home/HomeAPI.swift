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

enum HomeTabs: Int {
    case getInTheater = 1
    case getComingSoon = 2
    case getTop250 = 3
    case getNewMovies = 6
}

enum WeeklyAndUSTabs: Int {
    case getWeekly = 4
    case getUSBox = 5
}

enum HomeAPI {

    struct GetMovies: HomeAPITargetType {

        typealias ResponseDataType = MovieModel

        var homeTabs: HomeTabs
        var path: String {
            switch homeTabs {
            case .getInTheater:
                return "/in_theaters"
            case .getComingSoon:
                return "/coming_soon"
            case .getTop250:
                return "/top250"
            case .getNewMovies:
                return "/new_movies"
            }
        }
        var task: Task { return .requestParameters(parameters: parameters, encoding: URLEncoding.default)}

        private let parameters: [String: String] = ["apikey": "0b2bdeda43b5688921839c8ecb20399b"]
        init(homeTabs: HomeTabs) {
            self.homeTabs = homeTabs
        }
    }
    
    struct GetWeeklyAndUSMovies: HomeAPITargetType {

        typealias ResponseDataType = WeeklyAndUSMovieModel

        var tabs: WeeklyAndUSTabs
        var path: String {
            switch tabs {
            case .getWeekly:
                return "/weekly"
            case .getUSBox:
                return "/us_box"
            }
        }
        var task: Task { return .requestParameters(parameters: parameters, encoding: URLEncoding.default)}

        private let parameters: [String: String] = ["apikey": "0b2bdeda43b5688921839c8ecb20399b"]
        init(tabs: WeeklyAndUSTabs) {
            self.tabs = tabs
        }
    }
}
