//
//  String+Extension.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/24.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit

extension String {
    public func width(font: UIFont, height: CGFloat) -> CGFloat {
        return NSAttributedString(string: self, attributes: [.font: font]).width(height: height)
    }
}

//  MARK: - NSAttributedString
extension NSAttributedString {
    public func width(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            context: nil)
        return ceil(boundingBox.width) + 0.5
    }
}
