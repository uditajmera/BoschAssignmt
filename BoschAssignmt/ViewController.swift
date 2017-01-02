//
//  ViewController.swift
//  BoschAssignmt
//
//  Created by Udit Ajmera on 12/28/16.
//  Copyright © 2016 Udit Ajmera. All rights reserved.
//

import UIKit


public enum UserType:Int {
    
    case none = 0
    case User = 1
    case Admin = 2
    
}


class ViewController: UIViewController {


    var enumUserType:UserType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func adminButtonPressed(_ sender: AnyObject) {
        
        self.enumUserType = UserType.Admin
        self.performSegue(withIdentifier: "SegueToLogin", sender: self)
    }

    
    @IBAction func userButtonPressed(_ sender: AnyObject) {
        
        self.enumUserType = UserType.User
        self.performSegue(withIdentifier: "SegueToLogin", sender: self)
        
    }
    
    
    //---------------------------------------------------
    // MARK: - Navigation
    //---------------------------------------------------
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "SegueToLogin")
        {
            let destinationVC:UserLoginViewController = segue.destination as! UserLoginViewController
            
            destinationVC.setUserType(lenumUserType: self.enumUserType!)
            
        }
    }
    
}

