//
//  LocalNetworkStub.swift
//  FindPlacesTests
//
//  Created by yongcheol Lee on 2021/12/29.
//

import Foundation
import RxSwift
import Stubber

@testable import FindPlaces

class LocalNetworkStub: LocalNetwork {
    override func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        return  Stubber.invoke(getLocation, args: mapPoint)
    }
}
