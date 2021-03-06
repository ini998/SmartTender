*** Keywords ***
Створити тендер
	Switch Browser  tender_owner
	Перейти у розділ (webclient)  Публічні закупівлі (тестові)
	Натиснути додати(F7)  Додавання. Тендери
  	create_tender.Вибрати тип процедури  Допорогові закупівлі
  	prod_below.Заповнити startDate періоду пропозицій
  	prod_below.Заповнити endDate періоду пропозицій
  	prod_below.Заповнити endDate періоду обговорення
  	prod_below.Заповнити amount для tender
  	prod_below.Заповнити minimalStep для tender
  	prod_below.Заповнити contact для tender
  	prod_below.Заповнити title для tender
  	prod_below.Заповнити description для tender
  	prod_below.Додати предмет в тендер
    Додати документ до тендара власником (webclient)
    Зберегти чернетку
    Оголосити тендер


#########################################################
#	                  Keywords							#
#########################################################
Заповнити endDate періоду обговорення
    ${value}  get_time_now_with_deviation  5  minutes
    ${new_date}  get_only_numbers  ${value}
    ${value}  Create Dictionary  endDate=${value}
    Set To Dictionary  ${data}  enquiryPeriod  ${value}
    Заповнити "Обговорення закупівлі до"  ${new_date}


Заповнити startDate періоду пропозицій
    ${value}  get_time_now_with_deviation  6  minutes
    ${new_date}  get_only_numbers  ${value}
    ${value}  Create Dictionary  startDate=${value}
    Set To Dictionary  ${data}  tenderPeriod  ${value}
    Заповнити "Прийом пропозицій з"  ${new_date}


Заповнити endDate періоду пропозицій
    ${value}  get_time_now_with_deviation  22  minutes
    ${new_date}  get_only_numbers  ${value}
    Set To Dictionary  ${data['tenderPeriod']}  endDate  ${value}
    Заповнити "Прийом пропозицій по"  ${new_date}


Заповнити contact для tender
    ${person}  Заповнити "Контактна особа"
    ${value}  Create Dictionary  name=${person}
    Set To Dictionary  ${data}  contactPerson  ${value}


Заповнити amount для tender
    ${amount}  random_number  100000  100000000
    ${value}  Create Dictionary  amount=${amount}
    Set To Dictionary  ${data}  value  ${value}
    Заповнити "Очікувана вартість закупівлі"  ${amount}


Заповнити minimalStep для tender
    ${minimal_step_percent}  random_number  1  5
    ${value}  Create Dictionary  percent=${minimal_step_percent}
    Set To Dictionary  ${data.value}  minimalStep  ${value}
    Заповнити "Мінімальний крок аукціону"   ${minimal_step_percent}


Заповнити title для tender
    ${text}  create_sentence  5
    ${title}  Set Variable  [ТЕСТУВАННЯ] ${text}
    Set To Dictionary  ${data}  title  ${title}
    Заповнити "Узагальнена назва закупівлі"   ${title}


Заповнити description для tender
    ${description}  create_sentence  15
    Set To Dictionary  ${data}  description  ${description}
    Заповнити "Примітки до закупівлі"  ${description}


Додати предмет в тендер
    prod_below.Заповнити title для item
    prod_below.Заповнити quantity для item
    prod_below.Заповнити id для item
    prod_below.Заповнити unit.name для item
    prod_below.Заповнити postalCode для item
    prod_below.Заповнити streetAddress для item
    prod_below.Заповнити locality для item
    prod_below.Заповнити endDate для item
    prod_below.Заповнити startDate для item


Заповнити title для item
    ${title}  create_sentence  5
    ${value}  Create Dictionary  title=${title}
    Set To Dictionary  ${data}  item  ${value}
    Заповнити "Назва предмета закупівлі"  ${title}


Заповнити quantity для item
    ${quantity}  random_number  1  1000
    Set To Dictionary  ${data['item']}  quantity  ${quantity}
    Заповнити "Об'єм постачання"  ${quantity}


Заповнити id для item
    ${value}    Заповнити "Класифікація"
    ${id}       Evaluate  re.search(r'(?P<id>\\d.+)', u'${value}').group('id')  re
    ${id title}  Evaluate  re.search(r'(?P<title>\\D.+) ', u'${value}').group('title')  re
    Set To Dictionary  ${data['item']}  id  ${id}
    Set To Dictionary  ${data['item']}  id title  ${id title}


Заповнити unit.name для item
    ${unit name}  Заповнити "Одиниця виміру"
    Set To Dictionary  ${data['item']}  unit  ${unit name}


Заповнити postalCode для item
    ${postal code}  random_number  10000  99999
    Заповнити "Індекс"  ${postal code}
    Set To Dictionary  ${data['item']}  postal code  ${postal code}


Заповнити streetAddress для item
    ${address}  get_some_uuid
    Заповнити "Вулиця"  ${address}
    Set To Dictionary   ${data['item']}  streetAddress  ${address}


Заповнити locality для item
    ${city}  Заповнити "Місто"  Мюнхен
    Set To Dictionary  ${data['item']}  city  ${city}


Заповнити startDate для item
    ${value}  get_time_now_with_deviation  1  days
    Заповнити "Строк поставки з"  ${value}


Заповнити endDate для item
    ${value}  get_time_now_with_deviation  2  days
    Заповнити "Строк поставки по"  ${value}

