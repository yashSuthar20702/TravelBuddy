//
//  ExpensesTVCTableViewCell.swift
//  FinalExam
//
//  Created by Yash Suthar on 2024-12-14.
//

import UIKit

class ExpensesTVC: UITableViewCell {

    // IBOutlet connections to UI elements
    @IBOutlet weak var lblExpenseName: UILabel!   // Label to display the name of the expense
    @IBOutlet weak var lblExpensePrice: UILabel!  // Label to display the price of the expense
    @IBOutlet weak var viewExpense: UIView!       // View containing the expense item, used for styling
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewExpense.layer.cornerRadius = 15 // Apply rounded corners to the view
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // You can add any configuration you want for when the cell is selected (if needed)
    }
    
    // Function to populate the cell with expense data
    func setData(expense: Expenses) {
        // Set the expense name from the Expenses object
        lblExpenseName.text = expense.espenseName
        
        // Check if expense has a valid value
        if let expenseValue = expense.expense {
            // Format the expense value as currency
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale.current // Use the current system locale for currency format
            // Set the formatted price text or "N/A" if formatting fails
            lblExpensePrice.text = formatter.string(from: expenseValue) ?? "N/A"
        } else {
            // If no valid expense value, display "N/A"
            lblExpensePrice.text = "N/A"
        }
    }
}
