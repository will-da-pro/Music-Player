//
//  MusicPlayer.swift
//  Music Player
//
//  Created by William D'Olier on 24/11/2023.
//

import SwiftUI
import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer!

class MusicPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying: Bool = false
    @Published var currentSong: Item? = nil
    @Published var audioPlayer: AVAudioPlayer!
    
    public func togglePlay(item: Item) {
        let url: URL = item.url
        
        if let _ = audioPlayer {
            if (audioPlayer.url != url) {
                audioPlayer = try! AVAudioPlayer(contentsOf: url)
                audioPlayer.delegate = self
            }
        } else {
            audioPlayer = try! AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
        }
        
        if !isPlaying {
            currentSong = item
            audioPlayer.play()
            
            isPlaying = true
        }
        else {
            audioPlayer.pause()
            isPlaying = false
            
            if currentSong != item {
                currentSong = item
                audioPlayer.play()
                
                isPlaying = true
            }
        }
    }
    
    func forward() {
        
    }
    
    func backward() {
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
