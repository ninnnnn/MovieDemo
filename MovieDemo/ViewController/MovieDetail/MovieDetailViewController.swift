//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/24.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
    }
    
    private func registerCell() {
        tableView.registerCellWithNib(identifier: String(describing: MovieDetailCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: StarRateCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: MovieIntroCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: CastIntroCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: CommentCell.self), bundle: nil)
    }
}

extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailCell.identifier, for: indexPath) as? MovieDetailCell else { return UITableViewCell() }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StarRateCell.identifier, for: indexPath) as? StarRateCell else { return UITableViewCell() }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieIntroCell.identifier, for: indexPath) as? MovieIntroCell else { return UITableViewCell() }
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastIntroCell.identifier, for: indexPath) as? CastIntroCell else { return UITableViewCell() }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UITableViewCell() }
            return cell
        }
    }
}

extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 200
        case 1:
            return 80
        case 2:
            return 150
        case 3:
            return 150
        default:
            return 100
        }
    }
}
