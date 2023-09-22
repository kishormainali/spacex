# spacex

project to demonstrate SpaceX Launches


## Prerequisites
- lcov
- flutter 3.13.4
- dart 3.1.2

 If **lcov** is not installed on your system install using `brew install lcov` on MacOS systems

for more on lcov please visit https://github.com/linux-test-project/lcov

for more on flutter please visit https://flutter.dev

## Packages Used

- **flutter_bloc** as state management
- **auto_route** as routing
- **get_it** as dependency injection
- **injectable** as code generation for get_it
- **dio** for http requests
- **freezed** and **json_serializable** for model classes and states
- **fpdart** for functional programming
- **cached_network_image** for render network images

## Setting up Project

- clone project using https://github.com/kishormainali/spacex.git
- run  `flutter pub get`
- run `dart run build_runner build -d`


# Run project
- run using `flutter run` or IDE's default run configurations 


# Run Tests
- Generate `coverage/lcov.info` file using `flutter test --coverage`

- Generate HTML report using `genhtml coverage/lcov.info -o coverage/html`


- Open the report using `open coverage/html/index.html`

- if you want to run test without coverage run `flutter test` on project root

# Screenshots

| ![Launces](/resources/list.png) | ![Details](/resources/details.png) |
|-|-|


# Disclaimer
Author and app is not affiliated, associated, authorized, endorsed by, or in any way officially connected with Space Exploration Technologies Corp (SpaceX), or any of its subsidiaries or its affiliates. The names SpaceX as well as related names, marks, emblems and images are registered trademarks of their respective owners. This is not an official SpaceX app.