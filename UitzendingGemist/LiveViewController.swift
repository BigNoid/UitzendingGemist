//
//  LiveViewController.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 12/6/15.
//
//

import Foundation

import Foundation
import UIKit
import SwiftyJSON
import AVKit

class LiveViewController: UICollectionViewController {
    var streams:[Dictionary<String, String>]?
    let UGManager = UitzendingGemistManager.sharedInstance
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        streams = [
            ["name": "NPO 1",
                "stream": "http://livestreams.omroep.nl/live/npo/tvlive/ned1/ned1.isml/ned1.m3u8"],
            ["name": "NPO 2",
                "stream": "http://livestreams.omroep.nl/live/npo/tvlive/ned2/ned2.isml/ned2.m3u8"],
            ["name": "NPO 3",
                "stream": "http://livestreams.omroep.nl/live/npo/tvlive/ned3/ned3.isml/ned3.m3u8"],
            ["name": "NPO Nieuws",
                "stream": "http://livestreams.omroep.nl/live/npo/thematv/journaal24/journaal24.isml/journaal24.m3u8"],
            ["name": "NPO Cultura",
                "stream": "http://livestreams.omroep.nl/live/npo/thematv/cultura24/cultura24.isml/cultura24.m3u8"],
            ["name": "NPO 101",
                "stream": "http://livestreams.omroep.nl/live/npo/thematv/101tv/101tv.isml/101tv.m3u8"],
            ["name": "NPO Politiek",
                "stream": "http://livestreams.omroep.nl/live/npo/thematv/politiek24/politiek24.isml/politiek24.m3u8"],
            ["name": "NPO Best",
                "stream": "http://livestreams.omroep.nl/live/npo/thematv/best24/best24.isml/best24.m3u8"],
            ["name": "NPO Doc",
                "stream": "http://livestreams.omroep.nl/live/npo/thematv/hollanddoc24/hollanddoc24.isml/hollanddoc24.m3u8"],
            ["name": "NPO Zappelin",
                "stream": "http://livestreams.omroep.nl/live/npo/thematv/zappelin24/zappelin24.isml/zappelin24.m3u8"],
            ["name": "NPO Humor TV",
                "stream": "http://livestreams.omroep.nl/live/npo/thematv/humor24/humor24.isml/humor24.m3u8"]
        ]
    }
    
    //MARK: Collection View Datasource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (streams != nil) ? streams!.count : 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LiveCollectionViewCell", forIndexPath: indexPath) as! LiveCollectionViewCell
        cell.name = streams![indexPath.row]["name"]
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let streamURL = streams![indexPath.row]["stream"] {
            playVideo(streamURL)
        }
    }
    
    //MARK: Video player
    
    func playVideo(url: String) {
        UGManager.getLiveStreamURL(url, success: { url in
            let player = AVPlayer(URL: NSURL(string: url)!)
            let playerViewController = PlayerViewController()
            playerViewController.player = player
            
            self.presentViewController(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }) { error in
            debugPrint("could not get video stream for stream url '\(url)' (\(error))")
        }
    }
}