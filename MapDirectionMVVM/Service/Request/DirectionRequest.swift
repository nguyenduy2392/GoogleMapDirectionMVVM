//
//  DirectionRequest.swift
//  MapDirectionMVVM
//
//  Created by duy on 9/19/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class DirectionRequest: Request {
  init(origin: String, destination: String) {
    self.origin = origin
    self.destination = destination
  }
  typealias BaseResponse = DirectionResponse
  
  var origin: String
  var destination: String
  
  var headerFields: [String : String] {
    return [:]
  }
  var method: HTTPMethod {
    return .get
  }
  var params: [String : AnyObject] {
    return [:]
  }
  var path: String {
    //    return "?key=\(AppConstant.ApiKey)&origin=\(origin)&destination=\(destination)"
    return "direction\(origin)to\(destination)"
  }
  var timeout: TimeInterval {
    return 10
  }
}
