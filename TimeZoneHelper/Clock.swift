import Foundation

class Clock {
    
    var onTimerChange: (() -> Void)?
    
    var time: (hour: Int, minute: Int)!
    
    var timer: Foundation.Timer?
    
    init() {
        onTimerChange?()
        let date = Date()
        let secondsUntilMinute = 60 - (Calendar.current as NSCalendar).component(.second, from: date)
        if secondsUntilMinute != 0 {
            _ = Foundation.Timer.after(Double(secondsUntilMinute)) {
                [weak self] in
                if let myself = self {
                    myself.onTimerChange?()
                    myself.timer = Foundation.Timer.every(60) {
                        [weak self] _ in
                        if self == nil {
                            self?.timer?.invalidate()
                        }
                        self?.onTimerChange?()
                    }
                }
            }
        } else {
            self.timer = Foundation.Timer.every(60) {
                [weak self] _ in
                if self == nil {
                    self?.timer?.invalidate()
                }
                self?.onTimerChange?()
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
