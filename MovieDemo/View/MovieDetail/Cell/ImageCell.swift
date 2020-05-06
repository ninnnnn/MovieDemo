//
//  CastIntroCell.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/28.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell, CellType {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    var cellContentList: [CellContent] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.registerCellWithNib(identifier: CollectionViewCell.identifier, bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data: Any) {
        if let data = data as? [CellContent] {
            self.cellContentList = data
        }
    }
}

extension ImageCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellContentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell() }
        let cellIndexPath = cellContentList[indexPath.item]
        switch cellIndexPath.type {
        case .cast:
            categoryLabel.text = "演職員"
            cell.setup(text: cellIndexPath.text, imageUrl: cellIndexPath.imageUrl)
        default:
            categoryLabel.text = "花絮"
            cell.setup(text: cellIndexPath.text, imageUrl: cellIndexPath.imageUrl)
        }
        return cell
    }
}

extension ImageCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 24, right: 8)
        return CGSize(width: width / 3, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
