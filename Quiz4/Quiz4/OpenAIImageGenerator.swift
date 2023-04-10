//
//  OpenAIImageGenerator.swift
//  Quiz4
//
//  Created by user234695 on 4/10/23.
//

// OpenAI.swift

import Foundation

struct ImageGeneration {
    static let apiKey = "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"
    
    static func generateImage(prompt: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = "https://api.openai.com/v1/images/generations"
        let params = [
            "model": "image-alpha-001",
            "prompt": prompt,
            "num_images": 1,
            "size": "256x256",
            "response_format": "url"
        ] as [String : Any]
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "com.example.OpenAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            let error = NSError(domain: "com.example.OpenAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid parameters"])
            completion(.failure(error))
            return
        }
        
        request.httpBody = httpBody
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "com.example.OpenAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])
                completion(.failure(error))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}
