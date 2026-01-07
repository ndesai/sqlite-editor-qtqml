# Architecture

This document describes the architecture of the SQLite Editor project.

## Overview

The SQLite Editor is a desktop application for browsing and editing SQLite databases. It is built using the Qt framework, with a C++ backend for logic and a QML frontend for the user interface.

The architecture follows a separation of concerns, where the UI (QML) is decoupled from the business logic (C++). This is similar to a Model-View-ViewModel (MVVM) pattern.

## High-Level Architecture

The application is divided into two main layers:

-   **C++ Backend**: This layer is responsible for all the core logic, including database access, query execution, and data processing. It is implemented in C++ using Qt libraries.
-   **QML Frontend**: This layer provides the user interface. It is written in QML, a declarative language for creating fluid and dynamic UIs.

Communication between these two layers is achieved through Qt's signals and slots mechanism and by exposing C++ objects to the QML context.

## Directory Structure

The project's source code is organized as follows:

-   `app/SQLiteEditor/`: Contains the main source code for the application.
    -   `*.pro`: The qmake project file, which defines the build configuration.
    -   `*.cpp`, `*.h`: The C++ source and header files for the backend logic.
    -   `qml/`: The QML source files for the user interface.
        -   `main.qml`: The main QML file, which is the entry point for the UI.
        -   `views/`: Contains larger, self-contained QML components that represent different parts of the UI (e.g., `AppWindow.qml`, `Header.qml`).
        -   `utils/`: Contains smaller, reusable QML components and utilities used throughout the application.

## C++ Backend

The C++ backend consists of several key classes:

### `main.cpp`

This is the application's entry point. It performs the following tasks:
-   Initializes the `QApplication`.
-   Initializes the `QQmlApplicationEngine` to load and run the QML code.
-   Registers the `SQLite` and `SqlTableModel` C++ classes as QML types under the `st.app` namespace, making them available for use in QML.
-   Creates an instance of a `Utility` class and exposes it to QML as a context property named `$`. This allows QML to call utility functions like `saveTextToClipboard`.
-   Loads the main QML file (`main.qml`).

### `sqlite.h` / `sqlite.cpp`

This class acts as a bridge between the QML frontend and the database backend.
-   It exposes properties like `databasePath`, `status`, and `tableModel` to QML.
-   It provides a public slot `executeQuery(QString)` that can be called from QML to run a SQL query.
-   When a query is executed, it creates a `DbThread` to perform the database operations in a separate thread, preventing the UI from freezing.
-   It uses signals (`resultsReady`) to send the query results back to the QML layer asynchronously and updates the internal `SqlTableModel`.

### `dbthread.h` / `dbthread.cpp`

This class manages a worker thread for executing database queries.
-   It inherits from `QThread`.
-   When `execute(const QString& query)` is called, it signals a worker object running in the thread to perform the query.
-   The use of a separate thread is crucial for maintaining a responsive UI, especially when dealing with large databases or long-running queries.
-   It communicates with the `SQLite` class using signals and slots to receive queries and return results.

### `SqlTableModel.h` / `SqlTableModel.cpp`

This class adapts the SQL query results for the QML `TableView`.
-   It inherits from `QAbstractTableModel`.
-   It holds the query results (`QList<QSqlRecord>`) and column names.
-   It exposes `count` and `columnNames` as properties to QML.
-   It overrides standard model methods (`rowCount`, `columnCount`, `data`, `roleNames`) to supply data to the QML views.

## QML Frontend

The QML frontend is responsible for the application's visual presentation and user interaction.

### `main.qml`

This is the root QML component. It:
-   Uses a `Views.AppWindow` as the main application window.
-   Instantiates the `AppStreet.SQLite` component to interact with the backend.
-   Defines the overall layout of the application, including the header, navigation pane, table list, and main content area.
-   Uses a `ListView` to display column headers and a `TableView` to display data, both bound to the `SqlTableModel` exposed by the `SQLite` object.
-   Connects UI events (like button clicks) to C++ slots (e.g., `_SQLite.executeQuery`).
-   Listens for signals from the C++ backend (e.g., `onResultsReady`) to update the UI.

### `views/`

This directory contains the major UI building blocks, such as:
-   `AppWindow.qml`: The main window of the application.
-   `Header.qml`: The application header bar.
-   `Label.qml`: A custom text label.

### `utils/`

This directory contains smaller, general-purpose components, such as spacers, buttons, and theme-related items.

## Communication: C++ and QML

The power of the Qt/QML architecture lies in the seamless integration between C++ and QML:

-   **Exposing C++ classes to QML**: C++ classes can be registered as QML types using `qmlRegisterType`, as seen in `main.cpp` with the `SQLite` and `SqlTableModel` classes. This allows them to be instantiated and used in QML just like any other QML object.
-   **Properties**: C++ properties defined with `Q_PROPERTY` are automatically accessible in QML and can be used for data binding.
-   **Signals and Slots**: QML can connect to C++ signals and C++ slots can be invoked from QML. This is the primary mechanism for event-based communication. For instance, a button click in QML can trigger a slot in a C++ object, and a C++ object can emit a signal to notify QML about a data change.
-   **Context Properties**: C++ objects can be directly inserted into the QML context using `QQmlContext::setContextProperty`. This makes the object's properties and invokable methods available to all QML components.

## Build System

The project uses `qmake` as its build system. The `SQLiteEditor.pro` file is a `qmake` project file that specifies:
-   The template to use (`app`).
-   The Qt modules to include (`qml`, `quick`, `sql`, `core`, `widgets`).
-   The C++ header and source files to compile.
-   The resources to be included in the application binary (like QML files via `qml.qrc`).