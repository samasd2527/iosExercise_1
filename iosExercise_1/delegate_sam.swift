//
//  delegate_sam.swift
//  iosExercise_1
//
//  Created by 莊善傑 on 2024/5/27.
//

import Foundation
import MapKit

protocol ViewController2ClearHistoryDelegate: AnyObject {
    func didClearHistory(_ data: [Hotel])
}

protocol PopupViewControllerDelegate: AnyObject {
    func navigateToDestination(_ destinationCoordinate: CLLocationCoordinate2D)
    func showHotelDetails(_ hotel: Hotel)
    func deselectAn()
}
