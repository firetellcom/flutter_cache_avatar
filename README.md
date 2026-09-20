# flutter_cache_avatar

A production-grade cached avatar and image widget for Flutter, seamlessly handling network images, Gravatar, initials fallbacks, and customizable badges.

Built on top of `cached_network_image`.

## Features
* **Network & Cached Images:** Loads and caches images efficiently.
* **Gravatar Support:** Automatically fetches avatars using an `email` address.
* **Initials Fallback:** Auto-generates initials from a `name` when the image URL is missing or fails to load.
* **Dynamic Colorization:** Option to dynamically colorize the background based on the user's name (`colorize: true`).
* **Custom Shapes:** Supports circle and rounded rectangle shapes with customizable borders.
* **Badges:** Built-in support for status indicators, unread counts, or custom badges.

## Installation

Add `flutter_cache_avatar` to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_cache_avatar: ^0.0.1
```

Run the following command in your terminal:
```bash
flutter pub get
```

## Usage

Import the package in your Dart code:
```dart
import 'package:flutter_cache_avatar/flutter_cache_avatar.dart';
```

### Basic Avatar
Directly use `CachedAvatar` (defaults to circular shape, size 40.0):

```dart
CachedAvatar(
  imageUrl: 'https://example.com/avatar.png',
  size: 50.0,
);
```

### Initials Fallback & Dynamic Background
If the URL is invalid or missing, it will automatically show initials with a dynamically generated background color.

```dart
CachedAvatar(
  name: 'John Doe',
  size: 60.0,
  colorize: true, // Will generate a unique background color for "John Doe"
);
```

### Gravatar Integration
Provide an email, and it will fetch the corresponding Gravatar.

```dart
CachedAvatar(
  email: 'user@example.com',
  name: 'User Name', // Used for initials if Gravatar doesn't exist
  size: 60.0,
  colorize: true,
);
```

### Adding Badges
You can easily add an unread count or a status dot badge.

```dart
CachedAvatar(
  imageUrl: 'https://example.com/avatar.png',
  size: 60.0,
  showBadge: true,
  badgeCount: 5,
  badgeColor: Colors.red,
);
```

### Rounded Rectangle Avatar
For group/channel icons, organizations, or custom designs:

```dart
CachedAvatar.rounded(
  name: 'Flutter Team',
  size: 60.0,
  radius: 16.0,
  colorize: true,
);
```

## Constructor Parameters

| Property | Type | Description |
|---|---|---|
| `imageUrl` | `String?` | The URL of the image to cache and display. |
| `email` | `String?` | If provided, used to load a Gravatar avatar. |
| `name` | `String?` | Used to generate initials for the fallback text. |
| `width` / `height` | `double?` | Width and height of the avatar. |
| `size` | `double?` | Used in `.circle` and `.avatar` constructors to set width and height. |
| `shape` | `BoxShape` | The shape of the avatar (`circle` or `rectangle`). |
| `colorize` | `bool` | If true, dynamically calculates a background color based on the `name`. |
| `showBadge` | `bool` | Enable to show a badge. |
| `badgeCount` | `int?` | Displays a number on the badge (e.g., unread messages). |
| `badgeColor` | `Color?` | Custom color for the badge. |

For more advanced customizations, please refer to the API documentation.
