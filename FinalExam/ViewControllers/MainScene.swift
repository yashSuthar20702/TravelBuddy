//
//  MainScene.swift
//  FinalExam
//
//  Created by Yash Suthar on 2024-12-13.
//

import UIKit

class MainScene: UIViewController {
    
    @IBOutlet weak var btnMyTrips: UIButton! // Button to navigate to the Trip List page
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup after loading the view
        self.setUI()               // Set up the UI elements
        self.hideNavigationBar()   // Hide the navigation bar for this view controller
    }
    
    // MARK: - UI Setup
    
    /// This method is used to set up the UI elements like button styling.
    func setUI(){
        // Apply rounded corners to the "My Trips" button
        self.btnMyTrips.layer.cornerRadius = 15
    }
    
    // MARK: - Button Actions
    
    /// Action triggered when the "My Trips" button is tapped.
    /// Navigates to the Trip List page.
    @IBAction func btnMyTripsTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "TripListPage") as! TripListPage
        
        // Add a custom transition
        vc.modalTransitionStyle = .flipHorizontal // Custom transition
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    @IBAction func btnAddTrips(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddTripPage") as! AddTripPage
        vc.modalPresentationStyle = .fullScreen // Display in full screen
        
        // Add a custom transition
        vc.modalTransitionStyle = .crossDissolve // Smooth dissolve transition
        self.navigationController?.present(vc, animated: true)
    }

    
}
