//
//  SongQuerry.swift
//  Music Player
//
//  Created by QuanMH on 8/24/17.
//  Copyright © 2017 Quan. All rights reserved.
//
import MediaPlayer
import Foundation

class SongQuery {

    func get(songCategory: String) -> [AlbumInfo] {

        var albums: [AlbumInfo] = []
        let albumsQuery: MPMediaQuery
        if songCategory == "Artist" {
            albumsQuery = MPMediaQuery.artists()
        } else if songCategory == "Album" {
            albumsQuery = MPMediaQuery.albums()
        } else if songCategory == "Song" {
            albumsQuery = MPMediaQuery.songs()
        } else {
            albumsQuery = MPMediaQuery.albums()
        }
        
        // let albumsQuery: MPMediaQuery = MPMediaQuery.albums()
        if let albumItems: [MPMediaItemCollection] = albumsQuery.collections {
        //  var album: MPMediaItemCollection

        for album in albumItems {
            let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
            // var song: MPMediaItem

            var songs: [SongInfo] = []

            var albumTitle: String = ""

            for song in albumItems {
                if songCategory == "Artist" {
                    albumTitle = song.value(forProperty: MPMediaItemPropertyArtist) as! String
                } else if songCategory == "Album" {
                    albumTitle = song.value(forProperty: MPMediaItemPropertyAlbumTitle) as! String
                } else if songCategory == "Song" {
                    albumTitle = song.value(forProperty: MPMediaItemPropertyAlbumTitle) as! String
                } else {
                    albumTitle = song.value(forProperty: MPMediaItemPropertyAlbumTitle) as! String
                }
                var albumName = ""
                var artistTitle = ""
                if let title = song.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String {
                    albumName = title
                }
                if let name = song.value(forProperty: MPMediaItemPropertyArtist) as? String {
                    artistTitle = name
                }
                
                let songInfo: SongInfo = SongInfo(
                    albumTitle: albumName,
                    artistName: artistTitle,
                    songTitle: song.value(forProperty: MPMediaItemPropertyTitle) as! String,
                    songId: song.value(forProperty: MPMediaItemPropertyPersistentID) as! NSNumber
                )
                songs.append(songInfo)
            }
            let albumInfo: AlbumInfo = AlbumInfo(

                albumTitle: albumTitle,
                songs: songs
            )
            albums.append(albumInfo)
        }
            
        }
        return albums
    }

    func getItem(songId: NSNumber) -> MPMediaItem {
        let property: MPMediaPropertyPredicate = MPMediaPropertyPredicate(value: songId, forProperty: MPMediaItemPropertyPersistentID)
        let query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate(property)
        var items: [MPMediaItem] = query.items! as [MPMediaItem]
        return items[items.count - 1]
    }
}
