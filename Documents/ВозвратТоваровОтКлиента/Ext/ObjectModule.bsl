﻿
&ИзменениеИКонтроль("ОбработкаЗаполнения")
Процедура РСК_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ЗаполненНаОснованииДокумента = Ложь;

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);

	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("ЗаполнитьПоПереданнойТаре") Тогда
			ЗаполнитьДокументНаОснованииПереданнойТары(ДанныеЗаполнения);
			ЗаполненНаОснованииДокумента = Истина;
		ИначеЕсли ДанныеЗаполнения.Свойство("АктОРасхождениях") 
			И ДанныеЗаполнения.Свойство("ОснованиеАкта") Тогда

			Если ТипЗнч(ДанныеЗаполнения.ОснованиеАкта) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
				ЗаполнитьДокументНаОснованииАктаПослеОтгрузки(ДанныеЗаполнения);
			ИначеЕсли ТипЗнч(ДанныеЗаполнения.ОснованиеАкта) = Тип("ДокументСсылка.ВозвратТоваровОтКлиента") Тогда
				ЗаполнитьДокументНаОснованииАктаПослеПриемки(ДанныеЗаполнения);
			КонецЕсли;
		ИначеЕсли ДанныеЗаполнения.Свойство("МассивЗаказов") Тогда
			ЗаполнитьПоЗаказу(ДанныеЗаполнения);
		ИначеЕсли ДанныеЗаполнения.Свойство("ЗаполнитьПоРеализацииТоваров") Тогда
			ЗаполнитьДокументНаОснованииРеализацииТоваровИУслуг(ДанныеЗаполнения.ДокументОснование, ДанныеЗаполнения.ПараметрыОформления);
			ЗаполненНаОснованииДокумента = Истина;
		Иначе
			ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
		КонецЕсли;
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		ЗаполнитьДокументНаОснованииРеализацииТоваровИУслуг(ДанныеЗаполнения);
		ЗаполненНаОснованииДокумента = Истина;
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента") Тогда
		ЗаполнитьДокументНаОснованииЗаявкиНаВозвратТоваровОтКлиента(ДанныеЗаполнения);
		ЗаполненНаОснованииДокумента = Истина;

	КонецЕсли;

	ОчиститьСпособОпределенияСебестоимостиИДокументРеализации();

	ВозвратТоваровОтКлиентаЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

	Если Не ЗаполненНаОснованииДокумента Тогда
		ИнициализироватьУсловияПродаж();
	КонецЕсли; 
	#Вставка
	//++РС Консалт Назаров М.Ю. 21 ноября 2022 г. 13:14:37                  
	Попытка
		Если ТипЗнч(ДанныеЗаполнения.ОснованиеАкта) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда 
			ЭтотОбъект.Менеджер = ДанныеЗаполнения.ОснованиеАкта.Менеджер;		
		КонецЕсли;
		
		Если ТипДанныхЗаполнения = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда 
			ЭтотОбъект.Менеджер = ДанныеЗаполнения.Менеджер;		
		КонецЕсли;                                                                                       
	Исключение
	КонецПопытки;
	//--РС Консалт Назаров М.Ю. 21 ноября 2022 г. 13:14:37
	#КонецВставки

	ИнициализироватьДокумент(ДанныеЗаполнения);

	ВзаиморасчетыСервер.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения);

	БонусныеБаллыСервер.ЗаполнитьБонусныеБаллыВозвратТоваровОтКлиента(ЭтотОбъект);

	ПересчитатьКоличествоРНПТ();

КонецПроцедуры
