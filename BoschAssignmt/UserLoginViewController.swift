//
//  UserLoginViewController.swift
//  BoschAssignmt
//
//  Created by Udit Ajmera on 12/30/16.
//  Copyright © 2016 Udit Ajmera. All rights reserved.
//

import UIKit
import CoreData

class UserLoginViewController: UIViewController {
    
    
    @IBOutlet weak var objBackgroundView: UIView!
    
    @IBOutlet weak var objPasswordTextField: UITextField!
    @IBOutlet weak var objUserNameTextField: UITextField!
    
    
    var enumUserType:UserType?
    var objLoginUser:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.enumUserType == UserType.Admin
        {
            navigationItem.title = "Admin Login"
            self.objBackgroundView.backgroundColor = UIColor.yellow
        }
        else
        {
            navigationItem.title = "User Login"
            
            self.objBackgroundView.backgroundColor = UIColor.lightGray
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueToUserRun"
        {
            let destinationVC:TruckMapViewController = segue.destination as! TruckMapViewController
            
            destinationVC.setTrackingUserInfo(lobjUser: self.objLoginUser!)
        }

     }
    
    @IBAction func loginButtonPressed(_ sender: AnyObject)
    {
        
        if self.enumUserType == UserType.Admin
        {
            let fetchRequest:NSFetchRequest<Admin> = Admin.fetchRequest()
            
            let idPredicate = NSPredicate(format: "username==%@ AND password==%@", self.objUserNameTextField.text!, self.objPasswordTextField.text!)
            
            fetchRequest.predicate = idPredicate
            
            do
            {
                let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
                
                print("result-->\(searchResults.count)")
                if searchResults.count == 0
                {
                    UIAlertView(title: "Error",
                                message: "You have entered an invalid or not registered username or password",
                                delegate:nil,
                                cancelButtonTitle: "OK").show()
                    
                }
                else
                {
                    for results in searchResults as [Admin]
                    {
                        self.performSegue(withIdentifier: "SegueUserSelection", sender: self)
                        
                        print(results.username)
                        print(results.password)
                    }
                }
                
            }
            catch
            {
                print("Error\(error)")
            }
        }
        else
        {
            let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
            
            let idPredicate = NSPredicate(format: "username==%@ AND password==%@", self.objUserNameTextField.text!, self.objPasswordTextField.text!)
            
            fetchRequest.predicate = idPredicate
            
            do
            {
                let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
                
                if searchResults.count == 0
                {
                    UIAlertView(title: "Error",
                                message: "You have entered an invalid or not registered username or password",
                                delegate:nil,
                                cancelButtonTitle: "OK").show()
                    
                }
                else
                {
                    print("result-->\(searchResults.count)")
                    for results in searchResults as [User]
                    {
                        self.objLoginUser = results
                        self.performSegue(withIdentifier: "segueToUserRun", sender: self)
                        
                        print(results.username)
                        print(results.password)
                    }
 
                }
            }
            catch
            {
                print("Error\(error)")
            }
 
        }
        
    }
    
    
    @IBAction func registerButtonPressed(_ sender: AnyObject) {
        
        if self.enumUserType == UserType.Admin
        {
            self.performSegue(withIdentifier: "SegueAdminRegistration", sender: self)
        }
        else
        {
            self.performSegue(withIdentifier: "SegueUserRegistration", sender: self)
        }
        
    }
    
    
    public func setUserType(lenumUserType:UserType)
    {
        self.enumUserType = lenumUserType
    }
    
}
