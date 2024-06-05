# Flutter [Waterbus](https://docs.waterbus.tech) SDK

Flutter plugin of [Waterbus](https://docs.waterbus.tech). Build video call or online meeting application with SFU model. Supports iOS, Android. [ExampleApp](https://github.com/waterbustech/waterbus)

<img src="https://github.com/waterbustech/waterbus-flutter-sdk/blob/migration/v2/.github/waterbus-sdk-banner.png?raw=true" width="100%"/>

<a href="https://opensource.org/licenses/Apache-2.0"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg"/></a>
<img src="https://img.shields.io/github/issues/waterbustech/waterbus-flutter-sdk" alt="GitHub issues"><a href="https://chromium.googlesource.com/external/webrtc/+/branch-heads/6099"><img src="https://img.shields.io/badge/libwebrtc-125.6422.02-yellow.svg" alt="libwebrtc"></a><img src="https://img.shields.io/cocoapods/v/KaiRTC" alt="Cocoapods Version"><a href="https://github.com/lambiengcode"><img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat&amp;logo=github" alt="PRs Welcome"></a>

## ⚡ Current supported features

| Feature            | Subscribe/Publish | Screen Sharing | Picture in Picture | Virtual Background | Beauty Filters | End to End Encryption |
| ------------------ | ----------------- | -------------- | ------------------ | ------------------ | -------------- | --------------------- |
| Android            |         🟢         |        🟢      |          🟢         |          🟢         |       🟢        |           🟢          | 
| iOS                |         🟢         |        🟢      |          🟢         |          🟢         |       🟢       |           🟢          |        
| Web                |         🟢         |        🟢      |          🟢         |          🟢         |       🟡       |           🟢          |
| MacOS              |         🟢         |        🟢      |          🔴         |          🟢         |       🟢       |           🟢          |
| Linux                |         🟢         |        🟢      |          🔴         |          🟡         |       🟡       |           🟢          |    


🟢 = Available

🟡 = Coming soon (Work in progress)

🔴 = Not currently available (Possibly in the future)

## Installation

### Add dependency

Add the dependency from command-line

```bash
$ flutter pub add waterbus_sdk
```

The command above will add this to the `pubspec.yaml` file in your project (you can do this manually):
```yaml
dependencies:
    waterbus_sdk: ^1.3.15
```

## Usage

### Initialize

Firstly, call `WaterbusSdk.instance.initial` to set your server url and sdk connect WebSocket.

```dart
await WaterbusSdk.instance.initial(
  apiUrl: 'https://service.waterbus.tech/busapi/v1/',
  wsUrl: 'wss://sfu.waterbus.tech',
);
```

### Create room

```dart
final Meeting? meeting = await WaterbusSdk.instance.createRoom(
  meeting: Meeting(title: 'Meeting with Kai Dao'),
  password: 'password',
  userId: 1, // <- modify to your user id
);
```

### Update room

```dart
final Meeting? meeting = await WaterbusSdk.instance.updateRoom(
  meeting:  Meeting(title: 'Meeting with Kai Dao - 2'),
  password: 'new-password',
  userId: 1, // <- modify to your user id
);
```

### Join room

```dart
final Meeting? meeting = await WaterbusSdk.instance.joinRoom(
  meeting: _currentMeeting,
  password: 'room-password-here',
  userId: 1, // <- modify to your user id
);
```

### Set callback room events

```dart
void _onEventChanged(CallbackPayload event) {
  switch (event.event) {
    case CallbackEvents.shouldBeUpdateState:
      break;
    case CallbackEvents.newParticipant:
      break;
    case CallbackEvents.participantHasLeft:
      break;
    case CallbackEvents.meetingEnded:
      break;
    default:
      break;
  }
}
```

```dart
WaterbusSdk.instance.onEventChangedRegister = _onEventChanged;
```

### Leave room

```dart
await WaterbusSdk.instance.leaveRoom();
```

#### Prepare Media (will prepare the camera and microphone for you to turn on and off before entering the meeting)
  
```dart
await WaterbusSdk.instance.prepareMedia();
```

## Configuration

### Android

Ensure the following permission is present in your Android Manifest file, located in `<project root>/android/app/src/main/AndroidManifest.xml`:

```xml
<uses-feature android:name="android.hardware.camera" />
<uses-feature android:name="android.hardware.camera.autofocus" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
```

If you need to use a Bluetooth device, please add:

```xml
<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />
```

The Flutter project template adds it, so it may already be there.

Also you will need to set your build settings to Java 8, because official WebRTC jar now uses static methods in `EglBase` interface. Just add this to your app level `build.gradle`:

```groovy
android {
    //...
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}
```

### iOS

Add the following entry to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>$(PRODUCT_NAME) Camera Usage!</string>
<key>NSMicrophoneUsageDescription</key>
<string>$(PRODUCT_NAME) Microphone Usage!</string>
```

This entry allows your app to access camera and microphone.

### Note for iOS.
The WebRTC.xframework compiled after the m104 release no longer supports iOS arm devices, so need to add the `config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'` to your ios/Podfile in your project

ios/Podfile

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
     target.build_configurations.each do |config|
      # Workaround for https://github.com/flutter/flutter/issues/64502
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES' # <= this line
     end
  end
end
```

## Contributing
Contributions are welcome! Please feel free to submit a pull request or open an issue if you encounter any problems or have suggestions for improvements.

## Contact Information

If you have any questions or suggestions related to this application, please contact me via email: lambiengcode@gmail.com.

## Reference

[flutter_webrtc](https://github.com/flutter-webrtc/flutter-webrtc)

## License

Apache License 2.0