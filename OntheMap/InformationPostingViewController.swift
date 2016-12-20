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

    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var userEnteredTextView: UITextView!
    @IBOutlet weak var findtheMaoButton: UIButton!
    
    @IBOutlet weak var shareTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.shareTextView.isHidden = true
        self.mapView.isHidden = true
        self.submitButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    @IBAction func submitLocation(_ sender: Any) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func findTheMapAction(_ sender: Any) {
        var address:String?
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
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    self.displayPinOntheMap(coordinates)
                }
            })
        }
        //let address = "1 Infinite Loop, CA, USA"
       
    }
    @IBAction func cancelPosting(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func displayPinOntheMap(_ coordinates:CLLocationCoordinate2D){
        self.promptLabel.isHidden = true
        self.userEnteredTextView.isHidden = true
        self.findtheMaoButton.isHidden = true
        
        self.shareTextView.isHidden = false
        self.mapView.isHidden = false
        self.submitButton.isHidden = false
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        self.mapView.addAnnotation(annotation)
    }
    func showAlertMessage(_ title:String, _ message:String) {
        let alertConroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertConroller.addAction(UIAlertAction(title:"OK",style : .default){ action in
            self.dismiss(animated: true, completion: nil)
        })
        self.present(alertConroller, animated: true, completion: nil)
    }
}
