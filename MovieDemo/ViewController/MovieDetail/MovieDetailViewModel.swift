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
    
    typealias LabelLines = (indexPath: IndexPath, lines: Int)
    
    struct Input {
        let indexPathOfCell: AnyObserver<IndexPath>
    }
    
    struct Output {
        let movieDetail: BehaviorRelay<MovieObject?>
        let movieTitle: Driver<String>
        let directors: Observable<String>
        let casts: Observable<String>
        let genres: Observable<String>
        let pubdate: Observable<String>
        let countries: Observable<String>
        let cellData: BehaviorRelay<[Any]>
        let labelNumsOfLines: BehaviorRelay<LabelLines?>
    }
    
    let input: Input
    let output: Output
    
    private let movieDetail = BehaviorRelay<MovieObject?>(value: nil)
    private let disposeBag = DisposeBag()
    
    init(eventId: String) {
        
        var dic: [IndexPath: Int] = [:]
        
        let cellData = BehaviorRelay<[Any]>(value: [])
        let indexPathOfCell = PublishSubject<IndexPath>()
        let labelNumsOfLines = BehaviorRelay<LabelLines?>(value: nil)
        
        let movieTitle = movieDetail.compactMap({ $0?.title }).asDriver(onErrorJustReturn: "電影名稱")
        
        movieDetail.map { (movieObject) -> [Any] in
            guard let movieObject = movieObject else { return [] }
            var dataList = [
                movieObject.rating.average as Any,
                movieObject.summary as Any,
                movieObject.casts.map{CellContent(type: .cast, text: $0.name, imageUrl: $0.avatars?.small ?? "")} as Any,
                movieObject.trailers.map{CellContent(type: .trailer, text: $0.title, imageUrl: $0.medium)} as Any,
            ]
            for (index, comment) in movieObject.popularComments.enumerated() {
                var isTitleHidden: Bool?
                isTitleHidden = index == 0 ? false : true
                dataList.append(PopularComments(usefulCount: comment.usefulCount,
                                                author: comment.author,
                                                content: comment.content,
                                                createdAt: comment.createdAt,
                                                isTitleHidden: isTitleHidden))
            }
            return dataList
        }
        .bind(to: cellData)
        .disposed(by: self.disposeBag)
        
        cellData
            .filter({ $0.count > 0 })
            .subscribe(onNext: { (dataList) in
                for indexPath in 0..<dataList.count {
                    switch indexPath {
                    case 1:  dic[IndexPath(row: indexPath, section: 0)] = 5
                    case let x where x > 3: dic[IndexPath(row: x, section: 0)] = 3
                    default: break
                    }
                }
            })
            .disposed(by: self.disposeBag)
        
        indexPathOfCell
            .subscribe(onNext: { (indexPath) in
                var originCount = 0
                switch indexPath.row {
                case 1: originCount = 5
                case let x where x > 3: originCount = 3
                default: return
                }
                if let linesOfLabel = dic[indexPath] {
                    if linesOfLabel == 0 {
                        dic[indexPath] = originCount
                    } else if linesOfLabel == originCount {
                        dic[indexPath] = 0
                    }
                    if let resultCount = dic[indexPath] {
                        labelNumsOfLines.accept((indexPath, resultCount))
                    }
                }
            })
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
        
        let pubdate = movieDetail.map { model -> String in
            guard let model = model else { return "" }
            let year = model.year
            return "上映日期：" + year
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
        
        
        self.input = Input(indexPathOfCell: indexPathOfCell.asObserver())
        self.output = Output(movieDetail: movieDetail,
                             movieTitle: movieTitle,
                             directors: directors,
                             casts: casts,
                             genres: genres,
                             pubdate: pubdate,
                             countries: countries,
                             cellData: cellData,
                             labelNumsOfLines: labelNumsOfLines)
        
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
