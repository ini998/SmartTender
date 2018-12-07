*** Variables ***
${privatization item}			//*[@class='content-block']//div[@class="ivu-card-body"]


*** Keywords ***
Активувати перемемик процедури на
	[Documentation]  ${field_text} == Об'єкти приватизації|Реєстр інформаційних повідомлень
	[Arguments]  ${field_text}
	${selector}  Set Variable  //input[@type="radio"]/ancestor::label[contains(., "${field_text}")]
	${class}  Get Element Attribute  ${selector}  class
	${status}  Run Keyword And Return Status  Should Contain  ${class}  checked
	Run Keyword If  ${status} == ${False}  Run Keywords
	...  Click Element  ${selector}
	...  AND  Дочекатись закінчення загрузки сторінки(skeleton)


Вибрати режим сторінки об'єктів приватизації
    [Arguments]  ${type}
    [Documentation]  Вибираємо режим сторінки. "Кабінет"  або "ПУблічний режим"
    ${selector}  Set Variable  //*[@data-qa="page-mode"]//span[text()="${type}"]
    Click Element   ${selector}
    Дочекатись закінчення загрузки сторінки(skeleton)
    Element Should Be Visible
    ...  ${selector}/preceding-sibling::span[contains(@class,"radio-checked")]


Перейти по результату пошуку за номером
	[Arguments]  ${n}
	${selector}  Set Variable  (${privatization item}//a)[${n}]
	${href}  Get Element Attribute  ${selector}  href
	${href}  Поправити лінку для IP  ${href}
	Go To  ${href}
	Дочекатись закінчення загрузки сторінки(skeleton)


Натиснути кнопку пошуку
	Click Element  ${elastic search button}
	Дочекатись закінчення загрузки сторінки(skeleton)
	Wait Until Page Contains Element  //*[@class="tag-holder"]