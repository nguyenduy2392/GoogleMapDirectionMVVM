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
  static let ApiKey = "AIzaSyDUU4NdnU3IkA633DIFduqkzpZzBM1zQVk"
  static let replaySpeed: Float = 100
  static let regionRadius: CLLocationDistance = 10000
  static let maxLeng: Int = 3
  static let defaultMapCenter: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.0367839, longitude: 105.832456)
  static let updateCenterLength: Double = 1500
  static let zoom: Int = 18
  static let speed: [Int] = [1, 10, 100, 1000]
}
