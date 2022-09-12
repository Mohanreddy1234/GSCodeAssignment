//
//  APODModel.swift
//  GSCodeAssignment
//
//  Created by Mohanreddy Batchu on 09/09/22.
//

import Foundation

class APODModel:Codable
{
    var copyright: String?
    var date: String?
    var explanation: String?
    var media_type: String?
    var title: String?
    var url: String?
    
    private enum CodingKeys: String, CodingKey {
        
        case copyright
        case date
        case explanation
        case media_type
        case title
        case url
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let copyrightValue  = try values.decodeIfPresent(String.self, forKey: .copyright)
        {
            copyright =  copyrightValue
        }
        
        if let dateValue  = try values.decodeIfPresent(String.self, forKey: .date)
        {
            date =  dateValue
        }
        
        if let explanationValue  = try values.decodeIfPresent(String.self, forKey: .explanation)
        {
            explanation =  explanationValue
        }
        
        if let titleValue  = try values.decodeIfPresent(String.self, forKey: .title)
        {
            title =  titleValue
        }
        
        if let urlValue  = try values.decodeIfPresent(String.self, forKey: .url)
        {
            url =  urlValue
        }
        
        if let media_typeValue  = try values.decodeIfPresent(String.self, forKey: .media_type)
        {
            media_type =  media_typeValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(copyright, forKey: .copyright)
        try container.encode(date, forKey: .date)
        try container.encode(explanation, forKey: .explanation)
        try container.encode(media_type, forKey: .media_type)
        try container.encode(title, forKey: .title)
        try container.encode(url, forKey: .url)
    }
}
