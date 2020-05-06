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
        getMovies(tabName: HomeTabs.getInTheater)
    }
    
    struct Input {
        let tabName: AnyObserver<String>
    }
    
    struct Output {
        let movieList: BehaviorRelay<[Subjects]>
    }
    
    let input: Input
    let output: Output
    
    private let moviesResult = BehaviorRelay<[Subjects]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    init() {
        let tabName = PublishSubject<String>()
        
        self.input = Input(tabName: tabName.asObserver())
        self.output = Output(movieList: moviesResult)
        
        tabName
            .subscribe(onNext: { [weak self] (tabName) in
                guard let strongSelf = self else { return }
                strongSelf.getMovies(tabName: HomeTabs(rawValue: tabName)!)
//                if tabName == "口碑榜" || tabName == "北美票房榜" {
//                    strongSelf.getWeeklyAndUSMovies(tabName: WeeklyAndUSTabs(rawValue: tabName)!)
//                } else {
//                    strongSelf.getMovies(tabName: HomeTabs(rawValue: tabName)!)
//                }
            })
            .disposed(by: disposeBag)
    }
    
    private func getMovies(tabName: HomeTabs) {
        CustomProgressHUD.show()
        APIService.shared.request(HomeAPI.GetMovies(homeTabs: tabName))
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (model) in
                CustomProgressHUD.dismiss()
                self?.moviesResult.accept(model.subjects)
                }, onError: { [weak self] _ in
                    CustomProgressHUD.showFailure()
                    self?.moviesResult.accept([])
            })
            .disposed(by: self.disposeBag)
    }
    
//    private func getWeeklyAndUSMovies(tabName: WeeklyAndUSTabs) {
//        self.isHotMoviesLoading.accept(true)
//        APIService.shared.request(HomeAPI.GetWeeklyAndUSMovies(tabs: tabName))
//            .subscribeOn(MainScheduler.instance)
//            .subscribe(onSuccess: { [weak self] (model) in
//                self?.isHotMoviesLoading.accept(false)
//                self?.moviesResult.accept(model.subjects)
//                }, onError: { [weak self] _ in
//                    self?.isHotMoviesLoading.accept(false)
//                    self?.moviesResult.accept([])
//            })
//            .disposed(by: self.disposeBag)
//    }
}
