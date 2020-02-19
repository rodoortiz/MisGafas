//
//  ViewController.swift
//  MisGafas
//
//  Created by Rodolfo Ortiz on 10/02/20.
//  Copyright © 2020 Rodolfo Ortiz. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var session: ARSession {
        return sceneView.session
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            updateMessage(text: "Face Tracking is not supported")
            return
        }
        
        setupScene()
        //createFaceGeometry()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true //Prevents the device from going to sleep
        resetTracking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        sceneView.session.pause()
    }
}

extension ViewController: ARSCNViewDelegate {
    
    //ARSession Handling
    func session(_ session: ARSession, didFailWithError error: Error) {
    updateMessage(text: "Session failed.") }
    
    func sessionWasInterrupted(_ session: ARSession) {
    updateMessage(text: "Session interrupted.") }
    
    func sessionInterruptionEnded(_ session: ARSession) {
    updateMessage(text: "Session interruption ended.") }
}

private extension ViewController {
    
    //Update label message
    func updateMessage(text: String) {
        DispatchQueue.main.sync {
            self.messageLabel.text = text
        }
    }
    
    //Setup scene
    func setupScene() {
        sceneView.delegate = self //Set de views delegate
        
        //Setup environment
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene.lightingEnvironment.intensity = 1.0
    }
    
    //FaceTracking Configuration
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else {
            updateMessage(text: "Face Tracking not supported")
            return
        }
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        configuration.providesAudioData = false
        
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

