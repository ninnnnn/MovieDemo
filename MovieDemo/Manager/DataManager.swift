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

struct TabData: ScrollableTabViewData {
    var id: Int?
    let title: String
}

class DataManager {
    static let shared = DataManager()
    
    private(set) var tabData: BehaviorRelay<[TabData]>
    
    private init() {
        tabData = BehaviorRelay<[TabData]>(value: [TabData(id: nil, title: "test1")])
    }
    
}
