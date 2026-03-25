![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

# NetkiSDK - Flutter

Flutter plugin that bridges the native NetkiSDK for iOS and Android, providing identity verification and onboarding capabilities.

## Table of Contents

- [Supported Versions](#supported-versions)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [API Reference](#api-reference)
- [UI Customization](#ui-customization)
- [Android Configuration](#android-configuration)
- [iOS Configuration](#ios-configuration)
- [Author](#author)
- [License](#license)

## Supported Versions

| Platform | Minimum Version |
|----------|-----------------|
| Flutter  | 3.3.0           |
| Dart     | 3.11.0          |
| iOS      | 17.0            |
| Android  | API 24 (7.0)    |

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  netki_sdk: ^11.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Initialize the SDK

```dart
import 'package:netki_sdk/netki_sdk.dart';

// Initialize with environment (optional, defaults to PROD)
await NetkiSdk.instance.initialize(environment: Environment.PROD);

// Configure with your token
final result = await NetkiSdk.instance.configureWithToken(
  token: 'your-token-here',
  accessCode: '', // Optional
);

if (result.isSuccessful) {
  print('SDK configured successfully');
}
```

### 2. Start Identification Flow

```dart
// Get available options
final idTypes = await NetkiSdk.instance.getAvailableIdTypes();
final countries = await NetkiSdk.instance.getAvailableCountries();

// Listen for identification events
NetkiSdk.instance.identificationEvents.listen((event) {
  switch (event) {
    case IdentificationSuccess(:final extraData):
      print('Capture successful: $extraData');
      break;
    case IdentificationCancelled(:final resultInfo):
      print('Cancelled: ${resultInfo?.message}');
      break;
    case IdentificationUnknown(:final event):
      print('Unknown event: $event');
      break;
  }
});

// Start identification
await NetkiSdk.instance.startIdentification(
  idType: IdType.driversLicense,
  idCountry: countries.first,
);
```

### 3. Submit Identification

```dart
// Submit with additional identity data
final result = await NetkiSdk.instance.submitIdentification(
  additionalData: {
    AdditionalDataField.ssn: '123456789',
    AdditionalDataField.email: 'user@example.com',
  },
);

if (result.isSuccessful) {
  print('Submitted successfully');
}
```

## API Reference

### Initialization & Configuration

| Method | Description |
|--------|-------------|
| `initialize({Environment? environment})` | Initialize the SDK with optional environment |
| `configureWithToken({required String token, String accessCode})` | Configure SDK with your credentials |

### Identification

| Method | Description |
|--------|-------------|
| `startIdentification({required IdType idType, required IdCountry idCountry})` | Start document capture flow |
| `submitIdentification({Map<AdditionalDataField, String> additionalData})` | Submit captured identification |
| `getAvailableIdTypes()` | Get list of supported ID types |
| `getAvailableCountries()` | Get list of supported countries |

### Biometrics

| Method | Description |
|--------|-------------|
| `startBiometrics({required String transactionId})` | Start biometric verification |
| `submitBiometrics({Map<AdditionalDataField, String> additionalData})` | Submit biometric data |

### Settings

| Method | Description |
|--------|-------------|
| `setClientGuid({required String clientGuid})` | Set client identifier |
| `setLocation({required String lat, required String lon})` | Set user location |
| `setLivenessSettings({required bool enabled})` | Enable/disable liveness detection |
| `setBusinessMetadata({required Map<String, String> metadata})` | Set custom business metadata |

### Security Code

| Method | Description |
|--------|-------------|
| `requestSecurityCode({required String phoneNumber})` | Request SMS verification code |
| `confirmSecurityCode({required String phoneNumber, required String securityCode})` | Confirm verification code |
| `bypassSecurityCode({required String phoneNumber})` | Bypass security code (if allowed) |

### Data Retrieval

| Method | Description |
|--------|-------------|
| `getBusinessConfiguration()` | Get business configuration from server |

### Events

| Property | Description |
|----------|-------------|
| `identificationEvents` | Stream of identification events |

## UI Customization

Customize the SDK UI with custom colors and instructions:

```dart
// Resolve Flutter assets to file paths for native SDK
final iconPath = await NetkiSdk.instance.resolveAssetPath('assets/icons/my_icon.png');

final theme = OnBoardIdTheme(
  buttons: ButtonColors(
    primaryBackground: '#FF6B35',
    primaryText: '#FFFFFF',
    secondaryBackground: '#4ECDC4',
    secondaryText: '#1A535C',
    cornerRadiusDp: 24,
  ),
  content: ContentColors(
    background: '#F7FFF7',
    surface: '#FFE66D',
    border: '#FF6B35',
    titleText: '#1A535C',
    subtitleText: '#4ECDC4',
    bodyText: '#333333',
  ),
  instructions: [
    InstructionContent(
      idType: IdType.driversLicense,
      pictureType: PictureType.front,
      title: 'Scan Your ID',
      subtitle: 'Front side',
      steps: [
        InstructionItem(text: 'Place ID on flat surface', iconUrl: iconPath),
        InstructionItem(text: 'Ensure good lighting'),
      ],
    ),
  ],
);

await NetkiSdk.instance.applyTheme(theme: theme);
```

## Android Configuration

Add the Netki Maven repositories to your `android/build.gradle.kts`:

```kotlin
allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://art.myverify.io/netki/libs-release-local/") }
        maven { url = uri("https://art.myverify.io/netki/libs-snapshot-local/") }
        maven { url = uri("https://developer.huawei.com/repo/") }
    }
}
```

> **Note:** If using the older Groovy-based `build.gradle`, use `maven { url "..." }` syntax instead.

## iOS Configuration

### Step 1: Update Podfile

Update your `ios/Podfile` with the following changes:

1. Set the platform to iOS 17.0
2. Add NetkiSDK and NFCPassportReader pods
3. Add the post_install configuration

```ruby
platform :ios, '17.0'

target 'Runner' do
  use_frameworks!

  # Add NetkiSDK
  pod 'NetkiSDK', :git => 'https://github.com/netkicorp/onboardid-pod.git', :branch => '11.0.0-snapshot'
  pod 'NFCPassportReader', '~> 2.0.2'

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)

    # Required for Swift module compatibility
    if target.name == 'NFCPassportReader'
      target.build_configurations.each do |config|
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
  end

  # Xcode 15+ compatibility fix
  Dir.glob(File.join(__dir__, 'Pods', 'Target Support Files', '**', '*.{xcconfig,sh}')).each do |file|
    contents = File.read(file)
    next unless contents.include?('DT_TOOLCHAIN_DIR')
    File.write(file, contents.gsub('DT_TOOLCHAIN_DIR', 'TOOLCHAIN_DIR'))
  end
end
```

### Step 2: Configure Permissions

Add the following to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required to capture ID documents</string>
<key>NFCReaderUsageDescription</key>
<string>NFC is used to read passport chips for identity verification</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location is used to verify your identity</string>
<key>NSFaceIDUsageDescription</key>
<string>Face ID is used for biometric verification</string>
```

### Step 3: Install Pods

```bash
cd ios && pod install
```

## Author

Netki, ops@netki.com

## License

NetkiSDK is available under the MIT license. See the LICENSE file for more info.
