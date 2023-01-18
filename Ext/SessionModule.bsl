﻿ 
&После("УстановкаПараметровСеанса")
Процедура РСК_УстановкаПараметровСеанса(ТребуемыеПараметры)
	
	Если ТипЗнч(ТребуемыеПараметры) = Тип("Массив") Тогда
		//++ РС Консалт: Трофимов Евгений 20.07.2022 Тикет 19109
		//e1cib/data/Документ.Задание?ref=8573c6b02148ef8e4e1c3baafe4d427b
		//Для удобной отладки загружаемых данных серез обработку УниверсальныйОбменДаннымиXML
		Если ТребуемыеПараметры.Найти("РСК_ПроводитьДокументыПослеЗагрузкиЧерезXML") <> Неопределено Тогда
			ПараметрыСеанса.РСК_ПроводитьДокументыПослеЗагрузкиЧерезXML = Ложь;
		КонецЕсли;
		//-- КонецТикета 19109	
		
		//++ РС Консалт: Трофимов Евгений 04.08.2022 Задача 19394
		//e1cib/data/Документ.Задание?ref=a08e5944efdf2c724d9f9d3c61ee1f3b
		//Для отслеживания длительности простоя кладовщика для сброса авторизации
		//см. ОбщийМодуль.РСК_РаботаСоСканером
		Если ТребуемыеПараметры.Найти("РСК_ВремяПоследнегоСканированияКладовщиком") <> Неопределено Тогда
			ПараметрыСеанса.РСК_ВремяПоследнегоСканированияКладовщиком = '00010101';
		КонецЕсли;
		Если ТребуемыеПараметры.Найти("РСК_АвторизовавшийсяКладовщик") <> Неопределено Тогда
			ПараметрыСеанса.РСК_АвторизовавшийсяКладовщик = Справочники.Пользователи.ПустаяСсылка();
		КонецЕсли;
		//-- КонецЗадачи 19394		
		
	КонецЕсли;
КонецПроцедуры