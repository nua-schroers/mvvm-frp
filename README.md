# MVVM and FRP: Perfect architectures for mobile development?

![Swift 3.1.x](https://img.shields.io/badge/Swift-3.1.x-orange.svg) ![platforms](https://img.shields.io/badge/platforms-iOS-lightgrey.svg) [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/nua-schroers/mvvm-frp/master/LICENSE) ![Travis build](https://travis-ci.org/nua-schroers/mvvm-frp.svg?=master)

What every developer should know about MVVM and FRP.

This set of files accompanies a presentation at the [Developer Week 2016](http://www.developer-week.de) conference, Nuremberg, Germany. See http://dwx2016.nua-schroers.de for further information (in German). *It has been updated for compatibility with Swift 3.*

## The match game

Concepts of the presentation are the MVVM (model-view-view model) architecture and FRP (functional reactive programming). A sample app illustrates the concepts by giving different ways to implement a simple game using different architectures and paradigms.

All sample codes are written in the Swift programming language version 3 and require Xcode 8 or higher. They have been tested on MacOS X (version 10.11.6) and iOS (version 10.2).

## Directories

The following directories are used:
* `01_Common` : Contains files used by several projects, like graphics resources, the data model and the custom view.
* `10_Commandline-App` : A command line version of the match game to demonstrate the data model.
* `20_Basic-App` : An iPhone app version of the match game implemented using a classic MVC architecture.
* `30_MVVM-App` : The iPhone app using the MVVM architecture, but no further external dependencies.
* `40_MVVM_FRP-App/Matchgame` : The iPhone app using the MVVM architecture and FRP with [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa/).
* `41_MVVM_FRP-App_ExplicitSignals` : Variant of the MVVM/FRP app which illustrates how to use, map and combine signals to enable/disable the "Take 2" button.
* `42_MVVM_FRP-App_WarningDialog` : Variant of the MVVM/FRP app which introduces a behavior/workflow change and displays a dialog in certain situations when leaving the settings screen.

*NOTE:* Currently, the MVVM-FRP app uses a pre-release version of the ReactiveCocoa library. This code may change since the library is not yet API stable. This is necessary, because Swift 3 is not (yet) supported in a stable release.

## Installation and use

For the command line version, the MVC and the MVVM apps, simply open the project file `Matchgame.xcodeproj` in the corresponding `Matchgame` subfolder.

For the MVVM-FRP app in addition [carthage](https://github.com/Carthage/Carthage) is required. Prior to opening the project file, please run

    cd 40_MVVM_FRP-App/Matchgame/ ; carthage update --platform iOS

to install the necessary dependencies.

## License and attribution

Documentation and associated written materials are subject to the [CC BY-NC-SA 4.0 license](http://creativecommons.org/licenses/by-nc-sa/4.0/ "CC BY-NC-SA 4,0 license").

The accompanying software is copyright (c) 2012-2017 Dr. Wolfram Schroers, [Numerik & Analyse Schroers](http://nua-schroers.de) and subject to the conditions in the file `LICENSE`.

The launch image and the icons are modified copies of a photo by Derek Gavey which has been licensed under the
[CC-BY 2.0 license](https://creativecommons.org/licenses/by/2.0/ "CC-BY 2.0 license"). The photo is available on [Flikr](https://www.flickr.com/photos/derekgavey/6068317482/in/photolist-afeHnu-dMRh3f-cMzkD7-anpD7m-cMzmb1-cMzkSC-cMzkL1-7JK2PQ-eUFjFB-6ZQjg-eMHzom-k1Zee3-aMFVAe-8L2DU7-nB2Gwq-ESkxeS-dMFLbJ-838DFC-dsaPqJ-9HzTP4-6V5jtx-6JPnvN-okwZka-DJk-pWdwJK-8cJ4gS-ozmrHo-krczSP-ikFion-9HgNMm-bHk1Pc-7JF7dx-yZs8f-6k4EGJ-6msS1R-6AK9Vu-k6iRYW-jAEaKT-6AF3Sa-btkq1c-6AF2cv-6AKd2h-6AK8Qu-dz4cat-6G73ii-5Syqj7-pZFQKz-onzJgm-f7UZ3i-6AF1X6 "Flikr link").
