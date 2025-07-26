# za_warudo

## Overview
za_warudo is a Flutter application that provides timer and alarm functionalities. Users can customize their alarms with various features such as sound selection, vibration, display colors, and flashlight activation. The app allows users to choose combinations of these options to enhance their alarm experience.

## Features
- Set and manage timers.
- Create and manage alarms with customizable options.
- Select alarm sounds from available options.
- Enable or disable vibration for alarms.
- Choose display colors for the alarm screen, even when the phone is locked.
- Activate the flashlight feature for alarms.

## Project Structure
```
za_warudo
├── lib
│   ├── main.dart                # Entry point of the application
│   ├── screens
│   │   ├── home_screen.dart     # Main interface for navigation
│   │   ├── timer_screen.dart     # Timer management interface
│   │   └── alarm_screen.dart     # Alarm management interface
│   ├── widgets
│   │   ├── sound_picker.dart     # UI for selecting alarm sounds
│   │   ├── vibration_toggle.dart  # Toggle for vibration settings
│   │   ├── color_picker.dart      # UI for selecting display colors
│   │   └── flashlight_toggle.dart  # Toggle for flashlight settings
│   ├── models
│   │   └── alarm_options.dart     # Model for alarm configuration options
│   └── services
│       ├── timer_service.dart     # Manages timer functionality
│       ├── alarm_service.dart     # Manages alarm functionality
│       ├── sound_service.dart     # Handles sound file operations
│       ├── vibration_service.dart  # Manages vibration functionality
│       ├── color_service.dart      # Manages display color settings
│       └── flashlight_service.dart  # Manages flashlight functionality
├── pubspec.yaml                  # Flutter configuration file
└── README.md                     # Project documentation
```

## Setup Instructions
1. Clone the repository:
   ```
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```
   cd za_warudo
   ```
3. Install the dependencies:
   ```
   flutter pub get
   ```
4. Run the application:
   ```
   flutter run
   ```

## Usage Guidelines
- Use the Home Screen to navigate to Timer and Alarm functionalities.
- Set timers and alarms according to your preferences.
- Customize alarm settings by selecting sounds, enabling vibration, choosing colors, and activating the flashlight.

## Contributing
Contributions are welcome! Please feel free to submit a pull request or open an issue for any suggestions or improvements.