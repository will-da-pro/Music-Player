//
//  ContentView.swift
//  Music Player
//
//  Created by William D'Olier on 15/11/2023.
//

import SwiftUI
import SwiftData
import AVFoundation

var audioPlayer: AVAudioPlayer!

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var selectedFile: URL?
    @State var filename = "Filename"
    @State var showFileChooser = false
    @State var isPlaying = false

    var body: some View {
        @State var showFileChooser = false
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        VStack {
                            Button(action: {
                                togglePlay(item: item)
                            }) {
                                Label(isPlaying ? "Pause" : "Play", systemImage: isPlaying ? "pause.fill" : "play.fill")
                                    .scaleEffect(10)
                                    .frame(width: 120, height: 120)
                            }
                            .labelStyle(.iconOnly)
                            .buttonStyle(.borderless)
                        }
                    } label: {
                        Text(item.name)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    private func togglePlay(item: Item) {
        let url: URL = item.url
        if (audioPlayer.url != item.url) {
            audioPlayer = try! AVAudioPlayer(contentsOf: url)
        }
        
        if !isPlaying {
            audioPlayer.play()
        }
        else {
            audioPlayer.pause()
        }
        
        isPlaying = !isPlaying
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
