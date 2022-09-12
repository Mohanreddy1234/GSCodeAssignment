//
//  ServiceRequest.swift
//  GSCodeAssignment
//
//  Created by Mohanreddy Batchu on 09/09/22.
//

import Foundation

public enum RequestType: String {
    
    case GET    = "GET"
    case PUT    = "PUT"
    case POST   = "POST"
    case DELETE = "DELETE"
    case PATCH  = "PATCH"
}

public struct ServiceRequest {
    
    public var type: RequestType  = RequestType.GET
    public var url: String?
    public var header: [String: Any]?
    public var body: [String: Any]?
    
    public init() {
        
    }
}
