//
//  DataManager.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/27.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct TabData: ScrollableTabViewData, Equatable {
    var id: Int?
    let title: String
}

class DataManager {
    static let shared = DataManager()
    
    private(set) var tabData: BehaviorRelay<[TabData]>
    
    private init() {
        let array = [TabData(id: 1, title: "正在熱映"),
                     TabData(id: 2, title: "即將上映"),
                     TabData(id: 3, title: "Top250"),
                     TabData(id: 4, title: "口碑榜"),
                     TabData(id: 5, title: "北美票房榜"),
                     TabData(id: 6, title: "新片")]
        tabData = BehaviorRelay<[TabData]>(value: array)
    }
    
}
