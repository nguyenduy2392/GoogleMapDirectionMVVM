//
//  DirectionViewModel.swift
//  MapDirectionMVVM
//
//  Created by duy on 9/19/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire
import MapKit

class DirectionViewModel {
  var routes: BehaviorRelay<[DirectionModel]> = BehaviorRelay(value: [])
  var origin: BehaviorRelay<String> = BehaviorRelay(value: "")
  var destination: BehaviorRelay<String> = BehaviorRelay(value: "")
  var annotationPosition: BehaviorRelay<Int> = BehaviorRelay(value: 0)
  var centerLocation: BehaviorRelay<CLLocation> = BehaviorRelay(value: AppConstant.defaultMapCenter)
  var isValid : Observable<Bool> {
    return Observable.combineLatest(origin.asObservable(), destination.asObservable()) { origin, destination in
      origin.count >= 1 && destination.count >= 1
    }
  }
  
  var startPoint: Artwork? {
    get {
      guard let leg = getLeg() else {
        return nil
      }
      return Artwork(
        title: "Start",
        locationName: "",
        discipline: "",
        coordinate: CLLocationCoordinate2D(latitude: (leg.startLocation?.lat)!, longitude: (leg.startLocation?.lng)!),
        type: .start,
        rotate: 0,
        runTime: 0,
        zPosition: CGFloat(1)
      )
    }
    set {}
  }
  var endPoint: Artwork? {
    get {
      guard let leg = getLeg() else {
        return nil
      }
      return Artwork(
        title: "End",
        locationName: "",
        discipline: "",
        coordinate: CLLocationCoordinate2D(latitude: (leg.endLocation?.lat)!, longitude: (leg.endLocation?.lng)!),
        type: .stop,
        rotate: 0,
        runTime: 0,
        zPosition: CGFloat(1)
      )
    }
    set {}
  }
  var runPathPolyline: [Artwork] {
    get {
      guard let leg = getLeg() else {
        return []
      }
      var newRunPolyline: [Artwork] = []
      for step in leg.steps! {
        let sourcePoint = CLLocationCoordinate2DMake(CLLocationDegrees((step.startLocation?.lat)!), CLLocationDegrees((step.startLocation?.lng)!))
        let destinationPoint = CLLocationCoordinate2DMake(CLLocationDegrees((step.endLocation?.lat)!), CLLocationDegrees((step.endLocation?.lng)!))
        let rotate = Utils.directionBetweenPoints(sourcePoint: sourcePoint, destinationPoint)
        var scaleDistance: Int = Utils.getPointDistance(distance: (step.distance?.value)!)
        scaleDistance = scaleDistance == 0 ? 1 : scaleDistance
        for index in 0...scaleDistance {
          let newCoordinate = Utils.getPointLocation(start: sourcePoint, end: destinationPoint, pointDistance: Double(scaleDistance), pointClass: Double(index))
          let newRunTime = Utils.getPointDurationTime(durationTime: (step.duration?.value)!, pointDistance: Double(scaleDistance))
          newRunPolyline.append(
            Artwork(
              title: "my car",
              locationName: "",
              discipline: "",
              coordinate: newCoordinate,
              type: .car,
              rotate: rotate,
              runTime: Float(newRunTime),
              zPosition: CGFloat(10)
            )
          )
        }
      }
      return newRunPolyline
    }
    set {}
  }
  var polyline: MKOverlay? {
    get {
      guard let leg = getLeg() else {
        return nil
      }
      var coords = leg.steps.map { steps in
        return steps.map { step in
          return CLLocationCoordinate2DMake(CLLocationDegrees((step.startLocation?.lat)!), CLLocationDegrees((step.startLocation?.lng)!))
        }
      }
      coords?.append((self.endPoint?.coordinate)!)
      
      let myPolyline = MKPolyline(coordinates: coords!, count: (coords?.count)!)
      return myPolyline
    }
    set {}
  }
  
  func loadRoutes() {
    let request = DirectionRequest(origin: origin.value, destination: destination.value)
    _ = APIClient.rx_request(request: request).subscribe(onNext: {[weak self] response in
      if response.status == "REQUEST_DENIED" {
        // Error
      }
      if response.status == "OK" {
        self?.routes.accept(response.response)
      }
      }, onError: nil, onCompleted: nil, onDisposed: nil)
  }
  
  func getLeg() -> Leg? {
    if self.routes.value.count == 0 {
      return nil
    }
    guard let leg = routes.value[0].legs?[0] else {
      return nil
    }
    return leg
  }
  
  func updatePosition() {
    
    if self.runPathPolyline.count > 0 {
      let step = 1
      guard self.annotationPosition.value + step < self.runPathPolyline.count
        else { return }
      
      let nextStep = self.runPathPolyline[self.annotationPosition.value + step]
      self.annotationPosition.accept(self.annotationPosition.value + step)
      let endLocation = CLLocation(latitude: CLLocationDegrees(nextStep.coordinate.latitude), longitude: CLLocationDegrees(nextStep.coordinate.longitude))
      if Utils.getDistanceLocation(start: self.centerLocation.value, end: endLocation) > AppConstant.updateCenterLength {
        self.centerLocation.accept(endLocation)
      }
      let nextMapPoint = self.runPathPolyline[self.annotationPosition.value]
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(nextMapPoint.runTime / AppConstant.replaySpeed)) {
        self.updatePosition()
      }
    }
  }
  
  func resetPosition() {
    self.annotationPosition.accept(0)
  }
}
