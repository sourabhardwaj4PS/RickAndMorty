# Rick And Morty App

This app is a demonstration of SwiftUI + Combine, async/await for network calls, CLEAN + MVVM architecture, and Swift Package Manager for dependency management. The code is structured using a modular architecture where each Swift package represents a different module (e.g., characters, episodes, etc.), and all modules are integrated into the main app "Rick And Morty."

## Features

- **SwiftUI**: Utilizes SwiftUI for building user interfaces, enabling a declarative and reactive approach to UI development.
- **Combine**: Leverages Combine framework for handling asynchronous and event-driven programming, particularly for network calls and data binding.
- **Async/Await**: Employs async/await syntax for asynchronous operations, enhancing readability and simplifying code for network requests.
- **CLEAN + MVVM Architecture**: Adheres to CLEAN architecture principles with a focus on separation of concerns, testability, and maintainability. The MVVM (Model-View-ViewModel) design pattern is used for structuring UI-related logic.
- **Swift Package Manager**: Relies on Swift Package Manager for dependency resolution and package management, promoting modularity and reusability across the codebase.
- **Code Coverage**: Includes code coverage analysis to ensure comprehensive testing and quality assurance.

## Modules

1. **Characters Module**: Handles functionality related to characters, including displaying character information, searching characters, and managing character details.
2. **Episodes Module**: To be developed later.
3. **Main App**: Integrates all modules together to create the "Rick And Morty" app, offering a seamless user experience across characters, episodes, and locations.

## Installation

1. Clone the repository to your local machine.
2. Open the file `RickAndMorty.xcodeproj`.
3. Build and run the project on a simulator or device.


## (Public) API Credits
https://rickandmortyapi.com/documentation/

**List characters**: https://rickandmortyapi.com/api/character/?page=1

**Character details**: https://rickandmortyapi.com/api/character/1
