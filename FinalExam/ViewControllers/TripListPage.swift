//
//  TripListPage.swift
//  FinalExam
//
//  Created by Yash Suthar on 2024-12-13.
//

import UIKit
import CoreData

class TripListPage: UIViewController {
    
    var trips: [Trip] = [] // Array to hold fetched Core Data objects
    var filteredTrips: [Trip] = [] // Array for filtered trips

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtSearch: UITextField! {
        didSet {
            txtSearch.leftImage(ImageviewNamed: "search")
            txtSearch.placeholder = "Search..."
        }
    }
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblNotFound: UILabel!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup UI elements, load custom cells, and fetch trips
        self.setUI()
        self.loadXib()
        self.hideKeyboardTappedAround()
        self.fetchTrips() // Fetch data from Core Data
        self.setupSearchTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fetch trips again when the view appears and reload the table
        self.fetchTrips() // Re-fetch trips from Core Data
        self.tblView.reloadData() // Refresh the table view
    }
    
    // MARK: - UI Setup Methods
    
    /// Set up UI elements, including corner radius and initial visibility.
    func setUI() {
        self.txtSearch.layer.cornerRadius = 15
        self.btnSearch.layer.cornerRadius = 15
        self.btnBack.layer.cornerRadius = self.btnBack.frame.height / 2
        lblNotFound.isHidden = true // Initially hide the "Not Found" message
    }
    
    /// Load the custom XIB for the table view cell.
    func loadXib() {
        self.tblView.register(UINib(nibName: "TripListTVC", bundle: nil), forCellReuseIdentifier: "TripListTVC") // Register the custom cell
        self.tblView.dataSource = self
        self.tblView.delegate = self
        self.tblView.backgroundColor = .clear
        self.tblView.separatorStyle = .none
    }
    
    // MARK: - Core Data Methods
    
    /// Fetch trips from Core Data and reload the table view.
    func fetchTrips() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        // Show loading animation or something indicating fetching is in progress
        tblView.alpha = 0.0 // Initially hide the table
        
        do {
            trips = try context.fetch(fetchRequest)
            filteredTrips = trips // Initialize filteredTrips with all data

            // Add fade-in animation to the table view when data is fetched
            UIView.animate(withDuration: 1) {
                self.tblView.alpha = 1.0 // Fade-in table view
            }
            
            tblView.reloadData() // Reload the table view data
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Search Methods
    
    /// Setup the search text field with a target for text change.
    func setupSearchTextField() {
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    /// Handle the tap on the "Back" button to pop the view controller.
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Handle the tap on the "Search" button to filter trips and add animation.
    @IBAction func btnSearchTapped(_ sender: Any) {
        // Animate the button with scaling effect
        UIView.animate(withDuration: 1, animations: {
            self.btnSearch.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            // Reset the scale back to normal after animation ends
            UIView.animate(withDuration: 1) {
                self.btnSearch.transform = CGAffineTransform.identity
            }
        }
        
        guard let searchText = txtSearch.text?.lowercased(), !searchText.isEmpty else {
            filteredTrips = trips
            lblNotFound.isHidden = true
            tblView.isHidden = false
            tblView.reloadData()
            return
        }
        
        filteredTrips = trips.filter {
            $0.tripName?.lowercased().contains(searchText) == true ||
            $0.destination?.lowercased().contains(searchText) == true
        }
        
        if filteredTrips.isEmpty {
            tblView.isHidden = true
            lblNotFound.isHidden = false
            lblNotFound.text = "No trips found for '\(searchText)'"
        } else {
            tblView.isHidden = false
            lblNotFound.isHidden = true
            
            // Reload table view with animation
            tblView.reloadData()
            
            // Add animation to each row as it is reloaded
            for (index, _) in filteredTrips.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                
                // Add fade-in animation to each cell with a slight delay
                let cell = tblView.cellForRow(at: indexPath)
                cell?.alpha = 0.0
                UIView.animate(withDuration: 0.5, delay: Double(index) * 0.1, options: .curveEaseIn, animations: {
                    cell?.alpha = 1.0
                })
            }
        }
    }

    /// Handle text field changes for real-time filtering of trips.
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            // Restore original list when search field is cleared
            filteredTrips = trips
            tblView.isHidden = false
            lblNotFound.isHidden = true
            tblView.reloadData()
        }
    }
}

extension TripListPage: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView DataSource Methods
    
    /// Return the number of rows in the table view based on filtered trips.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTrips.count
    }
    
    /// Configure each cell with the appropriate trip data.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripListTVC", for: indexPath) as! TripListTVC
        cell.selectionStyle = .none
        cell.setData(data: filteredTrips[indexPath.row], parentViewController: self)
        // Pass a callback to refresh the table when returning
        cell.onExpenseAdded = { [weak self] in
            self?.fetchTrips() // Refresh trips
            self?.tblView.reloadData() // Reload table view
        }
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    /// Handle swipe-to-delete gesture for deleting trips.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete Trip",
                                           message: "Are you sure you want to delete this trip?",
                                           preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.deleteTrip(at: indexPath)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Handle the selection of a trip to view its details.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrip = filteredTrips[indexPath.row] // Get the selected trip from the filtered array
        
        // Instantiate TripDetails view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name
        if let tripDetailsVC = storyboard.instantiateViewController(withIdentifier: "TripDetails") as? TripDetails {
            tripDetailsVC.trip = selectedTrip // Pass the selected trip to the next screen
            
            // Add custom transition animation
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .moveIn
            transition.subtype = .fromRight
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            // Apply the transition to the navigation controller
            navigationController?.view.layer.add(transition, forKey: kCATransition)
            
            // Perform the navigation
            self.navigationController?.pushViewController(tripDetailsVC, animated: false) // Disable default animation
        }
    }
    
    // MARK: - Helper Methods
    
    /// Delete a trip from Core Data and update the table view.
    private func deleteTrip(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let tripToDelete = filteredTrips[indexPath.row]
        
        context.delete(tripToDelete)
        
        do {
            try context.save()
            trips.removeAll(where: { $0 == tripToDelete }) // Remove from original list
            filteredTrips.remove(at: indexPath.row) // Remove from filtered list
            tblView.deleteRows(at: [indexPath], with: .fade)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}
