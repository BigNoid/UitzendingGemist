//
//  UitzendingGemistManager.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 11/24/15.
//
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class UitzendingGemistManager {
    // singleton
    static let sharedInstance = UitzendingGemistManager()
    private let infoDictionary = NSBundle.mainBundle().infoDictionary!
    
    //MARK: Request headers
    
    private func getHeaders() -> [String:String] {
        return [
            //"User-Agent"        : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.2.7 (KHTML, like Gecko) Version/9.0.1 Safari/601.2.7",
            "DNT"               : "1",
            "Accept-Encoding"   : "gzip, deflate, sdch",
            "Accept"            : "*/*",
            "X-UitzendingGemist-Version"        : infoDictionary["CFBundleShortVersionString"] as! String,
            "X-UitzendingGemist-Source"         : "https://github.com/4np/UitzendingGemist",
            "X-UitzendingGemist-Platform"       : infoDictionary["DTSDKName"] as! String,
            "X-UitzendingGemist-PlatformVersion": infoDictionary["DTPlatformVersion"] as! String
        ]
    }
    
    //MARK: NPO player token logic
    
    private func getToken(success succeed: String -> () = { token in }, failure fail : String -> () = {error in }) {
        Alamofire.request(.GET, "http://ida.omroep.nl/npoplayer/i.js", headers: getHeaders())
            .responseString { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        do {
                            let regex = try NSRegularExpression(pattern: "\"(.*)\"", options: NSRegularExpressionOptions.CaseInsensitive)
                            let matches = regex.matchesInString(value, options: [], range: NSMakeRange(0, value.characters.count))
                            
                            if let match = matches.first {
                                let range = match.rangeAtIndex(1)
                                if let swiftRange = self.rangeFromNSRange(range, forString: value) {
                                    let token = value.substringWithRange(swiftRange)
                                    
                                    // fix the token and return it
                                    succeed(self.fixToken(token))
                                } else {
                                    fail("could not match token")
                                }
                            } else {
                                fail("could not match token")
                            }
                        } catch {
                            // regex was bad!
                            fail("could not match token")
                        }
                    }
                case .Failure(let error):
                    print(error)
                    fail(error.description)
                }
        }
    }
    
    private func fixToken(token: String) -> String {
        // token components will be swapped, so we need to fix this
        var fixedToken = token
        let length = token.characters.count
        var index = 0
        var firstIndex = 0
        var secondIndex = 0
        for i in token.characters {
            if index > 4 && index < length - 4 {
                if let _ = Int("\(i)") {
                    if firstIndex == 0 {
                        firstIndex = index
                    } else if secondIndex == 0 {
                        secondIndex = index
                        
                        let firstChar = token[token.startIndex.advancedBy(firstIndex)]
                        let secondChar = token[token.startIndex.advancedBy(secondIndex)]
                        var chars = Array(token.characters)
                        chars[firstIndex] = secondChar
                        chars[secondIndex] = firstChar
                        fixedToken = String(chars)
                    }
                }
            }
            index++
        }
        
        return fixedToken
    }
    
    private func rangeFromNSRange(nsRange: NSRange, forString str: String) -> Range<String.Index>? {
        let fromUTF16 = str.utf16.startIndex.advancedBy(nsRange.location, limit: str.utf16.endIndex)
        let toUTF16 = fromUTF16.advancedBy(nsRange.length, limit: str.utf16.endIndex)
        
        if let from = String.Index(fromUTF16, within: str),
            let to = String.Index(toUTF16, within: str) {
                return from ..< to
        }
        
        return nil
    }
    
    //MARK: get video stream
    
    private func getStreams(mid: String, success succeed: String -> () = { streams in }, failure fail : String -> () = {error in }) {
        getToken(success: { token in
            let url = "http://ida.omroep.nl/odi/?prid=\(mid)&puboptions=h264_bb,h264_sb,h264_std&adaptive=no&part=1&token=\(token)"
          
            Alamofire.request(.GET, url, headers: self.getHeaders())
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            
                            if let stream = json["streams"][0].string {
                                succeed(stream)
                            }
                        }
                    case .Failure(let error):
                        fail("could not fetch streams (\(error.description))")
                    }
                }
        }) { error in
            fail("could not fetch streams (\(error))")
        }
    }
    
    func getVideoURL(mid: String, success succeed: String -> () = { url in }, failure fail : String -> () = {error in }) {
        getStreams(mid, success: { stream in
            var url = stream
            if let comp = NSURLComponents(string: stream) {
                url = "\(comp.scheme!)://\(comp.host!)\(comp.path!)"
            }
            
            Alamofire.request(.GET, url, headers: self.getHeaders())
                .responseJSON { response in
                    switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                if let finalURL = json["url"].string {
                                    succeed(finalURL)
                                }
                            }
                        case .Failure(let error):
                            fail("could not video stream (\(error.description))")
                    }
                }
            }) { error in
                fail("could not video stream (\(error))")
        }
    }
    
    //MARK: Live streams
    
    func getLiveStreamURL(url: String, success succeed: String -> () = { url in }, failure fail: String -> () = {error in}) {
        getStreamURL(url, success: { url in
            Alamofire.request(.GET, url, headers: self.getHeaders())
                .responseString { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            do {
                                let regex = try NSRegularExpression(pattern: "\"(.*)\"", options: NSRegularExpressionOptions.CaseInsensitive)
                                let matches = regex.matchesInString(value, options: [], range: NSMakeRange(0, value.characters.count))
                                
                                if let match = matches.first {
                                    let range = match.rangeAtIndex(1)
                                    if let swiftRange = self.rangeFromNSRange(range, forString: value) {
                                        let streamURL = value.substringWithRange(swiftRange)
                                        let unescapedStreamURL = streamURL.stringByReplacingOccurrencesOfString("\\", withString: "")
                                        
                                        succeed(unescapedStreamURL)
                                    } else {
                                        fail("could not match live stream url")
                                    }
                                } else {
                                    fail("could not match live stream url")
                                }
                            } catch {
                                // regex was bad!
                                fail("could not match live stream url")
                            }
                        }
                    case .Failure(let error):
                        print(error)
                        fail(error.description)
                    }
                }
        }) { error in
            fail(error)
        }
    }
    
    private func getStreamURL(url: String, success succeed: String -> () = { url in }, failure fail: String -> () = {error in}) {
        getToken(success: { token in
            let requestURL = "http://ida.omroep.nl/aapi/?type=jsonp&stream=\(url)&token=\(token)"
            
            Alamofire.request(.GET, requestURL, headers: self.getHeaders())
                .responseJSON { response in
                    switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                if let finalURL = json["stream"].string {
                                    succeed(finalURL)
                                }
                            }
                        case .Failure(let error):
                            fail("could not get live video stream (\(error.description))")
                    }
                }
        }) { error in
            fail("could not fetch streams (\(error))")
        }
    }
    
    //MARK: Episode
    
    func getEpisode(mid: String, success succeed: JSON -> () = { episode in }, failure fail : String -> () = {error in }) {
        let url = "http://apps-api.uitzendinggemist.nl/episodes/\(mid).json"
        
        Alamofire.request(.GET, url, headers: getHeaders())
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        succeed(JSON(value))
                    } else {
                        fail("could not get episode")
                    }
                case .Failure(let error):
                    fail(error.description)
                }
        }
    }
    
    //MARK: Series
    
    func getSerie(mid: String, success succeed: JSON -> () = { serie in }, failure fail : String -> () = {error in }) {
        let url = "http://apps-api.uitzendinggemist.nl/series/\(mid).json"
        
        Alamofire.request(.GET, url, headers: getHeaders())
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        succeed(JSON(value))
                    } else {
                        fail("could not get serie")
                    }
                case .Failure(let error):
                    fail(error.description)
                }
        }
    }
    
    func getSeries(success succeed: JSON -> () = { series in }, failure fail : String -> () = {error in }) {
        let url = "http://apps-api.uitzendinggemist.nl/series.json"
        
        Alamofire.request(.GET, url, headers: getHeaders())
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        succeed(JSON(value))
                    }
                case .Failure(let error):
                    fail(error.description)
                }
        }
    }
    
    //MARK: Daily recents
    
    func getDailyRecents(date: NSDate, success succeed: JSON -> () = { recent in }, failure fail : String -> () = {error in }) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate(date)
        let url = "http://apps-api.uitzendinggemist.nl/broadcasts/\(dateString).json"
        
        // get recents for this date
        Alamofire.request(.GET, url, headers: getHeaders())
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        succeed(JSON(value))
                    }
                case .Failure(let error):
                    fail("could not fetch recent videos for \(dateString) (\(error))")
                }
        }
    }
    
    //MARK: Featured videos
    
    func getFeatured(success succeed: JSON -> () = { featured in }, failure fail : String -> () = {error in }) {
        // get tips
        Alamofire.request(.GET, "http://apps-api.uitzendinggemist.nl/tips.json", headers: getHeaders())
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        succeed(JSON(value))
                    }
                case .Failure(let error):
                    fail("could not fetch featured videos (\(error))")
                }
        }
    }
    
    //MARK: Popular videos
    
    func getPopular(success succeed: JSON -> () = { popular in }, failure fail : String -> () = {error in }) {
        // get popular
        Alamofire.request(.GET, "http://apps-api.uitzendinggemist.nl/episodes/popular.json", headers: getHeaders())
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        succeed(JSON(value))
                    }
                case .Failure(let error):
                    fail("could not fetch popular videos (\(error))")
                }
        }
    }
    
    //MARK: Recent videos
    
    func getRecent(success succeed: JSON -> () = { recent in }, failure fail : String -> () = {error in }) {
        // get recent
        Alamofire.request(.GET, "http://apps-api.uitzendinggemist.nl/broadcasts/recent.json", headers: getHeaders())
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        succeed(JSON(value))
                    }
                case .Failure(let error):
                    fail("could not fetch recent videos (\(error))")
                }
        }
    }
}