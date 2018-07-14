//
//  ViewController.swift
//  ImageTrackingThing
//
//  Created by Erik Martin on 7/2/18.
//  Copyright © 2018 Erik Martin. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/Scene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
		
		guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "photos", bundle: Bundle.main) else {
			print("no images availiable")
			return
		}
		
		configuration.trackingImages = trackedImages
		configuration.maximumNumberOfTrackedImages = 1

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
	func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
		
		let node = SCNNode()
		
		if let imageAnchor = anchor as? ARImageAnchor {
			
			let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
			let plane2 = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)

			let image = UIImage(named:"mojaveDesk")!
			
			let planeMaterial = SCNMaterial()
			planeMaterial.emission.contents = image
			planeMaterial.isDoubleSided = true

			plane.firstMaterial?.diffuse.contents = image
			//plane.materials = [planeMaterial]
			plane2.firstMaterial?.diffuse.contents = image
			//plane2.materials = [planeMaterial]
			
			let planeNode = SCNNode(geometry: plane)
			planeNode.eulerAngles.x = -.pi / 2
			planeNode.eulerAngles.z = .pi / 4
			
			planeNode.position.x = 0.25
			planeNode.position.y = 0.1
			
			node.addChildNode(planeNode)
			
			let planeNode2 = SCNNode(geometry: plane)
			planeNode2.eulerAngles.x = -.pi / 2
			planeNode2.eulerAngles.z = -.pi / 4
			
			planeNode2.position.x = -0.25
			planeNode2.position.y = 0.1

			node.addChildNode(planeNode2)
		}
		
		return node
	}

	
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
