//
//  HomeMovieCell.swift
//  DouBanMovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/24.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeMovieCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var pubdateLabel: UILabel!
    @IBOutlet weak var durationsLabel: UILabel!
    
    var disposeBag = DisposeBag()
    var movieData: [Subjects] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCellShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
    
    func setupData(data: Subjects) {
        movieImageView.loadImage(data.images?.small)
        titleLabel.text = data.title
        pubdateLabel.text = "上映日期：".appendingPathExtension(data.mainlandPubdate ?? "")
        durationsLabel.text = "片長：" + data.durations[0]
        
        let newItems = Array(data.genres.map {[$0]}.joined(separator: ["/"]))
        var categories = ""
        newItems.forEach { (category) in
            categories.append(category)
        }
        categoryLabel.text = "類型：" + categories
    }
    
//    func setupData(viewModel: HomeMovieCellViewModel) {
//        movieImageView.loadImage(viewModel.movieImageUrl)
//        titleLabel.text = viewModel.title
//        categoryLabel.text = viewModel.category
//        pubdateLabel.text = viewModel.pubdate
//        durationsLabel.text = viewModel.durations
//    }
}
