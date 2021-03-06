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
    var myActivityIndicator: UIActivityIndicatorView!
    var studentLocationModel: StudentLocations!
    //var studentLocations: [StudentLocation] = [StudentLocation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //shared instance of model class
        studentLocationModel = StudentLocations.sharedInstance()
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
        
        parent!.navigationItem.rightBarButtonItems = [refreshButton,mapButton]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getStudentLocationsList()
    }
    
    //MARK:- Get Student Locations
    func getStudentLocationsList(){
        if(UdacityClient.sharedInstance().isConnectedToNetwork()) {
            StudentLocationClient.sharedInstance().getStudentLocations{ (studentLocations, error) in
                if let studentLocations = studentLocations {
                    self.studentLocationModel.studentLocations = studentLocations
                    performUIUpdatesOnMain {
                        // When the array is complete, we add the annotations to the map.
                        self.tableView.reloadData()
                    }
                }
                else {
                    self.showAlertMessage(StudentLocationClient.ErrorMessages.OntheMapError, "\(error!.userInfo[NSLocalizedDescriptionKey] as! String)")
                }
            }
        }else{
            self.showAlertMessage(UdacityClient.UdacityConstans.ErrorMessages.NetworkErrorTitle, UdacityClient.UdacityConstans.ErrorMessages.NetworkErrorMsg)
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
        return self.studentLocationModel.studentLocations.count
    }
    
    //MARK:- Table view delegate methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocation", for: indexPath)
        
        let studentLocation = self.studentLocationModel.studentLocations[indexPath.row]
        // Configure the cell...
        if studentLocation.firstName != nil && studentLocation.lastName != nil && studentLocation.mediaURL != nil{
            cell.imageView?.image = UIImage(named:"icon_pin")
            cell.textLabel?.text = "\(studentLocation.firstName!) \(studentLocation.lastName!)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        let selectedStudent = self.studentLocationModel.studentLocations[indexPath.row]
        
        let toOpen = selectedStudent.mediaURL
        if (!(toOpen?.isEmpty)!) {
            if let url = URL(string: toOpen!){
                app.open((url), options: [:], completionHandler: nil)
            }else{
                showAlertMessage("On the Map", "Media url is not valid!")
            }
        }
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        _ = self.studentLocationModel.studentLocations[indexPath.row]
    }
    //MARK:- Logout
    func logout() {
        DispatchQueue.main.async{
            self.myActivityIndicator.startAnimating()
        }
        view.addSubview(myActivityIndicator)
        UdacityClient.sharedInstance().deleteUdacitySession{ (session, error) in
            DispatchQueue.main.async{
                self.myActivityIndicator.stopAnimating()
            }
            if  error == nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    //MARK:- Refresh Student location
    func refreshStudentLocation(_ sender: Any) {
        self.getStudentLocationsList()
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
