//
//  DocumentScanningViewController.swift
//  VisionKitDemo
//
//  Created by rabeeh on 28/10/19.
//  Copyright © 2019 NFNLabs. All rights reserved.
//

import UIKit
import Vision
import VisionKit

class DocumentScanningViewController: UIViewController {

    @IBOutlet weak var btnScan: UIButton!
    
    static let show = "ShowDocumentViewController"
    
    var resultsViewController : (UIViewController & RecognizedTextDataSourceDelegate)?
    var textRecognitionRequest = VNRecognizeTextRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            guard let resultsViewController = self.resultsViewController else{print("resultsViewController is not set") ; return}
            if let result = request.results, !result.isEmpty{
                if let requestResults = request.results  as? [VNRecognizedTextObservation]{
                    DispatchQueue.main.async {
                        resultsViewController.addRecognizedText(recognizedText: requestResults)
                    }
                }
            }
        })
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true
        
    }
    
    @IBAction func btnScanClicked(_ sender: UIButton) {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }
    
    //MARK: - Functions
    
    func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("Failed to get cgimage from input image")
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
    }

}

extension DocumentScanningViewController:VNDocumentCameraViewControllerDelegate{
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        var vcID :String?
        vcID = DocumentScanningViewController.show
        
        if let vc = vcID{
            resultsViewController = storyboard?.instantiateViewController(identifier: vc) as? (UIViewController & RecognizedTextDataSourceDelegate)
        }
        
        controller.dismiss(animated: true) {
            DispatchQueue.global(qos: .userInitiated).async {
                for pageNumber in 0 ..< scan.pageCount {
                    let image = scan.imageOfPage(at: pageNumber)
                    self.processImage(image: image)
                }
                DispatchQueue.main.async {
                    if let resultsVC = self.resultsViewController {
                        self.navigationController?.pushViewController(resultsVC, animated: true)
                    }
                }
            }
        }
    }
}
