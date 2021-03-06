*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Run Keywords  Capture Page Screenshot
...  AND  Log Location
...  AND  Log  ${data}
...  AND  debug


*** Variables ***

#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None suites/small_privatization/suite.robot
*** Test Cases ***
Створити об'єкт МП
	start_page.Натиснути На торговельний майданчик
	old_search.Активувати вкладку ФГИ
	small_privatization_search.Активувати вкладку  Реєстр об'єктів приватизації
	small_privatization_search.Вибрати режим сторінки об'єктів приватизації  Кабінет
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	small_privatization_search.Натиснути створити  об'єкт
	small_privatization_object.Заповнити всі обов'язкові поля
	small_privatization_object.Прикріпити документ
	small_privatization_object.Натиснути кнопку зберегти
	small_privatization_object.Опублікувати об'єкт у реєстрі
	small_privatization_object.Отримати UAID для Об'єкту
	Log To Console  object-UAID=${data['object']['UAID']}


Створити інформаційне повідомлення МП
	[Setup]  Go To  ${start page}
	start_page.Натиснути На торговельний майданчик
	old_search.Активувати вкладку ФГИ
	small_privatization_search.Активувати вкладку  Реєстр об'єктів приватизації
	small_privatization_search.Вибрати режим сторінки об'єктів приватизації  Кабінет
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	small_privatization_search.Натиснути створити  інформаційне повідомлення
	small_privatization_informational_message.Заповнити всі обов'язкові поля 1 етап
	small_privatization_informational_message.Прикріпити документ
	small_privatization_informational_message.Зберегти чернетку інформаційного повідомлення
	small_privatization_informational_message.Опублікувати інформаційне повідомлення у реєстрі
	small_privatization_informational_message.Перейти до коригування інформації
	small_privatization_informational_message.Заповнити всі обов'язкові поля 2 етап
	small_privatization_informational_message.Зберегти чернетку інформаційного повідомлення
	small_privatization_informational_message.Передати на перевірку інформаційне повідомлення
	small_privatization_informational_message.Дочекатися статусу повідомлення  Опубліковано  5 min
	small_privatization_informational_message.Отримати UAID для Повідомлення
	Log To Console  message-UAID=${data['message']['UAID']}


Дочекатися початку прийому пропозицій
	small_privatization_informational_message.Дочекатися статусу повідомлення  Аукціон  15 min
	small_privatization_informational_message.Дочекатися опублікування посилання на лот  5 min
	small_privatization_informational_message.Перейти до аукціону
	small_privatization_auction.Отримати UAID та href для Аукціону
	Log To Console  lot-id=${data['tender_id']}
	Log To Console  lot-href=${data['tender_href']}
	Close Browser


Знайти аукціон учасниками
	Підготувати учасників
	small_privatization_auction.Знайти аукціон користувачем  provider1
	Switch Browser  provider2
	Go To  ${data['tender_href']}


Подати заявки на участь в тендері
	:FOR  ${i}  IN  1  2
	\  Switch Browser  provider${i}
	\  Подати заявку для подачі пропозиції


Підтвердити заявки на участь
	Підтвердити заявки на участь у тендері  ${data['tender_id']}


Подати пропозицію учасниками
	:FOR  ${i}  IN  1  2
	\  Switch Browser  provider${i}
	\  Reload Page
	\  Дочекатись закінчення загрузки сторінки(skeleton)
	\  Перевірити кнопку подачі пропозиції
	\  Заповнити поле з ціною  1  1
	\  Подати пропозицію
	\  Go Back


Дочекатися початку аукціону
	Switch Browser  provider1
	small_privatization_auction.Дочекатися статусу лота  Аукціон  20 min


Отримати поcилання на участь учасниками
    :FOR  ${i}  IN  1  2
	\  Switch Browser  provider${i}
	\  Натиснути кнопку "До аукціону"
	\  ${viewer_href}  Отримати URL на перегляд
    \  Set To Dictionary  ${data}  viewer_href  ${viewer_href}
	\  ${participate_href}  Wait Until Keyword Succeeds  60  3  Отримати URL для участі в аукціоні
	\  Set To Dictionary  ${data}  provider${i}_participate_href  ${participate_href}
	\  Перейти та перевірити сторінку участі в аукціоні  ${participate_href}
	\  Close Browser


Перевірити неможливість отримати поcилання на участь в аукціоні
	[Setup]  Підготувати глядачів
	[Template]  Неможливість отримати поcилання на участь в аукціоні глядачем
	viewer
	tender_owner
	provider3


*** Keywords ***
Precondition
	${data}  Create Dictionary
	${object}  Create Dictionary
	${message}  Create Dictionary
	Set To Dictionary  ${data}  object  ${object}
	Set To Dictionary  ${data}  message  ${message}
	Set Global Variable  ${data}
    Start  ${user}  tender_owner


Postcondition
    Log  ${data}
    Close All Browsers


Підготувати учасників
	Run Keyword If  '${site}' == 'test'  Run Keywords
	...       Start  user1  provider1
	...  AND  Start  user2  provider2
	...  ELSE IF  '${site}' == 'prod'  Run Keywords
	...       Start  prod_provider1  provider1
	...  AND  Start  prod_provider2  provider2


Підготувати глядачів
	Run Keyword If  '${site}' == 'test'  Run Keywords
	...       Start  user3  provider3
	...  AND  Start  test_viewer  viewer
	...  AND  Start  Bened  tender_owner
	...  ELSE IF  '${site}' == 'prod'  Run Keywords
	...       Start  prod_provider  provider3
	...  AND  Start  prod_viewer  viewer
	...  AND  Start  prod_tender_owner  tender_owner


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Location Should Contain  bidder_id=
	Підтвердити повідомлення про умови проведення аукціону
	${status}  Run Keyword And Return Status  Page Should Not Contain  Not Found
	Run Keyword If  ${status} != ${true}  Sleep  30
	Run Keyword If  ${status} != ${true}  Перейти та перевірити сторінку участі в аукціоні  ${auction_href}
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  20
	Sleep  2
	Element Should Contain  //*[@class="page-header"]//h2  ${data['tender_id']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['object']['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['object']['item']['description']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['object']['item']['count']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['object']['item']['unit']}
	Element Should Contain  //h4  Вхід на даний момент закритий.


Неможливість отримати поcилання на участь в аукціоні глядачем
	[Arguments]  ${user}
	Switch Browser  ${user}
	Go to  ${data['tender_href']}
	Дочекатись закінчення загрузки сторінки(skeleton)
	${auction_participate_href}  Run Keyword And Expect Error  *  Run Keywords
	...  Натиснути кнопку "До аукціону"
	...  AND  Отримати URL для участі в аукціоні


# todo
Перевірити кнопку подачі пропозиції
    ${button}  Set Variable  //*[contains(text(), 'Подача пропозиції')]
    Page Should Contain Element  ${button}
    Open button  ${button}
    Location Should Contain  /edit/
    Wait Until Keyword Succeeds  5m  3  Run Keywords
    ...  Reload Page  AND
    ...  Element Should Not Be Visible  //*[@class='modal-dialog ']//h4
