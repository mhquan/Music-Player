//
//  FirstViewController.swift
//  Music Player
//
//  Created by QuanMH on 8/21/17.
//  Copyright © 2017 Quan. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer



class SongListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
    var albums: [AlbumInfo] = []
    let albumsQuery = MPMediaQuery()
    var songQuery: SongQuery = SongQuery()

    @IBOutlet weak var myTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        getSongs()
        myTableView.heightAnchor.constraint(equalToConstant: view.frame.size.height - PLAYER_CONTTROLLER_HEIGHT - (tabBarController?.tabBar.bounds.size.height ?? 0)! - (navigationController?.navigationBar.bounds.size.height ?? 0)!).isActive = true
    }

    func getSongs() {
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.albums = self.songQuery.get(songCategory: "Song")
                self.myTableView?.reloadData()
                DispatchQueue.main.async {
                    self.myTableView?.rowHeight = UITableViewAutomaticDimension
                    self.myTableView?.estimatedRowHeight = 60.0
                    self.myTableView.reloadData()
                }
            } else {
                self.displayMediaLibraryError()
            }
        }
    }


    func displayMediaLibraryError() {
        var error: String
        switch MPMediaLibrary.authorizationStatus() {
        case .restricted:
            error = "Media library access restricted by corporate or parental settings"
        case .denied:
            error = "Media library access denied by user"
        default:
            error = "Unknown error"
        }

        let controller = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }))
        present(controller, animated: true, completion: nil)
    }

//

    /*
    func gettingSongNames() {
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        do {
            let songPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

            for song in songPath {
                var mySong = song.absoluteString
                if mySong.contains(".mp3") {
                    let findString = mySong.components(separatedBy: "/")
                    mySong = findString[findString.count - 1]
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    songsRealName.append(mySong)
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ")
                    mySong = mySong.replacingOccurrences(of: "-", with: " ")
                    songsDisplayName.append(mySong)
                }
            }
            myTableView.reloadData()
        }
        catch {
            print ("ERROR")
        }
    }
    */

    @IBAction func moveToPlayer(_ sender: Any) {
        performSegue(withIdentifier: "player", sender: nil)
    }

    @IBAction func play(_ sender: Any) {
    }


    //MARK: set up table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return albums.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums[section].songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let cellTag2 = cell.viewWithTag(2) as! UILabel
        cellTag2.text = albums[indexPath.section].songs[indexPath.row].songTitle

        let cellTag3 = cell.viewWithTag(3) as! UILabel
        cellTag3.text = albums[indexPath.section].songs[indexPath.row].artistName

        let songId: NSNumber = albums[indexPath.section].songs[indexPath.row].songId
        let item: MPMediaItem = songQuery.getItem(songId: songId)

        if let imageSound: MPMediaItemArtwork = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork {
            let cellTag1 = cell.viewWithTag(1) as! UIImageView
            cellTag1.image = imageSound.image(at: CGSize(width: cellTag1.frame.size.width, height: cellTag1.frame.size.height))
        } else {
            let cellTag1 = cell.viewWithTag(1) as! UIImageView
            cellTag1.image = UIImage(named: "note") 
        }
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.title = albums[indexPath.section].songs[indexPath.row].songTitle
        performSegue(withIdentifier: "player", sender: nil)
        let currentSong = albums[indexPath.section].songs[indexPath.row]
        MyAudioPlayer.sharedPlayer.thisSong = currentSong
        /*
        let songId: NSNumber = albums[indexPath.section].songs[indexPath.row].songId
        let item: MPMediaItem = songQuery.getItem(songId: songId)
        let url: URL = item.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
        print(url)
        MyAudioPlayer.sharedPlayer.audioPlayer = try! AVAudioPlayer(contentsOf: url)

        MyAudioPlayer.sharedPlayer.audioPlayer.play()
        */
        MyAudioPlayer.sharedPlayer.play()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "player",
            let nextScene = segue.destination as? PlayerViewController,
            let indexPath = myTableView.indexPathForSelectedRow {
            let currentSong = albums[indexPath.section].songs[indexPath.row]
            nextScene.currentSong = currentSong
        }
    }

}
