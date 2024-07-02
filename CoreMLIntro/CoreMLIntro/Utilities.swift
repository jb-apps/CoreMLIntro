//
//  Utilities.swift
//  CoreMLIntro
//
//  Created by Benavides Vallejo, Jonathan on 02.07.2024.
//

import Foundation
import UIKit

extension String: Error { }

extension UIImage {
    var pixelSize: CGSize {
        CGSize(width: cgImage!.width, height: cgImage!.height)
    }
}
