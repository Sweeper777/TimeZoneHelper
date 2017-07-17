import UIKit
import GoogleMaps
import RxGoogleMaps

class MapController: UIViewController, GMSMapViewDelegate {

    @IBOutlet var map: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.mapType = .normal
        map.delegate = self
    }

}

