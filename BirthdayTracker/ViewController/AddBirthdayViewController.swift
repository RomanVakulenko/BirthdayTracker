//
//  AddBirthdayViewController.swift
//  Birthdays
//
//  Created by Roman Vakulenko on 02.08.2022.
//

import UIKit
import CoreData
import UserNotifications

class AddBirthdayViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    
    //    var completion: ((Birthday) -> Void)? // 1создали свойство (его тип функция - замыкание), указываем, что функция принимает в себя аргумент Birthday. ?тк замыкание еще не существует, не инициализировано, будет инициализировано когда мы в него передадим newBirtday -экземпляр класса Birthday
    
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdayPicker.maximumDate = Date()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        
        let firstName = firstNameTextField.text ?? "" // записываем в константы текст и дату ДР
        let lastName = lastNameTextField.text ?? ""
        let birthDate = birthdayPicker.date
        let appDelegate = UIApplication.shared.delegate as! AppDelegate//обращаемся к делегату c появлением экземляра APP
        let context = appDelegate.persistentContainer.viewContext//достаем контекст из постоянного контейнера
        
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthDate = birthDate as Date?
        newBirthday.birthdayId = UUID().uuidString//будет возвращать новое уникальное Id при каждом вызове
        if let uniqueId = newBirthday.birthdayId {
            print("birthdayId: \(uniqueId)")
        }
//        appDelegate.saveContext()
        // Сохраняем в Сore Data то, что находится в области видимости(?) context (или строка выше):
                do {
                    try context.save()
                    
                    let message = "Today \(firstName) \(lastName) celebrate birthday"
                    let content = UNMutableNotificationContent()//зададим сообщение и звук уведомления
                    content.body = message
                    content.sound = UNNotificationSound.default
                    //trigger помогает знать, когда и как часто отправлять уведомления
                    var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthDate)//не год, т.к. год ДР уже прошел и нужен месяц и день
                    dateComponents.hour = 9 //в 9 утра
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    
                    if let identifier = newBirthday.birthdayId {
                        let request = UNNotificationRequest(
                            identifier: identifier,
                            content: content,
                            trigger: trigger)
                        let center = UNUserNotificationCenter.current()//для формЗапроса создКонстанту=текЗначениюNotCentra
                        center.add(request, withCompletionHandler: nil)//после формирования запроса его значение должно быть добавлено в UNUserNotificationCenter
                    }
                } catch let error {
                    print("cannot save the context due to error\(error)")
                }
//          completion?(newBirthday) // 2вызываем функцию, передавая в неё аргумент (частный вид делегата)
        navigationController?.popViewController(animated: true) //по нажатию на save 2ой VC достается из стека и показывается
    }
}


// dismiss нужен для варианта с PresentModaly из книги:
//        dismiss(animated: true, completion: nil) //отключает изображающийся в настоящее время контроллер представлений, принимает 2 параметра: Первый — animated для анимации закрывающегося экрана. При передаче значения true экран AddBirthday соскальзывает и исчезает. Второй параметр — это опционал замыкания с названием completion - это блок кода, передаваемый функции, используется в том случае, если у вас есть код, который должен запуститься после отключения контроллера представлений. Поскольку пока делать ничего не нужно - присвоили nil.
//
//    }

