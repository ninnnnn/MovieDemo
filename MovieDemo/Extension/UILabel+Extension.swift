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
    
    func willExpandLabel(label: UILabel, text: String, lineCount: Int) {
        let actualLines = label.lines
        label.numberOfLines = actualLines > lineCount ? lineCount : actualLines
//        if actualLines > lineCount {
//            // 計算lineCount的字數
//            let charactersCount = label.text?.count
//            print(charactersCount)
//            // 在字尾加上"...展開"
//            let size = CGSize(width: width - 16, height: 0)
//            var textSize = CGSize()
//            let charactersLineCount = lineCount
//            let attributes: [String : Any] = []
//            textSize = text.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes , context: nil)
//            print(charactersCount)
//        } else {
//            // 直接顯示目前內容
//        }
    }
}
