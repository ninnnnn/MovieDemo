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
        let movieTitle: Driver<String>
        let directors: Observable<String>
        let casts: Observable<String>
        let genres: Observable<String>
        let pubdate: Driver<String>
        let countries: Observable<String>
        let cellData: BehaviorRelay<[Any]>
    }
    
    let input: Input
    let output: Output
    
    private let movieDetail = BehaviorRelay<MovieObject?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    init(eventId: String) {
        
        let movieId = PublishSubject<Int>()
        let cellData = BehaviorRelay<[Any]>(value: [])
        
        let movieTitle = movieDetail.compactMap({ $0?.title }).asDriver(onErrorJustReturn: "電影名稱")
        let pubdate = movieDetail.compactMap({ $0?.year }).asDriver(onErrorJustReturn: "")
                
        movieDetail.map { (movieObject) -> [Any] in
            guard let movieObject = movieObject else { return [] }
            var dataList = [
                movieObject.rating.average as Any,
                movieObject.summary as Any,
                movieObject.casts.map{CellContent(type: .cast, text: $0.name, imageUrl: $0.avatars.small)} as Any,
                movieObject.trailers.map{CellContent(type: .trailer, text: $0.title, imageUrl: $0.medium)} as Any,
            ]
            for comment in movieObject.popularComments as [PopularComments] {
                dataList.append(PopularComments(usefulCount: comment.usefulCount,
                                                author: comment.author,
                                                content: comment.content,
                                                createdAt: comment.createdAt))
            }
            return dataList
        }
        .bind(to: cellData)
        .disposed(by: self.disposeBag)
        
        let directors = movieDetail.map { model -> String in
            guard let model = model else { return "" }
            var directorList: [String] = []
            var directors = ""
            if !model.directors.isEmpty {
                model.directors.forEach { (director) in
                    directorList.append(director.name)
                }
            }
            let newItems = Array(directorList.map {[$0]}.joined(separator: ["/"]))
            newItems.forEach { (cast) in
                directors.append(cast)
            }
            return "導演：" + directors
        }
        
        let casts = movieDetail.map { model -> String in
            guard let model = model else { return "" }
            var castList: [String] = []
            var casts = ""
            if !model.casts.isEmpty {
                model.casts.forEach { (cast) in
                    castList.append(cast.name)
                }
            }
            let newItems = Array(castList.map {[$0]}.joined(separator: ["/"]))
            newItems.forEach { (cast) in
                casts.append(cast)
            }
            return "演員：" + casts
        }
        
        let genres = movieDetail.map { model -> String in
            guard let model = model else { return "" }
            var categories = ""
            if !(model.genres.isEmpty) {
                let newItems = Array(model.genres.map {[$0]}.joined(separator: ["/"]))
                newItems.forEach { (category) in
                    categories.append(category)
                }
            }
            return "類型：" + categories
        }
        
        let countries = movieDetail.map { model -> String in
            guard let model = model else { return "" }
            var countries = ""
            if !(model.countries.isEmpty) {
                let newItems = Array(model.countries.map {[$0]}.joined(separator: ["/"]))
                newItems.forEach { (country) in
                    countries.append(country)
                }
            }
            return "製片國家/地區：" + countries
        }

        
        self.input = Input(movieId: movieId.asObserver())
        self.output = Output(movieDetail: movieDetail,
                             movieTitle: movieTitle,
                             directors: directors,
                             casts: casts,
                             genres: genres,
                             pubdate: pubdate,
                             countries: countries,
                             cellData: cellData)
        
        getMovieDetails(movieId: eventId)
    }
    
    private func getMovieDetails(movieId: String) {
        CustomProgressHUD.show()
        APIService.shared.request(MovieDetailAPI.GetMovieDetail(movieId: movieId))
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (model) in
                CustomProgressHUD.dismiss()
                self?.movieDetail.accept(model)
            }, onError: { [weak self] _ in
                CustomProgressHUD.showFailure()
                self?.movieDetail.accept(nil)
            })
            .disposed(by: disposeBag)
    }
}
