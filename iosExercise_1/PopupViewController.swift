//
//  PopupViewController.swift
//  iosExercise_1
//
//  Created by 莊善傑 on 2024/5/28.
//

import UIKit
import MapKit

class PopupViewController: UIViewController , MKMapViewDelegate {

    weak var delegate: PopupViewControllerDelegate?
    var hotelInfo: Hotel?
    
    init() {
        super.init(nibName: "PopupViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()//初始化popupView
        swipeDown()
        popupViewLabel.text = hotelInfo?.name
    }
    
    private func configView() {
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.popupView.alpha = 0
        self.popupView.layer.cornerRadius = 10
    }
    
    func swipeDown(){
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swapDownView(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @IBOutlet weak var popupViewLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var popupView: UIView!
    
    @IBAction func hotelInfo(_ sender: UIButton) {
        hideNoAnimate()
        if let hotel = hotelInfo {
              delegate?.showHotelDetails(hotel)
          }
    }
    
    @IBAction func hotelNavigation(_ sender: UIButton) {
        let destinationCoordinate = CLLocationCoordinate2D(latitude: hotelInfo!.lat, longitude: hotelInfo!.lng)
        
        delegate?.navigateToDestination(destinationCoordinate)

    }
    
    @IBAction func dismissView(_ sender: UITapGestureRecognizer) {
        hide()
    }
    
    @IBAction func swapDownView(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            hide()
        }
    }
    
    
    func appear(sender: ViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
    }
    
    private func show() {
        UIView.animate(withDuration: 1, delay: 0.1) {
            self.backView.alpha = 1
            self.popupView.alpha = 1
        }
    }
    
    func hide() {
        delegate?.deselectAn()
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.popupView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
    
    func hideNoAnimate() {
        delegate?.deselectAn()
        self.dismiss(animated: false)
        self.removeFromParent()
    }

}
