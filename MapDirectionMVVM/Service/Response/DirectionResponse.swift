//
//  DirectionResponse.swift
//  MapDirectionMVVM
//
//  Created by duy on 9/19/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation
import ObjectMapper

class DirectionResponse : BaseResponse {
  var response : [DirectionModel] = []
  required init?(map: Map) {
    super.init(map: map)
  }
  override func mapping(map: Map) {
    super.mapping(map: map)
    response <- map["routes"]
  }
}
