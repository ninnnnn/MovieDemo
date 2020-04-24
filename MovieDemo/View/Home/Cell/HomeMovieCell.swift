//
//  HomeMovieCell.swift
//  DouBanMovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/24.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit

class HomeMovieCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLengthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCellShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setCellShadow() {
        self.layer.cornerRadius = 5
        cellBackgroundView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cellBackgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        cellBackgroundView.layer.shadowOpacity = 0.5
        cellBackgroundView.layer.shadowRadius = 2
        cellBackgroundView.layer.cornerRadius = 5
        movieImageView.layer.cornerRadius = 5
        movieImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
}
