//
//  ExtensionObservableType.swift
//  Esports
//
//  Created by Daniel on 2020/2/20.
//  Copyright © 2020 ST_Ray.Lin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    
    //https://github.com/ReactiveX/RxSwift/issues/1164#issuecomment-290561416
    func currentAndPrevious() -> Observable<(current: Element, previous: Element?)> {
        return self.multicast({ () -> PublishSubject<Element> in PublishSubject<Element>() }) { (values: Observable<Element>) -> Observable<(current: Element, previous: Element?)> in
            let pastValues = values.asObservable().map { previous -> Element? in previous }.startWith(nil)
            return Observable.zip(values.asObservable(), pastValues) { (current, previous) in
                return (current: current, previous: previous)
            }
        }
    }
}
