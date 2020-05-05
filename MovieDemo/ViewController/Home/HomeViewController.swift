//
//  ViewController.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/24.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tabView: ScrollableTabView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    private let disposeBag = DisposeBag()
    private var viewModel: HomeViewModel!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var searchTextField: UITextField? = { [unowned self] in
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
    
    lazy var refreshControl: RxRefreshControl = {
        return RxRefreshControl(viewModel)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        
        registerCell()
        setNavigationBar()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshData()
    }

    private func registerCell() {
        tableView.registerCellWithNib(identifier: String(describing: HomeMovieCell.self), bundle: nil)
    }
    
    private func binding() {
        DataManager.shared.tabData
            .map({ $0 })
            .bind(to: tabView.dataArray)
            .disposed(by: self.disposeBag)
        
        // input
        tabView.didTapItem
            .map({ $0?.title ?? HomeTabs.getInTheater.rawValue })
            .bind(to: viewModel.input.tabName)
            .disposed(by: disposeBag)
        
        // output
        viewModel.output.movieList
        .subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        })
        .disposed(by: disposeBag)
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.backgroundColor = UIColor(named: "MainColor")
        navigationController?.navigationBar.barTintColor = UIColor(named: "MainColor")
        navigationItem.title = "豆瓣電影"
        searchController.searchBar.placeholder = "Search for movie"
        searchController.searchBar.backgroundImage = UIImage()
        navigationItem.searchController = searchController
        
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.movieList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeMovieCell.identifier, for: indexPath) as? HomeMovieCell else { return UITableViewCell()}
        let data = viewModel.output.movieList.value[indexPath.row]
        cell.setupData(data: data)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return width / 3.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard.movieDetail.instantiateViewController(withClass: MovieDetailViewController.self) else { return }
        detailVC.movieId = self.viewModel.output.movieList.value[indexPath.row].id
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
