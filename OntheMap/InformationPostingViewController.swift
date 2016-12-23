//
//  InformationPostingViewController.swift
//  OntheMap
//
//  Created by Venkat Kurapati on 19/12/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import UIKit
import MapKit
class InformationPostingViewController: UIViewController , MKMapViewDelegate ,UITextViewDelegate{
    
    var studentLocation: StudentLocation?
    var address:String?
    var coordinates:CLLocationCoordinate2D?
    var isStudentPostedAlready: Bool!
    var firstName: String!
    var lastName: String!
    var myActivityIndicator: UIActivityIndicatorView!
    var studentLocationModel: StudentLocations!
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var userEnteredTextView: UITextView!
    @IBOutlet weak var findTheMapButton: UIButton!
    @IBOutlet weak var shareTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //shared instance of model class
        self.studentLocationModel = StudentLocations.sharedInstance()
        mapView.delegate = self
        userEnteredTextView.delegate = self
        shareTextView.delegate = self
        self.myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        // Position Activity Indicator in the center of the main view
        self.myActivityIndicator.center = view.center
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        self.myActivityIndicator.hidesWhenStopped = true
        view.addSubview(self.myActivityIndicator)
        self.shareTextView.isHidden = true
        self.mapView.isHidden = true
        self.submitButton.isHidden = true
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        fetchUdacityUserProfile()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            view.endEditing(true)
            return false
        }
        else
        {
            return true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchUdacityUserProfile() {
        UdacityClient.sharedInstance().getPublicUserData{ (user, error) in
            if  error == nil {
                
                self.firstName = user?.first_name!
                self.lastName = user?.last_name!
            }
        }
    }
    //MARK:- Find on the MaP
    @IBAction func findTheMapAction(_ sender: Any) {
        if userEnteredTextView.text.isEmpty  {
            showAlertMessage("Inofrmation Posting", "Please enter the address.")
        }else{
            DispatchQueue.main.async{
                self.myActivityIndicator.startAnimating()
            }
            address = userEnteredTextView.text
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
                DispatchQueue.main.async{
                    self.myActivityIndicator.stopAnimating()
                }
                if((error) != nil){
                    self.showAlertMessage(StudentLocationClient.ErrorMessages.OntheMapError, StudentLocationClient.ErrorMessages.UnabletoFindtheMap)
                }
                if let placemark = placemarks?.first {
                    self.coordinates = placemark.location!.coordinate
                    self.displayPinOntheMap(self.coordinates!)
                }
            })
        }
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
        let region = MKCoordinateRegionMakeWithDistance(coordinates, 2000, 2000)
        self.mapView.setRegion(region, animated: true)
        self.mapView.addAnnotation(annotation)
    }
    //MARK:- Post the Student Location
    @IBAction func submitLocation(_ sender: Any) {
        if shareTextView.text.isEmpty {
            showAlertMessage("Inofrmation Posting", "Please enter the share Link")
        }else{
            if(UdacityClient.sharedInstance().isConnectedToNetwork()) {
                DispatchQueue.main.async{
                    self.myActivityIndicator.startAnimating()
                }
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                self.studentLocation = StudentLocation.init(dictionary: [:])
                self.studentLocation!.firstName = self.firstName
                self.studentLocation!.lastName = self.lastName
                self.studentLocation!.mapString = address
                self.studentLocation!.latitude = coordinates?.latitude
                self.studentLocation!.longitude = coordinates?.longitude
                self.studentLocation!.mediaURL = self.shareTextView.text
                for studentLocation in self.studentLocationModel.studentLocations{
                    //Check for student is alreayd posted or not?
                    if studentLocation.uniqueKey == appDelegate.udacityUserId {
                        isStudentPostedAlready = true
                        appDelegate.udacityUserObjectId = studentLocation.objectId
                        break
                    }else{
                        isStudentPostedAlready = false
                    }
                }
                if isStudentPostedAlready! {
                    StudentLocationClient.sharedInstance().updateToStudentLocation(self.studentLocation!){ (objectId, error) in
                        DispatchQueue.main.async{
                            self.myActivityIndicator.stopAnimating()
                        }
                        /* GUARD: Was there an error? */
                        guard (error == nil) else {
                            self.showAlertMessage(UdacityClient.UdacityConstans.ErrorMessages.InformationPosting, "\(error!.userInfo[NSLocalizedDescriptionKey] as! String)")
                            return
                        }
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                }else{
                    StudentLocationClient.sharedInstance().postToStudentLocation(self.studentLocation!){ (updatedAt, error) in
                        DispatchQueue.main.async{
                            self.myActivityIndicator.stopAnimating()
                        }
                        /* GUARD: Was there an error? */
                        guard (error == nil) else {
                            self.showAlertMessage(UdacityClient.UdacityConstans.ErrorMessages.InformationPosting, "\(error!.userInfo[NSLocalizedDescriptionKey] as! String)")
                            return
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            }else{
                self.showAlertMessage(UdacityClient.UdacityConstans.ErrorMessages.NetworkErrorTitle, UdacityClient.UdacityConstans.ErrorMessages.NetworkErrorMsg)
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
    func showAlertMessage(_ title:String, _ message:String) {
        let alertConroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertConroller.addAction(UIAlertAction(title:"OK",style : .default){ action in
            alertConroller.dismiss(animated: true, completion: nil)
        })
        self.present(alertConroller, animated: true, completion: nil)
    }
    // MARK:- Textview delegate
    
}
