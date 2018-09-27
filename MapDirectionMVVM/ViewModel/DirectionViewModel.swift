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
import GoogleMaps

class DirectionViewModel {
  var request: Int = 0
  var routes: BehaviorRelay<[DirectionModel]> = BehaviorRelay(value: [])
  var origin: BehaviorRelay<String> = BehaviorRelay(value: "")
  var destination: BehaviorRelay<String> = BehaviorRelay(value: "")
  var annotationPosition: BehaviorRelay<Int> = BehaviorRelay(value: 0)
  var playStatus: BehaviorRelay<Bool> = BehaviorRelay(value: false)
  var playSpeed: BehaviorRelay<Int> = BehaviorRelay(value: 1)
  var startTimePlay: DispatchTime?
  //  var centerLocation: BehaviorRelay<CLLocation> = BehaviorRelay(value: AppConstant.defaultMapCenter)
  var locationPoints: [Artwork]?
  var polylinePoints: GMSPath? {
    get {
      if self.routes.value.count == 0 {
        return nil
      }
      guard let points = routes.value[0].overviewPolyline?.points else {
        return nil
      }
      return GMSPath(fromEncodedPath: points)
    }
    set {}
  }
  var currentPoint: Artwork? {
    get {
      guard let leg = getLeg() else {
        return nil
      }
      return Artwork(
        title: "my car",
        locationName: "",
        discipline: "",
        coordinate: CLLocationCoordinate2D(latitude: (leg.startLocation?.lat)!, longitude: (leg.startLocation?.lng)!),
        type: .car,
        rotate: 0,
        runTime: 0,
        speed: 0,
        zPosition: CGFloat(1)
      )
    }
    set {}
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
        speed: 0,
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
        speed: 0,
        zPosition: CGFloat(1)
      )
    }
    set {}
  }
  
  init() {
    _ = self.routes
      .asObservable()
      .subscribe(onNext: {[weak self] routes in
        self?.locationPoints = self?.renderLocationPoints(routes: routes)
      })
    _ = self.playStatus
      .asObservable()
      .subscribe(onNext: {[weak self] status in
        if status {
          self?.setRunTime()
          self?.updatePosition(index: (self?.annotationPosition.value)!)
        }
      })
    _ = self.annotationPosition
      .asObservable()
      .subscribe(onNext: {[weak self] annotationPosition in
        if annotationPosition + 1 == (self?.locationPoints!.count)! {
          self?.playStatus.accept(false)
        }
      })
  }
  
  func loadRoutes(origin: String, destination: String) {
    let request = DirectionRequest(origin: origin, destination: destination)
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
  
  func setRunTime() {
    self.startTimePlay = .now()
  }
  
  func updatePosition(index: Int) {
    if !self.playStatus.value {
      return
    }
    if (self.locationPoints?.count)! > 0 {
      let step = 1
      
      self.annotationPosition.accept(index)
      guard index + step < (self.locationPoints?.count)! else {
        return
      }
      let currentPoint = self.locationPoints?[index]
      self.startTimePlay = self.startTimePlay! + Double((currentPoint?.runTime)! / Float(AppConstant.speed[self.playSpeed.value - 1]))
      DispatchQueue.main.asyncAfter(deadline: self.startTimePlay!) {
        self.updatePosition(index: index + 1)
      }
    }
  }
  
  func resetPosition() {
    self.annotationPosition.accept(0)
  }
  
  func renderLocationPoints(routes: [DirectionModel]) -> [Artwork] {
    if routes.count == 0 {
      return []
    }
    guard let leg = getLeg() else {
      return []
    }
    
    var newRunPolyline: [Artwork] = []
    var stepIndex = 0
    for step in leg.steps! {
      guard let points = step.polyline?.points  else {
        return []
      }
      let pointsLocation = GMSPath(fromEncodedPath: points)
      guard let locationCount = pointsLocation?.count() else {
        return []
      }
      for index in 0...Int(locationCount) {
        var rotate: Double = 0
        var distance: Double = 0
        var scaleDistance: Int = 1
        if index + 1 < Int(locationCount) {
          let currentLocation = pointsLocation?.coordinate(at: UInt(index))
          let nextLocation = pointsLocation?.coordinate(at: UInt(index + 1))
          
          // rotate
          rotate = Utils.directionBetweenPoints(sourcePoint: currentLocation!, nextLocation!)
          
          // add multi location
          let sourcePoint = CLLocation(latitude: (currentLocation?.latitude)!, longitude: (currentLocation?.longitude)!)
          let destinationPoint = CLLocation(latitude: (nextLocation?.latitude)!, longitude: (nextLocation?.longitude)!)
          distance = sourcePoint.distance(from: destinationPoint)
          scaleDistance = Utils.getPointDistance(distance: Int(distance))
          scaleDistance = scaleDistance == 0 ? 1 : scaleDistance
          let startScale = stepIndex == 0 ? 0 : 1
          for scaleIndex in startScale...scaleDistance {
            let newCoordinate = Utils.getPointLocation(start: currentLocation!, end: nextLocation!, pointDistance: Double(scaleDistance), pointClass: Double(scaleIndex))
            let time = Double((step.duration?.value)!) * distance / Double((step.distance?.value)!)
            let newRunTime = Utils.getPointDurationTime(durationTime: time, pointDistance: Double(scaleDistance))
            newRunPolyline.append(
              Artwork(
                title: "my car",
                locationName: "",
                discipline: "",
                coordinate: newCoordinate,
                type: .car,
                rotate: rotate,
                runTime: Float(newRunTime),
                speed: Utils.getSpeed(distance: (step.distance?.value)!, duration: (step.duration?.value)!),
                zPosition: CGFloat(10)
              )
            )
          }
        }
      }
      stepIndex += 1
    }
    
    return newRunPolyline
  }
  
  func runHistory() {
    self.playStatus.accept(!self.playStatus.value)
  }
  
  func changeSpeed() {
    let speed = self.playSpeed.value
    if speed + 1 > 4 {
      self.playSpeed.accept(1)
    } else {
      self.playSpeed.accept(speed + 1)
    }
  }
  
  func selectRoutes() {
    self.routes.accept([])
    self.annotationPosition.accept(0)
    print(self.request)
    if self.request == 0 {
      self.loadRoutes(origin: "1", destination: "2")
      self.request += 1
    } else {
      self.loadRoutes(origin: "2", destination: "1")
      self.request -= 1
    }
  }
}
