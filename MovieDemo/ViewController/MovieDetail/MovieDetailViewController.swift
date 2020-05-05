//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/24.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var pubdateLabel: UILabel!
    @IBOutlet weak var countriesLabel: UILabel!
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var movieId: String!
    var states: [Bool] = [true, true, true, true]
    var collectionViewDataList: [CellContent] = []
    
    private let heightOfHeader = height / 2
    private let heightOfTopView: CGFloat = 150
    private let disposeBag = DisposeBag()
    private let backBtn = UIButton()
    private var viewModel: MovieDetailViewModel!
    private var headerView = UIView()
    private var headImageView = UIImageView()
    private var topPadding: CGFloat {
        return self.view.safeAreaInsets.top
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MovieDetailViewModel(eventId: movieId)

        registerCell()
        setBackBtn()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func binding() {
        // output
        viewModel.output.movieDetail
        .subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
            self?.initHeaderData()
            self?.initHeaderView()
        })
        .disposed(by: disposeBag)
    }
    
    private func registerCell() {
        tableView.registerCellWithNib(identifier: String(describing: MovieDetailCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: StarRateCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: MovieIntroCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: CastIntroCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: CommentCell.self), bundle: nil)
    }
    
    private func initHeaderView() {
        headerView.frame = CGRect.init(x: 0, y: -(heightOfHeader + topPadding + heightOfTopView), width: width, height: heightOfHeader + topPadding)
        headerView.backgroundColor = UIColor(named: "MainColor")
        headImageView.frame = CGRect.init(x: 0, y: topPadding, width: width, height: heightOfHeader)
        headerView.addSubview(headImageView)
        headImageView.contentMode = .scaleAspectFit
        headImageView.clipsToBounds = true
        tableView.contentInset = UIEdgeInsets(top: heightOfHeader + topPadding + heightOfTopView, left: 0, bottom: 0, right: 0)
        tableView.addSubview(headerView)
    }
    
    private func initHeaderData() {
        guard let data = viewModel.output.movieDetail.value else { return }
        headImageView.loadImage(data.images.small, placeHolder: UIImage(named: "placeholder"))
        movieNameLabel.text = data.title
        directorLabel.text = getDirectorText(data: data)
        castLabel.text = getCastText(data: data)
        genresLabel.text = getGeneresText(data: data)
        pubdateLabel.text = "上映日期：" + (data.year)
        countriesLabel.text = getCountriesText(data: data)
    }
    
    private func setBackBtn() {
        backBtn.frame = CGRect(x: width * 0.05, y: width * 0.15, width: width * 0.1, height: width * 0.1)
        backBtn.setImage(UIImage(named: "back"), for: .normal)
        backBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        self.view.addSubview(backBtn)
    }
    
    private func getDirectorText(data: MovieObject) -> String {
        var directorList: [String] = []
        var directors = ""
        if !data.directors.isEmpty {
            data.directors.forEach { (director) in
                directorList.append(director.name)
            }
        }
        let newItems = Array(directorList.map {[$0]}.joined(separator: ["/"]))
        newItems.forEach { (cast) in
            directors.append(cast)
        }
        return "導演：" + directors
    }
    
    private func getCastText(data: MovieObject) -> String {
        var castList: [String] = []
        var casts = ""
        if !data.casts.isEmpty {
            data.casts.forEach { (cast) in
                castList.append(cast.name)
            }
        }
        let newItems = Array(castList.map {[$0]}.joined(separator: ["/"]))
        newItems.forEach { (cast) in
            casts.append(cast)
        }
        return "演員：" + casts
    }
    
    private func getGeneresText(data: MovieObject) -> String {
        var categories = ""
        if !(data.genres.isEmpty) {
            let newItems = Array(data.genres.map {[$0]}.joined(separator: ["/"]))
            newItems.forEach { (category) in
                categories.append(category)
            }
        }
        return "類型：" + categories
    }
    
    private func getCountriesText(data: MovieObject) -> String {
        var countries = ""
        if !(data.countries.isEmpty) {
            let newItems = Array(data.countries.map {[$0]}.joined(separator: ["/"]))
            newItems.forEach { (country) in
                countries.append(country)
            }
        }
        return "製片國家/地區：：" + countries
    }
}

extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 + 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StarRateCell.identifier, for: indexPath) as? StarRateCell else { return UITableViewCell() }
            let data = viewModel.output.movieDetail.value?.rating.average
            cell.setup(data: data ?? 0.0)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieIntroCell.identifier, for: indexPath) as? MovieIntroCell else { return UITableViewCell() }
            let data = viewModel.output.movieDetail.value?.summary
            cell.contentLabel.numberOfLines = 5
            cell.setup(data: data ?? "")
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastIntroCell.identifier, for: indexPath) as? CastIntroCell else { return UITableViewCell() }
            guard let data = viewModel.output.movieDetail.value?.casts else { return cell }
            collectionViewDataList.removeAll()
            for cast in data {
                collectionViewDataList.append(CellContent(type: .cast, text: cast.name, imageUrl: cast.avatars.small))
            }
            cell.setup(data: collectionViewDataList)
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastIntroCell.identifier, for: indexPath) as? CastIntroCell else { return UITableViewCell() }
            guard let data = viewModel.output.movieDetail.value?.trailers else { return cell }
            collectionViewDataList.removeAll()
            for trailer in data {
                collectionViewDataList.append(CellContent(type: .trailer, text: trailer.title, imageUrl: trailer.medium))
            }
            cell.setup(data: collectionViewDataList)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UITableViewCell() }
            let data = viewModel.output.movieDetail.value?.popularComments[indexPath.row - 4]
            let defaultData = PopularComments(usefulCount: 0, author: Author(avatar: "", name: ""), content: "", createdAt: "")
            cell.setup(data: data ?? defaultData)
            if indexPath.row == 4 {
                cell.categoryStackView.isHidden = false
            } else {
                cell.categoryStackView.isHidden = true
            }
            return cell
        }
    }
}

extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return height / 7
        case 1:
            return height / 4
        case 2:
            return height / 3
        case 3:
            return height / 3
        default:
            return height / 5
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let radius = -offsetY / heightOfTopView
        let remainHeader = topView.frame.height / 4
        
        if offsetY < -heightOfTopView {
            topViewTopConstraint.constant = -(offsetY + heightOfHeader + heightOfTopView)
        } else {
            if offsetY < -heightOfTopView + remainHeader {
                topViewTopConstraint.constant = -(offsetY + heightOfHeader + heightOfTopView)
            } else {
                topViewTopConstraint.constant = -(-heightOfTopView + remainHeader + heightOfHeader + heightOfTopView)
            }

            if radius > 0 {
                movieNameLabel.frame.origin.y = 100 * (1-radius)
                directorLabel.alpha = radius
                castLabel.alpha = radius
                genresLabel.alpha = radius
                pubdateLabel.alpha = radius
                countriesLabel.alpha = radius
                movieNameLabel.numberOfLines = 2
            } else {
                directorLabel.alpha = 0
                castLabel.alpha = 0
                genresLabel.alpha = 0
                pubdateLabel.alpha = 0
                countriesLabel.alpha = 0
                movieNameLabel.numberOfLines = 1
            }
        }
        
//        if (-offsetY > heightOfHeader){ // 海報放大
//            headImageView.transform = CGAffineTransform.init(scaleX: radius, y: radius)
//            var frame = headImageView.frame
//            frame.origin.y = offsetY
//            headImageView.frame = frame
//        }
    }
}
