//
//  TripExpenses.swift
//  FinalExam
//
//  Created by Yash Suthar on 2024-12-13.
//

import UIKit
import CoreData

class TripExpenses: UIViewController {
    
    @IBOutlet weak var lblTripName: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtExpenseName: UITextField!
    @IBOutlet weak var txtExpenseAmount: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblTotalExpense: UILabel!
    
    var onExpenseAdded: (() -> Void)?
    var trip: Trip?
    var fetchedExpenses: [Expenses] = [] // Array to store expenses for the trip
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the UI elements and initial data
        self.setUI()
        self.displayTripDetails()
        self.loadXIB()
        self.fetchExpenses() // Fetch existing expenses for the trip
        self.updateTotalExpense() // Update total expense
        self.hideKeyboardTappedAround()
    }
    
    // MARK: - UI Setup Methods
    
    func setUI() {
        self.btnBack.layer.cornerRadius = self.btnBack.frame.height / 2
        self.btnSave.layer.cornerRadius = 15
        self.btnReset.layer.cornerRadius = 15
        self.txtExpenseAmount.layer.cornerRadius = 15
        self.txtExpenseName.layer.cornerRadius = 15
        self.txtExpenseName.setLeftPaddingPoints(15)
        self.txtExpenseAmount.setLeftPaddingPoints(15)
    }
    
    func loadXIB() {
        self.tblView.register(UINib(nibName: "ExpensesTVC", bundle: nil), forCellReuseIdentifier: "ExpensesTVC")
        self.tblView.dataSource = self
        self.tblView.delegate = self
        self.tblView.backgroundColor = .clear
        self.tblView.separatorStyle = .none
    }
    
    // MARK: - Trip Details Methods
    
    func displayTripDetails() {
        guard let trip = trip else { return }
        self.lblTripName.text = trip.tripName
        self.updateTotalExpense() // Update the total expense when displaying details
    }
    
    // MARK: - Core Data Methods
    
    func fetchExpenses() {
        guard let trip = trip else { return }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Expenses> = Expenses.fetchRequest()
        request.predicate = NSPredicate(format: "trip == %@", trip)
        
        do {
            self.fetchedExpenses = try context.fetch(request)
            
            // Add fade-in animation when table data is fetched
            self.tblView.reloadData()
            self.animateTableView()  // Animation for newly loaded data
            self.updateTotalExpense() // Recalculate the total expense after fetching
        } catch {
            print("Failed to fetch expenses: \(error.localizedDescription)")
        }
    }
    
    func updateTotalExpense() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let expense = Expenses(context: context)

        let total = fetchedExpenses.reduce(0.0) { $0 + ($1.expense?.doubleValue ?? 0.0) }
        expense.exoenseTotal = NSDecimalNumber(value: total)

        do {
            try context.save()
        } catch {
            print("Failed to save total expense: \(error.localizedDescription)")
        }
        
        self.lblTotalExpense.text = "Total : $\(total)"
        print("Total : ", total)
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        guard let trip = trip,
              let expenseName = txtExpenseName.text, !expenseName.isEmpty,
              let expenseAmountText = txtExpenseAmount.text, !expenseAmountText.isEmpty,
              let expenseAmount = Double(expenseAmountText) else {
            print("Please fill in all fields")
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let expense = Expenses(context: context)
        expense.espenseName = expenseName
        expense.expense = NSDecimalNumber(value: expenseAmount)
        expense.trip = trip
        
        do {
            try context.save()
            self.txtExpenseName.text = ""
            self.txtExpenseAmount.text = ""
            self.fetchExpenses() // Refresh the expenses list
            self.updateTotalExpense() // Recalculate total expense after saving

            // Trigger the callback to refresh the trip list
            self.onExpenseAdded?()
        } catch {
            print("Failed to save expense: \(error.localizedDescription)")
        }
    }
    
    @IBAction func btnResetTapped(_ sender: Any) {
        self.txtExpenseName.text = ""
        self.txtExpenseAmount.text = ""
        
        // Add button reset animation
        animateButton(btnReset)
    }
    
    // MARK: - Animation Methods
    
    func animateTableView() {
        // Adding fade-in animation for the table view
        tblView.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.tblView.alpha = 1.0
        }
    }
    
    func animateButton(_ button: UIButton) {
        // Scale animation when the reset button is tapped
        UIView.animate(withDuration: 1, animations: {
            button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 1) {
                button.transform = CGAffineTransform.identity
            }
        }
    }
}

// MARK: - UITableView DataSource and Delegate Methods

extension TripExpenses: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedExpenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpensesTVC", for: indexPath) as? ExpensesTVC else {
            return UITableViewCell()
        }
        
        let expense = fetchedExpenses[indexPath.row]
        cell.setData(expense: expense)
        cell.selectionStyle = .none
        return cell
    }
}
