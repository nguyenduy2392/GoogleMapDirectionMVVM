//
//  Utils.swift
//  MapDirectionMVVM
//
//  Created by duy on 9/19/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Utils {
  static func convertParameterToData(_ parameters: [String: AnyObject], encode: String.Encoding = .utf8) -> Data {
    let data = parameters.stringFromHttpParameters().data(using: encode, allowLossyConversion: false)
    return data ?? Data()
  }
  
  static func directionBetweenPoints(sourcePoint: CLLocationCoordinate2D, _ destinationPoint: CLLocationCoordinate2D) -> CLLocationDirection {
    let pointX = destinationPoint.latitude - sourcePoint.latitude
    let pointY = destinationPoint.longitude - sourcePoint.longitude
    let degrees = radiansToDegrees(radians: atan2(pointY, pointX))
    let rotate = Int(degrees) % 360
    return CLLocationDirection(rotate)
  }
  
  static func radiansToDegrees(radians: Double) -> Double {
    return radians * 180 / Double.pi
  }
  
  static func degreesToRadians(degrees: Double) -> Double {
    return degrees * Double.pi / 180
  }
  
  static func getPointDistance(distance: Int) -> Int {
    return distance / AppConstant.maxLeng
  }
  
  static func getPointLocation(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, pointDistance: Double, pointClass: Double) -> CLLocationCoordinate2D {
    let subLat = (start.latitude - end.latitude) * pointClass / pointDistance
    let subLng = (start.longitude - end.longitude) * pointClass / pointDistance
    let lat = start.latitude - subLat
    let lng = start.longitude - subLng
    return CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(lng))
  }
  
  static func getPointDurationTime(durationTime: Int, pointDistance: Double) -> Double {
    return Double(durationTime) / pointDistance
  }
  
  static func getDistanceLocation(start: CLLocation, end: CLLocation) -> Double {
    return start.distance(from: end)
  }
}

extension Dictionary {
  public func stringFromHttpParameters() -> String {
    let parameterArray = self.map { (key, value) -> String in
      guard let keyString = key as? String, let percentEscapedKey = keyString.stringByAddingPercentEncodingForURLQueryValue() else { return "" }
      guard let valueString = value as? String, let percentEscapedValue = valueString.stringByAddingPercentEncodingForURLQueryValue() else { return "" }
      return "\(percentEscapedKey)=\(percentEscapedValue)"
    }
    return parameterArray.joined(separator: "&")
  }
}

extension String {
  public func stringByAddingPercentEncodingForURLQueryValue() -> String? {
    let characterSet = NSMutableCharacterSet.alphanumeric()
    characterSet.addCharacters(in: "-._~")
    return self.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)
  }
}

extension UIImage {
  func resizeImage(newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / self.size.width
    let newHeight = self.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
}
