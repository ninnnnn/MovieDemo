//
//  HomeMovieCellViewModel.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/27.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit

class HomeMovieCellViewModel {
    
    var movieImageUrl: String
    var title: String
    var category: String
    var pubdate: String
    var durations: String
    
    init(movieImageUrl: String, title: String, category: String, pubdate: String, durations: String) {
        self.movieImageUrl = movieImageUrl
        self.title = title
        self.category = category
        self.pubdate = pubdate
        self.durations = durations
    }
}
