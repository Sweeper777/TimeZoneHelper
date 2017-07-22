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
        
        map.rx.didChangePosition.debounce(0.5, scheduler: MainScheduler.instance)
            .map ({ CLLocation(latitude: $0.target.latitude, longitude: $0.target.longitude) })
            .asObservable()
            .subscribe(onNext: { self.timeZoneDisplay.location = $0 })
            .disposed(by: disposeBag)
    }
}

