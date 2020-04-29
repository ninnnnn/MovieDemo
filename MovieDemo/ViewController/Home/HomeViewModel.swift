//
//  HomeViewModel.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/27.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType, Refreshable {
    var endRefresh: PublishSubject<Void> = PublishSubject<Void>()
    func refreshData() {
        getInTheaterMovies(tabName: HomeTabs.getInTheater)
    }
    
    struct Input {
        let tabName: AnyObserver<String>
    }
    
    struct Output {
        let inTheaterMovieList: BehaviorRelay<[Subjects]>
    }
    
    let input: Input
    let output: Output
    
    private let moviesResultSub = BehaviorRelay<[Subjects]>(value: [])
    private let isHotMoviesLoading = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    init() {
        let tabName = PublishSubject<String>()
        
        self.input = Input(tabName: tabName.asObserver())
        self.output = Output(inTheaterMovieList: moviesResultSub)
        
        tabName
            .subscribe(onNext: { [weak self] (tabName) in
                guard let strongSelf = self else { return }
                strongSelf.getInTheaterMovies(tabName: HomeTabs(rawValue: tabName)!)
            })
            .disposed(by: disposeBag)
    }
    
    private func getInTheaterMovies(tabName: HomeTabs) {
        self.isHotMoviesLoading.accept(true)
        APIService.shared.request(HomeAPI.GetMovies(homeTabs: tabName))
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (model) in
                self?.isHotMoviesLoading.accept(false)
                self?.moviesResultSub.accept(model.subjects)
                }, onError: { [weak self] _ in
                    self?.isHotMoviesLoading.accept(false)
                    self?.moviesResultSub.accept([])
            })
            .disposed(by: self.disposeBag)
    }
}
