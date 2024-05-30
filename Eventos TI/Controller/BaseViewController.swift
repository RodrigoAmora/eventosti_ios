//
//  BaseViewController.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 23/05/24.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    func changeViewControllerWithPresent(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func changeViewControllerWithPushViewController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getVersionApp() -> String? {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return appVersion
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let buttonOK = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(buttonOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorMessage(errorCode: Int) {
        let message = switch errorCode {
            case 403:
                String(localized: "error_access_denied")
            case 404:
                String(localized: "error_not_found")
            case 500:
                String(localized: "error_service_unavailable")
            default:
                String(localized: "error_cant_was_possible_perform_operation")
        }
        
        self.showAlert(title: "", message: message)
    }
    
    func share(text: String) {
        let textToShare = [ text ]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}
