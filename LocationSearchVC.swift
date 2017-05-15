//
//  LocationSearchVC.swift
//  Project11ProximityReminders
//
//  Created by Vernon G Martin on 5/10/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchVC: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var searchBarController: UISearchController!
    
    var map:MKMapView = MKMapView()
    var matchingItems:[MKMapItem] = []
    
    var destinationCoordinates: CLLocationCoordinate2D?
    var destiationName: String?
    
    var indexPathForSelection: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchBarController.searchBar
        LocationManager.sharedLocationInstance.determineMyCurrentLocation { (location) in
            print("MY LOCATION IS: \(location)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        matchingItems.removeAll()
        let mapView = map
        guard let searchBarText = searchBar.text else { return }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
    
    func locationSetAlert(){
        let alert = UIAlertController(title: "Reminder Location Set",
                                      message: "You will be reminded when you get near \(destiationName!)",
                                      preferredStyle: .alert)
        let done = UIAlertAction(title: "Okay", style: .default) { (okaySelected) in
            self.performSegue(withIdentifier: "unwindToDetailSegue", sender: self)
        }
        alert.addAction(done)
        self.present(alert, animated: true)
    }
}


extension LocationSearchVC: UISearchBarDelegate, UISearchDisplayDelegate {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.locationNameLabel.text = selectedItem.name
        
        guard let city = selectedItem.addressDictionary?["City"], let state = selectedItem.addressDictionary?["State"],  let street = selectedItem.addressDictionary?["Thoroughfare"] else {
            cell.locationAddressLabel.text = ("\(selectedItem.addressDictionary!["City"]!), \(selectedItem.addressDictionary!["State"]!)")
            return cell
        }
        
        cell.locationAddressLabel.text = ("\(city), \(state) - \(street)")
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPathForSelection = indexPath.row
        let selectedItem = matchingItems[indexPath.row].placemark
        self.destinationCoordinates = selectedItem.coordinate
        self.destiationName = selectedItem.name
        
        locationSetAlert()
    }
    
    //MARK: - SearchBarDelegate Method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateSearchResults(for: searchBarController)
    }
    
    
    // MARK: - Navigation
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToDetailSegue"{
            let detailVC = segue.destination as! ReminderDetailsVC
            detailVC.locationText = self.destiationName!
            detailVC.reminder.latitude = self.matchingItems[indexPathForSelection!].placemark.coordinate.latitude
            detailVC.reminder.longitude = self.matchingItems[indexPathForSelection!].placemark.coordinate.longitude
            detailVC.locationisSet = true
        }
    }
}
