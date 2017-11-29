//
//  ViewController.swift
//  Spotiswift-iOS
//
//  Created by Arielle Vaniderstine on 2017-07-21.
//  Copyright © 2017 Arielle Vaniderstine. All rights reserved.
//

import UIKit
import SpotifyLogin

class ViewController: UIViewController {

    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var albumArtImage: UIImageView!
    @IBOutlet weak var topList: UILabel!
    
    var loginButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.previousButton.isHidden = true
        self.nextButton.isHidden = true
        self.topList.isHidden = true

        // Create a Spotify login button
        let button = SpotifyLoginButton(viewController: self, scopes: [.userReadTop, .userReadPlaybackState, .userModifyPlaybackState, .userReadCurrentlyPlaying])
        self.view.addSubview(button)
        self.loginButton = button

        // Notify when the user successfully logs in with Spotify
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginSuccessful),
                                               name: .SpotifyLoginSuccessful,
                                               object: nil)

        self.previousButton.addTarget(self, action: #selector(ViewController.previousTrack), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(ViewController.nextTrack), for: .touchUpInside)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loginButton?.center = self.view.center
    }

    @objc func previousTrack() {
        SpotifyDataController.shared.skipToPreviousTrack() { data in
            sleep(1)
            self.updateCurrentlyPlaying()
        }
    }

    @objc func nextTrack() {
        SpotifyDataController.shared.skipToNextTrack() { data in
            sleep(1)
            self.updateCurrentlyPlaying()
        }
    }

    @objc func updateCurrentlyPlaying() {
        SpotifyDataController.shared.getCurrentlyPlayingTrack() { data in

            guard let data = data else { return }

            // Parse JSON to get the image URL
            guard let trackItem = data["item"] as? [String: Any] else { return }
            guard let trackName = trackItem["name"] as? String else { return }
            guard let album = trackItem["album"] as? [String: Any] else { return }
            guard let images = album["images"] as? [AnyObject] else { return }
            guard let imageURLString = images[0]["url"] as? String else { return }

            print("Currently Playing:")
            print(trackName)
            print(imageURLString)
            print("")

            let imageURL = URL(string: imageURLString)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL!)
                DispatchQueue.main.async {
                    self.albumArtImage.image = UIImage(data: data!)
                }
            }
        }
    }

    @objc func showTop() {
        SpotifyDataController.shared.getMyTop(type: "tracks") { data in
            guard let data = data else { return }
            guard let itemsArray = data["items"] as? [[String : AnyObject]] else { return }

            var fullString = ""

            for track in itemsArray {
                guard let trackName = track["name"] as? String else { return }
                let formattedString: String = "\u{2022} \(trackName)\n"
                fullString = fullString + formattedString
            }

            print(fullString)

            DispatchQueue.main.async {
                self.topList.text = fullString
            }
        }
    }

    @objc func loginSuccessful() {
        print("LOGIN COMPLETED")

        self.loginButton?.isHidden = true
        self.previousButton?.isHidden = false
        self.nextButton?.isHidden = false
        self.topList?.isHidden = false

        self.showTop()
        self.updateCurrentlyPlaying()
    }

}

