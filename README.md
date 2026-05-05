# 📱 Rick And Morty App Lite

## Overview

Rick & Morty App Lite is an iOS application built in Swift that consumes the public API to display characters from the Rick & Morty universe.

This project is designed as a lightweight application, but developed following the same standards and best practices as a production-ready app.

## 🧩 Tech Stack

- Swift 6 (strict concurrency)
- SwiftUI
- Async/Await
- SwiftData (local persistence)
- Dependency Injection (AppContainer)
- Minimum iOS: 26.0

## 🧩 Architecture
The project follows an MVVM approach with a Clean Architecture-inspired layering:

- `App`: Entry point and dependency composition via `AppContainer`
- `Core`: Shared infrastructure (networking, environment, monitoring, extensions)
- `Domain`: Business models and repository contracts
- `Data`: Remote/local sources, DTOs, persistence entities, repository implementations
- `Feature`: Screens and ViewModels
- `Shared`: Reusable UI components
- `Resources`: Assets, launch screen, localized strings

The UI works with domain models through ViewModels and repositories, while DTOs and SwiftData entities stay isolated in the Data layer.

## 🧾 Features / Roadmap
We will work assuming tickets/task as Scrum project (RM: tasks, sub-tasks). 
And to prevent delays in App Store releases, the app will be developed and delivered in small (RELEASE), self-contained functional increments, enabling continuous progress toward full feature completion

- RM-1: Project setup and base architecture
- RM-2: Networking layer and RickyAndMorty initial endpoints
- RM-3: Initial Domain models and DTO mapping
- RM-4: SwiftData persistence (Manager+Migration+first entities)
- RM-5: Cached images
- RM-6: List characters
    - RM-7: Characters pagination + UI
- RM-8: Detail character
- RM-9: Test
    - Repository
    - Persistence
    - ListVM

- 🚀 RELEASE-1: Version 1.0 - List and Detail
- RM-10: Search local character

- 🚀 RELEASE-2: Version 1.1 - Local Search characters
- RM-11: Synchronize/update info character from server
    - We will use a date available to sync, to avoid inncesary actions from users

- 🚀 RELEASE-3: Version 1.2 - Synchronize character from server

## 🔮 Upcoming Features
- RM-{x}: Search online
    - Apply dual, in local database and Remote (saving the new results)
        /character/?name=rick
    - Create new DTO
        - ErrorDTO there are a special not found 404
        - PageInfo creating other PAGEID with contain ?name=jj
        
- RM-{y}: More info about location of character
    - Create DTO + Domain + Repository + Entity
    - In DetailCharacterView, use the section Location, to show more info about the id_location. Having the posibility to /location/{id} and show more info related like 'type', totalResidents
        - The UI will show that info in section, or Button to sync and refresh screen

## 📌 Notes and comments
- To increase the database performance:
    - We should include a (limit, offset) to protocols getCharacters(limit:offset) in order to get just a piece of items.
    - In CharacterListVM we will need to implement changes in fetchRemotePage(:) in order to first load the local items, and when we have all the items, apply RemoteDataSource to fetch related last page sync
- #if DEBUG
    - To have more flexibility, i apply that to force UI changes, and other things. We should NOT use it, because could change the production perspective and flow. But in that case as a 'Tecnical Test App' i deciced to used
- Errors improvement
    - We should increment errors object with a specific error about Database, and use in Repository for example onSave(), onGetLocal()
    - The idea is using the errorAlert(error:) which is showing the proper title and message, we can have a friendly error messages.
    -  One Example:
    
```swift
        func saveCharacters(_ characters: [Character]) async throws
        
        try PersistanteError(.saveLocal(message: error.localizedDescription))
        
        
        func getCharacters() async throws -> [Character])
        
        try PersistanteError(.getLocal(message: error.localizedDescription))

        
      -   And improving the title and messages to do not touch the View becouse should be automatically 
        

        extension Error {
            var titleLocalized: String { }
            var icon: String? { }
        }
```
    
- Other posible changes:
    - Other think related the UI database that we could do, is use modelContainer in App
    
```swift
    var body: some Scene {
        WindowGroup {
            CharacterListView(viewModel: AppContainer.shared.makeCharacterListVM())
        }
        .modelContainer(SwiftDataManager.shared.container)
    }
```


    - And replace the characterItems from viewModel to
    
```swift
struct CharacterListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CharacterEntity.id, order: .forward)
    private var characters: [CharacterEntity]

```
    - Avoiding to localCharacters from SwiftDataSource, and replace the callBack to update sync character becouse after save the UI will refresh automatically.
    - We can still using Character Domain in app for example in DetailView, etc.
    - This could be a good performance, becouse SwiftUI loading items with @Query is pretty fast, and probably we do not need (limit,offset) up to 40k records, becouse SwiftUI is rendering the list only when needed

## 🌐 API

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



