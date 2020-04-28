//
//  ViewModelType.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/27.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import Foundation

protocol ViewModelType: AnyObject {
   associatedtype Input
   associatedtype Output

   var input: Input { get }
   var output: Output { get }
}
