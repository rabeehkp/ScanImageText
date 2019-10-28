//
//  RecognizedTextDataSource.swift
//  VisionKitDemo
//
//  Created by rabeeh on 28/10/19.
//  Copyright © 2019 NFNLabs. All rights reserved.
//

import Foundation
import UIKit
import Vision

protocol RecognizedTextDataSourceDelegate {
    func addRecognizedText(recognizedText:[VNRecognizedTextObservation])
}
