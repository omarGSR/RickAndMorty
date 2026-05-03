# 📱 Rick And Morty App Lite

## Overview

Rick & Morty App Lite is an iOS application built in Swift that consumes the public API to display characters from the Rick & Morty universe.

This project is designed as a lightweight application, but developed following the same standards and best practices as a production-ready app.

## 🧩 Tech Stack

- Swift 6 (strict concurrency)
- SwiftUI
- Async/Await
- Persistence storage SwiftData
- Dependency injection throught an app-level container
- Target iOS: minimum 26.0

## 🧩 Architecture
The project follows an MVVM approauch with Clean Architecture inspired layering:

- 'App': Application entry point and dependency composition through 'AppContainer'
- 'Core': Shared infrastructure such as networking, environment configuration, monitoring, extensions, ..
- 'Domain': App models and repository contracts
- 'Data': Remote/local sources, DTOs, persistence entities and repository implementation
- 'Feature': List of screens and viewmodels
- 'Shared': Diferent UI components 
- 'Resources': Assets, launch screen, localizable strings, ..

The UI works with domain models through ViewModels and repositories, while DTOs and SwiftData entities stay isolated in the Data layer.

## 🧾 Features / Roadmap
We will work assuming tickets/task as Scrum project (RM: tasks, sub-tasks). 
And to prevent delays in App Store releases, the app will be developed and delivered in small (RELEASE), self-contained functional increments, enabling continuos progress toward full feature completion

- RM-1: Project setup and base architecture
- RM-2: Networking layer and RickyAndMorty initial endpoints
- RM-3: Initial Domain models and DTO mapping
- RM-4: SwiftData persistence (Manager+Migration+first entities)
- RM-5: List characters
- RM-6: Characters pagination + UI
- RM-7: Detail character

- 🚀 RELEASE-1: Version 1.0 - List and Detail

- RM-8: Search local character

- 🚀 RELEASE-2: Version 1.1 - Local Search characters

## API

All API information: https://rickandmortyapi.com

Example getting list character https://rickandmortyapi.com/api/character/?page=20

JSON response
```json
{
  "info": {
    "count": 826,
    "pages": 42,
    "next": "https://rickandmortyapi.com/api/character/?page=20",
    "prev": "https://rickandmortyapi.com/api/character/?page=18"
  },
  "results": [
    {
      "id": 361,
      "name": "Toxic Rick",
      "status": "Dead",
      "species": "Humanoid",
      "type": "Rick's Toxic Side",
      "gender": "Male",
      "origin": {
        "name": "Alien Spa",
        "url": "https://rickandmortyapi.com/api/location/64"
      },
      "location": {
        "name": "Earth",
        "url": "https://rickandmortyapi.com/api/location/20"
      },
      "image": "https://rickandmortyapi.com/api/character/avatar/361.jpeg",
      "episode": [
        "https://rickandmortyapi.com/api/episode/27"
      ],
      "url": "https://rickandmortyapi.com/api/character/361",
      "created": "2018-01-10T18:20:41.703Z"
    },
    // ...
  ]
}
```



