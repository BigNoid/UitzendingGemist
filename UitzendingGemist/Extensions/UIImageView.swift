//
//  UIImageView.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 11/23/15.
//
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

extension UIImageView {
    public func setImageWithJSON(json: JSON) {
        let imageScaleFactor = CGFloat(3.0)
        
        getImageURLWithJSON(json, fallbackImageURL: nil, success: { url in
            let size = CGSize(width: self.frame.size.width * imageScaleFactor, height: self.frame.size.height * imageScaleFactor)
            let filter = AspectScaledToFillSizeFilter(size: size)
            self.af_setImageWithURL(url, filter: filter)
        }) { error in
            debugPrint(error)
            self.image = UIImage(named: "Testbeeld")
        }
    }

    public func setImageWithJSON(json: JSON, fallbackImageURL: NSURL?) {
        let imageScaleFactor = CGFloat(3.0)
        
        getImageURLWithJSON(json, fallbackImageURL: fallbackImageURL, success: { url in
            let size = CGSize(width: self.frame.size.width * imageScaleFactor, height: self.frame.size.height * imageScaleFactor)
            let filter = AspectScaledToFillSizeFilter(size: size)
            self.af_setImageWithURL(url, filter: filter)
        }) { error in
            debugPrint(error)
            self.image = UIImage(named: "Testbeeld")
        }
    }
    
    private func getImageURLWithJSON(json: JSON, fallbackImageURL: NSURL?, success succeed: NSURL -> () = { url in }, failure fail: String -> () = { error in }) {
        if let url = json["image"].string, imageURL = NSURL(string: url) {
            // get main image URL
            succeed(imageURL)
        } else if let stills = json["stills"].array, firstStillString = stills.first!["url"].string, firstStillURL = NSURL(string: firstStillString) {
            // get first still image URL
            succeed(firstStillURL)
        } else if let url = json["series"]["image"].string, imageURL = NSURL(string: url) {
            // get series main image URL
            succeed(imageURL)
        } else if let seriesMID = json["series"]["mid"].string {
            // get any of the series image URLs
            UitzendingGemistManager.sharedInstance.getSerie(seriesMID, success: { serie in
                self.getImageURLWithJSON(serie, fallbackImageURL: fallbackImageURL, success: { url in
                    succeed(url)
                }) { error in
                    fail(error)
                }
            })
        } else if let url = fallbackImageURL {
            // get the fallback image
            succeed(url)
        } else {
            // no luck at all
            fail("no image available")
        }
    }
}