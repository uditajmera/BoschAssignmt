//
//  TruckMapViewController.swift
//  BoschAssignmt
//
//  Created by Udit Ajmera on 12/30/16.
//  Copyright © 2016 Udit Ajmera. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import HealthKit
import CoreData


class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

class TruckMapViewController: UIViewController {

    var seconds = 0.0
    var distance = 0.0
    var run: Run!
    var objSortedlocations:[Any]!
    var intLocationSimulationIndex = 0
    var objTrackingUser:User!
    
    @IBOutlet weak var objMapView: MKMapView!
    
    @IBOutlet weak var objTruckNumberLabel: UILabel!
    
    @IBOutlet weak var objTruckDestinationLabel: UILabel!
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .automotiveNavigation
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    lazy var locations = [CLLocation]()
    lazy var timer = Timer()
    lazy var previousRunSimulationtimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.requestAlwaysAuthorization()

        let lobjUserDetail:UserDetails = self.objTrackingUser.relationship!
        self.objTruckNumberLabel.text = "Truck Number : \(lobjUserDetail.truck_number!)"
        self.objTruckDestinationLabel.text = "Destination : Apple USA"
        navigationItem.title = self.objTrackingUser.username
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.retrievePreviousRun() == true
        {
            self.loadMap()
        }
        else
        {
            startTracking()
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if intLocationSimulationIndex <= 0
        {
            saveRun()
        }
        
        timer.invalidate()
        previousRunSimulationtimer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------
    // MARK: - Save Run
    //------------------------------------------------

    func saveRun()
    {
        // 1
        
        let lobjSavedRun:Run =
            Run(context: DatabaseController.getContext())
        
        lobjSavedRun.distance = Float(distance)
        lobjSavedRun.duration = Int16(seconds)
        lobjSavedRun.timestamp = NSDate()
        lobjSavedRun.truck_number = self.objTrackingUser.relationship?.truck_number
        // 2
        var larraySavedLocations = [Location]()
        
        for location in locations {
            
            let savedLocation:Location =
                Location(context: DatabaseController.getContext())
            
            savedLocation.timestamp = location.timestamp as NSDate?
            savedLocation.latitude = location.coordinate.latitude
            savedLocation.longitude = location.coordinate.longitude
            larraySavedLocations.append(savedLocation)
        }
        
        lobjSavedRun.locations = NSSet(array: larraySavedLocations)
        run = lobjSavedRun
        
        DatabaseController.saveContext()
        
        // 3
    }
    
    //------------------------------------------------
    // MARK: - Previous Run
    //------------------------------------------------
    
    func polyline()
    {
        var coords = [CLLocationCoordinate2D]()
        let larrayLocations = Array(self.objSortedlocations)
        if self.intLocationSimulationIndex < (larrayLocations.count - 1)
        {
            let lobjLocation1:Location = larrayLocations[self.intLocationSimulationIndex] as! Location
            coords.append(CLLocationCoordinate2D(latitude: lobjLocation1.latitude,
                                                 longitude: lobjLocation1.longitude))
            
            
            let lobjLocation2:Location = larrayLocations[self.intLocationSimulationIndex+1] as! Location
            coords.append(CLLocationCoordinate2D(latitude: lobjLocation2.latitude,
                                                 longitude: lobjLocation2.longitude))
            
            self.objMapView.add(MKPolyline(coordinates: &coords, count: 2))
  
            self.intLocationSimulationIndex += 1
        }
    }
    
    
    func mapRegion() -> MKCoordinateRegion {
        
        let locations:NSArray = run.locations!.allObjects as NSArray
        
        let initialLoc = locations.object(at: 0) as! Location

        var minLat = initialLoc.latitude
        var minLng = initialLoc.longitude
        var maxLat = minLat
        var maxLng = minLng
        
        
        for location in locations {
            
            let lobjLocation:Location = location as! Location
            minLat = min(minLat, lobjLocation.latitude)
            minLng = min(minLng, lobjLocation.longitude)
            maxLat = max(maxLat, lobjLocation.latitude)
            maxLng = max(maxLng, lobjLocation.longitude)
        }

        
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2,
                                           longitude: (minLng + maxLng)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.1,
                                   longitudeDelta: (maxLng - minLng)*1.1))
    }

    
    func loadMap()
    {
        if (run.locations?.count)! > 0
        {
            objMapView.isHidden = false
            
            // Set the map bounds
            objMapView.region = mapRegion()
            
            self.objSortedlocations = run.locations?.sortedArray(using: [NSSortDescriptor(key: "timestamp", ascending: true)])
            
            let lobjInitialCDLocation:Location = self.objSortedlocations[0] as! Location
            
            let lobjInititalLoc:CLLocation = CLLocation.init(latitude: lobjInitialCDLocation.latitude, longitude: lobjInitialCDLocation.longitude)
            
            let lobjInitialMapAnnotation:MapPin = MapPin.init(coordinate: lobjInititalLoc.coordinate, title: "start ", subtitle: "Check")
            
            self.objMapView.addAnnotation(lobjInitialMapAnnotation)
            
            let lobjDestCDLocation:Location = self.objSortedlocations[self.objSortedlocations.count - 1] as! Location

            let lobjDestLoc:CLLocation = CLLocation.init(latitude: lobjDestCDLocation.latitude, longitude: lobjDestCDLocation.longitude)
            
            let lobjDestMapAnnotation:MapPin = MapPin.init(coordinate: lobjDestLoc.coordinate,
                                                       title: "End ", subtitle: "EndCheck")
            
            self.objMapView.addAnnotation(lobjDestMapAnnotation)
            
            previousRunSimulationtimer = Timer.scheduledTimer(timeInterval: 1,
                                                              target: self,
                                                              selector:#selector(polyline),
                                                              userInfo: nil,
                                                              repeats: true)
            
            
            
            // Make the line(s!) on the map
         //   objMapView.add(polyline())
        }
        else
        {
            // No locations were found!
            previousRunSimulationtimer.invalidate()
            self.startTracking()
//            UIAlertView(title: "Error",
//                        message: "Sorry, this run has no locations saved",
//                        delegate:nil,
//                        cancelButtonTitle: "OK").show()
        }
    }
    
    
    func retrievePreviousRun()->Bool
    {
        var lbPreviousRunExist:Bool = false
        let fetchRequest:NSFetchRequest<Run> = Run.fetchRequest()
        
        let idPredicate = NSPredicate(format: "truck_number==%@", (self.objTrackingUser.relationship?.truck_number)!)
        
        fetchRequest.predicate = idPredicate
        
        do{
            
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            
            print("result-->\(searchResults.count)")
            for results in searchResults as [Run]
            {
                lbPreviousRunExist = true
                self.run = results
            }
            
        }
        catch
        {
            print("Error\(error)")
        }
        
        return lbPreviousRunExist
    }
    
    //------------------------------------------------
    // MARK: - Track Run
    //------------------------------------------------
    
    func eachSecond(timer: Timer) {
        seconds+=1
    }
    
    func startLocationUpdates() {
        // Here, the location manager will be lazily instantiated
        locationManager.startUpdatingLocation()
    }
    
    
    func startTracking()
    {
        seconds = 0.0
        distance = 0.0
        locations.removeAll(keepingCapacity: false)
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector:#selector(eachSecond(timer:)),
                                     userInfo: nil,
                                     repeats: true)
        startLocationUpdates()
    }
    
    //------------------------------------------------
    // MARK: - Navigation
    //------------------------------------------------
    
    /*
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    public func setTrackingUserInfo(lobjUser:User)
    {
        self.objTrackingUser = lobjUser
    }


}

//------------------------------------------------
// MARK: - CLLocationManagerDelegate
//------------------------------------------------

extension TruckMapViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation])
    {
        for location in locations {
            let howRecent = location.timestamp.timeIntervalSinceNow
            
            if abs(howRecent) < 10 && location.horizontalAccuracy < 20 {
                //update distance
                if self.locations.count > 0 {
                    distance += location.distance(from: self.locations.last!)
                    
                    var coords = [CLLocationCoordinate2D]()
                    coords.append(self.locations.last!.coordinate)
                    coords.append(location.coordinate)
                    
                    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
                    objMapView.setRegion(region, animated: true)
                    objMapView.add(MKPolyline(coordinates: &coords, count: coords.count))
                }
                
                //save location
                if self.locations.count < 1
                {
                    let lobjMapAnnotation:MapPin = MapPin.init(coordinate: location.coordinate, title: "start ", subtitle: "Check")
                    
                    self.objMapView.addAnnotation(lobjMapAnnotation)
                }
                self.locations.append(location)
            }
        }
    }
}

//------------------------------------------------
// MARK: - MKMapViewDelegate
//------------------------------------------------

extension TruckMapViewController: MKMapViewDelegate
{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3
        return renderer
    }
    
}

