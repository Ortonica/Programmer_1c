﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СписокПартнёров.ТекстЗапроса = ТекстЗапросаПартнёров();
	СписокПартнёров.Параметры.УстановитьЗначениеПараметра(
		"ВидАдресаРегистрации", 
		РСК_ПовтИсп.Получить_Справочники_ВидыКонтактнойИнформации_ПоИдентификатору("АдресРегистрации")
	);
	СписокДокументов.ТекстЗапроса = СтрЗаменить(
		СписокДокументов.ТекстЗапроса,
		"ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)",
		"&Заявитель"
	);
	СписокДокументов.Параметры.УстановитьЗначениеПараметра(
		"Заявитель",
		Справочники.Партнеры.ПустаяСсылка()
	);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекстЗапросаПартнёров()

	Текст = 
		"ВЫБРАТЬ
		|	Партнеры.Ссылка КАК Ссылка,
		|	Партнеры.Наименование КАК Наименование,
		|	Партнеры.РСК_СНИЛС КАК СНИЛС,
		|	ПОДСТРОКА(ЕСТЬNULL(КонтактыАдресРег.Представление, """"), 1, 150) КАК АдресРегистрации,
		|	ПОДСТРОКА(ЕСТЬNULL(КонтактыАдресПроживания.Представление, """"), 1, 150) КАК АдресМестожительства,
		|	ПОДСТРОКА(ЕСТЬNULL(КонтактыТелефон.Представление, """"), 1, 150) КАК Телефон,
		|	Партнеры.РСК_СтатусПолучателяТСР КАК Статус,
		|	Партнеры.РСК_ПаллиативнаяПомощь КАК ПаллиативнаяПомощь,
		|	Партнеры.ДатаРождения КАК ДатаРождения,
		|	Партнеры.ЗонаДоставки КАК ЗонаДоставки,
		|	ЕСТЬNULL(ЗоныДоставки.Родитель, ЗНАЧЕНИЕ(Справочник.ЗоныДоставки.ПустаяСсылка)) КАК Регион
		|ИЗ
		|	Справочник.Партнеры КАК Партнеры
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Партнеры.КонтактнаяИнформация КАК КонтактыАдресРег
		|		ПО Партнеры.Ссылка = КонтактыАдресРег.Ссылка
		|			И (КонтактыАдресРег.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес))
		|			И (КонтактыАдресРег.Вид = &ВидАдресаРегистрации)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Партнеры.КонтактнаяИнформация КАК КонтактыАдресПроживания
		|		ПО Партнеры.Ссылка = КонтактыАдресПроживания.Ссылка
		|			И (КонтактыАдресПроживания.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес))
		|			И (КонтактыАдресПроживания.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресПартнера))
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Партнеры.КонтактнаяИнформация КАК КонтактыТелефон
		|		ПО Партнеры.Ссылка = КонтактыТелефон.Ссылка
		|			И (КонтактыТелефон.ВидДляСписка = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонПартнера))
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗоныДоставки КАК ЗоныДоставки
		|		ПО Партнеры.ЗонаДоставки = ЗоныДоставки.Ссылка
		|ГДЕ
		|	Партнеры.РСК_ЭтоПолучательТСР";
	
	Возврат Текст;

КонецФункции // ТекстЗапросаПартнёров()

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбновитьСписокДокументов",0.5,Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокДокументов() Экспорт

	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено ИЛИ НЕ ТД.Свойство("Ссылка") Тогда
		Возврат;
	КонецЕсли;
	
	СписокДокументов.Параметры.УстановитьЗначениеПараметра(
		"Заявитель",
		ТД.Ссылка
	);
	
	Элементы.Список.Обновить();

КонецПроцедуры // ОбновитьСписокДокументов()

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ДанныеСтроки = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
	ИмяПоля = Сред(Поле.Имя, СтрДлина(Элемент.Имя)+1);
	ПоказатьЗначение(, ДанныеСтроки[ИмяПоля]);	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьАкт(Команда)
	ТекДанные = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение(, "Выберите документ!");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СкладВыдачи) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Укажите склад выдачи!",,
			"СкладВыдачи"
		);
		Возврат;
	КонецЕсли;
	
	ЗагрузочнаяВедомость = ТекДанные.ЗагрузочнаяВедомость;
	СтатусАкта = ТекДанные.Статус;

	Если ЗагрузочнаяВедомость = ПредопределенноеЗначение("Документ.ЗаданиеНаПеревозку.ПустаяСсылка") Тогда
		Док = ТекДанные.Акт;
		Текст = "";
		ПометитьНаСервере(Док,Текст,"Закрыть");
		
	ИначеЕсли  ЗагрузочнаяВедомость <> ПредопределенноеЗначение("Документ.ЗаданиеНаПеревозку.ПустаяСсылка") 
		И (СтатусАкта = ПредопределенноеЗначение("Перечисление.РСК_СтатусыАктовВыдачи.Отгружен")
		ИЛИ СтатусАкта = ПредопределенноеЗначение("Перечисление.РСК_СтатусыАктовВыдачи.Доставлен")) Тогда
		ПоказатьПредупреждение(, "Документ отгружен в загрузочной ведомости! "+ЗагрузочнаяВедомость+" Закрытие невозможно!");
		
	ИначеЕсли ЗагрузочнаяВедомость <> ПредопределенноеЗначение("Документ.ЗаданиеНаПеревозку.ПустаяСсылка")
		И (СтатусАкта = ПредопределенноеЗначение("Перечисление.РСК_СтатусыАктовВыдачи.Создан")
		ИЛИ СтатусАкта = ПредопределенноеЗначение("Перечисление.РСК_СтатусыАктовВыдачи.Подготовлен")) Тогда
		ПоказатьПредупреждение(, "Акт выбран в  "+ ЗагрузочнаяВедомость +". Не забудьте удалить акт из этой загрузочной ведомости!");
		Док = ТекДанные.СсылкаСсылка;
		ПометитьНаСервере(Док,Текст,"Закрыть");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПометитьНаСервере(Док,Текст,Команда)
	Об = Док.ПолучитьОбъект();
	Если Команда = "Удалить" Тогда
		Об.ПометкаУдаления = Истина;
		Об.Комментарий = Текст;
		Об.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	ИначеЕсли Команда = "Закрыть" Тогда
		Об.РСК_СтатусАктаВыдачиТСР = Перечисления.РСК_СтатусыАктовВыдачи.Выдан;
		Об.Комментарий = Текст;
		Об.ДатаЗакрытия = ТекущаяДата();
		Если ЗначениеЗаполнено(Об.СкладВыдачи) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В Документе Акт %1  уже установлен Склад выдачи %2'"),
				Об.Ссылка, Об.СкладВыдачи);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, Об.Ссылка, , , );
			Возврат;
		Иначе
			Об.Склад = СкладВыдачи;
		КонецЕсли;
		Об.Записать(РежимЗаписиДокумента.Проведение);
	ИначеЕсли Команда = "ОтменитьЗакрытие" Тогда
		Об.РСК_СтатусАктаВыдачиТСР = Перечисления.РСК_СтатусыАктовВыдачи.Подготовлен;
		Об.Комментарий = Текст;
		Об.Записать(РежимЗаписиДокумента.Проведение);
	ИначеЕсли Команда = "Аннулировать"	 Тогда
		Об.РСК_СтатусАктаВыдачиТСР = Перечисления.РСК_СтатусыАктовВыдачи.Аннулирован;
		Об.Комментарий = Текст;
		Об.Записать(РежимЗаписиДокумента.Проведение);
	ИначеЕсли Команда = "ОтменитьАннулирование"	 Тогда
		Об.РСК_СтатусАктаВыдачиТСР = Перечисления.РСК_СтатусыАктовВыдачи.Подготовлен;
		Об.Комментарий = Текст;
		Об.Записать(РежимЗаписиДокумента.Проведение);
	Иначе
		ВызватьИсключение "Команда "+Команда+" не определена. Обратитесь к программисту 1С!";
	КонецЕсли;
	Элементы.СписокДокументов.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьЗакрытиеАкта(Команда)
	ТекДанные = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение(, "Выберите документ!");
		Возврат;
	КонецЕсли;
	
	Док = ТекДанные.Акт;
	Текст = "";
	Подсказка = "Укажите причину!";
	ПоказатьВводСтроки(
		Новый ОписаниеОповещения(
			"ОтменитьЗакрытиеЗавершение", 
			ЭтотОбъект, 
			Новый Структура("Док", Док)
		), 
		Текст, 
		Подсказка, 
		0, 
		Истина
	);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьЗакрытиеЗавершение(Строка, ДополнительныеПараметры) Экспорт
	
	Если Строка = Неопределено ИЛИ ПустаяСтрока(Строка) Тогда
		ПоказатьПредупреждение(, "Необходимо ввести причину!!!");
		Возврат;
	КонецЕсли;
	
	ПометитьНаСервере(ДополнительныеПараметры.Док, Строка, "ОтменитьЗакрытие");

КонецПроцедуры

&НаКлиенте
Процедура АннулироватьАкт(Команда)
	ТекДанные = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение(, "Выберите документ!");
		Возврат;
	КонецЕсли;
	Док = ТекДанные.Акт;
	Текст = "";
	Подсказка = "Укажите причину!";
	ПоказатьВводСтроки(
		Новый ОписаниеОповещения(
			"АннулироватьАктЗавершение", 
			ЭтотОбъект, 
			Новый Структура("Док", Док)
		), 
		Текст, 
		Подсказка, 
		0, 
		Истина
	);
КонецПроцедуры

&НаКлиенте
Процедура АннулироватьАктЗавершение(Строка, ДополнительныеПараметры) Экспорт
	
	Если Строка = Неопределено ИЛИ ПустаяСтрока(Строка) Тогда
		ПоказатьПредупреждение(, "Необходимо ввести причину!!!");
		Возврат;
	КонецЕсли;
	
	ПометитьНаСервере(ДополнительныеПараметры.Док, Строка, "Аннулировать");

КонецПроцедуры

&НаКлиенте
Процедура ОтменитАннулированиеАкта(Команда)
	ТекДанные = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение(, "Выберите документ!");
		Возврат;
	КонецЕсли;
	Текст = "";
	Подсказка = "Укажите причину!";
	ПоказатьВводСтроки(
		Новый ОписаниеОповещения(
			"ОтменитьАннулированиеЗавершение", 
			ЭтотОбъект, 
			Новый Структура("Док", ТекДанные.Акт)
		), 
		Текст, 
		Подсказка, 
		0, 
		Истина
	);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьАннулированиеЗавершение(Строка, ДополнительныеПараметры) Экспорт
	Если Строка = Неопределено ИЛИ ПустаяСтрока(Строка) Тогда
		ПоказатьПредупреждение(, "Необходимо ввести причину!!!");
		Возврат;
	КонецЕсли;
	
	ПометитьНаСервере(ДополнительныеПараметры.Док, Строка, "ОтменитьАннулирование");

КонецПроцедуры

&НаКлиенте
Процедура СоздатьАкт(Команда)
	ТД = Элементы.СписокДокументов.ТекущиеДанные;
	ПараметрыДок = Новый Структура;
	Если ТД = Неопределено Тогда
		ТД = Элементы.Список.ТекущиеДанные;
		Если ТД = Неопределено ИЛИ НЕ ТД.Свойство("Ссылка") Тогда
			ПоказатьПредупреждение(,"Выберите получателя ТСР");
			Возврат;
		КонецЕсли;
		ПараметрыДок.Вставить("Пункт", ТД.Ссылка);
	Иначе
		ПараметрыДок.Вставить("Пункт", ТД.Заявитель);
		ТД = Элементы.Список.ТекущиеДанные;
	КонецЕсли;
	ПараметрыДок.Вставить("ЗонаДоставки", ТД.ЗонаДоставки);
	Если ТД.Статус = ПредопределенноеЗначение("Перечисление.РСК_СтатусыПолучателяТСР.Умер") Тогда
		ПоказатьПредупреждение(,"Получатель ТСР умер");
		Возврат;
	КонецЕсли;
	
	ФормаАкта = ПолучитьФорму("Документ.ПоручениеЭкспедитору.ФормаОбъекта");
	ДанныеФормы = ФормаАкта.Объект;
	СоздатьАктНаСервере(ДанныеФормы, ПараметрыДок);
	КопироватьДанныеФормы(ДанныеФормы, ФормаАкта.Объект);
	ФормаАкта.Открыть();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СоздатьАктНаСервере(ДанныеФормы, ПараметрыДок)

	оАкт = Документы.ПоручениеЭкспедитору.СоздатьДокумент();
	ЗаполнитьЗначенияСвойств(оАкт, ПараметрыДок);
	оАкт.РСК_АктВыдачиТСР 	= Истина;
	оАкт.СпособДоставки		= Перечисления.СпособыДоставки.ПоручениеЭкспедиторуСоСклада;
	оАкт.Дата				= ТекущаяДата();
	Если ПустаяСтрока(оАкт.Номер) Тогда
		оАкт.УстановитьНовыйНомер();
	КонецЕсли;
	оАкт.ОсобыеУсловияПеревозкиОписание = ".";	
	оАкт.АдресДоставки = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
		оАкт.Пункт,
		Справочники.ВидыКонтактнойИнформации.АдресПартнера,
		ТекущаяДата(),
		Истина
	);
	оАкт.РСК_СтатусАктаВыдачиТСР = Перечисления.РСК_СтатусыАктовВыдачи.Создан;
	ЗначениеВДанныеФормы(оАкт, ДанныеФормы);

КонецПроцедуры // СоздатьАктНаСервере()

&НаКлиенте
Процедура ОткрытьАкт(Команда)
	ТекДанные = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение(, "Выберите документ!");
		Возврат;
	КонецЕсли;
	ПоказатьЗначение(, ТекДанные.Акт);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьАкт(Команда)
	ТекДанные = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение(, "Выберите документ!");
		Возврат;
	КонецЕсли;
	Текст = "";
	Подсказка = "Укажите причину!";
	ПоказатьВводСтроки(
		Новый ОписаниеОповещения(
			"УдалитьАктЗавершение", 
			ЭтотОбъект, 
			Новый Структура("Док", ТекДанные.Акт)
		), 
		Текст, 
		Подсказка, 
		0, 
		Истина
	);	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьАктЗавершение(Строка, ДополнительныеПараметры) Экспорт
	
	Если Строка = Неопределено ИЛИ ПустаяСтрока(Строка) Тогда
		ПоказатьПредупреждение(, "Необходимо ввести причину!!!");
		Возврат;
	КонецЕсли;
	
	ПометитьНаСервере(ДополнительныеПараметры.Док, Строка, "Удалить");

КонецПроцедуры

&НаКлиенте
Процедура ПечатьАкта(Команда)
	
	МассивАктов = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.СписокДокументов.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.СписокДокументов.ДанныеСтроки(ВыделеннаяСтрока);
		МассивАктов.Добавить(ДанныеСтроки.Акт);
	КонецЦикла;
	
	РСК_Клиент.ПечатьАктов(МассивАктов);
	
КонецПроцедуры
