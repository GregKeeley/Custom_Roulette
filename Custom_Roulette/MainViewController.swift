//
//  ViewController.swift
//  Custom_Roulette
//
//  Created by Gregory Keeley on 11/23/20.
//

import UIKit

struct customItem {
    let title: String
    let multiplier: Int
    init(title: String, multiplier: Int) {
        self.title = title
        self.multiplier = multiplier
    }
}

class MainViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var itemTitleTextField: UITextField!
    @IBOutlet weak var multiplierPickerView: UIPickerView!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var collectionPickerView: UIPickerView!
    @IBOutlet weak var randomizeButton: UIButton!
    
    //MARK:- Variables and Constants
    var customCollection: [customItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
    }
    private func configureController() {
        itemTitleTextField.delegate = self
        multiplierPickerView.dataSource = self
        collectionPickerView.dataSource = self
        multiplierPickerView.delegate = self
        collectionPickerView.delegate = self
    }
    @IBAction func addItemToCollection(_ sender: UIButton) {
        print("Add to collection")
    }
    
}

//MARK:- Extenstions
extension MainViewController: UITextFieldDelegate {
    
}

extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == collectionPickerView {
            let item = customCollection?[row]
            return "\(item?.title ?? "ERROR") (\(item?.multiplier ?? -1)X)"
        } else {
            let array = Array(1...100)
            return "\(array[row])"
        }
    }
}

extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == collectionPickerView {
            return customCollection?.count ?? 0
        } else {
            return 100
        }
    }
    
}
