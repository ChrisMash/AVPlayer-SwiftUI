//
//  SUIVideoPlayer.swift
//  AVPlayer-SwiftUI
//
//  Created by Christopher Mash on 24/06/2020.
//  Copyright © 2020 Chris Mash. All rights reserved.
//

import SwiftUI
import AVKit

struct SUIVideoPlayer: View {
    private let player = AVPlayer(url: URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")!)
    
    var body: some View {
        VideoPlayer(player: player)
            .onAppear() {
                // Start the player going, otherwise controls don't appear
                player.play()
            }
    }
}

struct SUIVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        SUIVideoPlayer()
    }
}
