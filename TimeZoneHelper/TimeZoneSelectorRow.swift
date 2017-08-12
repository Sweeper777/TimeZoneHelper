import Eureka

class TimeZoneSelectorRow: SelectorRow<PushSelectorCell<TimeZone>, TimeZoneSelectorController> {
    required init(tag: String?, _ initializer: ((TimeZoneSelectorRow) -> ())) {
        super.init(tag: tag)
        initializer(self)
        presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.storyBoard(storyboardId: "TimeZoneSelector", storyboardName: "Main", bundle: nil), onDismiss: {
            _ in
        })
        displayValueFor = {
            $0?.identifier ?? ""
        }
    }
    
    required convenience init(tag: String?) {
        self.init(tag: tag)
    }
}
