import Eureka

final class TimeZoneSelectorRow: SelectorRow<PushSelectorCell<TimeZone>, TimeZoneSelectorController>, RowType {
    required init(tag: String?, _ initializer: ((TimeZoneSelectorRow) -> ())) {
        super.init(tag: tag)
        initializer(self)
        presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.storyBoard(storyboardId: "TimeZoneSelector", storyboardName: "Main", bundle: nil), onDismiss: {
            _ in
        })
        displayValueFor = {
            $0?.identifier ?? NSLocalizedString("Please Select", comment: "")
        }
    }
    
    required convenience init(tag: String?) {
        self.init(tag: tag, {_ in})
    }
    
}
