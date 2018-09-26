//
//  DirectionModel.swift
//  MapDirectionMVVM
//
//  Created by duy on 9/19/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation
import ObjectMapper

protocol DirectionResponseModelPresentable {
  var geocodedWaypoints: [GeocodedWaypoint]? { get }
  var routes: [DirectionModel]? {get}
  var status : String? {get}
}

struct DirectionResponseModel: Mappable, DirectionResponseModelPresentable {
  var geocodedWaypoints: [GeocodedWaypoint]?
  var routes: [DirectionModel]?
  var status: String?
  
  init() {
    self.geocodedWaypoints = [GeocodedWaypoint()]
    self.routes = [DirectionModel()]
    self.status = ""
  }
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    geocodedWaypoints <- map["geocoded_waypoints"]
    routes <- map["routes"]
    status <- map["status"]
  }
}

protocol GeocodedWaypointPresentable {
  var geocoderStatus: String? { get }
  var placeID: String? {get}
  var types: [String]? {get}
}

struct GeocodedWaypoint: Mappable, GeocodedWaypointPresentable {
  
  var geocoderStatus: String?
  var placeID: String?
  var types: [String]?
  init() {
    self.geocoderStatus = ""
    self.placeID = ""
    self.types = [""]
  }
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    geocoderStatus <- map["geocoder_status"]
    placeID <- map["place_id"]
    types <- map["types"]
  }
}

protocol DirectionModelPresentable {
  var bounds: Bounds? { get }
  var copyrights: String? { get }
  var legs: [Leg]? { get }
  var overviewPolyline: Polyline? { get }
  var summary: String? { get }
}

struct DirectionModel: Mappable, DirectionModelPresentable {
  var bounds: Bounds?
  var copyrights: String?
  var legs: [Leg]?
  var overviewPolyline: Polyline?
  var summary: String?
  
  init() {
    self.bounds = Bounds()
    self.copyrights = ""
    self.legs = [Leg()]
    self.overviewPolyline = Polyline()
    self.summary = ""
  }
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    bounds <- map["bounds"]
    copyrights <- map["copyrights"]
    legs <- map["legs"]
    overviewPolyline <- map["overview_polyline"]
    summary <- map["summary"]
  }
}

protocol BoundsPresentable {
  var northeast: Northeast? { get }
  var southwest: Northeast? { get }
}

struct Bounds: Mappable, BoundsPresentable {
  var northeast: Northeast?
  var southwest: Northeast?
  
  init() {
    self.northeast = Northeast()
    self.southwest = Northeast()
  }
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    northeast <- map["northeast"]
    southwest <- map["southwest"]
  }
}

protocol NortheastPresentable {
  var lat: Double? { get }
  var lng: Double? { get }
}

struct Northeast: Mappable, NortheastPresentable {
  var lat: Double?
  var lng: Double?
  
  init() {
    self.lat = Double(0)
    self.lng = Double(0)
  }
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    lat <- map["lat"]
    lng <- map["lng"]
  }
}

protocol LegPresentable {
  var distance: Distance? { get }
  var duration: Distance? { get }
  var endAddress: String? { get }
  var endLocation: Northeast? { get }
  var startAddress: String? { get }
  var startLocation: Northeast? { get }
  var steps: [Step]? { get }
}

struct Leg: Mappable, LegPresentable {
  var distance: Distance?
  var duration: Distance?
  var endAddress: String?
  var endLocation: Northeast?
  var startAddress: String?
  var startLocation: Northeast?
  var steps: [Step]?
  
  init() {
    self.distance = Distance()
    self.duration = Distance()
    self.endAddress = ""
    self.endLocation = Northeast()
    self.startAddress = ""
    self.startLocation = Northeast()
    self.steps = [Step()]
  }
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    distance <- map["distance"]
    duration <- map["duration"]
    endAddress <- map["end_address"]
    endLocation <- map["end_location"]
    startAddress <- map["start_address"]
    startLocation <- map["start_location"]
    steps <- map["steps"]
  }
}

protocol DistancePresentable {
  var text: String? { get }
  var value: Int? { get }
}

struct Distance: Mappable, DistancePresentable {
  var text: String?
  var value: Int?
  
  init() {
    self.text = ""
    self.value = 0
  }
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    text <- map["text"]
    value <- map["value"]
  }
}

protocol StepPresentable {
  var distance: Distance? { get }
  var duration: Distance? { get }
  var endLocation: Northeast? { get }
  var htmlInstructions: String? { get }
  var polyline: Polyline? { get }
  var startLocation: Northeast? { get }
  var maneuver: String? { get }
}

struct Step: Mappable, StepPresentable {
  var distance: Distance?
  var duration: Distance?
  var endLocation: Northeast?
  var htmlInstructions: String?
  var polyline: Polyline?
  var startLocation: Northeast?
  var maneuver: String?
  
  init() {
    self.distance = Distance()
    self.duration = Distance()
    self.endLocation = Northeast()
    self.htmlInstructions = ""
    self.polyline = Polyline()
    self.startLocation = Northeast()
    self.maneuver = ""
  }
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    distance <- map["distance"]
    duration <- map["duration"]
    endLocation <- map["end_location"]
    htmlInstructions <- map["html_instructions"]
    polyline <- map["polyline"]
    startLocation <- map["start_location"]
    maneuver <- map["maneuver"]
  }
}

protocol PolylinePresentable {
  var points: String? { get }
}

struct Polyline: Mappable, PolylinePresentable {
  var points: String?
  
  init() {
    self.points = ""
  }
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    points <- map["points"]
  }
}
