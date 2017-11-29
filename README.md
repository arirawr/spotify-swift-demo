# spotify-swift-demo
Interact with the Spotify Web API in Swift

This app uses the Spotify Connect Web API to show the currently playing track for a logged in user and give playback controls.

## Requirements
- Spotify Premium
- A developer app from the [Spotify for Developers Dashboard](https://beta.developer.spotify.com/dashboard)
- XCode 9
- Cocoapods

## Authorization

This demo uses [SpotifyLogin](https://github.com/spotify/SpotifyLogin) for authentication and authorization. This library is intended for prototyping purposes only and should not be used in production apps.

## Getting Started

First, fork and clone this project to your machine.

#### In the Spotify Dashboard:

1. Register an app on the [Spotify for Developers Dashboard](https://beta.developer.spotify.com/dashboard).
2. In the settings of your app, enter your iOS app's bundle ID and redirect URI (ie. `com.yourdomain.awesome-spotify-app://`)

#### In the iOS App:
1. Run `pod repo update` and `pod install` in the Terminal.
2. In the `AppDelegate`, look for the call to `SpotifyLogin.shared.configure()`. Replace the placeholders with your client ID, secret, and redirect URI.

## Challenges

1. Your top tracks are shown on the page. Show your **top artists** instead. (See `showTop()`)
2. Add a **pause** button and a **play** button. The functions are already implemented in the `SpotifyDataController`. (See `previous()` and `next()`) 
3. Show the title and artist of the **current track**. (See `updateCurrentlyPlaying()`)
4. The top tracks endpoint allows you to choose out of 3 different time ranges, `short_term`, `medium_term` (default), and `long_term`. Show your long term top tracks. (See `getMyTop()` in `SpotifyDataController`)
5. Use one of the other functions from `SpotifyDataController` to show data in your app.
6. Implement another endpoint from the Spotify API.
