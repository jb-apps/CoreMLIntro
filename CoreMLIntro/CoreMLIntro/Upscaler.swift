//
//  Upscaler.swift
//  CoreMLIntro
//
//  Created by Benavides Vallejo, Jonathan on 02.07.2024.
//

import CoreML
import SwiftUI

@Observable final class Upscaler{
    enum State {
        case loadingModel
        case upscaling
        case ready
        case error(Error)
        case completed(input: UIImage, output: UIImage)
    }
    
    private(set) var state: State = .ready
    
    private var model: Anime512?
    
    init() {
        loadModel()
    }
    
    func upscaleImage(filename: String) {
        guard let model else {
            return
        }
        
        let inputImage = UIImage(named: filename)!
        
        Task {
            do {
                let modelInput = try Anime512Input(xWith: inputImage.cgImage!)
                let resultPixelBuffer = try await model.prediction(input: modelInput).enhanced
                if let resultImage = UIImage(pixelBuffer: resultPixelBuffer) {
                    await MainActor.run {
                        state = .completed(input: inputImage, output: resultImage)
                    }
                } else {
                    await MainActor.run {
                        state = .error("Could not convert image to pixel buffer")
                    }
                }
            } catch {
                await MainActor.run {
                    state = .error(error)
                }
            }
        }
    }
}

private extension Upscaler {
    func loadModel() {
        let configuration = MLModelConfiguration()
        configuration.allowLowPrecisionAccumulationOnGPU = true
        configuration.computeUnits = .all
        
        Task {
            do {
                model = try await Anime512.load(configuration: configuration)
                
                await MainActor.run {
                    state = .ready
                }
            } catch {
                await MainActor.run {
                    state = .error(error)
                }
            }
        }
    }
}
