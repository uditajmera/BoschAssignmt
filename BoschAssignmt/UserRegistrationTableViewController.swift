//
//  UserRegistrationTableViewController.swift
//  BoschAssignmt
//
//  Created by Udit Ajmera on 1/1/17.
//  Copyright © 2017 Udit Ajmera. All rights reserved.
//

import UIKit
import CoreData

class UserRegistrationTableViewController: UITableViewController {
    
    @IBOutlet weak var objTruckModelTextField: UITextField!
    
    @IBOutlet weak var objTruckNumberTextField: UITextField!
    
    @IBOutlet weak var objTruckColor: UITextField!
    
    @IBOutlet weak var objUserNameTextField: UITextField!
    
    @IBOutlet weak var objEmailIdTextField: UITextField!
    @IBOutlet weak var objPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "User Registration"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 7
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func registerButtonPressed(_ sender: AnyObject)
    {
        let lobjUserDetail:UserDetails =
            UserDetails(context: DatabaseController.getContext())
        lobjUserDetail.truck_color = self.objTruckColor.text
        lobjUserDetail.truck_model = self.objTruckModelTextField.text
        lobjUserDetail.truck_number = self.objTruckNumberTextField.text
        
        
        let lobjTruckUser:User = User(context: DatabaseController.getContext())
        lobjTruckUser.username = self.objUserNameTextField.text
        lobjTruckUser.password = self.objPasswordTextField.text
        lobjTruckUser.emailId = self.objEmailIdTextField.text

        lobjTruckUser.relationship = lobjUserDetail
        
        DatabaseController.saveContext()
        
        let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
        // 1
        
        do
        {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            
            print(searchResults.count)
            for results in searchResults as [User]
            {
                let lobjUserDetail:UserDetails = results.relationship!
                
                print(results.username)
                print(results.password)
                
                print(lobjUserDetail.truck_number)
            }
        }
        catch
        {
            print("Error\(error)")
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
