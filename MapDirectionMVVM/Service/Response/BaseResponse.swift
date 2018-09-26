//
//  BaseResponse.swift
//  MapDirectionMVVM
//
//  Created by duy on 9/19/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponse: Mappable {
  var status : String? = ""
  var error : String? = ""
  required init?(map: Map) {}
  func mapping(map: Map) {
    status <- map["status"]
    error <- map["error_message"]
  }
}
