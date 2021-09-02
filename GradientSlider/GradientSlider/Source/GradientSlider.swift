//
//  GradientSlider.swift
//  GradientSlider
//
//  Created by Karan Singla on 02/09/21.
//

import UIKit

class GradientSlider: UISlider {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let thumb = thumbImage(radius: 28)
        setThumbImage(thumb, for: .normal)
        colorTrack()
    }
    
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = .white//thumbTintColor
        thumb.layer.borderWidth = 6.5
        thumb.layer.borderColor = "#CCA2FC".hexColor.cgColor
        return thumb
    }()
    
    
     override func trackRect(forBounds bounds: CGRect) -> CGRect {
          var result = super.trackRect(forBounds: bounds)
          result.origin.x = 0
          result.size.width = bounds.size.width
          result.size.height = 8 //added height for desired effect
          return result
     }
    
}

private extension GradientSlider {
    
    private func thumbImage(radius: CGFloat) -> UIImage {
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2

        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }

    func colorTrack() {
        let minTrackStartColor = "#7710FF".hexColor
        let minTrackEndColor = "#E12353".hexColor
        let maxTrackColor = "#F3F3F9".hexColor
        do {
            self.setMinimumTrackImage(try self.gradientImage(
            size: self.trackRect(forBounds: self.bounds).size,
            colorSet: [minTrackStartColor.cgColor, minTrackEndColor.cgColor]),
                                  for: .normal)
            self.setMaximumTrackImage(try self.gradientImage(
            size: self.trackRect(forBounds: self.bounds).size,
            colorSet: [maxTrackColor.cgColor, maxTrackColor.cgColor]),
                                  for: .normal)
        } catch {
            self.minimumTrackTintColor = minTrackStartColor
            self.maximumTrackTintColor = maxTrackColor
        }

    }
    
    func gradientImage(size: CGSize, colorSet: [CGColor]) throws -> UIImage? {
           let tgl = CAGradientLayer()
           tgl.frame = CGRect.init(x:0, y:0, width:size.width, height: size.height)
           tgl.cornerRadius = tgl.frame.height / 2
           tgl.masksToBounds = false
           tgl.colors = colorSet
           tgl.startPoint = CGPoint.init(x:0.0, y:0.5)
           tgl.endPoint = CGPoint.init(x:1.0, y:0.5)

           UIGraphicsBeginImageContextWithOptions(size, tgl.isOpaque, 0.0);
           guard let context = UIGraphicsGetCurrentContext() else { return nil }
           tgl.render(in: context)
           let image =

       UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets:
           UIEdgeInsets.init(top: 0, left: size.height, bottom: 0, right: size.height))
           UIGraphicsEndImageContext()
           return image!
       }

}
