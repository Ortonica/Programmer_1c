﻿// Устанавливает в параметр сеанса текущее время на сервере
// Для отслеживания длительности простоя кладовщика для сброса авторизации
// ++ РС Консалт: Трофимов Евгений 04.08.2022 Задача 19394
// e1cib/data/Документ.Задание?ref=a08e5944efdf2c724d9f9d3c61ee1f3b
Процедура УстановитьВремяПоследнегоСобытия() Экспорт
	ПараметрыСеанса.РСК_ВремяПоследнегоСканированияКладовщиком = ТекущаяДата();
КонецПроцедуры

// Возвращает элемент справочника «Складские операции»
// ++ РС Консалт: Трофимов Евгений 04.08.2022 Задача 19394
// e1cib/data/Документ.Задание?ref=a08e5944efdf2c724d9f9d3c61ee1f3b
//
// Параметры:
//  Штрихкод - Строка - Штрихкод
// 
Функция ОперацияПоШтрихкоду(Штрихкод) Экспорт

	Возврат Справочники.РСК_СкладскиеОперации.НайтиПоКоду(Штрихкод);

КонецФункции // ОперацияПоШтрихкоду()

// ++ РС Консалт: Трофимов Евгений 04.08.2022 Задача 19394
// e1cib/data/Документ.Задание?ref=a08e5944efdf2c724d9f9d3c61ee1f3b
Процедура УстановитьПараметрСеансаАвторизованныйКладовщик(Пользователь) Экспорт
	ПараметрыСеанса.РСК_АвторизовавшийсяКладовщик = Пользователь;
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 04.08.2022 Задача 19394
//e1cib/data/Документ.Задание?ref=a08e5944efdf2c724d9f9d3c61ee1f3b
Функция ТаймаутПрошел() Экспорт
	Возврат ТекущаяДата() - ПараметрыСеанса.РСК_ВремяПоследнегоСканированияКладовщиком > 30;	
КонецФункции

