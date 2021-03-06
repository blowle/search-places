//
//  LocationInformationViewModelTests.swift
//  FindPlacesTests
//
//  Created by yongcheol Lee on 2021/12/29.
//

import XCTest
import Nimble
import RxSwift
import RxTest

@testable import FindPlaces

class LocationInformationViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    let stubNetwork = LocalNetworkStub()
    var model: LocationInformatioModel!
    var viewModel: LocationInformationViewModel!
    var doc: [KLDocument]!
    
    override func setUp() {
        model = LocationInformatioModel(localNetwork: stubNetwork)
        viewModel = LocationInformationViewModel(model)
        doc = cvsList
    }
    
    func testSEtMapCenter() {
        let scheduler = TestScheduler(initialClock: 0)
        
        //더미데이터 이벤트
        let dummyDataEvent = scheduler.createHotObservable([
            .next(0, cvsList)
        ])
        
        let documentData = PublishSubject<[KLDocument]>()
        dummyDataEvent
            .subscribe(documentData)
            .disposed(by: disposeBag)
        
        //DetailList 아이템 탭 이벤트
        let itemSelectedEvent = scheduler.createHotObservable([
            .next(1, 0)
        ])
        
        let itemSelected = PublishSubject<Int>()
        itemSelectedEvent
            .subscribe(itemSelected)
            .disposed(by: disposeBag)
        
        let selectedItemMapPoint = itemSelected
            .withLatestFrom(documentData) { $1[0] }
            .map(model.documentToMTMapPoint)
        
        // 최초 현재 위치 이벤트
        let initialMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(37.394225), longitude: Double(127.110341)))!
        
        let currentLocationEvent = scheduler.createHotObservable([
            .next(0, initialMapPoint)
        ])
        
        let initialCurrentLocation = PublishSubject<MTMapPoint>()
        
        currentLocationEvent
            .subscribe(initialCurrentLocation)
            .disposed(by: disposeBag)
        
        // 현재 위치 버튼 탭 이벤트
        let currentLocationButtonTapEvent = scheduler.createHotObservable([
            .next(2, Void()),
            .next(3, Void())
        ])
        
        let currnetLocationButtonTapped = PublishSubject<Void>()
        
        currentLocationButtonTapEvent
            .subscribe(currnetLocationButtonTapped)
            .disposed(by: disposeBag)
        
        let moveToCurrentLocation = currnetLocationButtonTapped
            .withLatestFrom(initialCurrentLocation)
        
        // Merge
        let currentMapCenter = Observable
            .merge (
                selectedItemMapPoint,
                initialCurrentLocation.take(1),
                moveToCurrentLocation
            )
        
        let currentMapCenterObserver = scheduler.createObserver(Double.self)
        
        currentMapCenter
            .map { $0.mapPointGeo().latitude }
            .subscribe(currentMapCenterObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let secondMapPoint = model.documentToMTMapPoint(doc[0])
        
        expect(currentMapCenterObserver.events)
            .to(equal(
                [.next(0, initialMapPoint.mapPointGeo().latitude),
                 .next(1, secondMapPoint.mapPointGeo().latitude),
                 .next(2, initialMapPoint.mapPointGeo().latitude),
                 .next(3, initialMapPoint.mapPointGeo().latitude),
                 ]),
                description: nil)
    }
}
