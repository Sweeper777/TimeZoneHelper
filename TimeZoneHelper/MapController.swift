import UIKit
import GoogleMaps
import RxGoogleMaps

class MapController: UIViewController, GMSMapViewDelegate {

    @IBOutlet var map: GMSMapView!
    @IBOutlet var crosshair: UIImageView!
    @IBOutlet var timeZoneDisplay: TimeZoneDisplay!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.mapType = .normal
        map.delegate = self
        map.settings.tiltGestures = false
        crosshair.layer.zPosition = 1
    }
}

