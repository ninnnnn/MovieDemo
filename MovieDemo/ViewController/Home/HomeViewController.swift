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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        
        registerCell()
        setNavigationBar()
        setSearchController()
        binding()
    }
    
    private func registerCell() {
        tableView.registerCellWithNib(identifier: String(describing: HomeMovieCell.self), bundle: nil)
    }
    
    private func binding() {
        DataManager.shared.tabData.subscribe(onNext: { [weak self] (tabDataList) in
            self?.tabView.dataArray.accept(tabDataList)
            self?.tabView.updateDefualtSelect(tabDataList[0])
        }).disposed(by: self.disposeBag)
        
        // input
        tabView.didTapItem.map { (tabData) -> Int in
            CustomProgressHUD.show()
            return tabData?.id ?? 1
        }
        .bind(to: viewModel.input.tabName)
        .disposed(by: self.disposeBag)
        
        // output
        viewModel.output.movieList
            .subscribe(onNext: { [weak self] _ in
                CustomProgressHUD.dismiss()
                self?.tableView.reloadData()
            })
            .disposed(by: self.disposeBag)
        
        viewModel.output.weeklyAndUSList
            .subscribe(onNext: { [weak self] _ in
                CustomProgressHUD.dismiss()
                self?.tableView.reloadData()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.backgroundColor = UIColor(named: "MainColor")
        navigationController?.navigationBar.barTintColor = UIColor(named: "MainColor")
        navigationItem.title = "豆瓣電影"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    private func setSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.backgroundColor = UIColor(named: "MainColor")
        searchController.searchBar.placeholder = "輸入電影名稱"
        searchController.hidesNavigationBarDuringPresentation = false
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let didTapItem = tabView.didTapItem.value
        switch didTapItem?.id {
        case 4, 5:
            return viewModel.output.weeklyAndUSList.value.count
        default:
            return viewModel.output.movieList.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeMovieCell.identifier, for: indexPath) as? HomeMovieCell else { return UITableViewCell()}
        let didTapItem = tabView.didTapItem.value
        switch didTapItem?.id {
        case 4, 5:
            let data = viewModel.output.weeklyAndUSList.value[indexPath.row].subject
            cell.setupData(data: data)
        default:
            let data = viewModel.output.movieList.value[indexPath.row]
            cell.setupData(data: data)
        }
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return width / 3.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard.movieDetail.instantiateViewController(withClass: MovieDetailViewController.self) else { return }
        let didTapItem = tabView.didTapItem.value
        var id: String = ""
        switch didTapItem?.id {
        case 4, 5:
            id = self.viewModel.output.weeklyAndUSList.value[indexPath.row].subject.id
        default:
            id = self.viewModel.output.movieList.value[indexPath.row].id
        }
        detailVC.movieId = id
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
