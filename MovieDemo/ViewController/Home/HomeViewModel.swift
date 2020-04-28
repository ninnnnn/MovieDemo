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
        getInTheaterMovies()
    }
    
    struct Input {
//        let tabCategories: AnyObserver<Int?>
    }
    
    struct Output {
        let inTheaterMovieList: BehaviorRelay<InTheaterMovieModel?>
//        let inTheaterMovieListCount: BehaviorRelay<Int>
    }
    
    let input: Input
    let output: Output
    
    private let moviesResultSub = BehaviorRelay<InTheaterMovieModel?>(value: nil)
    private let isHotMoviesLoading = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    var cellViewModel: [HomeMovieCellViewModel] = []
    
    init() {
//        let tabTitleSub = PublishSubject<Int?>()
        let moviesResult = BehaviorRelay<BaseResponseData<[InTheaterMovieModel]>?>(value: nil)
//        let inTheaterMovieListCount = BehaviorRelay<Int>(value: 0)
        
        self.input = Input()
        self.output = Output(inTheaterMovieList: moviesResultSub)
        
//        moviesResultSub
//            .map({ $0 })
//            .bind(to: moviesResult)
//            .disposed(by: disposeBag)
//        
//        moviesResult.subscribe(onNext: { [weak self] (model) in
//            self?.getInTheaterMovies()
//        })
//        .disposed(by: disposeBag)
        
        getInTheaterMovies()
    }
    
    private func getInTheaterMovies() {
        self.isHotMoviesLoading.accept(true)
        APIService.shared.request(HomeAPI.GetHotMovies(pageType: .inTheaters))
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (model) in
                self?.isHotMoviesLoading.accept(false)
                self?.moviesResultSub.accept(model)
                print(model)
                }, onError: { [weak self] _ in
                    self?.isHotMoviesLoading.accept(false)
//                    self?.moviesResultSub.onNext(nil)
            })
            .disposed(by: self.disposeBag)
    }
}
