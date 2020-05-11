//
//  CommentCell.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/28.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell, CellType {
    
    @IBOutlet private weak var categoryStackView: UIStackView!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var postTimeLabel: UILabel!
    @IBOutlet private weak var usefulCountLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data: Any) {
        if let data = data as? PopularComments {
            userImageView.loadImage(data.author.avatar, placeHolder: UIImage(named: "placeholder"))
            userNameLabel.text = data.author.name
            postTimeLabel.text = data.createdAt
            usefulCountLabel.text = String(data.usefulCount) + " 有用"
            contentLabel.text = data.content
            categoryStackView.isHidden = data.isTitleHidden ?? true
        }
    }
}
