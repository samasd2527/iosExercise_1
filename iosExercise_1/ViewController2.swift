//
//  ViewController2.swift
//  iosExercise_1
//
//  Created by 莊善傑 on 2024/5/27.
//

import UIKit

class ViewController2: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    
    var searchHistoryTable: [String] = []
    weak var delegate: ViewController2ClearHistoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView1.delegate = self
        tableView1.dataSource = self
    }

    @IBAction func clearHistoryBtn(_ sender: UIButton) {
        //清除歷史紀錄
        delegate?.didClearHistory([])
        navigationController?.popViewController(animated: false)
    }
    
    @IBOutlet weak var tableView1: UITableView!//需實現的func
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return searchHistoryTable.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell", for: indexPath) as
                UITableViewCell
        cell.textLabel?.text = searchHistoryTable[indexPath.row]
        return cell
    }
    
}
