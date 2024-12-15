//
//  TripListTVC.swift
//  FinalExam
//
//  Created by Yash Suthar on 2024-12-13.
//

import UIKit

class TripListTVC: UITableViewCell {

    @IBOutlet weak var lblTripName: UILabel!           // Label to display the trip name
    @IBOutlet weak var lblDestination: UILabel!        // Label to display the trip destination
    @IBOutlet weak var viewTVC: UIView!                // Container view for the cell (for styling)
    @IBOutlet weak var lblExpenseTotal: UILabel!       // Label to display the total expenses for the trip
    @IBOutlet weak var btnAddExpense: UIButton!        // Button to add an expense to the trip
    
    weak var parentViewController: UIViewController?   // Reference to the parent view controller to navigate to the next screen
    var trip: Trip?                                    // Store the Trip object to pass data to the next screen
    var onExpenseAdded: (() -> Void)?                  // Closure to notify when an expense is added
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewTVC.layer.cornerRadius = 15    // Set rounded corners for the cell's container view
        self.btnAddExpense.addTarget(self, action: #selector(addExpenseTapped), for: .touchUpInside) // Add target for button
        print("Target added to btnAddExpense")  // Debugging message to check if the target is added
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state (not needed here as no specific selection behavior is defined)
    }
    
    // Function to set the data for the cell
    func setData(data: Trip, parentViewController: UIViewController) {
        // Assign references to trip data and parent view controller
        self.trip = data
        self.parentViewController = parentViewController
        
        // Set labels with trip name and destination
        self.lblTripName.text = data.tripName
        self.lblDestination.text = data.destination
        
        // Calculate total expenses for the trip
        let totalExpenses = data.expenses?.compactMap { ($0 as? Expenses)?.expense?.doubleValue }.reduce(0, +) ?? 0.0
        
        if totalExpenses > 0 {
            // If expenses exist, format and display total expenses
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency          // Format as currency
            formatter.locale = Locale.current          // Use system locale for formatting
            
            self.lblExpenseTotal.text = " \(formatter.string(from: NSNumber(value: totalExpenses)) ?? "N/A")"
            self.lblExpenseTotal.isHidden = false     // Make total expense label visible
            self.btnAddExpense.isHidden = true        // Hide Add Expense button when there are existing expenses
        } else {
            // No expenses, show Add Expense button and hide the total expenses label
            self.lblExpenseTotal.isHidden = true
            self.btnAddExpense.isHidden = false
        }
        
        // Customize the Add Expense button's appearance
        self.btnAddExpense.setTitle("Add Expense", for: .normal)
        self.btnAddExpense.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)  // Set bold font for button
        self.btnAddExpense.setTitleColor(.accent, for: .normal)  // Set custom color for button title
        self.btnAddExpense.backgroundColor = .clear           // Set background color to clear
        self.btnAddExpense.layer.cornerRadius = 10            // Round the button corners
        self.btnAddExpense.addTarget(self, action: #selector(addExpenseTapped), for: .touchUpInside) // Add target for button
    }

    // Function to handle "Add Expense" button tap
    @objc func addExpenseTapped() {
        print("Add Expense button tapped")  // Debugging message when button is tapped
        
        // Ensure the trip object exists before proceeding
        guard let trip = trip else {
            print("Trip is nil")  // Debugging message if the trip is nil
            return
        }
        
        // Instantiate the TripExpenses view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tripExpensesVC = storyboard.instantiateViewController(withIdentifier: "TripExpenses") as? TripExpenses {
            tripExpensesVC.trip = trip  // Pass the trip object to the next view controller
            
            // Pass the closure callback to the TripExpenses view controller to handle expense addition
            tripExpensesVC.onExpenseAdded = { [weak self] in
                self?.onExpenseAdded?()  // Notify the parent when an expense is added
            }
            
            // Push the TripExpenses view controller onto the navigation stack
            parentViewController?.navigationController?.pushViewController(tripExpensesVC, animated: true)
        }
    }
}
