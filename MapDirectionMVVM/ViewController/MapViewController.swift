//
//  MapViewController.swift
//  MapDirectionMVVM
//
//  Created by duy on 9/19/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import GoogleMaps

class MapViewController: UIViewController {
  
  @IBOutlet weak var originTextField: UITextField!
  @IBOutlet weak var destinationTextField: UITextField!
  let directionViewModel = DirectionViewModel()
  var myLocation: GMSMarker!
  let disposeBag = DisposeBag()
  @IBOutlet weak var googleMapView: GMSMapView!
  @IBOutlet weak var runButton: UIButton!
  @IBOutlet weak var speedButton: UIButton!
  @IBOutlet weak var speedLable: UILabel!
  @IBOutlet weak var directionButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.googleMapView.animate(toZoom: 18)
    self.directionButton.layer.zPosition = 10;
    
    bindingViewModel()
  }
  
  func bindingViewModel() {
    directionViewModel.routes
      .asObservable()
      .filter({$0.count > 0})
      .subscribe(onNext: {[weak self] routes in
        if routes.count == 0 {
          self?.directionButton.layer.zPosition = 10;
        } else {
          self?.directionButton.layer.zPosition = 0;
        }
        // make Routes
        let polyline = GMSPolyline(path: self?.directionViewModel.polylinePoints)
        polyline.strokeColor = self?.directionViewModel.request == 1 ? .blue : .red
        polyline.strokeWidth = 3
        polyline.map = self?.googleMapView
        
        // create Maker
        let startMaker = self?.createMaker(point: (self?.directionViewModel.startPoint)!)
        startMaker?.map = self?.googleMapView
        
        let stopMaker = self?.createMaker(point: (self?.directionViewModel.endPoint)!)
        stopMaker?.map = self?.googleMapView
        
        if ((self?.myLocation) != nil) {
          self?.myLocation.map = nil
        }
        self?.myLocation = self?.createMaker(point: (self?.directionViewModel.currentPoint)!)
        self?.myLocation.map = self?.googleMapView
        self?.googleMapView.animate(toLocation: (self?.myLocation.position)!)
      }).disposed(by: disposeBag)
    
    directionViewModel.annotationPosition
      .asObservable()
      .subscribe(onNext: {[weak self] annotationPosition in
        if (self?.directionViewModel.locationPoints!.count)! > 0 {
          if annotationPosition + 1 == (self?.directionViewModel.locationPoints!.count)! {
            self?.directionButton.layer.zPosition = 10;
          }
          let newPoint = self?.directionViewModel.locationPoints![annotationPosition]
          self?.myLocation.rotation = newPoint!.rotate
          self?.myLocation.position = newPoint!.coordinate
//          self?.googleMapView.moveCamera(GMSCameraUpdate.setTarget(newPoint!.coordinate))
          self?.googleMapView.animate(toLocation: (self?.myLocation.position)!)
          self?.myLocation.map = self?.googleMapView
          self?.speedLable.text = "\(String(describing: newPoint!.speed)) km/h"
        }
      }).disposed(by: disposeBag)
    
    directionViewModel.playStatus
      .asObservable()
      .subscribe(onNext: {[weak self] status in
        if status {
          self?.runButton.setTitle("Stop", for: .normal)
        } else {
          self?.runButton.setTitle("Play", for: .normal)
        }
      }).disposed(by: disposeBag)
    
    directionViewModel.playSpeed
      .asObservable()
      .subscribe(onNext: {[weak self] speed in
          self?.speedButton.setTitle("\(speed)x", for: .normal)
      }).disposed(by: disposeBag)
  }
  
  func createMaker(point: Artwork) -> GMSMarker {
    let marker = GMSMarker()
    marker.position = point.coordinate
    marker.title = point.title
    marker.snippet = point.locationName
    marker.icon = point.type.image()
    marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
    return marker
  }
  
  @IBAction func runButtonTouchUp(_ sender: Any) {
    self.directionViewModel.runHistory()
  }
  
  @IBAction func changeSpeedButtonTouchUp(_ sender: Any) {
    self.directionViewModel.changeSpeed()
  }
  @IBAction func directionButtonTouchUp(_ sender: Any) {
    self.directionViewModel.selectRoutes()
  }
}
