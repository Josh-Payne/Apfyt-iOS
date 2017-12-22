# appfyt
# iOS-OpenCV-apfyt

This app is the consumer facing side of Apfyt. With it, a user can scan an Apfyt code, access the corresponding survey from the server, and store data about their purchase, coupons, and other helpful incentives. Users log in through Facebook. To build, run ```$ pod install ``` and ```$ carthage update ``` to gather the frameworks needed, including OpenCV for iOS, Alamofire, ResearchKit, Cosmos, and SwiftyJSON. Carthage was having some issues building the iOS framework bundle so I've included the build folder from my own project. Once Carthage creates that directory, just move the contents of the folder to it. The app's scanner will not work in the simulator.

This repository has been moved to omit frameworks with large file sizes. The
author is currently working on other projects and will return soon to implement
the principles of OOP learned in CS 108.
