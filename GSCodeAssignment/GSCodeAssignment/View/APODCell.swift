//
//  APODCell.swift
//  GSCodeAssignment
//
//  Created by Mohanreddy Batchu on 09/09/22.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation
import AVKit

@objc  protocol APODCellProtocol:AnyObject {
    @objc  optional func addFav()
    @objc  optional func deleteFav(index:Int)
}

class APODCell:UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var explanation: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var apodImageView: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var videoImage: UIImageView!
    
    weak var delegate:APODCellProtocol?
    
    var isFromFavorite:Bool = false
    var currentIndex:Int = -1
    var parentVC:UIViewController?
    var videoUrl:String? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.traitCollection.userInterfaceStyle == .dark
        {
            self.date.toggleTheme(true)
            self.title.toggleTheme(true)
            self.explanation.toggleTheme(true)
        }
        
        favButton.setImage(UIImage(named: "fav"), for: .normal)
        favButton.tag = 1
        
        if isFromFavorite == true
        {
            favButton.tag = 2
            favButton.setImage(UIImage(named: "Delete"), for: .normal)
        }
    }
    
    func setAPODObject(_ apodObject:APODModel?, index:Int = 0){
        
        videoView.isHidden      = false
        videoButton.isHidden    = false
        apodImageView.isHidden  = true
        videoImage.isHidden     = false
        videoUrl                = apodObject?.url
        
        if apodObject?.media_type?.caseInsensitiveCompare("image") == ComparisonResult.orderedSame
        {
            videoView.isHidden      = true
            videoButton.isHidden    = true
            apodImageView.isHidden  = false
            videoImage.isHidden     = true
            videoUrl                = nil
        }
        
        if let date = apodObject?.date
        {
            self.date.text = "Date: "+date
        }
        
        if let explanation = apodObject?.explanation
        {
            self.explanation.text = "Explanation: "+explanation
        }
        
        if let title = apodObject?.title
        {
            self.title.text = "Title: "+title
        }
        
        if let image = apodObject?.url
        {
            self.apodImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder"))
        }
        
        if let url = videoUrl
        {
            AVAsset(url: URL(string: url)!).generateThumbnail { [weak self] (image) in
                DispatchQueue.main.async {
                    guard let image = image else { return }
                    self?.videoImage.image = image
                }
            }
        }
        
        currentIndex = index
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        
        if sender.tag == 1
        {
            delegate?.addFav?()
        }
        else if sender.tag == 2
        {
            delegate?.deleteFav?(index: currentIndex)
        }
    }
    
    @IBAction func videoPlayButton(_ sender: UIButton) {
        
        DispatchQueue.main.async
        {
            if let url = self.videoUrl
            {
                let player = AVPlayer(url: URL(string: url)!)
                let playerController = AVPlayerViewController()
                playerController.player = player
                self.parentVC?.addChild(playerController)
                
                // Add your view Frame
                playerController.view.frame = self.videoView.bounds
                
                // Add sub view in your view
                self.videoView.addSubview(playerController.view)
                
                player.play()
            }
        }
    }
}
