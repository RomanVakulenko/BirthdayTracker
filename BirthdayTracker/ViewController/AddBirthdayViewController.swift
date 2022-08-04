//
//  AddBirthdayViewController.swift
//  Birthdays
//
//  Created by Roman Vakulenko on 02.08.2022.
//

import UIKit

class AddBirthdayViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    
    var completion: ((Birthday) -> Void)? // 1создали свойство (тип замыкание), указываем, что свойство принимает в себя(?) или возвращает?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdayPicker.maximumDate = Date()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        
        let firstNameAB = firstNameTextField.text ?? "" // записываем в константы текст и дату ДР
        let lastNameAB = lastNameTextField.text ?? ""
        let birthDateAB = birthdayPicker.date
       
        let newBirtday = Birthday(firstName: firstNameAB, lastName: lastNameAB, birthdate: birthDateAB) //в новый ДР записываем введенное
       
        completion?(newBirtday) // 2используем свойство, а что происходит - физический смысл?
        navigationController?.popViewController(animated: true) //по нажатию на save 2ой VC достается из стека и показывается
        
        print("Создан ДР, Имя: \(newBirtday.firstName), Фамилия: \(newBirtday.lastName)")
        print("ДР: \(newBirtday.birthdate)")
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {

        
        
// это для варианта с PresentModaly из книги:
//        dismiss(animated: true, completion: nil) //отключает изображающийся в настоящее время контроллер представлений, принимает 2 параметра: Первый — animated для анимации закрывающегося экрана. При передаче значения true экран AddBirthday соскальзывает и исчезает. Второй параметр — это опционал замыкания с названием completion - это блок кода, передаваемый функции, используется в том случае, если у вас есть код, который должен запуститься после отключения контроллера представлений. Поскольку пока делать ничего не нужно - присвоили nil.
//
    }
}
