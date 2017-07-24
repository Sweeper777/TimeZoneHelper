import UIKit
import CoreLocation
import TimeZoneLocate

@IBDesignable
class TimeZoneDisplay: UIView {
    @IBOutlet var timeDisplay: UILabel!
    @IBOutlet var dayDisplay: UILabel!
    @IBOutlet var descriptionDisplay: UILabel!
    
    let geocoder = CLGeocoder()
    
    var location: CLLocation!
    {
        didSet {
            var countryCode: String?
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil {
                    self.timeDisplay.text = NSLocalizedString("Error", comment: "")
                    self.dayDisplay.text = ""
                    self.descriptionDisplay.text = ""
                } else {
                    self.descriptionDisplay.text = stringFromPlacemark(placemarks?.first)
                    countryCode = placemarks?.first?.isoCountryCode
                }
            }
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
