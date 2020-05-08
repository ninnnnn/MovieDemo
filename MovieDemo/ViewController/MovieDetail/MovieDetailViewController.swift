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

protocol CellType: UITableViewCell {
    func setup(data: Any)
}

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
    
    private let heightOfHeader = height / 2
    private let heightOfTopView: CGFloat = 150
    private let disposeBag = DisposeBag()
    private let backBtn = UIButton()
    private var viewModel: MovieDetailViewModel!
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
        // input
        tableView.rx.itemSelected
            .bind(to: viewModel.input.indexPathOfCell)
            .disposed(by: self.disposeBag)
        
        // output
        viewModel.output.labelNumsOfLines
            .subscribe(onNext: { [weak self] obj in
                guard let obj = obj else { return }
                self?.tableView.beginUpdates()
                switch obj.0.row {
                case 1:
                    guard let cell = self?.tableView.cellForRow(at: obj.0) as? MovieIntroCell else { return }
                    cell.contentLabel.numberOfLines = obj.1
                case let x where x > 3:
                    guard let cell = self?.tableView.cellForRow(at: obj.0) as? CommentCell else { return }
                    cell.contentLabel.numberOfLines = obj.1
                default: return
                }
                self?.tableView.endUpdates()
            })
            .disposed(by: self.disposeBag)
        
        viewModel.output.movieDetail
            .do(onNext: { (_) in
                CustomProgressHUD.show()
            })
            .subscribe(onNext: { [weak self] _ in
                CustomProgressHUD.dismiss()
                self?.tableView.reloadData()
                self?.initHeaderData()
                self?.initHeaderView()
                }, onError: { _ in
                    CustomProgressHUD.showFailure()
            })
            .disposed(by: self.disposeBag)
        
        viewModel.output.movieTitle
            .drive(movieNameLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        viewModel.output.directors
            .bind(to: directorLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        viewModel.output.casts
            .bind(to: castLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        viewModel.output.genres
            .bind(to: genresLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        viewModel.output.pubdate
            .bind(to: pubdateLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        viewModel.output.countries
            .bind(to: countriesLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    private func registerCell() {
        tableView.registerCellWithNib(identifier: String(describing: StarRateCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: MovieIntroCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: ImageCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: CommentCell.self), bundle: nil)
    }
    
    private func initHeaderView() {
        headImageView.frame = CGRect.init(x: 0, y: -(heightOfHeader + heightOfTopView), width: width, height: heightOfHeader)
        headImageView.contentMode = .scaleAspectFit
        headImageView.clipsToBounds = true
        tableView.contentInset = UIEdgeInsets(top: heightOfHeader + topPadding + heightOfTopView, left: 0, bottom: 0, right: 0)
        tableView.addSubview(headImageView)
    }
    
    private func initHeaderData() {
        guard let data = viewModel.output.movieDetail.value else { return }
        headImageView.loadImage(data.images.small, placeHolder: UIImage(named: "placeholder"))
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
}

extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.cellData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CellType?
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: StarRateCell.identifier, for: indexPath) as? CellType
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: MovieIntroCell.identifier, for: indexPath) as? CellType
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.identifier, for: indexPath) as? CellType
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.identifier, for: indexPath) as? CellType
        case let x where x > 3:
            cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CellType
            if indexPath.row == 4 {
                (cell as? CommentCell)?.categoryStackView.isHidden = false
            } else {
                (cell as? CommentCell)?.categoryStackView.isHidden = true
            }
        default:
            return UITableViewCell()
        }
        
        let data = self.viewModel.output.cellData.value[indexPath.row]
        cell?.setup(data: data)
        if let cell = cell {
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
            }
            directorLabel.alpha = radius > 0 ? radius : 0
            castLabel.alpha = radius > 0 ? radius : 0
            genresLabel.alpha = radius > 0 ? radius : 0
            pubdateLabel.alpha = radius > 0 ? radius : 0
            countriesLabel.alpha = radius > 0 ? radius : 0
            movieNameLabel.numberOfLines = radius > 0 ? 2 : 1
        }
        
        if (-offsetY > heightOfHeader){ // 海報放大
            headImageView.transform = CGAffineTransform.init(scaleX: radius, y: radius)
            var frame = headImageView.frame
            frame.origin.y = offsetY
            headImageView.frame = frame
        }
    }
}
