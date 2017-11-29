//
//  SpotifyDataController.swift
//  Spotiswift-iOS
//
//  Created by Arielle Vaniderstine on 2017-07-21.
//  Copyright © 2017 Arielle Vaniderstine. All rights reserved.
//

//
//  SpotifyDataController.swift
//  Spotiswift
//
//  Created by Arielle Vaniderstine on 2017-07-21.
//  Copyright © 2017 Arielle Vaniderstine. All rights reserved.
//

import Foundation
import SpotifyLogin

class SpotifyDataController: NSObject {

    static let shared = SpotifyDataController()

    // --------- Utility Functions --------- //

    var accessToken: String {
        var accessToken: String = ""
        SpotifyLogin.shared.getAccessToken { (token, error) in
            accessToken = token!
        }
        return accessToken
    }

    func spotifyAPIRequest(method: String, urlPath: String, queryParams: String?) -> URLRequest {
        var urlString = "https://api.spotify.com/v1\(urlPath)"
        if queryParams != nil {
            urlString.append("?\(queryParams!)")
        }
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = method
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        print(request)
        print("")

        return request
    }

    func sendRequest(request: URLRequest, completionHandler: @escaping ([String : AnyObject]?) -> Void ) {
        var json = [String : AnyObject]()

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            do {
                // Parse and return JSON Response
                json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                completionHandler(json)
            }
            catch {
                // No JSON Response / Empty response
                completionHandler(nil)
            }
        })
        task.resume()
    }

    func arrayToCommaSeparated(array: [String]) -> String {
        var string = ""
        for item in array {
            string.append("\(item),")
        }
        let commaSeparated = string.dropLast()
        return String(commaSeparated)
    }

    // --------- TRACKS --------- //

    func getTrack(id: String, completionHandler: @escaping ([String : AnyObject]?) -> Void ) {
        let request = spotifyAPIRequest(method: "GET", urlPath: "/tracks/\(id)", queryParams: nil)
        sendRequest(request: request, completionHandler: completionHandler)
    }

    func getSeveralTracks(ids: [String], completionHandler: @escaping ([String : AnyObject]?) -> Void ) {
        let request = spotifyAPIRequest(method: "GET", urlPath: "/tracks/", queryParams: "ids=\(arrayToCommaSeparated(array: ids))")
        sendRequest(request: request, completionHandler: completionHandler)
    }

    // --------- ARTISTS --------- //

    func getArtist(id: String, completionHandler: @escaping ([String : AnyObject]?) -> Void ) {
        let request = spotifyAPIRequest(method: "GET", urlPath: "/artists/\(id)", queryParams: nil)
        sendRequest(request: request, completionHandler: completionHandler)
    }

    func getSeveralArtists(ids: [String], completionHandler: @escaping ([String : AnyObject]?) -> Void ) {
        let request = spotifyAPIRequest(method: "GET", urlPath: "/artists/", queryParams: "ids=\(arrayToCommaSeparated(array: ids))")
        sendRequest(request: request, completionHandler: completionHandler)
    }

    // --------- ALBUMS --------- //

    func getAlbum(id: String, completionHandler: @escaping ([String : AnyObject]?) -> Void ) {
        let request = spotifyAPIRequest(method: "GET", urlPath: "/albums/\(id)", queryParams: nil)
        sendRequest(request: request, completionHandler: completionHandler)
    }

    func getSeveralAlbums(ids: [String], completionHandler: @escaping ([String : AnyObject]?) -> Void ) {
        let request = spotifyAPIRequest(method: "GET", urlPath: "/albums/", queryParams:"ids=\(arrayToCommaSeparated(array: ids))")
        sendRequest(request: request, completionHandler: completionHandler)
    }

    // ----- PERSONALIZATION ----- //

    func getMyTop(type: String, completionHandler: @escaping ([String : AnyObject]?) -> Void ) {
        let request = spotifyAPIRequest(method: "GET", urlPath: "/me/top/\(type)", queryParams: "limit=10")
        sendRequest(request: request, completionHandler: completionHandler)
    }

    // --------- PLAYER --------- //

    func skipToPreviousTrack(completionHandler: @escaping ([String : AnyObject]?) -> Void ) {
        let request = spotifyAPIRequest(method: "POST", urlPath: "/me/player/previous/", queryParams: nil)
        sendRequest(request: request, completionHandler: completionHandler)
    }

    func skipToNextTrack(completionHandler: @escaping ([String : AnyObject]?) -> Void ) {
        let request = spotifyAPIRequest(method: "POST", urlPath: "/me/player/next/", queryParams: nil)
        sendRequest(request: request, completionHandler: completionHandler)
    }

    func getCurrentlyPlayingTrack(completionHandler: @escaping ([String : AnyObject]?) -> Void ) {
        let request = spotifyAPIRequest(method: "GET", urlPath: "/me/player/currently-playing/", queryParams: nil)
        sendRequest(request: request, completionHandler: completionHandler)
    }

}


