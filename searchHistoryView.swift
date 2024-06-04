//
//  searchHistoryView.swift
//  iosExercise_1
//
//  Created by 莊善傑 on 2024/6/3.
//

import UIKit

class searchHistoryView: UIViewController{
    
    weak var delegate: searchHistoryViewDelegate?
    var searchHistory: [Hotel] = []
    var hotel: [Hotel]?
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var tableView1: UITableView!
    
    init() {
        super.init(nibName: "searchHistoryView", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView1.delegate = self
        tableView1.dataSource = self
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView1.register(nib, forCellReuseIdentifier: "CustomCell")
        configView()
        swipeDown()

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
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.popupView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }

    @IBAction func swapDownView(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            hide()
        }
    }
    

    @IBAction func dismissView(_ sender: UITapGestureRecognizer) {
        hide()
    }
    
    @IBAction func clearHistoryBtn(_ sender: UIButton) {
        searchHistory.removeAll()
        delegate?.didClearHistory(searchHistory)
        hide()
        
    }
}

extension searchHistoryView: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        let hotel = searchHistory[indexPath.row]
        cell.titleLabel.text = hotel.name
        cell.subtitleLabel.text = hotel.vicinity
        
        return cell
    }
}
