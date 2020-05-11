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

class HomeViewModel: ViewModelType {
    
    struct Input {
        let tabName: AnyObserver<Int>
    }
    
    struct Output {
        let movieList: BehaviorRelay<[Subjects]>
        let weeklyAndUSList: BehaviorRelay<[Subjects2]>
        let reloadData: Observable<Void>
    }
    
    let input: Input
    let output: Output
    
    private let moviesResult = BehaviorRelay<[Subjects]>(value: [])
    private let weeklyAndUSResult = BehaviorRelay<[Subjects2]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    init() {
        let tabName = PublishSubject<Int>()
        let reloadData = Observable.of(moviesResult.asObservable().map({ _ in }), weeklyAndUSResult.asObservable().map({ _ in })).merge()
        
        self.input = Input(tabName: tabName.asObserver())
        self.output = Output(movieList: moviesResult,
                             weeklyAndUSList: weeklyAndUSResult,
                             reloadData: reloadData)
        
        tabName
            .subscribe(onNext: { [weak self] (tabId) in
                if tabId == 4 || tabId == 5 {
                    self?.getWeeklyAndUSMovies(tabName: WeeklyAndUSTabs(rawValue: tabId)!)
                } else {
                    self?.getMovies(tabName: HomeTabs(rawValue: tabId)!)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func getMovies(tabName: HomeTabs) {
        APIService.shared.request(HomeAPI.GetMovies(homeTabs: tabName))
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (model) in
                self?.moviesResult.accept(model.subjects)
                }, onError: { [weak self] _ in
                    self?.moviesResult.accept([])
            })
            .disposed(by: self.disposeBag)
    }
    
    private func getWeeklyAndUSMovies(tabName: WeeklyAndUSTabs) {
        APIService.shared.request(HomeAPI.GetWeeklyAndUSMovies(tabs: tabName))
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (model) in
                self?.weeklyAndUSResult.accept(model.subjects)
                }, onError: { [weak self] _ in
                    self?.weeklyAndUSResult.accept([])
            })
            .disposed(by: self.disposeBag)
    }
}
