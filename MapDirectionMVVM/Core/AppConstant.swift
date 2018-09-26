//
//  AppConstant.swift
//  MapDirectionMVVM
//
//  Created by duy on 9/19/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation
import MapKit

class AppConstant {
//    static let BaseUrl = "https://maps.googleapis.com/maps/api/directions/json"
  static let BaseUrl = "http://localhost:3000/"
  static let ApiKey = "AIzaSyDI149vbv73cdxHJXytpvBXcFxBQWT-GQ4"
  static let replaySpeed: Float = 100
  static let regionRadius: CLLocationDistance = 10000
  static let maxLeng: Int = 150
  static let defaultMapCenter: CLLocation = CLLocation(latitude: CLLocationDegrees(21.0367839), longitude: CLLocationDegrees(105.832456))
  static let updateCenterLength: Double = 1500
}
