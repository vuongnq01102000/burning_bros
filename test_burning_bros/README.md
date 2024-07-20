# test_burning_bros

A test of Burning Bros.

## Getting Started

This project is a test assignment by Nguyen Quoc Vuong

A few steps to run the project:

1. flutter pub get

#### Generated Model Json 
2. cd core

3. flutter pub run build_runner build --delete-conflicting-outputs

#### Run project
4. cd ..

5. flutter run


## About Project

### Tech & Package used in the project

1. Dio package (REST API)
2. Hive, Hive_Flutter, Hive_generated (local DB)
3. pull_to_refresh (Handle loading more and refresh product list)
4. json_annotation (generate model JSON to handle parse data from response API)
5. Flutter Bloc used to state management
6. Search feature I used SearchDelegate of Flutter
7. Internet connection checker package

### Structure Project
- TEST_BURNING_BROS
  - -- android (native)
  - -- ios (native)
  - -- lib (library)
    - --- core (contains model data, network service, types)
      - ---- network_client (contains defined class protocols to communicate with the server, and interceptor to handle auth(if you need & log exception))
      - ---- models (contains model data used json_annotation to define class model)
      - ---- services (contains services to be used in the app (connectivity))
      - ---- types (contains defines a new data type)
    - --- src (contains screens app and utilities)
      - ---- screens app (defined UI feature)
      - ---- utils (contains utilities to be used in the app)
    - --- app_config.dart (configuration management in your Flutter app.)
    - --- main.dart
    - ...etc

# Thanks for watching ❤️
### Please get in touch with me if you need more info 
#### --- nqvuongdev@gmail.com ---