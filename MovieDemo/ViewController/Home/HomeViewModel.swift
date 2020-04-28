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
        getInTheaterMovies(tabId: 1)
    }
    
    struct Input {
        let tabId: AnyObserver<Int?>
    }
    
    struct Output {
        let inTheaterMovieList: BehaviorRelay<InTheaterMovieModel?>
    }
    
    let input: Input
    let output: Output
    
    private let moviesResultSub = BehaviorRelay<InTheaterMovieModel?>(value: nil)
    private let isHotMoviesLoading = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    init() {
        let tabId = PublishSubject<Int?>()
        
        self.input = Input(tabId: tabId.asObserver())
        self.output = Output(inTheaterMovieList: moviesResultSub)
        
        tabId
            .subscribe(onNext: { [weak self] (tabId) in
                guard let strongSelf = self else { return }
                strongSelf.getInTheaterMovies(tabId: tabId ?? 1)
            })
            .disposed(by: disposeBag)
    }
    
    private func getInTheaterMovies(tabId: Int) {
        self.isHotMoviesLoading.accept(true)
        APIService.shared.request(HomeAPI.GetInTheater(pageType: .inTheaters)) // TODO: 改成tabId
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (model) in
                self?.isHotMoviesLoading.accept(false)
                self?.moviesResultSub.accept(model)
                }, onError: { [weak self] _ in
                    self?.isHotMoviesLoading.accept(false)
            })
            .disposed(by: self.disposeBag)
    }
}
