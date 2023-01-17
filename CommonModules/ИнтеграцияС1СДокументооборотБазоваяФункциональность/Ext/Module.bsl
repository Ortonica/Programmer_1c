﻿
&ИзменениеИКонтроль("ДобавитьКомандуСозданияНаОсновании")
Процедура РСК_ДобавитьКомандуСозданияНаОсновании(ТаблицаКоманд, Команда, Обработчик, ВидВРег, ФункциональныеОпции, Порядок)

	КомандаСозданияНаОсновании = ТаблицаКоманд.Добавить();
	КомандаСозданияНаОсновании.Обработчик = Обработчик;
	КомандаСозданияНаОсновании.Идентификатор = Команда.Имя;
	КомандаСозданияНаОсновании.Представление = Команда.Синоним;
	#Удаление
	КомандаСозданияНаОсновании.РежимЗаписи = ?(ВидВРег = "ДОКУМЕНТ", "Записывать", "Записывать");
	#КонецУдаления
	#Вставка
	КомандаСозданияНаОсновании.РежимЗаписи = ?(ВидВРег = "ДОКУМЕНТ", "Проводить", "Проводить");
	#КонецВставки
	КомандаСозданияНаОсновании.ФункциональныеОпции = ФункциональныеОпции;
	КомандаСозданияНаОсновании.Порядок = Порядок;

	Порядок = Порядок - 1;

КонецПроцедуры

	&ИзменениеИКонтроль("ПолучитьПрокси")
Функция РСК_ПолучитьПрокси(ВызыватьИсключение, ИмяПользователя, Пароль, ИспользуетсяАутентификацияОС)

	// Получим настройки авторизации из параметров сеанса, если они не переданы параметрами функции.
	Если ИспользуетсяАутентификацияОС = Неопределено Тогда 
		ИспользуетсяАутентификацияОС = ПараметрыСеанса.ИнтеграцияС1СДокументооборотИспользуетсяАутентификацияОС;
	КонецЕсли;

	Если ИмяПользователя = Неопределено Тогда
		#Удаление
		ИмяПользователя = ПараметрыСеанса.ИнтеграцияС1СДокументооборотИмяПользователя;
		#КонецУдаления
		#Вставка  
		ИмяПользователя = Константы.ИнтеграцияС1СДокументооборотИмяПользователяДляОбмена.Получить();
		УстановитьПривилегированныйРежим(Истина);
		#КонецВставки
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ИмяПользователя) И Не ИспользуетсяАутентификацияОС Тогда
		Возврат Неопределено;
	КонецЕсли;

	Если Пароль = Неопределено Тогда 
		#Удаление
		Если Не ПараметрыСеанса.ИнтеграцияС1СДокументооборотПарольИзвестен И Не ИспользуетсяАутентификацияОС Тогда
			Возврат Неопределено;
		КонецЕсли;
		#КонецУдаления  
		#Удаление
		Пароль = ПараметрыСеанса.ИнтеграцияС1СДокументооборотПароль;
		#КонецУдаления
		#Вставка
		Пароль = Константы.ИнтеграцияС1СДокументооборотПарольДляОбмена.Получить();
		#КонецВставки
	КонецЕсли;

	МестоположениеWSDL = Константы.АдресВебСервиса1СДокументооборот.Получить();
	Если ЗначениеЗаполнено(МестоположениеWSDL)
		И Прав(МестоположениеWSDL, 1) <> "/"
		И Прав(МестоположениеWSDL, 1) <> "\" Тогда
		МестоположениеWSDL = МестоположениеWSDL + "/";
	КонецЕсли;

	// При необходимости создадим защищенное соединение. Используем сертификаты из хранилища
	// Windows, если это имеет смысл для текущей платформы.
	ЭтоСоединениеSSL = СтрНачинаетсяС(МестоположениеWSDL, "https");
	Если ЭтоСоединениеSSL Тогда
		Если СерверРаботаетПодWindows() Тогда
			ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение(
			Новый СертификатКлиентаWindows(),
			Новый СертификатыУдостоверяющихЦентровWindows());
		Иначе
			ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
		КонецЕсли;
	Иначе
		ЗащищенноеСоединение = Неопределено;
	КонецЕсли;

	Таймаут = ТаймаутСервиса();
	ИнтернетПрокси = Неопределено;
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ПриПолученииWSПрокси(ИнтернетПрокси);

	Попытка
		Определения = Новый WSОпределения(МестоположениеWSDL + "ws/dm.1cws?wsdl",
		ИмяПользователя,
		Пароль,
		ИнтернетПрокси,
		Таймаут,
		ЗащищенноеСоединение,
		ИспользуетсяАутентификацияОС);
	Исключение
		Определения = Неопределено;
		ТекстСообщенияОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

	Если Определения = Неопределено Тогда
		Попытка
			Определения = Новый WSОпределения(МестоположениеWSDL + "ws/DMService?wsdl",
			ИмяПользователя,
			Пароль,
			ИнтернетПрокси,
			Таймаут,
			ЗащищенноеСоединение,
			ИспользуетсяАутентификацияОС);
		Исключение
			Определения = Неопределено;
			ТекстСообщенияОбОшибке = ТекстСообщенияОбОшибке
			+ Символы.ПС
			+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
	КонецЕсли;

	Если Определения = Неопределено Тогда
		ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Ошибка,,,
		ТекстСообщенияОбОшибке);
		Если ВызыватьИсключение Тогда
			ВызватьИсключение НСтр("ru = 'Ошибка подключения к 1С:Документообороту.
			|
			|Возможно, не прошла авторизация, указан неверный адрес веб-сервиса 
			|или база 1С:Документооборота не опубликована на веб-сервере.
			|
			|Подробности в журнале регистрации. Обратитесь к администратору системы.';
			|en = '1C:Document Management connection error.
			|
			|Authorization might fail, the web service address is incorrect 
			|or the 1C:Document Management base is not published on the web server.
			|
			|See the Event log. Contact your system administrator.'");
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;

	Попытка
		Прокси = Новый WSПрокси(Определения,
		"http://www.1c.ru/dm",
		"DMService",
		"DMServiceSoap",
		ИнтернетПрокси,
		Таймаут,
		ЗащищенноеСоединение,,
		ИспользуетсяАутентификацияОС);
	Исключение
		Инфо = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Ошибка,,,
		ПодробноеПредставлениеОшибки(Инфо));
		Если ВызыватьИсключение Тогда
			ВызватьИсключение НСтр("ru = 'Ошибка подключения к 1С:Документообороту.
			|
			|Возможно, не прошла авторизация, указан неверный адрес веб-сервиса 
			|или база 1С:Документооборота не опубликована на веб-сервере.
			|
			|Подробности в журнале регистрации. Обратитесь к администратору системы.';
			|en = '1C:Document Management connection error.
			|
			|Authorization might fail, the web service address is incorrect 
			|or the 1C:Document Management base is not published on the web server.
			|
			|See the Event log. Contact your system administrator.'");
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	КонецПопытки;

	Прокси.Пользователь = ИмяПользователя;
	Прокси.Пароль = Пароль;

	Возврат Прокси;

КонецФункции
	