## 0.0.5

* Modularize architecture by extracting pure Dart utilities (`InitialsFormatter`, `GravatarHelper`, `AvatarColorGenerator`) and specialized sub-widgets (`AvatarBadge`, `AvatarFallback`).
* Remove redundant `CachedAvatar.avatar` constructor in favor of standard `CachedAvatar()` default constructor.
* Update LICENSE copyright holder to Firetell LLC using canonical MIT format.
* Add automated CI/CD publishing workflow to pub.dev via GitHub Actions with OIDC.
* Add comprehensive unit and widget tests covering all modules (26 tests total).

## 0.0.4

* Make default `CachedAvatar` constructor circular by default with convenient `size` parameter.
* Add `CachedAvatar.rounded` and `CachedAvatar.square` constructors for flexible shapes.
* Fix badge expansion bug and balance responsive badge scaling and typography.
* Optimize package archive size by ignoring build and example platform files.
* Add comprehensive widget tests and improve README examples.

## 0.0.3

* Update package repository and homepage links.

## 0.0.2

* Export `cached_network_image` so users can use its APIs directly without adding it to their dependencies.

## 0.0.1

* Initial release.
* Features: `CachedAvatar` widget with Gravatar, fallback initials, badging, and dynamic background colorization based on user name.
