//
//  delegate_sam.swift
//  iosExercise_1
//
//  Created by 莊善傑 on 2024/5/27.
//

import Foundation
import MapKit

protocol PopupViewControllerDelegate: AnyObject {
    func navigateToDestination(_ destinationCoordinate: CLLocationCoordinate2D)
    func showHotelDetails(_ hotel: Hotel)
    func deselectAn()
}

protocol searchHistoryViewDelegate: AnyObject {
    func didClearHistory(_ data: [Hotel])
}

protocol SearchResultsViewDelegate: AnyObject {
    func didSelectHotel(_ matchingHotel: Hotel)
}
