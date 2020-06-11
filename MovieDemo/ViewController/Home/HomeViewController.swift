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
import Lottie

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tabView: ScrollableTabView!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    private let disposeBag = DisposeBag()
    private let animationView = Lottie.AnimationView(name: "loading")
    private var viewModel: HomeViewModel!
    private lazy var refreshControl: RxRefreshControl = {
        return RxRefreshControl(viewModel)
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        
        configureUI()
        registerCell()
        setNavigationBar()
        setSearchController()
        binding()
    }
    
    private func configureUI() {
        tableView.refreshControl = refreshControl
    }
    
    private func registerCell() {
        tableView.registerCellWithNib(identifier: String(describing: HomeMovieCell.self), bundle: nil)
    }
    
    private func binding() {
        DataManager.shared.tabData.subscribe(onNext: { [weak self] (tabDataList) in
            self?.tabView.dataArray.accept(tabDataList)
            self?.tabView.updateDefualtSelect(tabDataList[0])
        }).disposed(by: self.disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
//            .do(onNext: { [weak self] _ in
//                guard let self = self else { return }
//                self.animationView.currentProgress = 0
//                self.animationView.play()
//            })
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
            })
            .disposed(by: self.disposeBag)
        
        // input
        tabView.didTapItem.do(onNext: { (_) in
            CustomProgressHUD.show()
        })
            .map({ $0?.id ?? 1 })
            .bind(to: viewModel.input.tabName)
            .disposed(by: self.disposeBag)
        
        // output
        viewModel.output.reloadData
            .subscribe(onNext: { [weak self] _ in
                CustomProgressHUD.dismiss()
                self?.tableView.reloadData()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.backgroundColor = UIColor.MainColor
        navigationController?.navigationBar.barTintColor = UIColor.MainColor
        navigationItem.title = "豆瓣電影"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    private func setSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.backgroundColor = UIColor.MainColor
        searchController.searchBar.placeholder = "輸入電影名稱"
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshControl.updateProgress(with: scrollView.contentOffset.y)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let didTapItem = tabView.didTapItem.value
        switch didTapItem?.id {
        case 4, 5: return viewModel.output.weeklyAndUSList.value.count
        default: return viewModel.output.movieList.value.count
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
        case 4, 5: id = self.viewModel.output.weeklyAndUSList.value[indexPath.row].subject.id
        default: id = self.viewModel.output.movieList.value[indexPath.row].id
        }
        detailVC.movieId = id
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
