//
//  InstructionOverlay.swift
//  InstructionOverlay
//
//  Created by Gaurang on 10/03/23.
//
import UIKit

class InstructionOverlay: UIView {
    
    var viewFrame: CGRect = .zero
    var instruction: String = ""
    var hideAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static func show(
        inRect rect: CGRect,
        instruction: String,
        hideAction: @escaping () -> Void
    ) {
        guard let window = UIApplication.shared.windows.last else {
            return
        }
        let object = InstructionOverlay(frame: window.bounds)
        object.viewFrame = rect
        object.instruction = instruction
        window.addSubview(object)
        object.show()
        object.hideAction = hideAction
    }
    
    @objc func hide() {
        self.removeFromSuperview()
        hideAction?()
    }
    
    func show() {
        
        self.backgroundColor =  UIColor.black.withAlphaComponent(0.7)
    
        let maskLayer = CALayer()
        maskLayer.frame = self.bounds
        let circleLayer = CAShapeLayer()
        //assume the circle's radius is 150
        circleLayer.frame = CGRect(x:0 , y:0, width: self.frame.size.width,height: self.frame.size.height)
        let finalPath = UIBezierPath(roundedRect: CGRect(x:0 , y:0, width: self.frame.size.width, height: self.frame.size.height), cornerRadius: 0)
        let circlePath = UIBezierPath.init(rect: viewFrame)
        finalPath.append(circlePath.reversing())
        circleLayer.path = finalPath.cgPath
        circleLayer.borderColor = UIColor.white.withAlphaComponent(1).cgColor
        circleLayer.borderWidth = 1
        maskLayer.addSublayer(circleLayer)
        self.layer.mask = maskLayer
        
        // Create a text layer with some sample text
        let textLayer = CATextLayer()
        textLayer.string = instruction
        textLayer.fontSize = 17
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.alignmentMode = .center
        let preferredSize = textLayer.preferredFrameSize()

        let screenHeight = UIScreen.main.bounds.height
        var yPoint: CGFloat = 0
        let shapeY = viewFrame.origin.y
        let shapeHeight = viewFrame.height
        if (shapeY + shapeHeight + 100) < screenHeight {
            yPoint = shapeY + shapeHeight + 20
        } else {
            yPoint = shapeY - shapeHeight - 20
        }
        textLayer.frame = CGRect(x: 0, y: yPoint, width: UIScreen.main.bounds.width, height: preferredSize.height)
        self.layer.addSublayer(textLayer)
    }
}

class TextLayer: CALayer {
    var text: String = ""
    var font: UIFont = UIFont.systemFont(ofSize: 12)
    var color: UIColor = .white
    
    override func draw(in ctx: CGContext) {
        let attributedText = NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color.cgColor])
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText as CFAttributedString)
        let rect = bounds.insetBy(dx: 5, dy: 5)
        let path = UIBezierPath(rect: rect).cgPath
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedText.length), path, nil)
        CTFrameDraw(frame, ctx)
    }
}

extension UIView {
    func showInstructionOverlay(_ instruction: String) {
        guard let window = UIApplication.shared.windows.last else {
            return
        }
        let object = InstructionOverlay(frame: window.bounds)
        object.viewFrame = self.frame
        object.instruction = instruction
        window.addSubview(object)
        object.show()
        window.bringSubviewToFront(self)
    }
}
