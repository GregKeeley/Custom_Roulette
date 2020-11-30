//
//  ViewController.swift
//  Custom_Roulette
//
//  Created by Gregory Keeley on 11/23/20.
//

import UIKit
import DataPersistence

struct CustomItem: Equatable & Codable {
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
    @IBOutlet weak var multiplierLabel: UILabel!
    
    //MARK:- Variables and Constants
    
    var dataPersistence = DataPersistence<[CustomItem]>(filename: "customItemCollection.plist")
    
    var customCollection = [CustomItem]() {
        didSet {
            configureRandomButton()
            collectionPickerView.reloadAllComponents()
            dump(customCollection)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
        configureRandomButton()
    }
    private func configureController() {
        itemTitleTextField.delegate = self
        multiplierPickerView.dataSource = self
        collectionPickerView.dataSource = self
        multiplierPickerView.delegate = self
        collectionPickerView.delegate = self
        multiplierLabel.adjustsFontSizeToFitWidth = true
        multiplierLabel.sizeToFit()
    }
    private func configureRandomButton() {
        if customCollection.count == 0 {
            randomizeButton.isEnabled = false
            randomizeButton.backgroundColor = .systemGray4
        } else {
            randomizeButton.isEnabled = true
            randomizeButton.backgroundColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        }
    }
    @IBAction func addItemToCollection(_ sender: UIButton) {
        let multiplier = multiplierPickerView.selectedRow(inComponent: 0) + 1
        let item = CustomItem(title: itemTitleTextField.text ?? "Error", multiplier: multiplier)
        let itemWithMultiplier = Array(repeating: item, count: item.multiplier)
        
        customCollection.append(item)
        customCollection.append(contentsOf: itemWithMultiplier)
    }
    @IBAction func randomizeButtonPressed(_ sender: UIButton) {
        guard let randomItem = customCollection.randomElement() else { return }
        guard let index = customCollection.firstIndex(of: randomItem) else {
            return
        }
        collectionPickerView.selectRow(index, inComponent: 0, animated: true)
    }
    @IBAction func saveCollectionButtonPressed(_ sender: UIButton) {
        do {
            try dataPersistence.createItem(customCollection)
        } catch {
            
        }
    }
}


//MARK:- Extenstions
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == collectionPickerView {
            let item = customCollection[row]
            return "\(item.title) (\(item.multiplier)X)"
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
            return customCollection.count
        } else {
            return 100
        }
    }
    
}
