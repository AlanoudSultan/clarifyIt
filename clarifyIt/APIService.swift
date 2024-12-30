//
//  APIService.swift
//  clarifyIt
//
//  Created by Nahed Almutairi on 29/06/1446 AH.
//

import Foundation

class APIService {
    private let apiKey = "AIzaSyBWk05Ki0kwV3Atsu4JOd7olfV6gQNQqcM"
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"

    func fetchWordDetails(word: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            print("Error: Invalid URL")
            completion("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let prompt = """
        Please provide the following for the word "\(word)" in a concise and structured format:
        - A single, clear definition of the word.
        - four synonyms only.
        - One example sentence using the word.
        """
        let parameters: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error: Failed to serialize JSON: \(error.localizedDescription)")
            completion("Failed to create request body")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                completion("Network Error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    completion("HTTP Error: \(httpResponse.statusCode)")
                    return
                }
            }

            guard let data = data else {
                print("Error: No data received")
                completion("No data received")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let candidates = json["candidates"] as? [[String: Any]],
                   let content = candidates.first?["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]],
                   let text = parts.first?["text"] as? String {
                    completion(text)
                } else {
                    print("Error: Unexpected JSON structure")
                    completion("Unexpected JSON structure")
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion("JSON Decoding Error: \(error.localizedDescription)")
            }

        }.resume()
    }
}
