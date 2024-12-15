//
//  Textfeild+extensions.swift
//  FinalExam
//
//  Created by Yash Suthar on 2024-12-13.
//

import Foundation
import UIKit

extension UITextField {
    
    // Method to set left padding for the text field
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    // Method to set right padding for the text field
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    // Enum to define the direction (left or right) for the image to be set in the text field
    enum Direction {
        case Left
        case Right
    }
    
    // Method to add an image to the left or right of the text field
    func setImage(direction: Direction, imageName: String, Frame: CGRect, backgroundColor: UIColor) {
        let View = UIView(frame: CGRect(x: Frame.origin.x, y: Frame.origin.y, width: Frame.size.width + 25, height: Frame.size.height))
        View.backgroundColor = backgroundColor
        
        let imageView = UIImageView(frame: Frame)
        imageView.image = UIImage(named: imageName)
        imageView.tintColor = .white
        View.addSubview(imageView)
        
        // Add the image view to either the left or right based on the direction
        if Direction.Left == direction {
            self.leftViewMode = .always
            self.leftView = View
        } else {
            self.rightViewMode = .always
            self.rightView = View
        }
    }
    
    // Property to set and get placeholder color
    var placeholderColors: UIColor? {
        get {
            return self.placeholderColors
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    // Method to add an image to the left of the text field
    func leftImage(ImageviewNamed: String) {
        let imgview = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imgview.image = UIImage(named: ImageviewNamed)
        let imgviewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imgviewContainer.addSubview(imgview)
        leftView = imgviewContainer
        leftViewMode = .always
    }
    
    // Method to set an icon on the left side of the text field
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    // Method to set an icon on the right side of the text field
    func setRightViewIcon(icon: UIImage) {
        let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        btnView.setImage(icon, for: .normal)
        btnView.tintColor = .accent
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
        self.rightViewMode = .always
        self.rightView = btnView
    }
}
