//
//  ContentView.swift
//  Quiz4
//
//  Created by user234695 on 4/9/23.
//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
import SwiftUI

struct ContentView: View {
    @State private var text = ""
    @State private var image: Image?
    @State private var completion: String?
    @State private var sentiment: String?
    
    var body: some View {
        VStack {
            Text("OpenAI Demo")
                .font(.largeTitle)
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Enter text:")
                TextEditor(text: $text)
                    .frame(height: 150)
            }
            .padding()
            
            Button(action: generateImage) {
                Text("Generate Image")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
            
            Button(action: completeSentence) {
                Text("Complete Sentence")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            if let completion = completion {
                Text(completion)
                    .padding()
            }
            
            Button(action: getSentiment) {
                Text("Get Sentiment")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            if let sentiment = sentiment {
                Text("Sentiment: \(sentiment)")
                    .padding()
            }
            
            Spacer()
        }
    }
    
    func generateImage() {
        ImageGeneration.generateImage(prompt: text) { result in
            switch result {
            case .success(let imageData):
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.image = Image(uiImage: image)
                    }
                } else {
                    print("Error: Unable to convert image data to UIImage")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func completeSentence() {
        TextCompletion.completeSentence(prompt: text) { completion in
            DispatchQueue.main.async {
                self.completion = completion ?? "No completion found"
            }
        }
    }
    
    func getSentiment() {
        let sentimentAnalysis = SentimentsAnalysis()
        sentimentAnalysis.getSentiment(sentence: self.text) { sentiment in
            DispatchQueue.main.async {
                self.sentiment = sentiment ?? "Unable to determine sentiment"
            }
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
