//
//  ViewController.swift
//  MisGafas
//
//  Created by Rodolfo Ortiz on 10/02/20.
//  Copyright © 2020 Rodolfo Ortiz. All rights reserved.
//

import UIKit
import ARKit

//enum ContentType: Int {
//    case none
//    case model1
//    case model2
//    case model3
//}

class ARSceneViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var anchorNode: SCNNode?
    var contentTypeSelected: Content = .none //Variable to track the selection
    var model1: SunglassesModel1? //Variable for the glasses 1
    var model2: SunglassesModel2? //Variable for the glasses 2
    var model3: SunglassesModel3? //Variable for the glasses 3
    var takenPhoto: UIImage? //Variable for the taken photo
    
    var session: ARSession {
        return sceneView.session
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            updateMessage(text: "Device not supported")
            return
        }
        
        updateMessage(text: "Choose a product")
        contentTypeSelected = .none
        setupScene()
        createFaceGeometry()
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
    
    @IBAction func didTapModel1(_ sender: Any) {
        updateMessage(text: "Model 1")
        contentTypeSelected = .model1
        resetTracking()
    }
    
    @IBAction func didTapModel2(_ sender: Any) {
        updateMessage(text: "Model 2")
        contentTypeSelected = .model2
        resetTracking()
    }
    
    @IBAction func didTapModel3(_ sender: Any) {
        updateMessage(text: "Model 3")
        contentTypeSelected = .model3
        resetTracking()
    }
    
    @IBAction func didTapBuy(_ sender: Any) {
    }
    
    @IBAction func didTapPhoto(_ sender: Any) {
        takenPhoto = sceneView.snapshot()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photo" {
            let destinationVC = segue.destination as! SnapshotViewController
            if let photo = takenPhoto {
                destinationVC.photo = photo //Sending thru segue the photo
            }
        }
        if segue.identifier == "buy" {
            let destinationVC = segue.destination as! BuyViewController
            destinationVC.contentTypeSelected = contentTypeSelected //Sending thru segue the contentType status
        }
    }
}

extension ARSceneViewController: ARSCNViewDelegate {
    
    //ARSession Handling
    func session(_ session: ARSession, didFailWithError error: Error) {
    updateMessage(text: "Session failed.") }
    
    func sessionWasInterrupted(_ session: ARSession) {
    updateMessage(text: "Session interrupted.") }
    
    func sessionInterruptionEnded(_ session: ARSession) {
    updateMessage(text: "Choose a product") }
    
    //Anchor Node, ARNodeTracking
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) { //(_didAdd:for:) gets called for each anchor added to the scene
        anchorNode = node
        setUpFaceNodeContent()
    }
    
    //ARFaceGeometryUpdate
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        switch contentTypeSelected {
        case .none: break
        case .model1:
            model1?.update(withFaceAnchor: faceAnchor)
        case .model2:
            model2?.update(withFaceAnchor: faceAnchor)
        case .model3:
            model3?.update(withFaceAnchor: faceAnchor)
        }
    } //View automatically calls the renderer(_:didUpdate:for:) ARSCNViewDelegate method every time the anchor is updated
    
    //SceneKit Renderer
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let estimate = session.currentFrame?.lightEstimate else { return }
        
        let intesity = estimate.ambientIntensity/1000.0
        sceneView.scene.lightingEnvironment.intensity = intesity
    }
}

private extension ARSceneViewController {
    
    //Update label message
    func updateMessage(text: String) {
      DispatchQueue.main.async {
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
            updateMessage(text: "Device not supported")
            return
        }
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        configuration.providesAudioData = false
        
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    //CreateARSCNFaceGeometry
    func createFaceGeometry() {
        
        let device = sceneView.device!
        
        let model1Geometry = ARSCNFaceGeometry(device: device)! //Using the scene’s Metal device to initialize an ARSCNFaceGeometry object. Creates the face geometry object
        model1 = SunglassesModel1(geometry: model1Geometry) //Populates model1 using the face geometry
        
        let model2Geometry = ARSCNFaceGeometry(device: device)!
        model2 = SunglassesModel2(geometry: model2Geometry)
        
        let model3Geometry = ARSCNFaceGeometry(device: device)!
        model3 = SunglassesModel3(geometry: model3Geometry)
    }
    
    //Setup Face Content Nodes
    func setUpFaceNodeContent() {
        guard let node = anchorNode else { return }
        
        node.childNodes.forEach{ $0.removeFromParentNode() } //Removes any child nodes that contains anchorNode
        
        switch contentTypeSelected {
        case .none: break
        case .model1:
            if let content = model1 {
                node.addChildNode(content) //Adds model1 to the node as a child node
            }
        case .model2:
            if let content = model2 {
                node.addChildNode(content)
            }
        case .model3:
            if let content = model3 {
                node.addChildNode(content)
            }
        }
        
    }
}

