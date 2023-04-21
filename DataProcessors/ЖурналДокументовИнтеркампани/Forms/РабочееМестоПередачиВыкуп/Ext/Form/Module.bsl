﻿//++ РС Консалт: Тарасов Михаил 27.03.2023 Тикет 24694
//e1cib/data/Документ.Задание?ref=9dee4226413d62da4f66d1a8e14341aa

&НаКлиенте
Процедура РСК_РС_ОформитьВозвратПосле(Команда)
	
	//Используем ОформитьДокументЗаПериод в качестве основы для возврата
	
	Строка = Элементы.КОформлениюЗаПериод.ТекущиеДанные;
	
	Если Не ОбщегоНазначенияУТКлиент.ВыбраныДокументыКОформлению(
		Строка, ПараметрыЖурнала()) Тогда
		Возврат;
	КонецЕсли; 
	
	Если Строка = Неопределено ИЛИ ОформляемыеДокументы <> "ТолькоПередачи" Тогда
		Возврат;
	КонецЕсли;
	
	//++РС Консалт: Минаков А.С. Задача 24557
	СтруктураПолейШапки = Новый Структура(ПоляШапки);	
	ЗаполнитьЗначенияСвойств(СтруктураПолейШапки, Строка);	
	//ИмяФормыОткрытия = "Документ.ПередачаТоваровМеждуОрганизациями.ФормаОбъекта";
	ИмяФормыОткрытия = "Документ.ВозвратТоваровМеждуОрганизациями.ФормаОбъекта";
	
	Основание = Новый Структура;
	Основание.Вставить("ПоляШапки", СтруктураПолейШапки);
	Основание.Вставить("ЗаполнятьПоРезервамТоваровОрганизаций");
	
	СтруктураПараметры = Новый Структура("Основание, РС_ПересчитатьТоварыПоПередачам", Основание, Истина);
	
	ОткрытьФорму(ИмяФормыОткрытия, СтруктураПараметры, ЭтотОбъект);
	
	//ФормаПередачи = ПолучитьФорму(ИмяФормыОткрытия, СтруктураПараметры, ЭтотОбъект);
	//ФормаВозврата = ПолучитьФорму("Документ.ВозвратТоваровМеждуОрганизациями.Форма.ФормаДокумента", Новый Структура("РС_ПересчитатьТоварыПоПередачам", Истина), ЭтотОбъект); 
	//КопироватьДанныеФормы(ФормаПередачи.Объект, ФормаВозврата.Объект);
	//
	//ФормаВозврата.Объект.Договор = ПредопределенноеЗначение("Справочник.ДоговорыМеждуОрганизациями.ПустаяСсылка");	
	//ФормаВозврата.Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями");
	//
	//ФормаВозврата.Открыть();
	//++РС Консалт: Минаков А.С. Задача 24557
	
КонецПроцедуры 

//-- КонецТикета 24694
