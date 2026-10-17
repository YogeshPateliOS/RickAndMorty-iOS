# Rick and Morty

SwiftUI app (iOS 17+) using the [Rick and Morty API](https://rickandmortyapi.com). No Combine. Kingfisher is the only dependency, used for image caching. The API calls are our own code.

## Features
- Character list (first page, 20 characters) with thumbnail, name and episode count
- Search by name with debounce
- Detail screen with image, name, status, species, gender and current location

## Structure
```
View -> ViewModel -> Repository -> Service -> URLSession
```
- `Core/Networking`: `ServiceEndPoint`, `ServiceProtocol`, `APIService`, `NetworkError`
- `Data`: `CharactersEndpoint`, response types (match the JSON) and `CharacterRepository`
- `Models`: `CharacterModel`, the type the UI uses. Response types are mapped to it with `toModel()`
- `Features`: list and detail screens
- `Shared`: image and small reusable views

There is no use case layer. The view model would only forward calls to the repository, so I left it out.

## Search
`.task(id: searchText)` restarts on every change and cancels the previous run. The view waits 400 ms, then calls the view model, all inside one `do/catch`. A cancel during the wait or during the request is dropped there.
A search with no matches returns 404 from the API, which the repository turns into an empty list.

## Run
Open `RickAndMorty.xcodeproj`, choose an iPhone simulator and run. Tests: Cmd+U.
