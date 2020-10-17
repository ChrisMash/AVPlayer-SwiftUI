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
    
    init() {
        // start the player playing, controls don't appear without this
        player.play()
    }
    
    var body: some View {
        VideoPlayer(player: player)
    }
}

struct SUIVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        SUIVideoPlayer()
    }
}
