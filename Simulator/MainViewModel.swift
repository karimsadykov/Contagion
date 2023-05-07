//
//  MainViewModel.swift
//  Simulator
//
//  Created by Карим Садыков on 06.05.2023.
//

import Foundation
import UIKit

class MainViewModel {
    
    func isValid(elements: String?, delay: String?) -> (Bool, String?) {
        guard let elementsText = elements, !elementsText.isEmpty,
              let elements = Int(elementsText),
              elements > 0 else {
            return (false, LocalizableStrings.elementInvalid)
        }
        
        guard let delayText = delay, !delayText.isEmpty,
              let delay = Double(delayText),
              delay > 0 else {
            return (false, LocalizableStrings.delayInvalid)
        }
        
        return (true, nil)
    }
    
    func showAlert(on viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: LocalizableStrings.alertError, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizableStrings.alertOk, style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}

