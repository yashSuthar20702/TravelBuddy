//
//  AddTripPage.swift
//  FinalExam
//
//  Created by Yash Suthar on 2024-12-13.
//

// AddTripPage.swift

import UIKit

class AddTripPage: UIViewController {

    @IBOutlet weak var txtTripName: UITextField!
    @IBOutlet weak var txtStartingLocation: UITextField!
    @IBOutlet weak var txtDestination: UITextField!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var txtThingsToDo: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnBack: UIButton!
    private var startDatePicker: UIDatePicker!
    private var endDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the UI and related features
        self.setUI()
        
        // Hide the keyboard when tapping outside text fields
        self.hideKeyboardTappedAround()
        
        // Register for keyboard notifications to adjust the scroll view
        self.registerForKeyboardNotifications()
        
        // Set up the date pickers for start and end dates
        self.setupDatePickers()
        
        // Hide the navigation bar for this view controller
        self.hideNavigationBar()
    }
    
    // MARK: - UI Setup Methods
    func setUI() {
        self.txtTripName.layer.cornerRadius = 15
        self.txtStartingLocation.layer.cornerRadius = 15
        self.txtDestination.layer.cornerRadius = 15
        self.txtStartDate.layer.cornerRadius = 15
        self.txtEndDate.layer.cornerRadius = 15
        self.txtThingsToDo.layer.cornerRadius = 15
        self.btnSave.layer.cornerRadius = 15
        self.btnReset.layer.cornerRadius = 15
                
        self.txtTripName.setLeftPaddingPoints(15)
        self.txtStartingLocation.setLeftPaddingPoints(15)
        self.txtDestination.setLeftPaddingPoints(15)
        self.txtStartDate.setLeftPaddingPoints(15)
        self.txtEndDate.setLeftPaddingPoints(15)
        self.txtThingsToDo.setLeftPaddingPoints(15)
        self.btnBack.layer.cornerRadius = self.btnBack.frame.height / 2
        
        // Adding calendar icons to date text fields
        self.txtStartDate.setRightViewIcon(icon: UIImage(systemName: "calendar")!)
        self.txtEndDate.setRightViewIcon(icon: UIImage(systemName: "calendar")!)
    }
    
    // MARK: - Date Picker Methods
    func setupDatePickers() {
        startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.minimumDate = Date()
        startDatePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
        txtStartDate.inputView = startDatePicker
        
        endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .wheels
        endDatePicker.minimumDate = Date()
        endDatePicker.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)
        txtEndDate.inputView = endDatePicker
    }
    
    @objc func startDateChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        txtStartDate.text = formatter.string(from: startDatePicker.date)
        
        endDatePicker.minimumDate = startDatePicker.date
        if endDatePicker.date < startDatePicker.date {
            txtEndDate.text = nil
        }
    }

    @objc func endDateChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        txtEndDate.text = formatter.string(from: endDatePicker.date)
    }
    
    // MARK: - Keyboard Handling Methods
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    // MARK: - Alert Method
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Reset and Save Methods
    func resetFields() {
        self.txtTripName.text = ""
        self.txtStartingLocation.text = ""
        self.txtDestination.text = ""
        self.txtStartDate.text = ""
        self.txtEndDate.text = ""
        self.txtThingsToDo.text = ""
    }

    @IBAction func btnResetTapped(_ sender: Any) {
        resetFields()
    }

    @IBAction func btnSaveTapped(_ sender: Any) {
        guard let tripName = txtTripName.text, !tripName.isEmpty,
              let startingLocation = txtStartingLocation.text, !startingLocation.isEmpty,
              let destination = txtDestination.text, !destination.isEmpty,
              let startDateText = txtStartDate.text, let selectedStartDate = startDatePicker?.date,
              let endDateText = txtEndDate.text, let selectedEndDate = endDatePicker?.date,
              let thingsToDo = txtThingsToDo.text, !thingsToDo.isEmpty else {
            showAlert(title: "Error", message: "Please fill all the fields.")
            return
        }
        
        if selectedEndDate < selectedStartDate {
            showAlert(title: "Error", message: "End date cannot be earlier than start date.")
            return
        }
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: selectedStartDate)
        let endDate = calendar.startOfDay(for: selectedEndDate)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let newTrip = Trip(context: context)

        newTrip.tripName = tripName
        newTrip.startingLocation = startingLocation
        newTrip.destination = destination
        newTrip.startDate = startDate
        newTrip.endDate = endDate
        newTrip.thingsToDo = thingsToDo
        
        do {
            try context.save()
            showAlert(title: "Success", message: "Trip saved successfully!")
            
            // Add animation for adding data to table
            animateDataAdded()
            
            resetFields()
        } catch let error as NSError {
            showAlert(title: "Error", message: "Could not save the trip. \(error.localizedDescription)")
        }
    }

    // MARK: - Animation Method
    func animateDataAdded() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0.0
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.view.alpha = 1.0
            }
        }
    }

    // MARK: - Navigation Methods
    @IBAction func btnBackTapped(_ sender: Any) {
        // Adding a smooth transition when going back
        UIView.transition(with: self.view, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.dismiss(animated: true)
        })
    }
}
