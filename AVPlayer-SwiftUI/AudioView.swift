//
//  AudioView.swift
//  AVPlayer-SwiftUI
//
//  Created by Chris Mash on 08/03/2020.
//  Copyright © 2020 Chris Mash. All rights reserved.
//

import SwiftUI
import AVFoundation

struct AudioPlayerControlsView: View {
    private enum PlaybackState: Int {
        case waitingForSelection
        case buffering
        case playing
    }
    
    let player: AVPlayer
    let timeObserver: PlayerTimeObserver
    let durationObserver: PlayerDurationObserver
    let itemObserver: PlayerItemObserver
    @State private var currentTime: TimeInterval = 0
    @State private var currentDuration: TimeInterval = 0
    @State private var state = PlaybackState.waitingForSelection
    
    var body: some View {
        VStack {
            if state == .waitingForSelection {
                Text("Select a song below")
            } else if state == .buffering {
                Text("Buffering...")
            } else {
                Text("Great choice!")
            }
            
            Slider(value: $currentTime,
                   in: 0...currentDuration,
                   onEditingChanged: sliderEditingChanged,
                   minimumValueLabel: Text("\(Utility.formatSecondsToHMS(currentTime))"),
                   maximumValueLabel: Text("\(Utility.formatSecondsToHMS(currentDuration))")) {
                    // I have no idea in what scenario this View is shown...
                    Text("seek/progress slider")
            }
            .disabled(state != .playing)
        }
        .padding()
        // Listen out for the time observer publishing changes to the player's time
        .onReceive(timeObserver.publisher) { time in
            // Update the local var
            self.currentTime = time
            // And flag that we've started playback
            if time > 0 {
                self.state = .playing
            }
        }
        // Listen out for the duration observer publishing changes to the player's item duration
        .onReceive(durationObserver.publisher) { duration in
            // Update the local var
            self.currentDuration = duration
        }
        // Listen out for the item observer publishing a change to whether the player has an item
        .onReceive(itemObserver.publisher) { hasItem in
            self.state = hasItem ? .buffering : .waitingForSelection
            self.currentTime = 0
            self.currentDuration = 0
        }
    }
    
    // MARK: Private functions
    private func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            // Tell the PlayerTimeObserver to stop publishing updates while the user is interacting
            // with the slider (otherwise it would keep jumping from where they've moved it to, back
            // to where the player is currently at)
            timeObserver.pause(true)
        }
        else {
            // Editing finished, start the seek
            state = .buffering
            let targetTime = CMTime(seconds: currentTime,
                                    preferredTimescale: 600)
            player.seek(to: targetTime) { _ in
                // Now the (async) seek is completed, resume normal operation
                self.timeObserver.pause(false)
                self.state = .playing
            }
        }
    }
}

struct AudioView: View {
    let player = AVPlayer()
    private let items = [(url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
                          title: "Song-1"),
                         (url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
                          title: "Song-2")]
    
    var body: some View {
        VStack {
            AudioPlayerControlsView(player: player,
                                    timeObserver: PlayerTimeObserver(player: player),
                                    durationObserver: PlayerDurationObserver(player: player),
                                    itemObserver: PlayerItemObserver(player: player))
            
            List(items, id: \.title) { item in
                Button(item.title) {
                    guard let url = URL(string: item.url) else {
                        return
                    }
                    let playerItem = AVPlayerItem(url: url)
                    self.player.replaceCurrentItem(with: playerItem)
                    self.player.play()
                }
            }
        }
        .onDisappear {
            // When this View isn't being shown anymore stop the player
            self.player.replaceCurrentItem(with: nil)
        }
    }
}

import Combine
class PlayerTimeObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private weak var player: AVPlayer?
    private var timeObservation: Any?
    private var paused = false
    
    init(player: AVPlayer) {
        self.player = player
        
        // Periodically observe the player's current time, whilst playing
        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
            guard let self = self else { return }
            // If we've not been told to pause our updates
            guard !self.paused else { return }
            // Publish the new player time
            self.publisher.send(time.seconds)
        }
    }
    
    deinit {
        if let player = player,
            let observer = timeObservation {
            player.removeTimeObserver(observer)
        }
    }
    
    func pause(_ pause: Bool) {
        paused = pause
    }
}

class PlayerItemObserver {
    let publisher = PassthroughSubject<Bool, Never>()
    private var itemObservation: NSKeyValueObservation?
    
    init(player: AVPlayer) {
        // Observe the current item changing
        itemObservation = player.observe(\.currentItem) { [weak self] player, change in
            guard let self = self else { return }
            // Publish whether the player has an item or not
            self.publisher.send(player.currentItem != nil)
        }
    }
    
    deinit {
        if let observer = itemObservation {
            observer.invalidate()
        }
    }
}

class PlayerDurationObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private let itemObserver: PlayerItemObserver
    private var itemObserverCancellable: AnyCancellable?
    private var durationObservation: NSKeyValueObservation?
    
    init(player: AVPlayer) {
        itemObserver = PlayerItemObserver(player: player)
        // Listen out for the itemObserver publishing a change to the player's item
        itemObserverCancellable = itemObserver.publisher.sink { hasItem in
            if let existingObserver = self.durationObservation {
                existingObserver.invalidate()
                self.durationObservation = nil
            }
            
            if hasItem {
                // Observe the duration of this new item changing (becoming known)
                self.durationObservation = player.currentItem?.observe(\.duration) { [weak self] item, change in
                    guard let self = self else { return }
                    // Publish the new duration
                    self.publisher.send(item.duration.seconds)
                }
            }
        }
    }
    
    deinit {
        if let observer = durationObservation {
            observer.invalidate()
        }
        
        if let cancellable = itemObserverCancellable {
            cancellable.cancel()
        }
    }
}
