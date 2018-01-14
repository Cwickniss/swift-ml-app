//  Created by Areej & SaifRehman on 10/9/17.
import UIKit
import AVKit
import Vision
import AVFoundation
import Alamofire
import SwiftyJSON
class ViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var labelshow: UILabel!
    var voice = ""
    var overlay : UIView?
    
    @IBAction func japanese(_ sender: Any) {
        
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.black
        overlay!.alpha = 0.8
        view.addSubview(overlay!)
        let user = "d2f58ac8-9a7b-4e41-872f-bc068dd16ea7"
        let password = "HLeAnmEz1v0P"
        var headers: HTTPHeaders = ["Content-Type":"application/json","Accept":"application/json"]
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        let trimmedString = self.labelshow.text!.replacingOccurrences(of: " ", with: "")
        print (trimmedString)
        Alamofire.request("https://gateway.watsonplatform.net/language-translator/api/v2/translate?source=en&target=ja&text="+trimmedString,encoding: JSONEncoding.default,headers:headers)
            .responseJSON { response in
                print (response)
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                    let o = JSON(json)
                    var val = o["translations"][0]["translation"].stringValue
                    print (val)
                    let string = ""
                    DispatchQueue.main.async {
                        let utterance = AVSpeechUtterance(string: val)
                        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
                        let synth = AVSpeechSynthesizer()
                        synth.speak(utterance)
                        self.navigationItem.title = val
                        self.overlay?.removeFromSuperview()
                    }
                }
        }
    }
    @IBAction func french(_ sender: Any) {
        
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.black
        overlay!.alpha = 0.8
        view.addSubview(overlay!)
        let user = "d2f58ac8-9a7b-4e41-872f-bc068dd16ea7"
        let password = "HLeAnmEz1v0P"
        
        var headers: HTTPHeaders = ["Content-Type":"application/json","Accept":"application/json"]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        let trimmedString = self.labelshow.text!.replacingOccurrences(of: " ", with: "")
        print (trimmedString)
        
        Alamofire.request("https://gateway.watsonplatform.net/language-translator/api/v2/translate?source=en&target=fr&text="+trimmedString,encoding: JSONEncoding.default,headers:headers)
            .responseJSON { response in
                print (response)
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                    let o = JSON(json)
                    var val = o["translations"][0]["translation"].stringValue
                    print (val)
                    let string = ""
                    DispatchQueue.main.async {
                        let utterance = AVSpeechUtterance(string: val)
                        utterance.voice = AVSpeechSynthesisVoice(language: "fi-FI")
                        let synth = AVSpeechSynthesizer()
                        synth.speak(utterance)
                        self.navigationItem.title = val
                        self.overlay?.removeFromSuperview()

                    }
                    
                }
        }
    }
    
    @IBAction func arabic(_ sender: Any) {
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.black
        overlay!.alpha = 0.8
        view.addSubview(overlay!)
        let user = "d2f58ac8-9a7b-4e41-872f-bc068dd16ea7"
        let password = "HLeAnmEz1v0P"
        
        var headers: HTTPHeaders = ["Content-Type":"application/json","Accept":"application/json"]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        let trimmedString = self.labelshow.text!.replacingOccurrences(of: " ", with: "")
        print (trimmedString)

        Alamofire.request("https://gateway.watsonplatform.net/language-translator/api/v2/translate?source=en&target=ar&text="+trimmedString,encoding: JSONEncoding.default,headers:headers)
            .responseJSON { response in
                print (response)
                            if let json = response.result.value {
                                print("JSON: \(json)") // serialized json response
                                let o = JSON(json)
                                var val = o["translations"][0]["translation"].stringValue
                                print (val)
                                let string = ""
                                DispatchQueue.main.async {
                                    let utterance = AVSpeechUtterance(string: val)
                                    utterance.voice = AVSpeechSynthesisVoice(language: "ar-SA")
                                    let synth = AVSpeechSynthesizer()
                                    synth.speak(utterance)
                                    self.navigationItem.title = val
                                    self.overlay?.removeFromSuperview()
                                }

                            }
        }
    }
    @IBAction func action(_ sender: Any) {
        let string = "Hello, World, speak!"
        let utterance = AVSpeechUtterance(string: self.labelshow.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        self.navigationItem.title =  self.labelshow.text!
    }
    let captureSession = AVCaptureSession()
    let dataOutput = AVCaptureVideoDataOutput()
    var bombSoundEffect: AVAudioPlayer?
    var audioPlayer:AVAudioPlayer!
    var player = AVPlayer()
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession.sessionPreset = .photo
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try?AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "vid getting started"))
        captureSession.addOutput(dataOutput)
        captureSession.startRunning()
    }
    
    func captureOutput(_ output:AVCaptureOutput!, didOutput sampleBuffer: CMSampleBuffer!, from connection:AVCaptureConnection!){
        guard let model  =  try? VNCoreMLModel(for: Resnet50().model) else {return}
        guard let pixelBuffer : CVPixelBuffer =  CMSampleBufferGetImageBuffer(sampleBuffer) else{return}
        let request = VNCoreMLRequest(model: model) { (finishReq, Error) in
            guard let result = finishReq.results as? [VNClassificationObservation] else {return}
            guard let firstob = result.first else {return}
            DispatchQueue.main.async {
            self.labelshow.text = String(firstob.identifier)
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
