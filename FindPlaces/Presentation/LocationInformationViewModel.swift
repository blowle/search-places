//
//  LocationInformationViewModel.swift
//  FindPlaces
//
//  Created by yongcheol Lee on 2021/12/25.
//

import Foundation
import RxCocoa
import RxSwift

struct LocationInformationViewModel {
    let disposeBag = DisposeBag()
    
    let currentLocationButtonTapped = PublishRelay<Void>()
}
