//
//  UIStoryBoard+Extension.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/24.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit

private struct StoryboardCategory {
    static let main = "Main"
    static let movieDetail = "MovieDetail"
}

extension UIStoryboard {
    static var main: UIStoryboard { return movieStoryboard(name: StoryboardCategory.main) }
    static var movieDetail: UIStoryboard { return movieStoryboard(name: StoryboardCategory.movieDetail) }
    
    private static func movieStoryboard(name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
    
    func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T? {
        return instantiateViewController(withIdentifier: String(describing: name)) as? T
    }
}
