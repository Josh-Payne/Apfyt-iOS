# Apfyt
# iOS app with OpenCV

This app is the consumer facing side of Apfyt. With it, a user can scan an Apfyt code, access the corresponding survey from the server, and store data about their purchase, coupons, and other helpful incentives. Users log in through Facebook. To build, run ```$ pod install ``` and ```$ carthage update ``` to gather the frameworks needed, including OpenCV for iOS, Alamofire, ResearchKit, Cosmos, and SwiftyJSON. Carthage was having some issues building the iOS framework bundle so I've included the build folder from my own project. Once Carthage creates that directory, just move the contents of the folder to it. The app's scanner will not work in the simulator.

Additionally, the ResearchKit framework has a small issue having to do with the
iOS versions available. To fix this, replace lines 42-45 in
ORKHealthAnswerFormat.swift
```
return HKBiologicalSex.other
        default:
            return nil
        }
```
 with 

```if #available(iOS 8.2, *) {
                return HKBiologicalSex.other
            } else {
                // Fallback on earlier versions
            }
        default:
            return nil
        }
        return nil
```

This repository has been moved to omit frameworks with large file sizes. I'm currently working on other projects and will return soon to implement
the principles of OOP learned in CS 108.
