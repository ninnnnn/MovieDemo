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

enum HomeTabs: String {
    case getInTheater = "正在熱映"
    case getComingSoon = "即將上映"
    case getTop250 = "Top250"
    case getNewMovies = "新片"
}

//enum WeeklyAndUSTabs: String {
//    case getWeekly = "口碑榜"
//    case getUSBox = "北美票房榜"
//}

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
    
//    struct GetWeeklyAndUSMovies: HomeAPITargetType {
//
//        typealias ResponseDataType = MovieModel
//
//        var tabs: WeeklyAndUSTabs
//        var path: String {
//            switch tabs {
//            case .getWeekly:
//                return "/weekly"
//            case .getUSBox:
//                return "/us_box"
//            }
//        }
//        var task: Task { return .requestParameters(parameters: parameters, encoding: URLEncoding.default)}
//
//        private let parameters: [String: String] = ["apikey": "0b2bdeda43b5688921839c8ecb20399b"]
//        init(tabs: WeeklyAndUSTabs) {
//            self.tabs = tabs
//        }
//    }
}
