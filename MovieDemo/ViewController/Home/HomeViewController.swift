//
//  ViewController.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/24.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tabView: ScrollableTabView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    let width = UIScreen.main.bounds.width
    let searchController = UISearchController(searchResultsController: nil)
    private lazy var searchTextField: UITextField? = { [unowned self] in
        var textField: UITextField?
        self.searchController.searchBar.subviews.forEach({ view in
            view.subviews.forEach({ view in
                if let view  = view as? UITextField {
                    textField = view
                }
            })
        })
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        setNavigationBar()
    }

    private func registerCell() {
        tableView.registerCellWithNib(identifier: String(describing: HomeMovieCell.self), bundle: nil)
    }
    
    private func binding() {
        
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.backgroundColor = UIColor(named: "MainColor")
        navigationController?.navigationBar.barTintColor = UIColor(named: "MainColor")
        navigationItem.title = "豆瓣電影"
        searchController.searchBar.placeholder = "Search for movie"
        searchController.searchBar.backgroundImage = UIImage()
        navigationItem.searchController = searchController
        
    }
    
    private func showDetailVC() {
        guard let detailVC = UIStoryboard.movieDetail.instantiateViewController(withClass: MovieDetailViewController.self) else { return }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeMovieCell.identifier, for: indexPath) as? HomeMovieCell else { return UITableViewCell()}
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return width / 3.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        showDetailVC()
    }
}
