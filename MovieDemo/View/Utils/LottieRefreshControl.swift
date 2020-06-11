//
//  LottieRefreshControl.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/6/10.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit
import Lottie

class LottieRefreshControl: UIRefreshControl {
    fileprivate let animationView = Lottie.AnimationView(name: "loading")
    fileprivate var isAnimating = false
    fileprivate let maxPullDistance: CGFloat = 150

    override init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateProgress(with offsetY: CGFloat) {
        guard !isAnimating else { return }
        let progress = min(abs(offsetY / maxPullDistance), 1)
        animationView.currentProgress = progress
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
}

private extension LottieRefreshControl {
    func setupView() {
        // hide default indicator view
        tintColor = .clear
        animationView.loopMode = .loop
        setupLayout()
        addTarget(self, action: #selector(beginRefreshing), for: .valueChanged)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalToConstant: 50),
            animationView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let loadingLabel = UILabel()
        loadingLabel.text = "加載中"
        loadingLabel.font = UIFont(name: "Arial", size: 13)
        loadingLabel.textAlignment = .left
        NSLayoutConstraint.activate([
            loadingLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.addArrangedSubview(animationView)
        stackView.addArrangedSubview(loadingLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
