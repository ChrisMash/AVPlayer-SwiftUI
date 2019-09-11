# AVPlayer-SwiftUI

This repository is the result of my 3-part blog on using AVPlayer in SwiftUI:

* [AVPlayer & SwiftUI](https://medium.com/@chris.mash/avplayer-swiftui-b87af6d0553)
* [AVPlayer & SwiftUI Part 2: Player Controls](https://medium.com/@chris.mash/avplayer-swiftui-part-2-player-controls-c28b721e7e27)
* [AVPlayer & SwiftUI Part 3: More Player Controls]()

Disclaimer: I'm no SwiftUI pro, there are things about this code that don't feel right but it works. And that's something 😁. I'll try and improve it over time! This code is also not battle tested, but seems to be ok!

The following diagram shows the view structs/classes in ContentView.swift:

*(multiple structs/classes in a single file? Yep, I think it's easier to learn from with all these small structs/classes all in the same file, but maybe don't structure your own code this way)*

![alt text](https://github.com/ChrisMash/AVPlayer-SwiftUI/blob/master/uml.png "Structs/classes in ContentView.swift")

The annotations show one of the first things that isn't quite right currently. PlayerUIView doesn't actually care about the videoPos, videoDuration or seeking values, only PlayerControlsView does. But it's the only way I've currently found to make this work.
