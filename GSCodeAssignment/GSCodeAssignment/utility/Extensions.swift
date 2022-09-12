//
//  Extensions.swift
//  GSCodeAssignment
//
//  Created by Mohanreddy Batchu on 09/09/22.
//

import Foundation
import UIKit
import AVKit

extension JSONSerialization {
    
    public class func paserJSONData(_ iData: Data?) -> AnyObject? {
        if iData != nil {
            
            var parsingResult: Any?
            
            do {
                
                parsingResult = try JSONSerialization.jsonObject(with: iData!, options: JSONSerialization.ReadingOptions())
            } catch (let error) {
                Utility.customLog(error)
            }
            
            return parsingResult as Any? as AnyObject?
        } else {
            return nil
        }
    }
}

extension NSDictionary {
    
    func jsonObject <T:Decodable> (ofType type:T.Type) ->T? {
        
        var typeAny:T?
        
        do {
            let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder()
            if jsonData !=  nil {
                typeAny = try decoder.decode(type, from: jsonData!)
            }
        } catch{
            Utility.customLog(error.localizedDescription)
        }
        
        return typeAny
    }
}

extension UILabel{
    
    func toggleTheme(_ selected : Bool){
        if selected{
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark{
                    self.textColor = UIColor.black
                    self.backgroundColor = UIColor.white
                }else{
                    self.textColor = UIColor.white
                    self.backgroundColor = UIColor.black
                }
            } else {
                self.textColor = UIColor.white
                self.backgroundColor = UIColor.black
            }
            
        }else{
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark{
                    self.textColor = UIColor.white
                    self.backgroundColor = UIColor.black
                }else{
                    self.textColor = UIColor.black
                    self.backgroundColor = UIColor.white
                }
            } else {
                self.textColor = UIColor.black
                self.backgroundColor = UIColor.white
            }
            
        }
    }
}

extension AVAsset {
    
    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}
