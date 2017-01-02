//
//  AdminUserSelectionViewController.swift
//  BoschAssignmt
//
//  Created by Udit Ajmera on 1/1/17.
//  Copyright © 2017 Udit Ajmera. All rights reserved.
//

import UIKit
import DropDown
import CoreData

class AdminUserSelectionViewController: UIViewController {

    @IBOutlet weak var userDropDownView: UIView!
    
    @IBOutlet weak var objTrackButton: UIButton!
    @IBOutlet weak var objUserSelectionButton: UIButton!
    
    @IBOutlet weak var objNoUserLabel: UILabel!
    
    var arrayUserDetails:NSMutableArray = NSMutableArray()
    let dropDown = DropDown()
    
    var intSelectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchUserDetails()
        // The view to which the drop down will appear on
        dropDown.anchorView = self.userDropDownView // UIView or UIBarButtonItem
        
        if self.arrayUserDetails.count == 0
        {
            self.objTrackButton.isEnabled = false
            self.objNoUserLabel.isHidden = false
        }
        else
        {
            for user in self.arrayUserDetails
            {
                let lobjUser:User = (user as! User)
                let lobjUserDetail:UserDetails = lobjUser.relationship!
                
                dropDown.dataSource.append("\(lobjUser.username!)- \(lobjUserDetail.truck_number!)")
            }
  
        }
        
        // The list of items to display. Can be changed dynamically
    
        
        // Action triggered on selection
        dropDown.selectionAction = { (index: Int, item: String) in
            
            self.objUserSelectionButton.setTitle(item, for: .normal)
            
            self.intSelectedIndex = index
            print("Selected item: \(item) at index: \(index)")
        }
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.objUserSelectionButton.frame = self.objUserSelectionButton.frame
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func fetchUserDetails()
    {
        let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
        // 1
        
        do
        {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            
            print(searchResults.count)
            for results:User in searchResults as [User]
            {
                self.arrayUserDetails.add(results)
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
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueToTrack"
        {
            let destinationVC:TruckMapViewController = segue.destination as! TruckMapViewController
            
            destinationVC.setTrackingUserInfo(lobjUser: self.arrayUserDetails.object(at: self.intSelectedIndex) as! User)
        }
    }
    
    
    @IBAction func userSelectionButtonPressed(_ sender: AnyObject) {
        
        dropDown.show()
    }
    
    
    @IBAction func trackButtonPressed(_ sender: AnyObject) {
        
    }

}
