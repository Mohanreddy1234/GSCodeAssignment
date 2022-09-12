//
//  Constants.swift
//  GSCodeAssignment
//
//  Created by Mohanreddy Batchu on 09/09/22.
//

import Foundation
import UIKit

enum Backend {
    static let apiKey =  "DEMO_KEY"  //"TeQNB5N9rmKjJuI1akHrnaDQAmXagp3FspkASjs0"
    static let host = "https://api.nasa.gov"
}

let defaultDateFormat = "yyyy-MM-dd"

struct Constants {
    
    static let favoriteTitle:String     = "Favorite Details"
    static let pictureOfDay:String      = "Astronomy picture of the day"
    static let addFavorite:String       = "Add Favorites"
    static let favoriteOption:String    = "Please select below option"
    static let addTitle:String          = "Add"
    static let cancelTitle:String       = "Cancel"
    
    static let deleteFavorite:String    = "Delete Favorites"
    static let deleteTitle:String       = "Delete"
    
    static let addCell:String           = "APODCell"
    
    static let commonErrorMsg:String    = "Something went wrong"
    static let serverDownErrorMsg:String = "Server down, please try after sometime."
    static let genericErrorMsg:String   = "Error from server"
    static let unknowErrorMsg:String    = "Unknown Error"
    static let doneTitle:String         = "Done"
    
    static let selectedDate:String      = "selectedDate"
    static let apodModel:String         = "apodModel"
    static let apodLastViewModel:String = "apodLastViewModel"
    
    static let freeFavoriteMemory       = "Free the Favorite ViewController"
    static let freeViewControllerMemory = "Free the ViewController"
    static let freeErrorViewControllerMemory = "Free the Error ViewController"

    static let tagValue:Int             = 1000
}
