//
//  DetailListBackgroundViewModel.swift
//  FindPlaces
//
//  Created by yongcheol Lee on 2021/12/26.
//

import Foundation
import RxCocoa
import RxSwift

struct DetailListBackgroundViewModel {
    // viewmodel -> view
    let isStatusLabelHidden: Signal<Bool>
    
    // 외부에서 전달받은 값
    let shouldHideStatusLabel = PublishSubject<Bool>()
    
    init() {
        isStatusLabelHidden = shouldHideStatusLabel
            .asSignal(onErrorJustReturn: true)
    }
}
