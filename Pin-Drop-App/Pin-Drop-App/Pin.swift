//
//  Pin.swift
//  Pin-Drop-App
//
//  Created by Isaiah X Smith on 3/7/19.
//  Copyright © 2019 Isaiah X Smith. All rights reserved.
//

import Foundation //Basic pieces of code needed to make programs
import MapKit

class Pin:NSObject, Codable { //Codable is a protocal that makes it easy to encode and decode things
    let name: String
    let caption: String
    let latitude: Double
    let longitude: Double
    
    init(name: String, caption: String, latitude: Double, longitude: Double) {
        self.name = name
        self.caption = caption
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
    
}
    
extension Pin {
    static let pinsKey = "pins"
    
    static func save(pins: [Pin]) { //everytime we save a pin, we want to save them to user defaults
        let data = try? JSONEncoder().encode(pins) //function that cßan throw and arrow and it will be ignored
        UserDefaults.standard.set(data, forKey: pinsKey)
    }
    
    static func loadPins() -> [Pin]? { //The question mark means that the return type is optional
        if let data = UserDefaults.standard.value(forKey: pinsKey) as? Data {
            let pins = try? JSONDecoder().decode([Pin].self, from: data)
            return pins
        }
        return nil
    }
}


extension Pin: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
   public var title: String? {
        return name
    }
    
    public var subtitle: String? {
        return caption
    }
    
}
