# test_burning_bros

A new Flutter project.

## Getting Started

This project is a test assignment by Nguyen Quoc Vuong

A few step to run project:

1. flutter pub get

/* To generate model */
2. cd core

3. flutter pub run build_runner build --delete-conflicting-outputs

4. cd ..

5. flutter run


## About Project

### Tech & Package used in the project

1. Dio package (REST API)
2. Hive, Hive_Flutter, Hive_generated (local DB)
3. pull_to_refresh (Handle loading more and refresh product list)
4. json_annotation (generate model JSON to handle parse data from response API)
5. Flutter Bloc used to state management
6. Search feature i used SearchDelegate of Flutter
