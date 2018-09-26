//
//  RunPolyline.swift
//  MapDirectionMVVM
//
//  Created by duy on 9/24/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation
import MapKit

class RunPolyline {
  let coordinate: CLLocationCoordinate2D
  let runtime: Float
  
  init (coordinate: CLLocationCoordinate2D, runtime: Float) {
    self.coordinate = coordinate
    self.runtime = runtime
  }
}
