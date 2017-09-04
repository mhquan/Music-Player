//
//  PlayerView.swift
//  Music Player
//
//  Created by QuanMH on 8/25/17.
//  Copyright © 2017 Quan. All rights reserved.
//

import UIKit

class PlayerView: UIView {

    @IBOutlet weak var imgSongIcon: UIImageView!
    @IBOutlet weak var lblSongname: UILabel!
    @IBOutlet weak var lblSongArtist: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imgPlayPause: UIButton!
    @IBAction func btnPlay(_ sender: Any) {
        if MyAudioPlayer.sharedPlayer.thisSong != nil {
        MyAudioPlayer.sharedPlayer.playAndPause()
        updatePlaybutton()
        }
    }
    
    
    @IBOutlet weak var contentView: UIView!
    
    func updatePlaybutton() {
        if MyAudioPlayer.sharedPlayer.thisSong != nil {
            print("audio player khac nil")
            if MyAudioPlayer.sharedPlayer.audioPlayer.isPlaying == true {
                imgPlayPause.setImage(UIImage.init(named: "pause-128"), for: UIControlState.normal)
            } else {
                imgPlayPause.setImage(UIImage.init(named: "play-128"), for: UIControlState.normal)
            }
        } else {
            print("audio player = nil")
            imgPlayPause.setImage(UIImage.init(named: "play-128"), for: UIControlState.normal)
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Private Helper Methods
    
    // Performs the initial setup.
    private func setupView() {
        Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)
        contentView.frame = self.bounds
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
