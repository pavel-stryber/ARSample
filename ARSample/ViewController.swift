//
//  ViewController.swift
//  ARSample
//
//  Created by Pavel Lapin on 3/9/21.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration();
    
    @IBAction func reset(_ sender: Any) {
        self.restartSession();
    }
    @IBAction func add(_ sender: Any) {
        let node = SCNNode()
        
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.1/2)
        let x = self.randomNumbers(first: -0.3, second: 0.3)
        let y = self.randomNumbers(first: -0.3, second: 0.3)
        let z = self.randomNumbers(first: -0.3, second: 0.3)
        node.position = SCNVector3(x, y, z)
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        self.configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "ARObjects", bundle: Bundle.main)!
        
//        self.configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "ARObjects", bundle: Bundle.main)!
        // important to have it:
        sceneView.delegate = self
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin];
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors]);
        self.sceneView.autoenablesDefaultLighting = true;
    }
    
    func restartSession() {
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func randomNumbers(first: CGFloat, second: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(first - second) + min(first, second)
    }

    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode();
        if let imageAnchor = anchor as? ARImageAnchor {
            let referenceImage = imageAnchor.referenceImage
            
            print("--------- anchor is detected ---", referenceImage.name!)
            let tipNode = SCNNode();
            let text = SCNText(string: referenceImage.name, extrusionDepth: 2)
            // tipNode.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.1/2)
            text.font = UIFont(name: "", size: 0.1);
            let material = SCNMaterial();                       material.diffuse.contents = UIColor.magenta;
            text.materials = [material];
            
            
            
            //tipNode.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.1/2)
            
            //tipNode.geometry?.firstMaterial?.specular.contents = UIColor.white
            //tipNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            
            
            tipNode.geometry = text;
            tipNode.scale = SCNVector3(0.003, 0.003, 0.003);
            tipNode.rotation = SCNVector4(0, 3, 2, 3);
            tipNode.position = SCNVector3(0.08, 0, -0.02);
            
            
            
            node.addChildNode(tipNode)
            
        }
        return node;
    }
    

    
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        let node = SCNNode();
//
//        if let objectAnchor = anchor as? ARObjectAnchor {
//            NSLog("--------- anchor is detected ----------------")
//            let plane = SCNPlane(width: CGFloat(objectAnchor.referenceObject.extent.x * 0.8), height: CGFloat(objectAnchor.referenceObject.extent.y * 0.5))
//            plane.cornerRadius = plane.width / 8
//            let spriteKitScene = SKScene(fileNamed: "calc_photo")
//
//            plane.firstMaterial?.diffuse.contents = spriteKitScene
//            plane.firstMaterial?.isDoubleSided = true
//            plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
//            let planeNode = SCNNode(geometry: plane)
//            planeNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x, objectAnchor.referenceObject.center.y + 0.35, objectAnchor.referenceObject.center.z)
//             node.addChildNode(node)
////            node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.1/2)
////            node.position = SCNVector3(objectAnchor.referenceObject.center.x, objectAnchor.referenceObject.center.y, objectAnchor.referenceObject.center.z)
////            node.geometry?.firstMaterial?.specular.contents = UIColor.white
////            node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//        }
//
//
//
//        return node;
//    }
    
}

