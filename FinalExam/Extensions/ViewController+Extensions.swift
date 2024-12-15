///
//  ViewController+Extensions.swift
//  FinalExam
//
//  Created by Yash Suthar on 2024-12-13.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Displays a toast message on the screen with optional font customization.
    /// - Parameters:
    ///   - message: The message to display in the toast.
    ///   - font: The font for the toast message (default is system font of size 16).
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 16)) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-150, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.black
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    /// Dismisses the keyboard when tapped anywhere outside of the keyboard area.
    func hideKeyboardTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    /// Dismisses the keyboard by resigning first responder status from the active field.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// Adds a pull-to-refresh control to a UICollectionView.
    /// - Parameters:
    ///   - collectionView: The UICollectionView to add the refresh control to.
    ///   - triggerMethod: The method to trigger when the refresh control is activated.
    func makePullToRefreshToCollectionView(collectionView: UICollectionView, triggerMethod: Selector) {
        let collectionRefreshControl: UIRefreshControl = UIRefreshControl()
        collectionRefreshControl.backgroundColor = UIColor.clear
        collectionRefreshControl.addTarget(self, action: triggerMethod, for: .valueChanged)
        collectionView.refreshControl = collectionRefreshControl
    }
    
    /// Ends the refreshing state for a UICollectionView.
    /// - Parameter collectionView: The UICollectionView to stop refreshing.
    func endRefreshing(collectionView: UICollectionView) {
        collectionView.refreshControl?.endRefreshing()
    }
    
    /// Adds a pull-to-refresh control to a UITableView.
    /// - Parameters:
    ///   - tableView: The UITableView to add the refresh control to.
    ///   - triggerMethod: The method to trigger when the refresh control is activated.
    func makePullToRefreshToTableView(tableView: UITableView, triggerMethod: Selector) {
        let tableRefreshControl: UIRefreshControl = UIRefreshControl()
        tableRefreshControl.backgroundColor = UIColor.clear
        tableRefreshControl.addTarget(self, action: triggerMethod, for: .valueChanged)
        tableView.refreshControl = tableRefreshControl
    }
    
    /// Ends the refreshing state for a UITableView.
    /// - Parameter tableView: The UITableView to stop refreshing.
    func endRefreshing(tableView: UITableView) {
        tableView.refreshControl?.endRefreshing()
    }
    
    /// Displays an alert with a title and message.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message to display in the alert.
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = .red
        let someAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(someAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// Binds the keyboard height to a constraint, so it moves with the keyboard.
    /// - Parameter constraint: The NSLayoutConstraint that will change with the keyboard's visibility.
    func bindKeyboard(to constraint: NSLayoutConstraint) {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) { [weak self, weak constraint] notification in
            guard let info = notification.userInfo else { return }
            guard let height = (info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.size.height else { return }
            guard constraint?.constant != height else { return }
            constraint?.constant = height + 5
            self?.view.layoutIfNeeded()
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main) { [weak self, weak constraint] notification in
            guard constraint?.constant != 0 else { return }
            guard let info = notification.userInfo else { return }
            guard ((info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.size.height) != nil else { return }
            constraint?.constant = 20
            self?.view.layoutIfNeeded()
        }
    }
    
    /// Hides the navigation bar for the current view controller.
    func hideNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
}
