//
//  APODViewModel.swift
//  GSCodeAssignment
//
//  Created by Mohanreddy Batchu on 09/09/22.
//

import Foundation
import UIKit

protocol APODViewModelProtocol:AnyObject {
    
    func refreshAPOD()
    func showError()
}

class APODViewModel {
    
    weak var apodViewModelProtocol:APODViewModelProtocol?
    
    let progressHUD = ProgressBar(text: "Fetch data")
    
    var apodDetail:APODModel? {
        didSet {
            apodViewModelProtocol?.refreshAPOD()
        }
    }
    
    var errorMessage:String?
    {
        didSet {
            apodViewModelProtocol?.showError()
        }
    }
    
    func getAPODDetails(_ currentDate:String, viewController:UIViewController)
    {
        progressHUD.tag = Constants.tagValue
        progressHUD.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        viewController.view.addSubview(progressHUD)
        
        progressHUD.show()
        
        NetWorkWrapper().getAPODDetails(currentDate: currentDate) { (result) in
            
            Utility.removeSubViews(viewController)
            self.progressHUD.hide()
            
            switch result
            {
            case .success(let data):
                if let request = JSONSerialization.paserJSONData(data) as? NSDictionary
                {
                    Utility.customLog(request)
                    
                    if let model = request.jsonObject(ofType: APODModel.self)
                    {
                        self.apodDetail = model
                    }
                }
            case .failure(let error):
                Utility.customLog(error.localizedDescription)
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func getCurrentDate() ->String
    {
        let date = Date()
        let dateFormatter = self.getDateFormatter()
        Utility.storeSelectedDate(dateFormatter.string(from: date))
        
        return dateFormatter.string(from: date)
    }
    
    func getDateFormatter() -> DateFormatter
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = defaultDateFormat
        dateFormatter.calendar = Calendar.current
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter
    }
}
