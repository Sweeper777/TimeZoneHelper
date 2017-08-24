import UIKit

@IBDesignable
class CrossHair: UIView {
    override func draw(_ rect: CGRect) {
        let newRect = CGRect(
            x: rect.x + rect.width / 4,
            y: rect.y + rect.height / 4,
            width: rect.width / 2,
            height: rect.height / 2
        )
        let path = UIBezierPath(ovalIn: newRect)
        let strokeWidth = min(rect.width, rect.height) * 0.05
        path.lineWidth = strokeWidth
        UIColor.black.setStroke()
        path.stroke()
        
        let horizontalLine = UIBezierPath()
        horizontalLine.move(to: CGPoint(x: rect.x, y: rect.midY))
        horizontalLine.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        horizontalLine.lineWidth = strokeWidth
        horizontalLine.stroke()
        
        let verticalLine = UIBezierPath()
        verticalLine.move(to: CGPoint(x: rect.midX, y: rect.y))
        verticalLine.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        verticalLine.lineWidth = strokeWidth
        verticalLine.stroke()
    }
}
