//
//  RegistrationViewController.swift
//  BoschAssignmt
//
//  Created by Udit Ajmera on 12/30/16.
//  Copyright © 2016 Udit Ajmera. All rights reserved.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController {

    
    @IBOutlet weak var objUserNameTextField: UITextField!
    
    @IBOutlet weak var objPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func registerButtonPressed(_ sender: AnyObject) {
        
        let lobjStudent:Admin =
            Admin(context: DatabaseController.getContext())
        lobjStudent.username = objUserNameTextField.text
        lobjStudent.password = objPasswordTextField.text

        
        DatabaseController.saveContext()
        
         self.navigationController?.popViewController(animated: true)

    }
    
}
