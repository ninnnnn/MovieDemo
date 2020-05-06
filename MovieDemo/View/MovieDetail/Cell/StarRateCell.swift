//
//  StarRateCell.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/28.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit
import Cosmos

class StarRateCell: UITableViewCell, CellType {

    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        cosmosView.settings.fillMode = .precise
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data: Any) {
        if let data = data as? Double {
            ratingLabel.text = "評分：" + String(data)
            cosmosView.rating = data / 2
        }
    }
}
