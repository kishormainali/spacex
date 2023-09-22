# spacex

SpaceX is an open-source app that provides information of Flight Launches of SpaceX built with [Flutter](https://flutter.dev)

The app is currently in the stage of development and only displays launches and launch details with rocket and site information. This app uses API from https://github.com/r-spacex/SpaceX-API.

The project uses clean architecture and test driven development for development process.


# Built With
- [macOS](https://www.apple.com/macos/ventura/)
- [IntelliJ Idea](https://www.jetbrains.com/idea/)
- [XCode 15](https://developer.apple.com/xcode/)


## Prerequisites
- lcov
- flutter 3.13.4
- dart 3.1.2

### Install lcov 
```sh
    brew install lcov
```

> As we are using macOS for development environment, installation of lcov is different on other operating system. please visit https://github.com/linux-test-project/lcov for more info on lcov.

for more on flutter please visit https://flutter.dev

## Packages Used

- **[flutter_bloc](https://pub.dev/packages/flutter_bloc)** as state management
- **[auto_route](https://pub.dev/packages/auto_route)** as routing
- **[get_it](https://pub.dev/packages/get_it)** as dependency injection
- **[injectable](https://pub.dev/packages/injectable)** as code generation for get_it
- **[dio](https://pub.dev/packages/dio)** for http requests
- **[freezed](https://pub.dev/packages/freezed)** and **[json_serializable](https://pub.dev/packages/json_serializable)** for model classes and states
- **[fpdart](https://pub.dev/packages/fpdart)** for functional programming
- **[cached_network_image](https://pub.dev/packages/cached_network_image)** for render network images

## Download and Install

First, clone the project with `git clone` command or download the zip file

```sh
    git clone https://github.com/kishormainali/spacex.git
```

Run, `flutter pub get` to install dependencies
```sh
    flutter pub get
```

Run, `build_runner` to generate code for models, dependency injections and bloc states

```sh
    dart run build_runner build -d
```


# Run Locally
- [Download and Install](#Download-and-Install)
- To run project locally you can use IDE's run button or you can run using `flutter run` command.
```sh
    flutter run
```

# Install Using APK

- Download [APK](resources/spacex.apk)
- Open using android file manager or tap on downloaded file
- If install is blocked from unknown sources, Tap allow install from unknown sources.
- If popup is not displayed during install time goto settings > apps > Chrome > check install from unknown sources


# Run Test Cases

Generate `coverage/lcov.info` file using
```sh
flutter test --coverage
```

Generate HTML report using
```sh
genhtml coverage/lcov.info -o coverage/html
```
Open the report using
```sh
open coverage/html/index.html
```

if you want to run test without coverage run `flutter test` on project root
```sh
flutter test
```

# Screenshots

| ![Launces](/resources/list.png) | ![Details](/resources/details.png) |
|-|-|


# Known Issues
As we are using *full_text_search* for searching functionality, sometimes it will search using launch name instead of rocket name.


# Disclaimer
Author and app is not affiliated, associated, authorized, endorsed by, or in any way officially connected with Space Exploration Technologies Corp (SpaceX), or any of its subsidiaries or its affiliates. The names SpaceX as well as related names, marks, emblems and images are registered trademarks of their respective owners. This is not an official SpaceX app.