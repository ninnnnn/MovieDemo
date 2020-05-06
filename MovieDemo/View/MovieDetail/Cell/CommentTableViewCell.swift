//
//  CommentTableViewCell.swift
//  MovieDemo
//
//  Created by Ninn on 2020/5/7.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell, CellType {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    private var dict = [Int: Int]()
    private var commentList: [PopularComments] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.registerCellWithNib(identifier: String(describing: CommentCell.self), bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data: Any) {
        if let data = data as? [PopularComments] {
            self.commentList = data
        }
    }
}

extension CommentTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UITableViewCell() }
        let cellIndexPath = commentList[indexPath.row]
        cell.setup(data: cellIndexPath)
        return cell
    }
}

extension CommentTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CommentCell else { return }
        guard let label = cell.contentLabel else { return }
        tableView.beginUpdates()
        if label.numberOfLines == 0 {
            label.numberOfLines = 3
            dict[indexPath.row] = 3
        } else {
            label.numberOfLines = 0
            dict[indexPath.row] = 0
        }
        tableView.endUpdates()
    }
}
