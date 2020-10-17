//
//  MenuView.swift
//  AVPlayer-SwiftUI
//
//  Created by Chris Mash on 08/03/2020.
//  Copyright © 2020 Chris Mash. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: VideoView()) {
                    Text("Parts 1-3: Custom Video Player")
                }
                NavigationLink(destination: AudioView()) {
                    Text("Part 4: Custom Audio Player")
                }
                NavigationLink(destination: SUIVideoPlayer()) {
                    Text("Part 5: SwiftUI's own VideoPlayer!")
                }
            }
        }
    }
}
