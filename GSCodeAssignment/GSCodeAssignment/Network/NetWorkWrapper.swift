//
//  NetWorkWrapper.swift
//  GSCodeAssignment
//
//  Created by Mohanreddy Batchu on 09/09/22.
//

import Foundation

class NetWorkWrapper: NSObject {
    
    func getAPODDetails(currentDate: String, CompleteHandle:@escaping(Result<Data, NSError>)-> Void)
    {
        var iServiceObject  = ServiceRequest()
        iServiceObject.body = nil
        iServiceObject.header = nil
        iServiceObject.url = Backend.host + "/planetary/apod?api_key=" + Backend.apiKey + "&date=" + currentDate
        iServiceObject.type = RequestType.GET
        
        ServiceHandler.shared().getDataForService(request: iServiceObject) { (result) in
            CompleteHandle(result)
        }
    }
}
