//
//  YouTubeViewController.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 18/11/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import UIKit
import CocoaLumberjack
import NPOKit
import AVKit

class YouTubeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    fileprivate var program: NPOProgram?
    fileprivate var videos: [NPOYouTubeVideo]? {
        didSet {
            videoCollectionView.reloadData()
        }
    }

    // MARK: View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel.text = program?.name
    }
    
    // MARK: Configuration
    
    func configure(withProgram program: NPOProgram) {
        self.program = program
        
        // show progress hud
        view.startLoading()
        
        NPOManager.sharedInstance.getYouTubeVideos(forProgram: program) { [weak self] videos, _ in
            self?.view.stopLoading()
            
            guard let videos = videos else {
                DDLogError("Could not fetch youtube videos for program \(String(describing: program.name))")
                return
            }
            
            self?.videos = videos
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCells.youTube.rawValue, for: indexPath)
        
        guard let youTubeCell = cell as? YouTubeCollectionViewCell, let videos = self.videos, indexPath.row >= 0 && indexPath.row < videos.count else {
            return cell
        }
        
        youTubeCell.configure(withYouTubeVideo: videos[indexPath.row])
        
        return youTubeCell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        guard let videos = self.videos, let indexPath = context.nextFocusedIndexPath else {
            return
        }

        let video = videos[indexPath.row]
        
        // get image
        _ = NPOManager.sharedInstance.getImage(forYouTubeVideo: video, ofSize: self.backgroundImageView.frame.size) { [weak self] image, _ in
            guard let image = image else {
                return
            }
            
            self?.backgroundImageView.image = image
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let videos = self.videos, indexPath.row >= 0 && indexPath.row < videos.count else {
            return
        }

        play(youTubeVideo: videos[indexPath.row])
    }
    
    // MARK: Play YouTube video
    
    fileprivate func play(youTubeVideo video: NPOYouTubeVideo) {
        // show progress hud
        view.startLoading()
        
        // play video
        NPOManager.sharedInstance.getPlayerItem(youTubeVideo: video) { [weak self] playerItem, _ in
            // show progress hud
            self?.view.stopLoading()
            
            // set up player
            let player = AVPlayer(playerItem: playerItem)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            // when the player reached the end of the video, pause the video
            player.actionAtItemEnd = .pause
            
            // present player
            self?.present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }
        }
    }
}
