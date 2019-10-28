//
//  ShowDocumentViewController.swift
//  VisionKitDemo
//
//  Created by rabeeh on 28/10/19.
//  Copyright © 2019 NFNLabs. All rights reserved.
//

import UIKit
import Vision

class ShowDocumentViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lblInstaHandle: UILabel!
    
    var transcript = ""
    var instaHandle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView?.text = transcript
        lblInstaHandle.text = instaHandle
    }

}

extension ShowDocumentViewController:RecognizedTextDataSourceDelegate{
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        let maximumCandidates = 1
        for observation in recognizedText {
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            transcript += candidate.string
            transcript += "\n"
        }
//        textView?.text = transcript
         let array = transcript.split(separator: "\n").map(String.init)
        var index = Int()
        if array.contains("<"){
            if let mmm = array.firstIndex(of: "<").map({ $0 }){
                index = mmm
            }
        }
        if array.count > 0 , index != nil{
            instaHandle = array[index]
//            lblInstaHandle.text = instaHandle
        }
    }
    
    
}
