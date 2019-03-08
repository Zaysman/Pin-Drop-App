//
//  ViewController.swift
//  Pin-Drop-App
//
//  Created by Isaiah X Smith on 3/7/19.
//  Copyright © 2019 Isaiah X Smith. All rights reserved.
//

import UIKit
import MapKit //This imports what we need so the MKMapView can work

class ViewController: UIViewController {
    var pins: [Pin] = [] //declares an array that holds Pin values
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) { //This function is called when the app sense a long press from the user.
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        addPin(at: coordinate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        loadPins()
    }
    
    func addPin(at coordinate: CLLocationCoordinate2D) {
        let alert = UIAlertController(title: "New Pin", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Caption"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            guard let textFields = alert.textFields else { return }
            let name = textFields[0].text ?? ""
            let caption = textFields[1].text ?? ""
            
            let pin = Pin(name: name, caption: caption, latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            self.add(pin: pin)
            self.mapView.addAnnotation(pin)
            
        }
        alert.addAction(saveAction)
        self.present(alert, animated: true)
    }
    
    func add(pin: Pin) {
        pins.append(pin) //appends the added pin to the array.
        Pin.save(pins: pins)
    }
    
    func loadPins() {
        if let pins = Pin.loadPins() {
            self.pins = pins
            mapView.addAnnotation(pins as! MKAnnotation)
        }
    }
}
    
    extension ViewController: MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "pin"
            
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)   {
                annotationView.annotation = annotation
                return annotationView
            }
            return nil
        }
}
