//
//  ServiceHandler.swift
//  GSCodeAssignment
//
//  Created by Mohanreddy Batchu on 09/09/22.
//

import Foundation
import UIKit

class ServiceHandler: NSObject, URLSessionDelegate {
    
    var session: Foundation.URLSession!
    var task: URLSessionDataTask!
    
    private var queue =   DispatchQueue(label: "gscodeassignment.api.queue",attributes: .concurrent)
    
    private static var sharedNetworkManager:ServiceHandler = {
        return ServiceHandler()
    }()
    
    public class func shared() -> ServiceHandler {
        return sharedNetworkManager
    }
    
    func getSession()->Foundation.URLSession {
        
        let configuration =  URLSessionConfiguration.default
        
        configuration.connectionProxyDictionary     = nil
        configuration.timeoutIntervalForResource    = 30
        configuration.timeoutIntervalForRequest     = 30
        configuration.requestCachePolicy            = .useProtocolCachePolicy
        
        if #available(iOS 13.0, *) {
            configuration.tlsMaximumSupportedProtocolVersion = .TLSv12
        } else {
            configuration.tlsMaximumSupportedProtocol = .tlsProtocol12
        }
        
        return Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    override init() {
        super.init()
        self.session = self.getSession()
    }
    
    public func getDataForService(request iServiceObject: ServiceRequest, completionBlock:@escaping (Result<Data, NSError>) -> Void) {
        
        queue.async {
            
            if let aRequest: URLRequest = self.prepareRequestWithService(iServiceObject) {
                
                if let data = aRequest.httpBody {
                    Utility.customLog(String(decoding: data, as: UTF8.self))
                }
                
                self.task = self.session.dataTask(with: aRequest) {  (data, response, error) in
                    
                    let result = self.verify(data: data, urlResponse: response as? HTTPURLResponse, error: error)
                    
                    switch result {
                    case .success( let data):
                        
                        completionBlock(.success(data))
                        
                    case .failure(let error):
                        completionBlock(.failure(error))
                    }
                }
                self.task.resume()
                
            } else {
                let error = Utility.error(Constants.unknowErrorMsg)
                completionBlock(.failure(error))
            }
        }
    }
    
    private func verify(data: Any?, urlResponse: HTTPURLResponse?, error: Error?) -> Result<Data, NSError> {
        
        if let data = data {
            Utility.customLog(String(decoding: ((data as? Data)!), as: UTF8.self))
        }
        
        if let statusCode = urlResponse?.statusCode
        {
            if let url = urlResponse?.url?.absoluteString
            {
                Utility.customLog(String(statusCode))
                Utility.customLog(url)
            }
            
            switch statusCode {
            case 200...299:
                if let data = data {
                    return .success((data as? Data)!)
                } else {
                    return .failure(Utility.error(Constants.commonErrorMsg, code: statusCode))
                }
            case 400...499:
                if let data = data {
                    if let dic:NSDictionary = JSONSerialization.paserJSONData(data as? Data) as? NSDictionary
                    {
                        return .failure(Utility.error(dic["msg"] as? String ?? Constants.genericErrorMsg, code: statusCode))
                    }
                }
                return .failure(Utility.error(Constants.commonErrorMsg, code: statusCode))
            case 500...599:
                if let data = data {
                    if let dic:NSDictionary = JSONSerialization.paserJSONData(data as? Data) as? NSDictionary
                    {
                        return .failure(Utility.error(dic["msg"] as? String ?? Constants.genericErrorMsg, code: statusCode))
                    }
                }
                return .failure(Utility.error(Constants.serverDownErrorMsg, code: statusCode))
            default:
                return .failure(Utility.error(Constants.serverDownErrorMsg, code: statusCode))
            }
        }
        else
        {
            return .failure(Utility.error(Constants.commonErrorMsg))
        }
    }
    
    func prepareRequestWithService(_ request: ServiceRequest?) -> URLRequest? {
        
        guard let request  =  request else {
            return nil
        }
        
        if let aUrl = request.url {
            
            Utility.customLog(aUrl)
            
            let aRequest: NSMutableURLRequest = NSMutableURLRequest(url: URL(string:aUrl)!)
            
            aRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            aRequest.httpMethod = (request.type.rawValue)
            
            if request.type == .POST || request.type == .PUT || request.type == .PATCH || request.type == .DELETE {
                if let body = request.body, body.count > 0 {
                    
                    let bodyData = try? JSONSerialization.data(
                        withJSONObject: body,
                        options: []
                    )
                    
                    aRequest.httpBody = bodyData
                }
            }
            
            return aRequest as URLRequest
            
        } else {
            return nil
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        completionHandler(proposedResponse)
    }
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        session.finishTasksAndInvalidate()
    }
}
