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
                    Text("Parts 1-3: Video Player")
                }
                NavigationLink(destination: AudioView()) {
                    Text("Part 4: Audio Player")
                }
            }
        }
    }
}
