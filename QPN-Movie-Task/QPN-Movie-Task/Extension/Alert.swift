//
//  Alert.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//


import UIKit
import Foundation


extension UIViewController {
    
     func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}
