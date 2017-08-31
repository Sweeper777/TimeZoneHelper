import UIKit
import GoogleMaps
import RxGoogleMaps
import RxSwift
import RxCocoa
import GoogleMobileAds

class MapController: UIViewController, GMSMapViewDelegate {

    @IBOutlet var map: GMSMapView!
    @IBOutlet var crosshair: CrossHair!
    @IBOutlet var timeZoneDisplay: TimeZoneDisplay!
    @IBOutlet var ad: GADBannerView?
    
    @IBOutlet var doneButtton: UIBarButtonItem?
    
    let disposeBag = DisposeBag()
    
    weak var delegate: MapControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.mapType = .normal
        map.delegate = self
        map.settings.tiltGestures = false
        crosshair.layer.zPosition = 1
        timeZoneDisplay.layer.zPosition = 1
        ad?.layer.zPosition = 1
        
        map.rx.idleAtPosition.debounce(0.5, scheduler: MainScheduler.instance)
            .map ({ CLLocation(latitude: $0.target.latitude, longitude: $0.target.longitude) })
            .asObservable()
            .subscribe(onNext: { [weak self] loc in self?.timeZoneDisplay.location = loc })
            .disposed(by: disposeBag)
        
        if let done = doneButtton {
            timeZoneDisplay.loading.asObservable()
                .map{ !$0 }
                .bind(to: done.rx.isEnabled)
                .disposed(by: disposeBag)
        }
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        ad?.adUnitID = ad1ID
        ad?.rootViewController = self
        ad?.load(request)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timeZoneDisplay.updateDisplays()
        (UIApplication.shared.delegate as! AppDelegate).clock.onTimerChange = {
            [weak self] in
            self?.timeZoneDisplay.updateDisplays()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        (UIApplication.shared.delegate as! AppDelegate).clock.onTimerChange = nil
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        if timeZoneDisplay.descriptionDisplay.text! == NSLocalizedString("Unknown Location", comment: "") {
            delegate?.didSelectTimeZone(timeZone: timeZoneDisplay.timeZone, customLabelText: "\(timeZoneDisplay.descriptionDisplay.text!) (\(timeZoneDisplay.timeZone.identifier))")
        } else {
            delegate?.didSelectTimeZone(timeZone: timeZoneDisplay.timeZone, customLabelText: timeZoneDisplay.descriptionDisplay.text!)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

