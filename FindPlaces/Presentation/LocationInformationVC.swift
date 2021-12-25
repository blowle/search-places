//
//  LocationInformationVC.swift
//  FindPlaces
//
//  Created by yongcheol Lee on 2021/12/25.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import SnapKit



class LocationInformationVC: UIViewController {
    let disposeBag = DisposeBag()
    
    let viewModel = LocationInformationViewModel()
    
    let locationManager = CLLocationManager()
    let mapView = MTMapView()
    let detailList = UITableView()
    let currentLocationButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        bind(viewModel)
        attribute()
        layout()
    }
    
    private func bind(_ viewModel: LocationInformationViewModel) {
        currentLocationButton.rx.tap
            .bind(to: viewModel.currentLocationButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
         title = "내 주변 편의시설 찾기"
        view.backgroundColor = .white
        
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
        
        currentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        currentLocationButton.backgroundColor = .white
        currentLocationButton.layer.cornerRadius = 20
    }
    
    private func layout() {
        [mapView, currentLocationButton, detailList]
            .forEach { view.addSubview($0) }
        
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.snp.centerY).offset(100)
        }
        
        currentLocationButton.snp.makeConstraints {
            $0.bottom.equalTo(detailList.snp.top).offset(-12)
            $0.leading.equalToSuperview().offset(12)
            $0.width.height.equalTo(40)
        }
        
        detailList.snp.makeConstraints {
            $0.centerX.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.top.equalTo(mapView.snp.bottom)
        }
    }
}

extension LocationInformationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
            return
        default:
//            viewModel.mapViewError.accept()
            return
        }
    }
}

extension LocationInformationVC: MTMapViewDelegate {
    
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        
        #if DEBUG
        // viewModel.currentLocation.accept()
        #else
        // viewModel.currentLocation.accept(location)
        #endif
    }
    
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        // viewModel.mapCenterPoint.accept(mapCenterPoint)
    }
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        // viewModel.selectPOIItem.accept(poiItem)
    }
    
    func mapView(_ mapView: MTMapView!, failedUpdatingCurrentLocationWithError error: Error!) {
        // viewModel.mapViewError.accept(error.localizedDescription)
        
    }
}
 
