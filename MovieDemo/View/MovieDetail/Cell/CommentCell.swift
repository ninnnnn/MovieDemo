//
//  CommentCell.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/28.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var categoryStackView: UIStackView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var usefulCountLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data: PopularComments) {
        userImageView.loadImage(data.author.avatar, placeHolder: UIImage(named: "placeholder"))
        userNameLabel.text = data.author.name
        postTimeLabel.text = data.createdAt
        usefulCountLabel.text = String(data.usefulCount) + " 有用"
        contentLabel.text = data.content
    }
}
