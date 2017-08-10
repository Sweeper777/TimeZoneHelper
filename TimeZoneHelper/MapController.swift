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
        
        map.rx.idleAtPosition.debounce(0.5, scheduler: MainScheduler.instance)
            .map ({ CLLocation(latitude: $0.target.latitude, longitude: $0.target.longitude) })
            .asObservable()
            .subscribe(onNext: { self.timeZoneDisplay.location = $0 })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timeZoneDisplay.updateDisplays()
        (UIApplication.shared.delegate as! AppDelegate).clock.onTimerChange = {
            self.timeZoneDisplay.updateDisplays()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        (UIApplication.shared.delegate as! AppDelegate).clock.onTimerChange = nil
    }
    
    @IBAction func cancel() {
    
    }
    
    @IBAction func done() {
        
    }
}

