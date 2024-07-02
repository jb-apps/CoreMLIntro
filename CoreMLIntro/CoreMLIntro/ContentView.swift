//
//  ContentView.swift
//  CoreMLIntro
//
//  Created by Benavides Vallejo, Jonathan on 02.07.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var upscaler = Upscaler()
    
    private func formattedImage(image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay(alignment: .bottom) {
                ZStack {
                    Color.black.opacity(0.5)
                    Text("\(Int(image.pixelSize.width))x\(Int(image.pixelSize.height))")
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .frame(height: 34)
            }
    }
    
    var body: some View {
        VStack {
            Spacer()
            switch upscaler.state {
            case .loadingModel:
                Text("Loading upscaler model")
            case .upscaling:
                Text("Upscaling...")
            case .ready:
                Text("Ready to upscale")
            case .error(let error):
                Text("Error: \(error.localizedDescription)")
            case .completed(let input, let output):
                formattedImage(image: input)
                formattedImage(image: output)
            }
            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button("Test 1") {
                    upscaler.upscaleImage(filename: "test_image_1")
                }
                Spacer()
                Button("Test 2") {
                    upscaler.upscaleImage(filename: "test_image_2")
                }
                Spacer()
                Button("Test 3") {
                    upscaler.upscaleImage(filename: "test_image_3")
                }
            }
            .padding(.horizontal, 34)
        }
    }
}

#Preview {
    ContentView()
}
