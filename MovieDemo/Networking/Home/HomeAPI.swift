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
    case getCommingSoon = "即將上映"
    case getTop250 = "Top250"
    case getWeekly = "口碑榜"
    case getUSBox = "北美票房榜"
    case getNewMovies = "新片"
}

enum HomeAPI {

    struct GetInTheater: HomeAPITargetType {

        typealias ResponseDataType = InTheaterMovieModel

        var path: String { return "/in_theaters" }
//        var path: String {
//            switch HomeTabs(rawValue: self.path) {
//            case .getInTheater:
//                return "/in_theaters"
//            case .getCommingSoon:
//                return "/coming_soon"
//            case .getTop250:
//                return "/top250"
//            case .getWeekly:
//                return "/weekly"
//            case .getUSBox:
//                return "/us_box"
//            case .getNewMovies:
//                return "/new_movies"
//            case .none:
//                return ""
//            }
//        }
        var task: Task { return .requestParameters(parameters: parameters, encoding: URLEncoding.default)}

        private let parameters: [String: String] = ["apikey": "0b2bdeda43b5688921839c8ecb20399b"]
        init(pageType: PageType) {
           // self.parameters = ["pageType": pageType.rawValue]
        }
    }
}
