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
    var myActivityIndicator: UIActivityIndicatorView!
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = true
         parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        let mapImage   = UIImage(named: StudentLocationClient.NavIcons.MAP_ICON)!
        let refreshImage = UIImage(named: StudentLocationClient.NavIcons.REFRESH_ICON)!
        let mapButton   = UIBarButtonItem(image: mapImage,  style: .plain, target: self, action: #selector(StudentMapViewController.postLocation(_:)))
        let refreshButton = UIBarButtonItem(image: refreshImage,  style: .plain, target: self, action: #selector(StudentMapViewController.refreshStudentLocation(_:)))
        
        parent!.navigationItem.rightBarButtonItems = [refreshButton, mapButton]
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
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.studentLocations = self.studentLocations
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
                    annotation.title = "\(studentLocation.firstName!) \(studentLocation.lastName!)"
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
            if (!(toOpen?.isEmpty)!) {
                if let url = URL(string: toOpen!){
                    app.open((url), options: [:], completionHandler: nil)
                }else{
                    showAlertMessage("On the Map", "Media url is not valid!")
                }
            }
        }
    }
    //MARK:- Logout
    func logout() {
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        UdacityClient.sharedInstance().deleteUdacitySession{ (session, error) in
            self.myActivityIndicator.stopAnimating()
            if  error == nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    //MARK:- Refresh Student location
    func refreshStudentLocation(_ sender: Any) {
        self.getStudentLocations()
    }
    //MARK:- Present Information View
    func postLocation(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "InofrmationNavView") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    func showAlertMessage(_ title:String, _ message:String) {
        let alertConroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertConroller.addAction(UIAlertAction(title:"OK",style : .default){ action in
            alertConroller.dismiss(animated: true, completion: nil)
        })
        self.present(alertConroller, animated: true, completion: nil)
    }
}
