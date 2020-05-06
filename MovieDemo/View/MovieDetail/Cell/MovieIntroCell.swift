//
//  MovieIntroCell.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/28.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit

class MovieIntroCell: UITableViewCell, CellType {

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentLabel.numberOfLines = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data: Any) {
        if let data = data as? String {
            contentLabel.text = data
        }
    }
}
