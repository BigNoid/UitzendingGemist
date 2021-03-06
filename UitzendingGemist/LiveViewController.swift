//
//  LiveViewController.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 21/07/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import NPOKit
import CocoaLumberjack

class LiveViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var liveCollectionView: UICollectionView!
    
    private var guides: [NPOLive: [NPOBroadcast]]? {
        didSet {
            guard let guides = guides, let oldValue = oldValue, oldValue.count > 0 else {
                self.liveCollectionView.reloadData()
                return
            }
            
            // refresh cells rather than reloading to make the UI behave better
            for (index, channel) in NPOLive.all.enumerated() {
                let path = IndexPath(row: index, section: 0)
                if let cell = self.liveCollectionView.cellForItem(at: path) as? LiveCollectionViewCell {
                    cell.configure(withLiveChannel: channel, andGuide: guides[channel])
                }
            }
        }
    }
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGuides()
        
        // observe when we are foregrounded
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func applicationWillEnterForeground() {
        fetchGuides()
    }
    
    // MARK: Networking
    
    private func fetchGuides() {
        NPOManager.sharedInstance.getGuides(forChannels: NPOLive.all, onDate: Date()) { [weak self] guides, errors in
            // log errors if we have any
            for (channel, error) in errors ?? [NPOLive: NPOError]() {
                DDLogError("Could not get guide for '\(channel)' (\(error))")
            }
            
            self?.guides = guides
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NPOLive.all.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCells.live.rawValue, for: indexPath)
        
        guard let liveCell = cell as? LiveCollectionViewCell, indexPath.row >= 0 && indexPath.row < NPOLive.all.count else {
            return cell
        }
        
        let channel = NPOLive.all[indexPath.row]
        liveCell.configure(withLiveChannel: channel, andGuide: self.guides?[channel])
        return liveCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row >= 0 && indexPath.row < NPOLive.all.count, let cell = collectionView.cellForItem(at: indexPath) as? LiveCollectionViewCell else {
            return
        }
        
        let channel = NPOLive.all[indexPath.row]
        
        var channelDescription = ""
        if let current = cell.currentLabel.text {
            channelDescription += current
        }
        if let upcoming = cell.upcommingLabel.text {
            if channelDescription != "" { channelDescription += ", " }
            channelDescription += upcoming
        }
        
        self.play(liveChannel: channel, channelImage: cell.channelImageView.image, channelDescription: channelDescription)
    }
    
    // MARK: Playing
    
    fileprivate func play(liveChannel channel: NPOLive, channelImage: UIImage?, channelDescription: String?) {
        // show progress hud
        self.view.startLoading()
        
        // live streams do not have a separate closed captioning resource, instead
        // they have a different (and unfortunately often a lower quality) stream
        let closedCaptioningEnabled = UserDefaults.standard.bool(forKey: UitzendingGemistConstants.closedCaptioningEnabledKey)
        let liveChannel = closedCaptioningEnabled ? channel.sdhChannel() : channel
        
        NPOManager.sharedInstance.getVideoStream(forLiveChannel: liveChannel) { [weak self] url, error in
            // hide progress hud
            self?.view.stopLoading()
            
            guard let url = url else {
                if let alternativeChannel = channel.configuration.alternativeChannel {
                    DDLogDebug("No stream for channel \(channel.configuration.name), switching to alternative channel \(alternativeChannel.configuration.name)")
                    self?.play(liveChannel: alternativeChannel, channelImage: nil, channelDescription: nil)
                } else {
                    DDLogError("Could not play live stream (\(String(describing: error)))")
                }
                return
            }
            
            let playerViewController = NPOPlayerViewController()
            let configuration = channel.configuration
            let metadata: [String: Any?] = [
                AVMetadataCommonKeyTitle: configuration.name,
                AVMetadataCommonKeyDescription: channelDescription,
                AVMetadataCommonKeyArtwork: channelImage
            ]
            
            self?.present(playerViewController, animated: true) {
                playerViewController.play(videoStream: url, externalMetadata: metadata)
            }
        }
    }
}
