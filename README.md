# Udacity iOS Nanodegree Capstone Project

This is the repository for my final project for [Udacity's iOS Developer Nanodegree.](https://www.udacity.com)

## Description
GameCollector is a game finder app: the app uses the IGDB games database to find games, and the user can add those games in his collection, or on a wishlist. The user can search games by name, genre and platform.

![Games Listing](/Screenshots/Screenshot01.png?raw=true "Games Listing")
![Menu](/Screenshots/Screenshot02.png?raw=true "Menu")
![Game Details](/Screenshots/Screenshot03.png?raw=true "Game Details")
![Collection](/Screenshots/Screenshot04.png?raw=true "Collection")
![Wishlist](/Screenshots/Screenshot05.png?raw=true "Wishlist")

## Environment

Since technology is ever evolving, and Apple updates it's development environment yearly, deprecating features and updating languages fast, I cannot guarantee for how long this code will continue working. This app was created with the following environment in mind:

* OSX Mojave
* XCode 10
* Swift 4.2
* iOS 12

While backwards compatibility and automatic conversion may work for future versions, there may be errors and inconsistencies.

### Cocoa Pods

This project uses [CocoaPods](https://cocoapods.org/) for it's dependencies. To initalize the project you should first install CocoaPods and then initialize the dependencies by running

> pod install

After that, open the project using the Itch.xcworkspace created by CocoaPods.

#### Libraries used by this project:
* [TagListView](https://github.com/ElaWorkshop/TagListView)

## Limitations
* Unfortunately, I could not test any features that require a physical device, like the camera functionality, since I don't have an Apple developer subscription.
* The user collection is stored locally using CoreData. 
* Some of the search and filtering options, like the number of results and offsets, may be limited by the IGDB Free API limitations.


## Contributing
Since this project is a personal project created for education pruposes, no external contributions will be accepted. However, you are free to fork and study the code! If you want to use this code on your own application, feel free to do so, following this repository's license. Just remember, when presenting Udacity projects, you should follow Udacity's code of conduct. If you are checking this project to help on your own Udacity project, feel free to use this code for inspiration, but please try to make everything on your own.

## License
The contents of this repository are covered under the [MIT License](LICENSE).
