import UIKit
import GoogleMaps
import RxGoogleMaps

class MapController: UIViewController, GMSMapViewDelegate {

    @IBOutlet var map: GMSMapView!
    @IBOutlet var crosshair: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.mapType = .normal
        map.delegate = self
        crosshair.layer.zPosition = 1
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        let location = map.camera.target
        let marker = GMSMarker(position: location)
        marker.map = map
    }
}

