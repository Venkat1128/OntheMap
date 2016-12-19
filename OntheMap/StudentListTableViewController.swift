//
//  StudentListTableViewController.swift
//  OntheMap
//
//  Created by Venkat Kurapati on 16/12/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import UIKit

class StudentListTableViewController: UITableViewController {
    
    // MARK: Properties
    var studentLocations: [StudentLocation] = [StudentLocation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        let mapImage   = UIImage(named: StudentLocationClient.NavIcons.MAP_ICON)!
        let refreshImage = UIImage(named: StudentLocationClient.NavIcons.REFRESH_ICON)!
        let mapButton   = UIBarButtonItem(image: mapImage,  style: .plain, target: self, action: #selector(StudentMapViewController.postLocation(_:)))
        let refreshButton = UIBarButtonItem(image: refreshImage,  style: .plain, target: self, action: #selector(StudentMapViewController.refreshStudentLocation(_:)))
        
        parent!.navigationItem.rightBarButtonItems = [refreshButton,mapButton]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getStudentLocationsList()
    }
    
    //MARK:- Get Student Locations
    func getStudentLocationsList(){
        StudentLocationClient.sharedInstance().getStudentLocations{ (studentLocations, error) in
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                performUIUpdatesOnMain {
                    // When the array is complete, we add the annotations to the map.
                    self.tableView.reloadData()
                }
            }
            else {
                print(error!)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.studentLocations.count
    }
    
    //MARK:- Table view delegate methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocation", for: indexPath)
        
        let studentLocation = self.studentLocations[indexPath.row]
        // Configure the cell...
        if studentLocation.firstName != nil && studentLocation.lastName != nil{
            cell.imageView?.image = UIImage(named:"icon_pin")
            cell.textLabel?.text = "\(studentLocation.firstName!) \(studentLocation.lastName!)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        let selectedStudent = self.studentLocations[indexPath.row]
        
        let toOpen = selectedStudent.mediaURL!
        if (toOpen.isEmpty) {
            app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            
        }
    }
    func logout() {
        print("Logout")
    }
    func refreshStudentLocation(_ sender: Any) {
        self.getStudentLocationsList()
        print("Refresh table")
    }
    func postLocation(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "InofrmationNavView") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
        print("Map")
    }
}
