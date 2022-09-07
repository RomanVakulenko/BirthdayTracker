//
//  BirthdaysTableViewController.swift
//  Birthdays
//
//  Created by Roman Vakulenko on 02.08.2022.
//

import UIKit

class BirthdaysTableViewController: UITableViewController {
    
    var birthdays = [Birthday]() //будет хранить далее ДР, кот в него запишем
    let dateFormatter = DateFormatter()// для форматирования ДР в приемлемый вид
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .full // отформатирует так "Tuesday, December 17, 2008"
        dateFormatter.timeStyle = .none
        
//будем показывать 2ой VC сами, а не NavigationController'ом как было в книге
        navigationItem.rightBarButtonItem = UIBarButtonItem ( // здесь мы переопределили(создали новый БарБаттон,тк нельзя вынести его Аутлет), чтобы можно было показать - пояснить что переопределили и как читать слова ниже и физ смысл
            barButtonSystemItem: .add,
            target: self, //объект,принимающий действие; где искать -в этом классе
            action: #selector(nextVC) //указатель на func для создаваемого объекта
        )
    }

    @objc
    private func nextVC () {
        let stb = UIStoryboard(name: "Main", bundle: .main) // создаем Storyboard и VC
        let vc = stb.instantiateViewController(withIdentifier: "AddBirthdayViewController")
//показываем контроллер; обращаемся к комплишн и задаем в замыкание функцию (указываем что захватить и перезагрузить tableView)
        (vc as? AddBirthdayViewController)?.completion = { [weak self] birthday in //аргумент birthday добавляем в массив и перезагружаем тейблВью
            self?.birthdays.append(birthday)
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true) // переходим на 2ой, пушим его в стек (чтобы потом достать при сохранении вводимых данных)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // вернет 1 секцию со строками имен и ДР
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birthdays.count // столько строк, сколько имен и ДР создадим
    }

    // Configure the cell...Сообщим табличному представлению, что именно поместить в каждую клетку:
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "birthdayCellIdentifier", for: indexPath)
        let birthday = birthdays[indexPath.row] //определяем, какой именно ДР из массива Birthday будет отображаться внутри ячейки;
        cell.textLabel?.text = birthday.firstName + " " + birthday.lastName //имя и фамилия
        cell.detailTextLabel?.text = dateFormatter.string(from: birthday.birthdate)// отформатирует так "Tuesday, December 17, 2008"

        return cell
    }
}
