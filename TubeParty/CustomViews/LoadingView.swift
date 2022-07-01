//
//  LoadingView.swift
//  TubeParty
//
//  Created by Damrongdech Haemanee on 1/7/2565 BE.
//

import Foundation
import UIKit

class LoadingView: UIView {
    struct Constants {
        static let circleSize: CGFloat = 20
        static let circleCount: Int = 3
        static let circleColor: UIColor = .tpMainBlue
        static let xPosition: [CGFloat] = [-70, -15, 15, 70]
    }
    
    private var viewStacks: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
        self.animate()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func prepare() {
        for index in 0..<Constants.circleCount {
            let circle = UIView(frame: .init(x: Constants.xPosition[0], y: 0, width: Constants.circleSize, height: Constants.circleSize))
            circle.layer.cornerRadius = Constants.circleSize / 2
            circle.backgroundColor = Constants.circleColor
            circle.layer.shadowColor = UIColor.tpMainBlue.withAlphaComponent(0.6).cgColor
            circle.layer.shadowOffset = .init(width: 3, height: 3)
            circle.layer.shadowOpacity = 1
            circle.layer.shadowRadius = 6
            circle.alpha = 0
            self.viewStacks.append(circle)
            self.addSubview(self.viewStacks[index])
        }
    }
    
    func animate() {
        var delay: Double = 0
        for circle in self.viewStacks {
            self.animateCircle(circle, delay: delay)
            delay += 0.95
        }
    }
    
    func animateCircle(_ circle: UIView, delay: Double) {
        UIView.animate(withDuration: 0.8, delay: delay, options: .curveLinear) {
            circle.alpha = 1
            circle.frame = CGRect(x: Constants.xPosition[1], y: 0, width: Constants.circleSize, height: Constants.circleSize)
        } completion: { _ in
            UIView.animate(withDuration: 1.3, delay: 0, options: .curveLinear) {
                circle.frame = CGRect(x: Constants.xPosition[2], y: 0, width: Constants.circleSize, height: Constants.circleSize)
            } completion: { _ in
                UIView.animate(withDuration: 0.8, delay: 0, options: .curveLinear) {
                    circle.alpha = 0
                    circle.frame = CGRect(x: Constants.xPosition[3], y: 0, width: Constants.circleSize, height: Constants.circleSize)
                } completion: { [weak self] _ in
                    circle.frame = CGRect(x: Constants.xPosition[0], y: 0, width: Constants.circleSize, height: Constants.circleSize)
                    self?.animateCircle(circle, delay: 0)
                }
            }
        }

    }
}