// Установить в распоряжение статус
//++ РС Консалт: Трофимов Евгений 04.11.2022 Задача 21690
//e1cib/data/Документ.Задание?ref=a94cfb7ab14ed9464fc6486de1b61c04
// Параметры:
//  Параметры		 - Структура - Ключи:
//		* Распоряжение - ДокументСсылка.РасходныйОрдерНаТовары
//		* Товары - ТаблицаЗначений - Колонки: Номенклатура,Характеристика,Серия,Упаковка,КоличествоОтобрано,КоличествоУпаковокОтобрано
//  АдресХранилища	 - Строка - 
//
Процедура УстановитьВРаспоряжениеСтатус(Параметры, АдресХранилища = "") Экспорт
	
	//++ РС Консалт: Минаков А.С. Задача 20226
	ПараметрыОбновленияОрдера = РСК_ВызовСервера.ПараметрыОбновленияОрдера();
	
	РеквизитыОрдера = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Распоряжение, "Склад, ЗаданиеНаПеревозку, ДатаОтгрузки");
	
	ПараметрыОбновленияОрдера.Ордер = Параметры.Распоряжение;
	ПараметрыОбновленияОрдера.Склад = РеквизитыОрдера.Склад;
	ПараметрыОбновленияОрдера.ДатаОтгрузки = РеквизитыОрдера.ДатаОтгрузки;
	ПараметрыОбновленияОрдера.ЗаполнитьЗадание = Не ЗначениеЗаполнено(РеквизитыОрдера.ЗаданиеНаПеревозку);
	ПараметрыОбновленияОрдера.НовыйСтатус = "КОтгрузке";
	ПараметрыОбновленияОрдера.ИсключаемыеСтатусы = "КОтгрузке,Отгружен";
	ПараметрыОбновленияОрдера.ВыполнениеВФоне = Истина;
	ПараметрыОбновленияОрдера.ЗаполнитьПоОтбору = Истина;
	
	Отказ = Ложь;
	РСК_ВызовСервера.ВыполнитьПроверкуИзменениеОрдера(ПараметрыОбновленияОрдера, Отказ);
	Если Отказ Тогда
		Мета = Параметры.Распоряжение.Метаданные();
		Для Каждого ДанныеОшибки Из ПараметрыОбновленияОрдера.Ошибки Цикл
			ЗаписьЖурналаРегистрации("УстановкаСтатусаРО", УровеньЖурналаРегистрации.Ошибка, Мета, Параметры.Распоряжение, ДанныеОшибки.ТекстОшибки)
		КонецЦикла
	КонецЕсли;
	
	Возврат;
	//++ РС Консалт: Минаков А.С. Задача 20226
	
	//Удалить код ниже после проверки
	
	оДок = Параметры.Распоряжение.ПолучитьОбъект();
	
	//++ РС Консалт: Трофимов Евгений 08.11.2022 Задача 21764
	//e1cib/data/Документ.Задание?ref=acb40d67c9e549894b12a35aa4395ead
	//Янюк Олеся: статут К ОТГРУЗКЕ ставиться автоматически, после сканирования отбора, 
	//но необходимо заходить в РО и ставить ОТГРУЗИТЬ руками, так же единица измерения не проставляется автоматически                  
	тзТоварыОтбор = Параметры.Товары;
	тзТоварыОтбор.Свернуть("Номенклатура,Характеристика,Серия,Упаковка","Количество,КоличествоУпаковок");
	тзКОтгрузке = оДок.ОтгружаемыеТовары.Выгрузить();
	оДок.ОтгружаемыеТовары.Очистить();
	
	
	Для Каждого Стр Из тзКОтгрузке Цикл
		Если Стр.Действие <> Перечисления.ДействияСоСтрокамиОрдеровНаОтгрузку.Отобрать Тогда
			НС = оДок.ОтгружаемыеТовары.Добавить();
			ЗаполнитьЗначенияСвойств(НС, Стр);
		КонецЕсли;
	КонецЦикла;
	тзКОтгрузке = тзКОтгрузке.Скопировать(Новый Структура("Действие",Перечисления.ДействияСоСтрокамиОрдеровНаОтгрузку.Отобрать));
	Фильтр = Новый Структура("Номенклатура,Характеристика,Серия");
	Для Каждого Стр Из тзКОтгрузке Цикл
		ЗаполнитьЗначенияСвойств(Фильтр, Стр);
		Найденные = тзТоварыОтбор.НайтиСтроки(Фильтр);
		Для Каждого СтрОтбор Из Найденные Цикл
			Если Стр.Количество <= 0 Тогда
				Прервать;
			ИначеЕсли СтрОтбор.Количество <= 0 Тогда
				Продолжить;
			КонецЕсли;
			МожноСписать = Мин(Стр.Количество, СтрОтбор.Количество);
			НС = оДок.ОтгружаемыеТовары.Добавить();
			ЗаполнитьЗначенияСвойств(НС, Стр);
			НС.Количество = МожноСписать;
			НС.Упаковка = СтрОтбор.Упаковка;
			НС.Действие = Перечисления.ДействияСоСтрокамиОрдеровНаОтгрузку.Отгрузить;
			
			СтруктураДействий = Новый Структура();
			СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковок");
			ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(НС, СтруктураДействий, Неопределено);
			
			Стр.Количество = Стр.Количество - МожноСписать;
			СтрОтбор.Количество = СтрОтбор.Количество - МожноСписать;
		КонецЦикла;
		
		Если Стр.Количество > 0 Тогда
			НС = оДок.ОтгружаемыеТовары.Добавить();
			ЗаполнитьЗначенияСвойств(НС, Стр);
		КонецЕсли;
	КонецЦикла;
	
	
	//Проверяем, если все действия строк Отгрузить или НеОтгружать, то можно переводить статус документа в КОтгрузке
	МожноОтгружать = Истина;
	Для Каждого Стр Из оДок.ОтгружаемыеТовары Цикл
		Если Стр.Действие <> Перечисления.ДействияСоСтрокамиОрдеровНаОтгрузку.Отгрузить
			И Стр.Действие <> Перечисления.ДействияСоСтрокамиОрдеровНаОтгрузку.НеОтгружать Тогда
			
			МожноОтгружать = Ложь;
			Прервать;
			
		КонецЕсли;
	КонецЦикла;
	Если МожноОтгружать Тогда
		оДок.Статус = Перечисления.СтатусыРасходныхОрдеров.КОтгрузке;
		
		//Подбираем подходящее задание на перевозку:
		Если НЕ ЗначениеЗаполнено(оДок.ЗаданиеНаПеревозку) Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение КАК ЗаказКлиента,
				|	ЗаданиеНаПеревозкуРаспоряжения.Ссылка КАК ЗаданиеНаПеревозку
				|ИЗ
				|	Документ.РасходныйОрдерНаТовары.ТоварыПоРаспоряжениям КАК РасходныйОрдерНаТоварыТоварыПоРаспоряжениям
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаданиеНаПеревозку.Распоряжения КАК ЗаданиеНаПеревозкуРаспоряжения
				|		ПО РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение = ЗаданиеНаПеревозкуРаспоряжения.Распоряжение
				|			И (НАЧАЛОПЕРИОДА(РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.ДатаОтгрузки, ДЕНЬ) >= НАЧАЛОПЕРИОДА(ЗаданиеНаПеревозкуРаспоряжения.Ссылка.ДатаВремяРейсаПланС, ДЕНЬ))
				|			И (ЗаданиеНаПеревозкуРаспоряжения.Ссылка.Проведен)
				|			И (РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка = &РО)
				|			И (ЗаданиеНаПеревозкуРаспоряжения.Ссылка.Склад = РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.Склад)";
			Запрос.УстановитьПараметр("РО", Параметры.Распоряжение);
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				оДок.ЗаданиеНаПеревозку = Выборка.ЗаданиеНаПеревозку;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	//-- КонецЗадачи 21764
	
	
	Попытка
		оДок.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
	Исключение
		ЗаписьЖурналаРегистрации("УстановкаСтатусаРО",УровеньЖурналаРегистрации.Ошибка,оДок.Метаданные(),оДок.Ссылка,ОписаниеОшибки());
		оДок.ОбменДанными.Загрузка = Истина;
		оДок.Записать(РежимЗаписиДокумента.Запись);
	КонецПопытки;

КонецПроцедуры

