//
//  Utility.swift
//  GSCodeAssignment
//
//  Created by Mohanreddy Batchu on 09/09/22.
//

import Foundation
import UIKit

class Utility: NSObject {
    
    static func customLog(_ message:Any)
    {
        #if DEBUG
        debugPrint("Debug: %@", message as! CVarArg)
        #endif
    }
    
    static func error(_ message: String, code: Int = 0, domain: String = "") -> NSError {
        
        let error = NSError(domain: domain, code: code, userInfo: [
            NSLocalizedDescriptionKey: message,
        ])
        
        return error
    }
    
    static func storeSelectedDate ( _ date:String?)
    {
        UserDefaults.standard.set(date, forKey: Constants.selectedDate)
    }
    
    static func fetchSelectedDate() -> String?
    {
        return UserDefaults.standard.object(forKey: Constants.selectedDate) as? String
    }
    
    static func storeAPODModel ( _ model:[APODModel])
    {
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(model) {
            UserDefaults.standard.set(data, forKey: Constants.apodModel)
        }
    }
    
    static func fetchAPODModel() -> [APODModel]?
    {
        if let data = UserDefaults.standard.data(forKey: Constants.apodModel)
        {
            let apodArray = try! JSONDecoder().decode([APODModel].self, from: data)
            return apodArray
        }
        return nil
    }
    
    static func storeLastViewAPODModel ( _ model:APODModel)
    {
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(model) {
            UserDefaults.standard.set(data, forKey: Constants.apodLastViewModel)
        }
    }
    
    static func fetchLastViewAPODModel() -> APODModel?
    {
        if let data = UserDefaults.standard.data(forKey: Constants.apodLastViewModel)
        {
            let objectArray = try! JSONDecoder().decode(APODModel.self, from: data)
            return objectArray
        }
        return nil
    }
    
    static func showEddError (_ error:String,viewController:UIViewController) {
        DispatchQueue.main.async {
            
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            if let errorVC = mainStoryBoard.instantiateViewController(withIdentifier: "ErrorViewController") as? ErrorViewController
            {
                errorVC.errorMessage = error
                errorVC.modalPresentationStyle = .custom
                viewController.present(errorVC, animated: true, completion: nil)
            }
        }
    }
    
    static func removeSubViews(_ viewController:UIViewController)
    {
        DispatchQueue.main.async {
            for v in viewController.view.subviews
            {
                if v is UIView{
                    if v.tag == Constants.tagValue
                    {
                        v.removeFromSuperview()
                    }
                }
            }
        }
    }
}
