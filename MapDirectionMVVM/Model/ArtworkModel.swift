//
//  ArtworkModel.swift
//  MapDirectionMVVM
//
//  Created by duy on 9/19/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Artwork: NSObject, MKAnnotation {
  let title: String?
  let locationName: String
  let discipline: String
  var coordinate: CLLocationCoordinate2D
  var type: AttractionType
  var rotate: CLLocationDirection
  var runTime: Float = 0
  var zPosition: CGFloat = 1
  
  init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, type: AttractionType, rotate: CLLocationDirection, runTime: Float, zPosition: CGFloat) {
    self.title = title
    self.locationName = locationName
    self.discipline = discipline
    self.coordinate = coordinate
    self.type = type
    self.rotate = rotate
    self.runTime = runTime
    self.zPosition = zPosition
    
    super.init()
  }
  
  var subtitle: String? {
    return locationName
  }
  
  func mapItem() -> MKMapItem {
    let addressDict = [CNPostalAddressStreetKey: subtitle!]
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = title
    return mapItem
  }
}

enum AttractionType: Int {
  case start = 0
  case stop
  case car
  
  func image() -> UIImage {
    switch self {
    case .start:
      return  #imageLiteral(resourceName: "start1").resizeImage(newWidth: 20.0)
    case .stop:
      return #imageLiteral(resourceName: "stop1").resizeImage(newWidth: 20.0)
    case .car:
      return  #imageLiteral(resourceName: "car1").resizeImage(newWidth: 30.0)
    }
  }
}
