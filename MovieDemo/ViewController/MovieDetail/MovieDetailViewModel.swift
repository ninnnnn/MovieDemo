//
//  MovieDetailViewModel.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/30.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailViewModel: ViewModelType {
    
    struct Input {
        let movieId: AnyObserver<Int>
    }
    
    struct Output {
        let movieDetail: BehaviorRelay<MovieObject?>
    }
    
    let input: Input
    let output: Output
    
    private let movieDetail = BehaviorRelay<MovieObject?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    init(eventId: String) {
        let movieId = PublishSubject<Int>()
        
        self.input = Input(movieId: movieId.asObserver())
        self.output = Output(movieDetail: movieDetail)
        
        getMovieDetails(movieId: eventId)
    }
    
    private func getMovieDetails(movieId: String) {
        APIService.shared.request(MovieDetailAPI.GetMovieDetail(movieId: movieId))
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (model) in
                self?.movieDetail.accept(model)
            }, onError: { [weak self] _ in
                self?.movieDetail.accept(nil)
            })
            .disposed(by: disposeBag)
    }
}
