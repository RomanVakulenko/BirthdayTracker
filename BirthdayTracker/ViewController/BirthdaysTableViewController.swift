//
//  BirthdaysTableViewController.swift
//  Birthdays
//
//  Created by Roman Vakulenko on 02.08.2022.
//

import UIKit
import CoreData

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
    override func viewWillAppear(_ animated: Bool) { //будет вызываться при каждом появлении представления на экране
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate//чтобы извлечь i из СD
        let context = appDelegate.persistentContainer.viewContext//и получить доступ к контексту
        let fetchRequest = Birthday.fetchRequest() as NSFetchRequest<Birthday> //запрос, позволяющий извлекать все объекты Birthday из Core Data (нужно привести его к типу NSFetchRequest<Birthday>, чтобы из базы данных загружался соответствующий тип объектов)
        let sortDescriptor1 = NSSortDescriptor(key: "lastName", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2] // сначала отсортируем по фамилиям, а потом по именам (все от А до Я)
        
        do {
            birthdays = try context.fetch(fetchRequest)
        } catch let error {
            print("cannot save the context due to error\(error)")
        }
        tableView.reloadData()
    }
    
    @objc
    private func nextVC () {
        let stb = UIStoryboard(name: "Main", bundle: .main) // создаем Storyboard и VC
        let vc = stb.instantiateViewController(withIdentifier: "AddBirthdayViewController")
        //показываем контроллер; обращаемся к комплишн и задаем в замыкание функцию (указываем что захватить и перезагрузить tableView)
        //        (vc as? AddBirthdayViewController)?.completion = { [weak self] birthday in //аргумент birthday добавляем в массив и перезагружаем тейблВью
        //            self?.birthdays.append(birthday)
        //            self?.tableView.reloadData()
        //        }
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
        let firstName = birthday.firstName ?? ""
        let lastName = birthday.lastName ?? ""
        cell.textLabel?.text = firstName + " " + lastName
        if let date = birthday.birthDate as Date? {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        } else {
            cell.detailTextLabel?.text = "no date"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true //значит, можем редактировать таблицу/удалять ряды
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if birthdays.count > indexPath.row {//убедимся, что массив birthdays имеет >= дней рождения, что и значение row в indexPath, которое мы пытаемся удалить. Используется оператор >, а не >=, поскольку birthdays.count должно быть больше indexPath.row - тут с 0 номерация
            let birthday = birthdays[indexPath.row]// присваиваем соответствующий объект из массива birthdays, чтобы его можно было удалить
            
            //поулчаем доступ к контексту управляемого объекта для делегата приложения
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            context.delete(birthday)// удаляем из Core Data
            birthdays.remove(at: indexPath.row)// удаляем его и из массива birthdays контроллера табличного представления Birthdays
            //Каждый раз, когда вы добавляете, обновляете или удаляете объекты в контексте, вам нужно сохранять его. В противном случае измененияr просто не сохраняются на устройстве.
            do {
                try context.save()
            } catch let error {
                print("cannot save the context due to error\(error)")
            }
            tableView.deleteRows(at:[indexPath],with: .none) //уточняем, как должны выглядеть ряды при удалении. none (без анимации), bottom (вниз), top (вверх), left (влево), right (вправо), middle (в середину) или fade (исчезновение).
        }
    }
}
