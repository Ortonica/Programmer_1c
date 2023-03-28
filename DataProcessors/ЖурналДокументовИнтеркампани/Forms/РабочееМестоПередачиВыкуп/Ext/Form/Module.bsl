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
			
	СтруктураПолейШапки = Новый Структура(ПоляШапки);	
	ЗаполнитьЗначенияСвойств(СтруктураПолейШапки, Строка);	
	ИмяФормыОткрытия = "Документ.ПередачаТоваровМеждуОрганизациями.ФормаОбъекта";
	
	Основание = Новый Структура;
	Основание.Вставить("ПоляШапки", СтруктураПолейШапки);
	Основание.Вставить("ЗаполнятьПоРезервамТоваровОрганизаций");
	
	СтруктураПараметры = Новый Структура("Основание", Основание);
	
	ФормаПередачи = ПолучитьФорму(ИмяФормыОткрытия, СтруктураПараметры, ЭтотОбъект);
	ФормаВозврата = ПолучитьФорму("Документ.ВозвратТоваровМеждуОрганизациями.Форма.ФормаДокумента", Новый Структура("РС_ПересчитатьТоварыПоПередачам", Истина), ЭтотОбъект); 
	КопироватьДанныеФормы(ФормаПередачи.Объект, ФормаВозврата.Объект);
	
	ФормаВозврата.Объект.Организация = ФормаПередачи.Объект.ОрганизацияПолучатель; 
	ФормаВозврата.Объект.ОрганизацияПолучатель = ФормаПередачи.Объект.Организация; 
	ФормаВозврата.Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями");
	
	ФормаВозврата.Открыть();
	
КонецПроцедуры
