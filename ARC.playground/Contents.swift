import UIKit

//MARK: - 1
/*
 Описать несколько структур – любой легковой автомобиль и любой грузовик. Структуры должны содержать марку авто, год выпуска, объем багажника/кузова, запущен ли двигатель, открыты ли окна, заполненный объем багажника
 */

protocol Vehicle {
    var mark: String { get }
    var year: Int { get }
    var engineRunning: Bool { get }
    var window: Bool { get }
    var completionVolume: Int { get }
}

struct Car: Vehicle, Hashable {
    
    var mark: String
    var year: Int
    var trunkVolume: Int
    var engineRunning = false
    var window = false
    var completionVolume: Int

    
    mutating func doAction(action: ActionAuto) -> String {
        switch action {
            
        case .startEngine:
            engineRunning = true
            return "Двигатель \(mark) заведен"
            
        case .stopEngine:
            engineRunning = false
            return "Двигатель \(mark) заглушен"
            
        case .openWindow:
            window = true
            return "Окна \(mark) открыто"
            
        case .closeWindow:
            window = false
            return "Окна \(mark) закрыто"
            
        case .fillVolume:
            if completionVolume == trunkVolume {
                return "Гуз загружен. Объем багажника заполнен полностью"
            } else {
                return "Груз загружен. Объем свободного места в багажнике \(trunkVolume - completionVolume)"
            }
            
        case .unloadVolume:
            completionVolume = 0
            return  "Из багажника извлечен груз объемом \(completionVolume)"
            
        }
    }
}

struct Truck: Vehicle {
    var mark: String
    var year: Int
    var bodyVolume: String
    var engineRunning: Bool
    var window: Bool
    var completionVolume: Int
}


/*
 Описать перечисление с возможными действиями с автомобилем: запустить/заглушить двигатель, открыть/закрыть окна, погрузить/выгрузить из кузова/багажника груз определенного объема
 */

enum ActionAuto {
    
    case startEngine
    case stopEngine
    case closeWindow
    case openWindow
    case fillVolume
    case unloadVolume
    
}


/*
 Добавить в структуры метод с одним аргументом типа перечисления, который будет менять свойства структуры в зависимости от действия
 Инициализировать несколько экземпляров структур. Применить к ним различные действия. Положить объекты структур в словарь как ключи, а их названия как строки например var dict = [structCar: 'structCar']
 */



var carOne = Car(mark: "bmw", year: 10, trunkVolume: 12, completionVolume: 10)
var carTwo = Car(mark: "bmw", year: 10, trunkVolume: 10, completionVolume: 10)

carOne.doAction(action: .fillVolume)
carTwo.doAction(action: .startEngine)

var dict = [Car: String]()

dict[carOne] = "carOne"
dict[carTwo] = "carTwo"

print(carOne)
print(dict)



//MARK: - 2
//Почитать о Capture List (см ссылку ниже) - и описать своими словами и сделать скрин своего примера и объяснения Capture

/*
 списки захвата используются, чтобы избежать циклов удержания при работе с Reference Type, а при работе с Value Type -  захватывает значения

*/

var number = 5
var anotherNumber = 8

let closure = { [number] in
    print("\(number) and \(anotherNumber)")
}

closure()

number = 40     //захват number происходит по значению, а не по ссылке
anotherNumber = 50

closure()


class Person {
    var name: String?
    
    lazy var greeting: () -> () = { [weak self] in //захватваем слабой ссылкой
        print("Привет, \(self?.name ?? " ")")
    }
    
    init(name: String) {
        self.name = name
    }
    
    deinit{
        print("Человек свободен")
    }
}


var person: Person?
person = Person(name: "Боб")
person?.greeting()
person = nil //деинициализация прошла успешно





//MARK: - 3
// Набрать код который на скриншоте понять в чем там проблема и решить эту проблему

class Carr {
  weak var driver: Man?
    
    deinit {
        print("Машина удалена из памяти")
    }
}

class Man {
    var myCar: Carr?
    
    deinit {
        print("Мужчина удален из памяти")
    }
}

var car: Carr? = Carr()
var man: Man? = Man()

car?.driver = man
man?.myCar = car

car = nil
man = nil

//экземпляры класса не могут освободиться из - за сильных ссылок друг на друга, при освобождении их, с помощью присвоения значения nil, сумма сильных ссылок не = 0, деинициализация не происходит
//необходимо добавить слабую ссылку, цикл сильных ссылок разрушается



//MARK: - 4
/*У нас есть класс мужчины и его паспорта. Мужчина может родиться и не иметь паспорта, но паспорт выдается конкретному мужчине и не может выдаваться без указания владельца. Чтобы разрешить эту проблему, ссылку на паспорт у мужчины сделаем опциональной, а ссылку на владельца у паспорта – константой. Также добавим паспорту конструктор, чтобы сразу определить его владельца. Таким образом, человек сможет существовать без паспорта, сможет его поменять или выкинуть, но паспорт может быть создан только с конкретным владельцем и никогда не может его сменить. Повторить все что на черном скрине и решить проблему соблюдая все правила!
 */

class Human {
    var passport: Passport?
    
    deinit {
        print("Человек удален из памяти")
    }
}

class Passport {
    unowned let human: Human //делаем ссылку на человека бесхозной, чтобы остановить цикл сильных ссылок
    
    init(human: Human) {
        self.human = human
    }
    
    deinit {
        print("Паспорт удален из памяти")
    }
}

var human: Human? = Human()
var passport: Passport? = Passport(human: human!)
human?.passport = passport
passport = nil
human = nil
