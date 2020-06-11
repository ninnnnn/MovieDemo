//
//  RefreshData.swift
//  Esports
//
//  Created by Daniel on 2020/3/10.
//  Copyright © 2020 ST_Ray.Lin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Lottie

protocol Refreshable: class {
    func refreshData()
    var endRefresh: PublishSubject<Void> { get }
    var didGetData: PublishSubject<Void> { get }
}

class RxRefreshControl: UIRefreshControl {
    private weak var refreshable: Refreshable?
    private let disposeBag = DisposeBag()
    private let animationView = Lottie.AnimationView(name: "loading_2")
    private let loadingLabel = UILabel()
    private var isAnimating = false
    
    private override init() {
        super.init()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
    
    convenience init(_ refreshable: Refreshable) {
        self.init()
        self.refreshable = refreshable
        self.binding()
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        isAnimating = true
        animationView.currentProgress = 0
        animationView.play()
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        animationView.stop()
        isAnimating = false
    }
    
    private func binding() {
        rx.controlEvent(.valueChanged)
            .asDriver()
            .do(onNext: { [weak self] _ in
                self?.animationView.isHidden = false
                self?.loadingLabel.text = "載入中"
                self?.loadingLabel.textColor = .black
                self?.loadingLabel.font = UIFont(name: "Arial", size: 13)
            })
            .drive(onNext: { [weak self] _ in
                self?.refreshable?.refreshData()
                self?.beginRefreshing()
            })
            .disposed(by: disposeBag)
        
        refreshable?.endRefresh
            .subscribe(onNext: { [weak self] _ in
                self?.loadingLabel.text = ""
                self?.endRefreshing()
            })
            .disposed(by: self.disposeBag)
        
        refreshable?.didGetData
            .subscribe(onNext: { [weak self] in
                self?.animationView.isHidden = true
                self?.loadingLabel.text = "加載完成"
                self?.loadingLabel.textColor = #colorLiteral(red: 0.4823529412, green: 0.2196078431, blue: 0.8196078431, alpha: 1)
                self?.loadingLabel.font = UIFont(name: "Arial", size: 13)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setupView() {
        // scale to set height of refresh control
        transform = CGAffineTransform(scaleX: 1, y: 1)
        // hide default indicator view
        tintColor = .clear
        animationView.loopMode = .loop
        setupLayout()
    }
    
    private func setupLayout() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.addArrangedSubview(animationView)
        stackView.addArrangedSubview(loadingLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
}
