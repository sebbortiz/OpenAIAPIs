//
//  SentimentAnalysis.swift
//  Quiz4
//
//  Created by user234695 on 4/10/23.
//

import Foundation

struct SentimentsAnalysis {
    func getSentiment(sentence: String) -> String? {
        let apiKey = "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"
        let urlString = "https://api.openai.com/v1/classifications"
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        let parameters = [
            "model": "text-davinci-002",
            "query": sentence,
            "examples": [
                ["text": "positive", "label": "Positive"],
                ["text": "negative", "label": "Negative"],
                ["text": "neutral", "label": "Neutral"]
            ],
            "search_model": "ada",
            "model_bias": -0.25
        ] as [String : Any]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        guard let url = URL(string: urlString),
              let data = jsonData else {
            return nil
        }
        
        var sentiment: String?
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }
            
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let dataJson = json["data"] as? [[String: Any]],
                  let label = dataJson.first?["label"] as? String else {
                return
            }
            
            sentiment = label
        }
        task.resume()
        semaphore.wait()
        
        return sentiment
    }

}
