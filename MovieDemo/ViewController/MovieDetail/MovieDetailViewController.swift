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

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var movieDeatil: Subjects?
    var movieId: String!
    
    private let disposeBag = DisposeBag()
    private let backBtn = UIButton()
    private var viewModel: MovieDetailViewModel!
    private var headImageView = UIImageView()
    private var topView = UIView()
    private var titleLabel = UILabel()
    private var directorLabel = UILabel()
    private var castLabel = UILabel()
    private var generesLabel = UILabel()
    private var pubdateLabel = UILabel()
    private var locationLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MovieDetailViewModel(eventId: movieId)

        registerCell()
        initHeaderView()
        initTopView()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(view.safeAreaInsets.top)
    }
    
    private func binding() {
        
        // output
        viewModel.output.movieDetail
        .subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
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
        headImageView.loadImage(movieDeatil?.images?.small, placeHolder: UIImage(named: "placeholder"))
        headImageView.frame = CGRect.init(x: 0, y: -200, width: width, height: 200)
        headImageView.contentMode = .scaleAspectFill
        headImageView.clipsToBounds = true
        tableView.addSubview(headImageView)
        tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
    }
    
    private func initTopView() {
        DispatchQueue.main.async {
            self.topView.frame = CGRect.init(x: 0, y: 200 + self.view.safeAreaInsets.top, width: width, height: 150)
        }
        topView.backgroundColor = UIColor(named: "MainColor")
        // 電影名稱
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: width, height: 25)
        titleLabel.font = UIFont(name: "PingFangSC-Regular", size: 18)!
        titleLabel.numberOfLines = 2
        titleLabel.text = movieDeatil?.title ?? "電影名稱"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        topView.addSubview(titleLabel)
        // 導演
        directorLabel.frame = CGRect.init(x: 0, y: titleLabel.frame.maxY, width: width, height: 25)
        directorLabel.font = UIFont(name: "PingFangSC-Regular", size: 12)!
        directorLabel.numberOfLines = 1
        directorLabel.text = "導演：" + (movieDeatil?.directors[0].name ?? "導演")
        directorLabel.textColor = .white
        directorLabel.textAlignment = .center
        topView.addSubview(directorLabel)
        // 演員
        castLabel.frame = CGRect.init(x: 0, y: directorLabel.frame.maxY, width: width, height: 25)
        castLabel.font = UIFont(name: "PingFangSC-Regular", size: 12)!
        castLabel.numberOfLines = 2
        castLabel.text = getCastText()
        castLabel.textColor = .white
        castLabel.textAlignment = .center
        topView.addSubview(castLabel)
        // 類型
        generesLabel.frame = CGRect.init(x: 0, y: castLabel.frame.maxY, width: width, height: 25)
        generesLabel.font = UIFont(name: "PingFangSC-Regular", size: 12)!
        generesLabel.numberOfLines = 1
        generesLabel.text = getGeneresText()
        generesLabel.textColor = .white
        generesLabel.textAlignment = .center
        topView.addSubview(generesLabel)
        // 上映日期
        pubdateLabel.frame = CGRect.init(x: 0, y: generesLabel.frame.maxY, width: width, height: 25)
        pubdateLabel.font = UIFont(name: "PingFangSC-Regular", size: 12)!
        pubdateLabel.numberOfLines = 1
        pubdateLabel.text = "上映日期：" + (movieDeatil?.mainlandPubdate ?? "")
        pubdateLabel.textColor = .white
        pubdateLabel.textAlignment = .center
        topView.addSubview(pubdateLabel)
        // 製片國家/地區
        locationLabel.frame = CGRect.init(x: 0, y: pubdateLabel.frame.maxY, width: width, height: 25)
        locationLabel.font = UIFont(name: "PingFangSC-Regular", size: 12)!
        locationLabel.numberOfLines = 1
        locationLabel.text = "製片國家/地區："
        locationLabel.textColor = .white
        locationLabel.textAlignment = .center
        topView.addSubview(locationLabel)
        
        self.view.addSubview(topView)
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
    
    private func getCastText() -> String {
        guard let data = movieDeatil?.casts else { return "" }
        var castList: [String] = []
        var casts = ""
        if !data.isEmpty {
            data.forEach { (cast) in
                castList.append(cast.name)
            }
        }
        let newItems = Array(castList.map {[$0]}.joined(separator: ["/"]))
        newItems.forEach { (cast) in
            casts.append(cast)
        }
        return "演員：" + casts
    }
    
    private func getGeneresText() -> String {
        var categories = ""
        if !(movieDeatil?.genres.isEmpty)! {
            let newItems = Array(movieDeatil!.genres.map {[$0]}.joined(separator: ["/"]))
            newItems.forEach { (category) in
                categories.append(category)
            }
        }
        return "類型：" + categories
    }
}

extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + 4
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
            cell.setup(data: data ?? "")
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastIntroCell.identifier, for: indexPath) as? CastIntroCell else { return UITableViewCell() }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UITableViewCell() }
//            let data = viewModel.output.movieDetail.value?.popularComments[indexPath.row]
//            cell.setup(data: data!)
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
            return height / 5
        case 2:
            return height / 4
        default:
            return height / 5
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isViewLoaded || view.window == nil { return }
        print(scrollView.contentOffset.y)
        let offsetY = scrollView.contentOffset.y
        let radius = -offsetY / 200 //200 = headView高度
        
        var topViewFrame = topView.frame
        if scrollView.contentOffset.y < 0 {
             topViewFrame.origin.y = -scrollView.contentOffset.y
        } else {
            if scrollView.contentOffset.y < 150 - 80 {
                topViewFrame.origin.y = -scrollView.contentOffset.y
            } else {
                topViewFrame.origin.y = -(150 - 80)
            }
        }

//        topViewFrame.origin.y += self.view.safeAreaInsets.top
        self.topView.frame = topViewFrame
        
        
        if (-offsetY > 200){
            headImageView.transform = CGAffineTransform.init(scaleX: radius, y: radius)
            var frame = headImageView.frame
            frame.origin.y = offsetY
            headImageView.frame = frame
        }
//
        if radius > 0 {
//            titleLabel.frame = CGRect.init(x: 0, y: (120 * (1-radius)), width: width, height: 25)
//            directorLabel.frame = CGRect.init(x: 0, y: titleLabel.frame.maxY, width: width, height: 25)
//            castLabel.frame = CGRect.init(x: 0, y: directorLabel.frame.maxY, width: width, height: 25)
//            generesLabel.frame = CGRect.init(x: 0, y: castLabel.frame.maxY, width: width, height: 25)
//            pubdateLabel.frame = CGRect.init(x: 0, y: generesLabel.frame.maxY, width: width, height: 25)
//            locationLabel.frame = CGRect.init(x: 0, y: pubdateLabel.frame.maxY, width: width, height: 25)
//
//            directorLabel.alpha = radius
//            castLabel.alpha = radius
//            generesLabel.alpha = radius
//            pubdateLabel.alpha = radius
//            locationLabel.alpha = radius
//            titleLabel.numberOfLines = 2
//
//            topView.frame = CGRect.init(x: 0, y: 200 - 150 - offsetY, width: width, height: 150)
        } else {
//            directorLabel.alpha = 0
//            castLabel.alpha = 0
//            generesLabel.alpha = 0
//            pubdateLabel.alpha = 0
//            locationLabel.alpha = 0
//            titleLabel.numberOfLines = 1
        }
    }
}
