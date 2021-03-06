import UIKit
import CoreLocation
import LatLongToTimezone
import RxSwift

@IBDesignable
class TimeZoneDisplay: UIView {
    @IBOutlet var timeDisplay: UILabel!
    @IBOutlet var dayDisplay: UILabel!
    @IBOutlet var descriptionDisplay: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    let loading = Variable<Bool>(false)
    
    let geocoder = CLGeocoder()
    
    var location: CLLocation!
    {
        didSet {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            loading.value = true
            geocoder.reverseGeocodeLocation(location) {
                [weak self]
                (placemarks, error) in
                guard let s = self else { return }
                s.descriptionDisplay.text = stringFromPlacemark(placemarks?.first)
                s.timeZone = TimezoneMapper.latLngToTimezone(s.location.coordinate)
                s.updateDisplays()
                s.loadingIndicator.isHidden = true
                s.loadingIndicator.stopAnimating()
                s.loading.value = false
            }
        }
    }
    
    var timeZone: TimeZone!
    
    func updateDisplays() {
        if let timeZone = self.timeZone {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = timeZone
            self.timeDisplay.text = formatter.string(from: Date())
            self.dayDisplay.text = dayStringFromTimeZone(timeZone)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    private func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        addSubview(view)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    private func viewFromNibForClass() -> UIView {
        
        let bundle = Bundle.main
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
}

func stringFromPlacemark(_ placemark: CLPlacemark?) -> String {
    guard let placemark = placemark else {
        return NSLocalizedString("Unknown Location", comment: "")
    }
    if let city = placemark.locality {
        return city
    }
    if let state = placemark.administrativeArea {
        return state
    }
    if let country = placemark.country {
        return country
    }
    return NSLocalizedString("Unknown Location", comment: "")
}

func dayStringFromTimeZone(_ timeZone: TimeZone) -> String {
    let delta = timeZone.secondsFromGMT()
    let currentDelta = TimeZone.current.secondsFromGMT()
    let difference = delta - currentDelta
    let currentDay = Calendar.current.component(.day, from: Date())
    let day = Calendar.current.component(.day, from: Date().addingTimeInterval(Double(difference)))
    switch day - currentDay {
    case 1:
        return NSLocalizedString("Tomorrow", comment: "")
    case 0:
        return NSLocalizedString("Today", comment: "")
    case -1:
        return NSLocalizedString("Yesterday", comment: "")
    default:
        fatalError()
    }
}
