//
//  ContentView.swift
//  Music Player
//
//  Created by William D'Olier on 15/11/2023.
//

import SwiftUI
import SwiftData
import AVFoundation


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var selectedFile: URL?
    @State var filename: String = "Filename"
    @State var showFileChooser: Bool = false
    @ObservedObject var musicPlayer = MusicPlayer()
    
    var body: some View {
        @State var showFileChooser = false
        
        VStack(spacing: 0) {
            List {
                ForEach(items) { item in
                    HStack {
                        Text(item.name)
                        
                        Spacer()
                        
                        Button(action: {
                            musicPlayer.togglePlay(item: item)
                        }) {
                            Label(musicPlayer.isPlaying && musicPlayer.currentSong == item ? "Pause" : "Play", systemImage: musicPlayer.isPlaying && musicPlayer.currentSong == item ? "pause.fill" : "play.fill")
                        }
                        .labelStyle(.iconOnly)
                        .buttonStyle(.borderless)
                        
                        Button(action: {
                            let index = items.firstIndex(of: item)
                            deleteItem(index: index!)
                        }) {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        .labelStyle(.iconOnly)
                        .buttonStyle(.borderless)
                    }
                }
            }
            
            VStack(spacing: 5) {
                Text(musicPlayer.currentSong == nil ? items.count == 0 ? "-" : items[0].name : musicPlayer.currentSong!.name)
                
                HStack(spacing: 0) {
                    Button(action: {
                        
                    }) {
                        Label("Backward", systemImage: "gobackward.10")
                            .frame(width: 40, height: 40)
                            .scaleEffect(1.5)
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.borderless)
                    
                    Button(action: {
                        if let item = musicPlayer.currentSong {
                            musicPlayer.togglePlay(item: item)
                        } else {
                            musicPlayer.togglePlay(item: items[0])
                        }
                    }) {
                        Label(musicPlayer.isPlaying ? "Pause" : "Play", systemImage: musicPlayer.isPlaying ? "pause.fill" : "play.fill")
                            .frame(width: 50, height: 50)
                            .scaleEffect(3)
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.borderless)
                    
                    Button(action: {
                        
                    }) {
                        Label("Forward", systemImage: "goforward.10")
                            .frame(width: 40, height: 40)
                            .scaleEffect(1.5)
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.borderless)
                }
                
                Text(musicPlayer.audioPlayer == nil ? "-" : String(musicPlayer.audioPlayer.currentTime) + " - " + String(musicPlayer.audioPlayer.duration))
            }
            .frame(maxWidth: .infinity)
            .padding(10)
        }
        .toolbar {
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let panel = NSOpenPanel()
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = false
            if panel.runModal() == .OK {
                if let fileDir: URL = panel.url {
                    let fileName = fileDir.lastPathComponent
                    let newItem = Item(name: fileName, url: fileDir)
                    
                    modelContext.insert(newItem)
                }
            }
        }
    }

    private func deleteItem(index: Int) {
        withAnimation {
            modelContext.delete(items[index])
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
