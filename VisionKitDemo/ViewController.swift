//
//  ViewController.swift
//  VisionKitDemo
//
//  Created by rabeeh on 25/10/19.
//  Copyright © 2019 NFNLabs. All rights reserved.
//

import UIKit
import VisionKit
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var captureBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    
    @IBAction func captureBtnClicked(_ sender: UIButton) {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = self
        present(scanner, animated: true)
    }

}
extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true) { [weak self] in
            
            for i in 0 ..< scan.pageCount {
                let img = scan.imageOfPage(at: i)
                // ... your code here
                self?.imgView.image = img
            }
            
            
            
            self?.imgView.image = scan.imageOfPage(at: 0)
            let asset = scan.imageOfPage(at: 0).cgImage
        
//            let rh = VNImageRequestHandler(cgImage: asset!, options: [:])
//            let rr = VNRecognizeTextRequest()
////            rr.completionHandler =
//            rr.recognitionLevel = VNRequestTextRecognitionLevel.accurate
//            rr.revision = VNRecognizeTextRequestRevision1
//            rr.usesLanguageCorrection = true
            
            
            let request = VNRecognizeTextRequest { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    fatalError("Received invalid observations")
                }

                for observation in observations {
                    guard let bestCandidate = observation.topCandidates(1).first else {
                        print("No candidate")
                        continue
                    }

                    print("Found this candidate: \(bestCandidate.string)")
                }
            }
            request.recognitionLevel = .accurate
            
            let requests = [request]

            DispatchQueue.global(qos: .userInitiated).async {
                guard let img = UIImage(named: "testImage")?.cgImage else {
                    fatalError("Missing image to scan")
                }

                let handler = VNImageRequestHandler(cgImage: img, options: [:])
                try? handler.perform(requests)
            }
            
            
            guard let strongSelf = self else { return }
            UIAlertController.present(title: "Success!", message: "Document \(scan.title) scanned with \(scan.pageCount) pages.", on: strongSelf)
        }
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true) { [weak self] in
            self?.imgView.image = nil
            
            guard let strongSelf = self else { return }
            UIAlertController.present(title: "Cancelled", message: "User cancelled operation.", on: strongSelf)
        }
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true) { [weak self] in
            self?.imgView.image = nil
            
            guard let strongSelf = self else { return }
            UIAlertController.present(title: "Error", message: error.localizedDescription, on: strongSelf)
        }
    }
}

extension UIAlertController {
    static func present(title: String?, message: String?, on viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "OK", style: .default)
        alert.addAction(confirm)
        viewController.present(alert, animated: true)
    }
}


