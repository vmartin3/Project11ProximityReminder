//
//  LocationSearchTableVC.swift
//  Project11ProximityReminders
//
//  Created by Vernon G Martin on 5/10/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit
import MapKit

var locationSelected: Bool = false

class LocationSearchTableVC: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
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
            print(location)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateSearchResults(for: searchBarController)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        matchingItems.removeAll()
        var mapView = map
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
        return matchingItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = ""
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        indexPathForSelection = indexPath.row
        let selectedItem = matchingItems[indexPath.row].placemark
        self.destinationCoordinates = selectedItem.coordinate
        self.destiationName = selectedItem.name
        //dismiss(animated: true, completion: nil)
        //unwind(for: , towardsViewController: LocationDetailTableView)
        locationSelected = true
        performSegue(withIdentifier: "unwindToDetailSegue", sender: self)
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
      //  let detailVC = subsequentVC as! LocationDetailTableView
            
        //detailVC.reminderTextField = UITextField()
       // et detailVC = unwindSegue.destination as! LocationDetailTableView
        //detailVC.viewDidLoad()
        //unwindSegue.source.navigationController?.reloadInputViews()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToDetailSegue"{
            let detailVC = segue.destination as! LocationDetailTableView
            detailVC.locationText = self.destiationName!
            detailVC.location = self.matchingItems[indexPathForSelection!]
            detailVC.locationisSet = true
            //detailVC.reminderTextField = UITextField()
        }
    }

}
