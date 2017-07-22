import UIKit
import GoogleMaps
import RxGoogleMaps
import RxSwift
import RxCocoa

class MapController: UIViewController, GMSMapViewDelegate {

    @IBOutlet var map: GMSMapView!
    @IBOutlet var crosshair: UIImageView!
    @IBOutlet var timeZoneDisplay: TimeZoneDisplay!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.mapType = .normal
        map.delegate = self
        map.settings.tiltGestures = false
        crosshair.layer.zPosition = 1
        timeZoneDisplay.layer.zPosition = 1
    }
}

