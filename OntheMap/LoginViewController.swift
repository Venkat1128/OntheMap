//
//  LoginViewController.swift
//  OntheMap
//
//  Created by Venkat Kurapati on 12/12/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import UIKit
// MARK: - LoginViewController: UIViewController
class LoginViewController: UIViewController {
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var keyboardOnScreen = false
    var myActivityIndicator: UIActivityIndicatorView!
    // MARK: Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var faceBookButton: BorderedButton!
    @IBOutlet weak var udacityLogoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        // Position Activity Indicator in the center of the main view
        self.myActivityIndicator.center = view.center
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        self.myActivityIndicator.hidesWhenStopped = true
        view.addSubview(self.myActivityIndicator)
        configureUI()
        // Do any additional setup after loading the view.
        loginButton.backgroundColor = UdacityClient.UI.LoginButtonColor
        loginButton.highlightedBackingColor =  UdacityClient.UI.LoginButtonColor
        loginButton.backingColor =  UdacityClient.UI.LoginButtonColor
        // get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        passwordTextField.isSecureTextEntry = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    //MARK:- Login Pressed
    @IBAction func loginPressed(_ sender: Any) {
        
        userDidTapView(self)
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            showAlertMessage(UdacityClient.UdacityConstans.ErrorMessages.LoginError, "Username or Password Empty.")
        }else {
            if(UdacityClient.sharedInstance().isConnectedToNetwork()) {
                
                setUIEnabled(false)
                // Start Activity Indicator
                self.myActivityIndicator.startAnimating()
                let jsonBody = "{\"udacity\": {\"\(UdacityClient.UdacityConstans.UdacityParameterKeys.Username)\": \"\(usernameTextField.text!)\", \"\(UdacityClient.UdacityConstans.UdacityParameterKeys.Password)\": \"\(passwordTextField.text!)\"}}"
                let _ =  UdacityClient.sharedInstance().taskForPOSTMethod(UdacityClient.UdacityConstans.UdacityResponseKeys.Session, jsonBody: jsonBody){
                    (results, error) in
                    //Stop Animation
                    self.myActivityIndicator.stopAnimating()
                    /* GUARD: Was there an error? */
                    guard (error == nil) else {
                        self.setUIEnabled(true)
                        self.showAlertMessage(UdacityClient.UdacityConstans.ErrorMessages.LoginError, "\(error!.userInfo[NSLocalizedDescriptionKey] as! String)")
                        return
                    }
                    /* GUARD: Is the "sessionID" key in parsedResult? */
                    let sessionDict = results?[UdacityClient.UdacityConstans.UdacityResponseKeys.Session] as! Dictionary<String, Any>
                    let accountDict = results?[UdacityClient.UdacityConstans.UdacityResponseKeys.Account] as! Dictionary<String, Any>
                    guard let sessionID = sessionDict[UdacityClient.UdacityConstans.UdacityResponseKeys.Id] as? String else {
                        self.showAlertMessage(UdacityClient.UdacityConstans.ErrorMessages.LoginError, "Cannot find key '\(UdacityClient.UdacityConstans.UdacityResponseKeys.Id)' in \(sessionDict)")
                        return
                    }
                    guard let userId = accountDict[UdacityClient.UdacityConstans.UdacityResponseKeys.UserId] as? String else {
                        self.showAlertMessage(UdacityClient.UdacityConstans.ErrorMessages.LoginError, "Cannot find key '\(UdacityClient.UdacityConstans.UdacityResponseKeys.UserId)' in \(accountDict)")
                        return
                    }
                    //Stop Animation
                    self.myActivityIndicator.stopAnimating()
                    self.appDelegate.sessionID = sessionID
                    self.appDelegate.udacityUserId = userId
                    print(userId)
                    self.completeLogin()
                }
            }else{
                self.showAlertMessage(UdacityClient.UdacityConstans.ErrorMessages.NetworkErrorTitle, UdacityClient.UdacityConstans.ErrorMessages.NetworkErrorMsg)
            }
        }
        
    }
    //MARK:- Sign Up to Updacity
    @IBAction func signUpUdacity(_ sender: Any) {
        if let url = URL(string: UdacityClient.signUpURL) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    //MARK:- Login with Facebook
    @IBAction func logininwithFacebook(_ sender: Any) {
        showAlertMessage("Facebook Login", "Work in progress")
    }
    //MARK:- Complete Login
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "LocationNavigationController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}
// MARK: - LoginViewController (Configure UI)

private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        signUpButton.isEnabled = enabled
        faceBookButton.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
            signUpButton.alpha = 1.0
            faceBookButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
            signUpButton.alpha = 0.5
            faceBookButton.alpha = 1.0
        }
    }
    
    func configureUI() {
        
        // configure background gradient
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [UdacityClient.UI.LoginColorTop, UdacityClient.UI.LoginColorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        configureTextField(usernameTextField)
        configureTextField(passwordTextField)
    }
    
    func configureTextField(_ textField: UITextField) {
        let textFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .always
        textField.backgroundColor = UdacityClient.UI.textFieldBgColor
        textField.textColor = UdacityClient.UI.LoginButtonColor
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.white])
        textField.tintColor = UdacityClient.UI.LoginButtonColor
        textField.delegate = self
    }
    func showAlertMessage(_ title:String, _ message:String) {
        let alertConroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertConroller.addAction(UIAlertAction(title:"OK",style : .default){ action in
            self.dismiss(animated: true, completion: nil)
        })
        self.present(alertConroller, animated: true, completion: nil)
    }
}

// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
            udacityLogoImageView.isHidden = true
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
            udacityLogoImageView.isHidden = false
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(usernameTextField)
        resignIfFirstResponder(passwordTextField)
    }
}


// MARK: - LoginViewController (Notifications)

private extension LoginViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
