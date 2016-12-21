//
//  InformationPostingViewController.swift
//  OntheMap
//
//  Created by Venkat Kurapati on 19/12/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import UIKit
import MapKit
class InformationPostingViewController: UIViewController {
    
    var studentLocation: StudentLocation?
    var address:String?
    var coordinates:CLLocationCoordinate2D?
    var studentLocations: [StudentLocation] = [StudentLocation]()
    var isStudentPostedAlready: Bool?
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var userEnteredTextView: UITextView!
    @IBOutlet weak var findTheMapButton: UIButton!
    
    @IBOutlet weak var shareTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.shareTextView.isHidden = true
        self.mapView.isHidden = true
        self.submitButton.isHidden = true
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Find on the MaP
    @IBAction func findTheMapAction(_ sender: Any) {
        
        if userEnteredTextView.text.isEmpty  {
            showAlertMessage("Inofrmation Posting", "Please enter the address.")
        }else{
            address = userEnteredTextView.text
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    self.showAlertMessage("Error", (error?.localizedDescription)!)
                }
                if let placemark = placemarks?.first {
                    self.coordinates = placemark.location!.coordinate
                    self.displayPinOntheMap(self.coordinates!)
                }
            })
        }
        //let address = "1 Infinite Loop, CA, USA"
        
    }
    //MARK:- Cancel the view
    @IBAction func cancelPosting(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //MARK:- Display Pin on the Map
    func displayPinOntheMap(_ coordinates:CLLocationCoordinate2D){
        self.promptLabel.isHidden = true
        self.userEnteredTextView.isHidden = true
        self.findTheMapButton.isHidden = true
        
        self.shareTextView.isHidden = false
        self.mapView.isHidden = false
        self.submitButton.isHidden = false
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        self.mapView.addAnnotation(annotation)
    }
    //MARK:- Post the Student Location
    @IBAction func submitLocation(_ sender: Any) {
        if shareTextView.text.isEmpty {
            showAlertMessage("Inofrmation Posting", "Please enter the share Link")
        }else{
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            self.studentLocation = StudentLocation.init(dictionary: [:])
            self.studentLocation!.firstName = "Venkat"
            self.studentLocation!.lastName = "Kurapati"
            self.studentLocation!.mapString = address
            self.studentLocation!.latitude = coordinates?.latitude
            self.studentLocation!.longitude = coordinates?.longitude
            self.studentLocation!.mediaURL = self.shareTextView.text
            self.studentLocations = appDelegate.studentLocations
            for studentLocation in self.studentLocations{
                //Check for student is alreayd posted or not?
                if studentLocation.uniqueKey == appDelegate.udacityUserId {
                    isStudentPostedAlready = true
                    appDelegate.udacityUserObjectId = studentLocation.objectId
                }
            }
            if isStudentPostedAlready! {
                StudentLocationClient.sharedInstance().updateToStudentLocation(self.studentLocation!){ (objectId, error) in
                    /* GUARD: Was there an error? */
                    guard (error == nil) else {
                        self.showAlertMessage(UdacityClient.UdacityConstans.ErrorMessages.InformationPosting, "\(error!.userInfo[NSLocalizedDescriptionKey] as! String)")
                        return
                    }
                    self.dismiss(animated: true, completion: nil)

                }
            }else{
                StudentLocationClient.sharedInstance().postToStudentLocation(self.studentLocation!){ (updatedAt, error) in
                    /* GUARD: Was there an error? */
                    guard (error == nil) else {
                        self.showAlertMessage(UdacityClient.UdacityConstans.ErrorMessages.InformationPosting, "\(error!.userInfo[NSLocalizedDescriptionKey] as! String)")
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    func showAlertMessage(_ title:String, _ message:String) {
        let alertConroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertConroller.addAction(UIAlertAction(title:"OK",style : .default){ action in
            alertConroller.dismiss(animated: true, completion: nil)
        })
        self.present(alertConroller, animated: true, completion: nil)
    }
}
