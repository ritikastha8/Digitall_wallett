# NovaCash – Digital Wallet Mobile Application

NovaCash is a mobile digital wallet application developed using Flutter. The application allows users to perform simple and secure cashless transactions such as sending money, scanning QR codes, and viewing transaction history. The system focuses on usability, performance, and secure financial interactions while demonstrating modern mobile development practices.

## Overview

NovaCash aims to provide a simplified digital payment experience by focusing on essential wallet features instead of complex financial services. The application demonstrates important mobile development concepts such as clean architecture, state management, sensor integration, and cloud-based data handling.

## Technology Stack

### Mobile Application

- Flutter (Dart)

- MVVM Architecture

- State Management

- Device Sensor Integration

## Prerequisites

Before running the project, ensure the following tools are installed:

- Flutter SDK

- Dart SDK

- Android Studio or Visual Studio Code

- Android Emulator or Physical Device

## Installation

### Clone the repository

```bash
git clone https://github.com/ritikastha8/Digitall_wallett.git
```
### Install dependencies
```bash
flutter pub get
```
### Run the application
```bash
flutter run
```

## Key Features

- Secure user registration and login

- Send money using registered mobile numbers

- QR code generation for receiving payments

- QR code scanning for instant payments

- Transaction history tracking

- Notification system for updates and transactions

- Profile management for users

- Light and dark theme customization

- Automatic theme switching using ambient light sensor

- Gesture-based navigation using accelerometer

- Shake-to-logout functionality for quick account security

- Offline access to transaction history and notifications

## Application Architecture

NovaCash follows the Model–View–ViewModel (MVVM) design pattern to ensure better separation of concerns and maintainable code structure.

- Model: Manages application data such as user information and transaction records.

- View: Handles the user interface including screens like login, dashboard, and QR scanning.

- ViewModel: Processes business logic and connects the view with the model layer.

This architecture improves scalability, maintainability, and code readability.


## Sensors Integration

The application uses mobile device sensors to enhance user experience.

- Light Sensor: Automatically switches between light and dark themes depending on surrounding brightness.

- Accelerometer: Enables device motion detection for gesture-based navigation and shake-to-logout functionality.

## Data Storage and Security

NovaCash stores essential data required for wallet functionality such as user profiles, transaction records, notifications, and application preferences.

To protect sensitive information, the application implements:

- Secure user authentication

- Encrypted communication with backend services

- Secure local data storage for offline access

- Controlled API communication for data protection

