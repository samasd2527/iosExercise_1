//
//  ViewController.swift
//  iosExercise_1
//
//  Created by 莊善傑 on 2024/5/26.
//

import UIKit
import MapKit
import Toast

struct Hotel: Decodable {
    let lat: Double
    let lng: Double
    let name: String
    let vicinity: String
    let photo: String
    let landscape: [String]
    let star: Int
}

struct ApiResponse: Decodable {
    let results: Results
}

struct Results: Decodable {
    let content: [Hotel]
}

class ViewController: UIViewController{

    var myData : ApiResponse?
    var selectedAnnotation: MKAnnotation?
    var searchHistory: [Hotel] = []
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //跟使用者請求地圖權限
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        //取得API資料
        getDataFromApi()

        mapView.delegate = self
        searchTextField.delegate = self
        
        tapGesturehideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //重置Annotation狀態
        deselectAnnotation()
    }
    
    func getDataFromApi() {
            let usrString = "https://android-quiz-29a4c.web.app/"
            let url = URL(string: usrString)
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if(error != nil){
                    print("發送失敗 ",error!.localizedDescription)
                }
                else{
                    print("發送成功")
                    DispatchQueue.main.async {
                        do{
                            self.myData = try JSONDecoder().decode(ApiResponse.self, from: data!)
                            self.addAnnotations()
                        
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            task.resume()
    }
    
    func addAnnotations() {
        guard let hotels = myData?.results.content else { return }
        for hotel in hotels {
            setAnnotation(lat: hotel.lat, lng: hotel.lng, name: hotel.name, vicinity: hotel.vicinity)
        }
    }
    
    func setAnnotation(lat: Double, lng: Double, name: String, vicinity: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        annotation.title = name
        annotation.subtitle = vicinity
        mapView.addAnnotation(annotation)
    }
    
    func deselectAnnotation() {
        if let annotation = selectedAnnotation {
            mapView.deselectAnnotation(annotation, animated: true)
        }
    }
    
    func tapGesturehideKeyboard(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    
    
    @IBAction func showUserLocationBtn(_ sender: UIBarButtonItem) {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        mapView.setRegion(MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100), animated: true)
    }

    @IBAction func searchBtn(_ sender: UIButton) {
         performSearch()
     }
    
    @IBAction func searchHistoryBtn(_ sender: UIButton) {
        if !searchHistory.isEmpty {
            let PopupView = searchHistoryView()
            PopupView.searchHistory = searchHistory
            PopupView.delegate = self
            PopupView.appear(sender: self)
        }
        else{
            self.view.makeToast("無歷史紀錄")
        }

    }
    
    func performSearch() {
        searchTextField.resignFirstResponder()
        guard let searchText = searchTextField.text, !searchText.isEmpty else {
            print("請輸入搜尋內容")
            return
        }

        guard let hotels = myData?.results.content else {
            self.view.makeToast("查無結果")
            return
        }

        let matchingHotels = hotels.filter { $0.name.contains(searchText) || $0.vicinity.contains(searchText) }

        var matchingHotelsArray: [Hotel] = []
        if !matchingHotels.isEmpty {
            for hotel in matchingHotels {
                matchingHotelsArray.append(hotel)
            }
            let PopupView = SearchResultsView()
            PopupView.searchResults = matchingHotelsArray
            PopupView.delegate = self
            PopupView.appear(sender: self)
        }else {
            self.view.makeToast("查無結果")
        }
    }
    
    func updateSearchHistory(with hotel: Hotel) {
        if let index = searchHistory.firstIndex(where: { $0.name == hotel.name && $0.vicinity == hotel.vicinity }) {
            searchHistory.remove(at: index)
        }
        searchHistory.insert(hotel, at: 0)
        print(searchHistory)
    }

}

extension ViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let title = view.annotation?.title ?? "" {
            if let hotel = myData?.results.content.first(where: { $0.name == title }) {
                let selectedHotel = Hotel(
                    lat: hotel.lat,
                    lng: hotel.lng,
                    name: hotel.name,
                    vicinity: hotel.vicinity,
                    photo: hotel.photo,
                    landscape: hotel.landscape,
                    star: hotel.star
                )
                let PopupView = PopupViewController()
                PopupView.hotelInfo = selectedHotel
                PopupView.delegate = self
                PopupView.appear(sender: self)
            } else {
                print("没有找到匹配的酒店")
            }
        } else {
            print("No title")
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        selectedAnnotation = annotation
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.annotation === selectedAnnotation {
            selectedAnnotation = nil
        }
    }
}

extension ViewController: searchHistoryViewDelegate{
    func didClearHistory(_ data: [Hotel]) {
        searchHistory = data
        self.view.makeToast("已清除紀錄")
    }
    
}

extension ViewController: SearchResultsViewDelegate{
    func didSelectHotel(_ matchingHotel: Hotel) {
        let searchAnnotation = MKPointAnnotation()
        searchAnnotation.coordinate = CLLocationCoordinate2D(latitude: matchingHotel.lat, longitude: matchingHotel.lng)
        mapView.setCenter(searchAnnotation.coordinate, animated: true)
        mapView.setRegion(MKCoordinateRegion(center: searchAnnotation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100), animated: true)
        updateSearchHistory(with: matchingHotel)
    }
    
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("enter")
        performSearch()
        return true
    }
    
}

extension ViewController: PopupViewControllerDelegate{
    
    func navigateToDestination(_ destinationCoordinate: CLLocationCoordinate2D) {
        print("內建導航")
        let sourcePlacemark = MKPlacemark(coordinate: mapView.userLocation.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)

        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let routes=[sourceMapItem,destinationMapItem]
        
        MKMapItem.openMaps(with: routes, launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])

     }
    func showHotelDetails(_ hotel: Hotel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "detailViewController") as? detailViewController {
            detailVC.hotelInfo = hotel
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    func deselectAn(){
        deselectAnnotation() 
    }
}
