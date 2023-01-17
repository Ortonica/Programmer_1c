﻿&НаСервере
Процедура РСК_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	//Начало РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
	Если Объект.Основания.Количество() > 0 Тогда
		Контракт = Объект.Основания[0].Основание;
	КонецЕсли;
	//Конец РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура РСК_ПриОткрытииПосле(Отказ)
	//Начало РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
	УстановитьВидимостьЭлементов();
	//Конец РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
КонецПроцедуры


&НаКлиенте
Процедура УстановитьВидимостьЭлементов()
	//Начало РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
	Если Объект.РСК_АктВыдачиТСР Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаАктВыдачиТСР;
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.ТиповойФункционал;
	КонецЕсли;
	Элементы.ФормаАктВыдачиТСР.Доступность = НЕ Объект.РСК_АктВыдачиТСР;
	Элементы.ФормаАктВыдачиТСР.Пометка = Объект.РСК_АктВыдачиТСР;
	Элементы.ФормаТиповойФункционал.Доступность = Объект.РСК_АктВыдачиТСР;
	Элементы.ФормаТиповойФункционал.Пометка = НЕ Объект.РСК_АктВыдачиТСР;
	//Конец РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
КонецПроцедуры // УстановитьВидимостьЭлементов()

&НаКлиенте
Процедура РСК_РСК_КоличествоПриИзмененииПосле(Элемент)
	//Начало РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
	Объект.РСК_Сумма = Объект.РСК_Количество * Объект.РСК_Цена;
	//Конец РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
КонецПроцедуры

&НаКлиенте
Процедура РСК_РСК_ЦенаПриИзмененииПосле(Элемент)
	//Начало РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
	Объект.РСК_Сумма = Объект.РСК_Количество * Объект.РСК_Цена;
	//Конец РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
КонецПроцедуры

&НаКлиенте
Процедура РСК_АктВыдачиТСРПосле(Команда)
	//Начало РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
	Объект.РСК_АктВыдачиТСР = Истина;
	Модифицированность = Истина;
	УстановитьВидимостьЭлементов();
	//Конец РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
КонецПроцедуры

&НаКлиенте
Процедура РСК_ТиповойФункционалПосле(Команда)
	//Начало РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
	Объект.РСК_АктВыдачиТСР = Ложь;
	Модифицированность = Истина;
	УстановитьВидимостьЭлементов();
	//Конец РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
КонецПроцедуры

&НаКлиенте
Процедура РСК_КонтрактПриИзмененииПосле(Элемент)
	//Начало РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
	Если ЗначениеЗаполнено(Контракт) Тогда
		Если Объект.Основания.Количество() > 0 Тогда
			Объект.Основания[0].Основание = Контракт;
		Иначе
			НС = Объект.Основания.Добавить();
			НС.Основание = Контракт;
		КонецЕсли;
	Иначе
		Объект.Основания.Очистить();
	КонецЕсли;
	//Конец РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
КонецПроцедуры

&НаКлиенте
Процедура РСК_НачалоВыбораСтрокиЗаказа(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//++ РС Консалт: Трофимов Евгений 26.10.2022 Задача 21384
	//e1cib/data/Документ.Задание?ref=b0773e366ad07a244bbad1a0c7a3ebaa
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗаказКлиента", Контракт);
	ПараметрыФормы.Вставить("НоменклатураКонтрагента", Объект.РСК_ТСР);
	ОткрытьФорму(
		"Документ.ЗаказКлиента.Форма.РСК_ВыборСтрокиЗаказа",
		ПараметрыФормы, 
		ЭтаФорма,,,, 
		Новый ОписаниеОповещения("РСК_ПослеВыбораСтрокиЗаказа", ЭтаФорма)
	);
	//-- КонецЗадачи 21384
КонецПроцедуры

&НаКлиенте
Процедура РСК_ПослеВыбораСтрокиЗаказа(Результат, ДополнительныеПараметры) Экспорт
	//++ РС Консалт: Трофимов Евгений 26.10.2022 Задача 21384
	//e1cib/data/Документ.Задание?ref=b0773e366ad07a244bbad1a0c7a3ebaa
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Объект.РСК_Номенклатура = Результат.Номенклатура;
	Объект.РСК_Характеристика = Результат.Характеристика;
	Объект.РСК_Серия = Результат.Серия;
	Объект.РСК_Цена = Результат.Цена;
	Объект.РСК_Сумма = Объект.РСК_Количество * Объект.РСК_Цена;
	//-- КонецЗадачи 21384
КонецПроцедуры

&НаКлиенте
Процедура РСК_РСК_ТСРНачалоВыбораПосле(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//++ РС Консалт: Трофимов Евгений 06.11.2022 Задача 21691
	//e1cib/data/Документ.Задание?ref=a7f8c1f3d9f5178d4137985975e27a93
	Если ЗначениеЗаполнено(Контракт) Тогда
		СтандартнаяОбработка = Ложь;
		НастройкиКомпоновки = Новый НастройкиКомпоновкиДанных;

		ЭлементОтбора = НастройкиКомпоновки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.ПравоеЗначение = ПолучитьТСРизЗаказа(Контракт);

		Парам = Новый Структура;
		Парам.Вставить("ФиксированныеНастройки", НастройкиКомпоновки);
		Парам.Вставить("РежимВыбора", Истина);
		Парам.Вставить("МножественныйВыбор",Ложь);

		ФормаВыбора = ПолучитьФорму("Справочник.НоменклатураКонтрагентов.ФормаВыбора", Парам, Элемент);
		ФормаВыбора.Открыть();
		ФормаВыбора.Элементы.Список.ТекущаяСтрока = Объект.РСК_ТСР;
	КонецЕсли;
	//-- КонецЗадачи 21691	
КонецПроцедуры

// Получает список ТСР из Заказа клиента
//++ РС Консалт: Трофимов Евгений 06.11.2022 Задача 21691
//e1cib/data/Документ.Задание?ref=a7f8c1f3d9f5178d4137985975e27a93
//
// Параметры:
//  ЗаказКлиента  - ДокументСсылка.ЗаказКлиента - Заказ клиента
//
// Возвращаемое значение:
//   СписокЗначений   - Элементы справочника «Номенклатура контрагентов»
//
&НаСервереБезКонтекста
Функция ПолучитьТСРизЗаказа(ЗаказКлиента)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗаказКлиентаТовары.НоменклатураПартнера КАК НоменклатураПартнера
		|ИЗ
		|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
		|ГДЕ
		|	ЗаказКлиентаТовары.Ссылка = &ЗаказКлиента";
	
	Запрос.УстановитьПараметр("ЗаказКлиента", ЗаказКлиента);
	Выборка = Запрос.Выполнить().Выбрать();
	СписокТСР = Новый СписокЗначений;	
	Пока Выборка.Следующий() Цикл
		СписокТСР.Добавить(Выборка.НоменклатураПартнера);
	КонецЦикла;
	Возврат СписокТСР;

КонецФункции // ПолучитьТСРизЗаказа()

