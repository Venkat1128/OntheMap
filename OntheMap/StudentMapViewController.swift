//
//  StudentMapViewController.swift
//  OntheMap
//
//  Created by Venkat Kurapati on 16/12/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import UIKit
import MapKit
class StudentMapViewController: UIViewController, MKMapViewDelegate {

    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!
    // MARK: Properties
    var studentLocations: [StudentLocation] = [StudentLocation]()
    var annotations = [MKPointAnnotation]()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getStudentLocations()
    }
    
    //MARK:- Get Student Locations
    func getStudentLocations(){
        StudentLocationClient.sharedInstance().getStudentLocations{ (studentLocations, error) in
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                 self.addAnnotations()
                performUIUpdatesOnMain {
                    // When the array is complete, we add the annotations to the map.
                    if (self.annotations.count > 0){
                        self.mapView.addAnnotations(self.annotations)
                    }
                    self.view.setNeedsDisplay()
                }
            }
            else {
                print(error!)
            }
        }
    }
    //MARK:- Add Annotations to Mapview
    func addAnnotations(){
        // The "locations" array is an array of dictionary objects that are similar to the JSON
        // data that you can download from parse.
        let locations = self.studentLocations
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for studentLocation in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            if (studentLocation.latitude != nil && studentLocation.latitude != nil)  {
                let lat = CLLocationDegrees((studentLocation.latitude)!)
                let long = CLLocationDegrees((studentLocation.longitude)!)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                if studentLocation.firstName != nil && studentLocation.lastName != nil && studentLocation.mediaURL != nil  {
                    annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
                    annotation.subtitle = studentLocation.mediaURL
                }
                // Finally we place the annotation in an array of annotations.
                self.annotations.append(annotation)
            }
           
        }
    }

    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            let toOpen = view.annotation?.subtitle!
            if (toOpen?.isEmpty)! {
                app.open(URL(string: toOpen!)!, options: [:], completionHandler: nil)

            }
        }
    }
    @IBAction func logoutAction(_ sender: Any) {
        
    }
    @IBAction func refreshStudentLocation(_ sender: Any) {
        self.getStudentLocations()
    }
    @IBAction func postLocation(_ sender: Any) {
    }
  
}
