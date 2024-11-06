# video_notes_app

Welcome to Video Notes Application! This project consists of a [Flutter](https://flutter.dev/) application and an [Express.js](https://expressjs.com/) server that allows users to watch videos and create time-stamped notes.

## Features
- Play local video files and streaming URLs
- Take time-stamped notes with rich text formatting
- Dark mode support
- Responsive design for various screen sizes
- Search for all notes across all video or notes related to a video
- User can password protect notes

## Prerequisites
Before you begin, ensure you have the following installed on your machine:
- **Windows 10** or later, 64-bit
- [Node.js](https://nodejs.org/en/download/package-manager) 
- [Flutter](https://docs.flutter.dev/get-started/install)
- [Visual Studio 2022](https://visualstudio.microsoft.com/vs/)(Ensure you include the C++ CMake tools for Windows and Windows 10 SDK (latest version) components during Visual Studio setup.)

## Installation

1. **Clone the Repository**
   ```
   git clone https://github.com/Vansh-Bh/video_notes_app.git
   ```
2. **Install Flutter dependencies** using `flutter pub get`
3. **Set up the backend server**:
   ```
   cd backend
   npm install
   ```
4. Run the following command
   ```
   cp .env.example .env
   ```
   Then configure the .env file with your MongoDB URI and Port.
   Follow the steps below for MongoDB URI if you dont have one

<details>
  <summary>Steps to Set Up MongoDB Atlas</summary>
   You can create a free tier MongoDB deployment on MongoDB Atlas to store and manage your data.

  - **Create a MongoDB Atlas Account**<br>
    Go to [MongoDB Atlas](https://www.mongodb.com/products/platform/atlas-database) and create a free account.
    
  - **Create a Cluster**<br>
    After creating your account, follow the instructions to create a new cluster. This will be your MongoDB database in the cloud.
    
  - **Get Your Connection String**<br>
    Once your cluster is created, click on "Connect", select "Connect your application", and copy the connection string.

</details>

5. Start the backend server with `node index.js` or `nodemon start`
6. In the Flutter app, open `lib/api_service.dart` and `lib/widgets/video_grid.dart`update the `baseUrl` with your backend server URL:

## Application Structure

After successful build, your application structure should look like this:

```
├── video_notes_app/
│   ├── lib/
│   │   ├── models/
│   │   │   ├── note.dart
│   │   │   └── video_data.dart
│   │   ├── modules/
│   │   │   ├── home/
|   |   |   |   ├── home_binding.dart
│   │   │   │   ├── home_controller.dart
│   │   │   │   └── home_view.dart
│   │   │   ├── video_player/
|   |   |   |   ├── video_player_binding.dart
│   │   │   │   ├── video_player_controller.dart
│   │   │   │   └── video_player_view.dart
│   │   │   └── add_video.dart
│   │   ├── widgets/
│   │   │   ├── custom_seek_bar.dart
│   │   │   ├── edit_note_dialog.dart
│   │   │   ├── note_editor.dart
│   │   │   ├── notes_list.dart
│   │   │   ├── rich_text_viewer.dart
│   │   │   ├── video_grid.dart
│   │   ├── theme_changer.dart
|   |   ├── api_service.dart
│   │   └── main.dart
│   ├── pubspec.yaml
│   ├── README.md
│   └── backend/
│       ├── models/
│       │   ├── note_model.js
│       │   └── video_model.js
│       ├── routes/
│       │   ├── notes.js
│       │   └── video.js
│       ├── thumbnails/                         -contains the generated thumbnails
│       ├── .env.example
│       ├── index.js
│       └── package.json
│
├── .gitignore
└── README.md
```

## Usage

1. Run the Flutter app using `flutter run`
2. Add videos:
    - Tap the "+" icon in the app bar
    - Enter a video title and select a local file or enter a streaming URL and you can upload a thumbnail url or leave it empty to autogenerate
3. Watch videos and take notes:
    - Tap on a video in the home screen to start playback
    - Use the note editor on the right side to add time-stamped notes
    - Notes will appear as colored dots on the video progress bar
    - All notes can be seen using the notes button and an be edited as well
