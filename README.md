# AVPlayer-SwiftUI

This repository is the result of my 4-part blog on using AVPlayer in SwiftUI:

* [AVPlayer & SwiftUI](https://medium.com/@chris.mash/avplayer-swiftui-b87af6d0553)
* [AVPlayer & SwiftUI Part 2: Player Controls](https://medium.com/@chris.mash/avplayer-swiftui-part-2-player-controls-c28b721e7e27)
* [AVPlayer & SwiftUI Part 3: More Player Controls](https://medium.com/@chris.mash/avplayer-swiftui-part-3-more-player-controls-e64558875f8e)
* [AVPlayer & SwiftUI Part 4: Better Player Observing](https://medium.com/@chris.mash/avplayer-swiftui-part-4-better-player-observing-3e5c3f24419d)

Disclaimer: I'm no SwiftUI pro, there are things about this code that don't feel right but it works. And that's something 😁. I'll try and improve it over time! This code is also not battle tested, but seems to be ok!

The app starts off with a menu to select between a video player or an audio player. Parts 1-3 refer to the video player. Part 4 refers to the audio player.

## Parts 1-3: Video Player Controls

The following diagram shows the view structs/classes in VideoView.swift:

*(multiple structs/classes in a single file? Yep, I think it's easier to learn from with all these small structs/classes all in the same file, but maybe don't structure your own code this way)*

![alt text](https://github.com/ChrisMash/AVPlayer-SwiftUI/blob/master/img/uml-videoview.png "Structs/classes in VideoView.swift")

The annotations show one of the first things that isn't quite right. VideoPlayerUIView doesn't actually care about the videoPos, videoDuration or seeking values, only VideoPlayerControlsView does. But at the time of writing part 3 of the blog series it was the only way I'd found to make it work.

## Part 4: Better Observation of the Player

As mentioned above one of the issues I had at the end of Part 3 was that I was observing the player's time and duration in VideoPlayerUIView, which didn't actually care about those values. Since then I've found a better way to observe the values elsewhere, and in fact if it's only audio playing then the VideoPlayerUIView isn't required at all, so for that reason it's presented as just an audio player.

Part 4 also allows switching what the player is playing, which was a bit of a problem in the prior parts of the blog.

The following diagram shows the view structs/classes in AudioView.swift:

![alt text](https://github.com/ChrisMash/AVPlayer-SwiftUI/blob/master/img/uml-audioview.png "Structs/classes in AudioView.swift")
