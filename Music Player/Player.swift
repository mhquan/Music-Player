//
//  Player.swift
//  Music Player
//
//  Created by QuanMH on 8/28/17.
//  Copyright © 2017 Quan. All rights reserved.
//

import Foundation
import MediaPlayer
import AVFoundation

struct SongInfo {
    var albumTitle: String
    var artistName: String
    var songTitle: String
    var songId: NSNumber = 0
}

struct AlbumInfo {
    var albumTitle: String
    var songs: [SongInfo]
}

class MyAudioPlayer: NSObject, AVAudioPlayerDelegate {
    var albumInfo: AlbumInfo?
    var albums: [AlbumInfo] = []
    var songList: [SongInfo] = []
    var songListName: [String] = []
    var thisSong: SongInfo?
    var audioStuffed = false
    let audioInfo = MPNowPlayingInfoCenter.default()
    var myMusicPlayer: MPMusicPlayerController?
    let masterVolumeSlider: MPVolumeView = MPVolumeView()
    let shouldShowSearchResults = false
    var songPosition = 0
    var audioPlayer = AVAudioPlayer()

    // songinfo
    // songlist

    // play
    // pause
    // next

    static var sharedPlayer: MyAudioPlayer = {
        return MyAudioPlayer()
    }()

    private override init() {
    }

    func next() {
        if songPosition < songList.count - 1{
            songPosition = songPosition + 1
            thisSong = songList[songPosition]
        }
        play()
    }

    func previous() {
        if songPosition > 0 {
            songPosition = songPosition - 1
            thisSong = songList[songPosition]
        }
        play()

    }

    func shuffleSong() {

    }

    func repeatSong() {

    }

    func play() {
        let songID = thisSong?.songId
        if songID != 0 && songID != nil {
            let item: MPMediaItem = SongQuery().getItem(songId: songID!)
            let url: URL = item.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
            audioPlayer = try! AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } else if songID == nil {
            print("songID = nil")
        }
    }
    func playAndPause() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }
}
