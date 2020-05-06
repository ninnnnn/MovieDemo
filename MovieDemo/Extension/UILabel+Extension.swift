//
//  UILabel+Extension.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/5/6.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit

extension UILabel {
    /// UILabel根據文字的需要的高度
    public var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: frame.width,
            height: CGFloat.greatestFiniteMagnitude)
        )
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
    
    /// UILabel根據文字實際的行數
    public var lines: Int {
        return Int(requiredHeight / font.lineHeight)
    }
}
