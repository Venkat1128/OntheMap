//
//  StudentMapViewController.swift
//  OntheMap
//
//  Created by Venkat Kurapati on 16/12/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import UIKit
import MapKit
class StudentMapViewController: UIViewController,MKMapViewDelegate {

    // MARK: Properties
    
    var studentLocations: [StudentLocation] = [StudentLocation]()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        StudentLocationClient.sharedInstance().getStudentLocations{ (studentLocations, error) in
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                performUIUpdatesOnMain {
                   // self.moviesTableView.reloadData()
                }
            } else {
                print(error)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
