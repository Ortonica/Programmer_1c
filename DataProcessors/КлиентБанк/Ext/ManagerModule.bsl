﻿
&ИзменениеИКонтроль("ОбновитьДокументы")
Процедура РСК_ОбновитьДокументы(ДокументыКЗагрузке, БанковскийСчет, СоздаватьКонтрагентов, ПроводитьДокументы)
	
	Перем РеквизитыВсе, РеквизитыХозОперации;
	
	Отбор = Новый Структура("БанковскийСчет, Загружать, НайденДокументВБазе",
		БанковскийСчет, Истина, Истина);
	СтрокиКЗагрузке = ДокументыКЗагрузке.НайтиСтроки(Отбор);
	
	Для каждого СтрокаДокумента Из СтрокиКЗагрузке Цикл
		
		ДокументОбъект = СтрокаДокумента.Документ.ПолучитьОбъект();
		#Вставка
		//++ РС Консалт: Минаков А.С. Задача 20226
		Если ДокументОбъект.ПроведеноБанком И ДокументОбъект.Проведен Тогда
			Продолжить
		КонецЕсли;
		//++ РС Консалт: Минаков А.С. Задача 20226
		#КонецВставки
		
		СделатьНепроведенным = Ложь;
		
		УстановитьСвойство(ДокументОбъект, "ПроведеноБанком", Истина);
		УстановитьСвойство(ДокументОбъект, "ДатаПроведенияБанком", СтрокаДокумента.ДатаПроведения);
		
		ЗаменитьСтароеЗначение = Ложь;
		//++ Локализация
		ЗаменитьСтароеЗначение = (СтрокаДокумента.Операция <> "Операция по Яндекс.Кассе");
		//-- Локализация
		УстановитьСвойство(ДокументОбъект, "НомерВходящегоДокумента", СтрокаДокумента.Номер, ЗаменитьСтароеЗначение);
		
		Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ПоступлениеБезналичныхДенежныхСредств") Тогда
			Документы.ПоступлениеБезналичныхДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
				ДокументОбъект.ХозяйственнаяОперация, РеквизитыВсе, РеквизитыХозОперации);
				
		ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.СписаниеБезналичныхДенежныхСредств") Тогда
			Документы.СписаниеБезналичныхДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
				ДокументОбъект, РеквизитыВсе, РеквизитыХозОперации);
		КонецЕсли;
		
		// Контрагент
		Если РеквизитыХозОперации.Найти("Контрагент") <> Неопределено И Не ЗначениеЗаполнено(ДокументОбъект.Контрагент) Тогда
			Если ЗначениеЗаполнено(СтрокаДокумента.Контрагент) Тогда
				УстановитьСвойство(ДокументОбъект, "Контрагент", СтрокаДокумента.Контрагент);
			ИначеЕсли СоздаватьКонтрагентов И СтрокаДокумента.СоздаватьКонтрагента Тогда
				УстановитьСвойство(ДокументОбъект, "Контрагент", СоздатьКонтрагента(ДокументыКЗагрузке, СтрокаДокумента));
			Иначе
				УстановитьСвойство(ДокументОбъект, "ИмяКонтрагента", СтрокаДокумента.ИмяКонтрагента);
			КонецЕсли;
		КонецЕсли;
		
		// Счет контрагента
		Если РеквизитыХозОперации.Найти("БанковскийСчетКонтрагента") <> Неопределено И Не ЗначениеЗаполнено(ДокументОбъект.БанковскийСчетКонтрагента) Тогда
			Если ЗначениеЗаполнено(СтрокаДокумента.СчетКонтрагента) Тогда
				УстановитьСвойство(ДокументОбъект, "БанковскийСчетКонтрагента", СтрокаДокумента.СчетКонтрагента);
			ИначеЕсли ЗначениеЗаполнено(ДокументОбъект.Контрагент) Тогда
				УстановитьСвойство(ДокументОбъект, "БанковскийСчетКонтрагента",
				СоздатьБанковскийСчетКонтрагента(ДокументыКЗагрузке, СтрокаДокумента, ДокументОбъект.Контрагент));
			КонецЕсли;
		КонецЕсли;
		
		СтатьяДвиженияДенежныхСредств =
			Справочники.СтатьиДвиженияДенежныхСредств.СтатьяДвиженияДенежныхСредствПоХозяйственнойОперации(ДокументОбъект.ХозяйственнаяОперация);
		
		Для каждого СтрокаРасшифровки Из ДокументОбъект.РасшифровкаПлатежа Цикл
			
			// Партнер
			Если Не ЗначениеЗаполнено(СтрокаРасшифровки.Партнер) Тогда
				СтрокаРасшифровки.Партнер = СтрокаДокумента.Партнер;
			КонецЕсли;
			
			РаботаСКурсамиВалютУТ.ЗаполнитьКурсДокументаПоУмолчанию(СтрокаРасшифровки.КурсЧислительВзаиморасчетов,
																	СтрокаРасшифровки.КурсЗнаменательВзаиморасчетов,
																	ДокументОбъект.Валюта,
																	СтрокаРасшифровки.ВалютаВзаиморасчетов,
																	ДокументОбъект.Организация,
																	ДокументОбъект.Дата,,
																	СтрокаРасшифровки.ОбъектРасчетов);
			
			// Статья ДДС
			Если РеквизитыХозОперации.Найти("РасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств") <> Неопределено
				И Не ЗначениеЗаполнено(СтрокаРасшифровки.СтатьяДвиженияДенежныхСредств) Тогда
				
				Если ЗначениеЗаполнено(СтрокаРасшифровки.ОбъектРасчетов) Тогда
					
					РеквизитыОбъектаРасчетов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
									СтрокаРасшифровки.ОбъектРасчетов,
									"Договор.СтатьяДвиженияДенежныхСредств, Соглашение.СтатьяДвиженияДенежныхСредств");
					
					СтрокаРасшифровки.СтатьяДвиженияДенежныхСредств =
									?(ЗначениеЗаполнено(РеквизитыОбъектаРасчетов.ДоговорСтатьяДвиженияДенежныхСредств),
									РеквизитыОбъектаРасчетов.ДоговорСтатьяДвиженияДенежныхСредств,
									РеквизитыОбъектаРасчетов.СоглашениеСтатьяДвиженияДенежныхСредств);
					
				КонецЕсли;
				
				Если Не ЗначениеЗаполнено(СтрокаРасшифровки.СтатьяДвиженияДенежныхСредств) Тогда
					СтрокаРасшифровки.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		УстановитьСвойство(ДокументОбъект, "СуммаДокумента", СтрокаДокумента.СуммаДокумента, Истина);
		УстановитьСвойство(ДокументОбъект, "НазначениеПлатежа", СтрокаДокумента.НазначениеПлатежа, Истина);
		УстановитьСвойство(ДокументОбъект, "ФорматированноеНазначениеПлатежа", СтрокаДокумента.ФорматированноеНазначениеПлатежа, Истина);
		УстановитьСвойство(ДокументОбъект, "ДанныеВыписки", СтрокаДокумента.ДанныеВыписки, Истина);
		
		СуммыРазличаются = (СтрокаДокумента.СуммаДокумента <> ДокументОбъект.СуммаДокумента);
		Если СуммыРазличаются Тогда
			Если ДокументОбъект.РасшифровкаПлатежа.Количество() = 1 Тогда
				СтрокаРасшифровки = ДокументОбъект.РасшифровкаПлатежа[0];
				СтрокаРасшифровки.Сумма = ДокументОбъект.СуммаДокумента;
			Иначе
				СделатьНепроведенным = Истина;
				ОписаниеОшибки = НСтр("ru = 'Сумма документа отличается от суммы строк расшифровки платежа.';
										|en = 'Document amount differs from the total of payment details lines.'");
				ДобавитьЗамечание(СтрокаДокумента.ОшибкиЗагрузки, ОписаниеОшибки);
			КонецЕсли;
		КонецЕсли;
		
		УстановитьСвойство(ДокументОбъект, "Комментарий", НСтр("ru = '#Загружен из Клиент-Банка';
																|en = '#Imported from Client Bank'"));
		
		Если ДокументОбъект.Модифицированность() Тогда
			УстановитьСвойство(ДокументОбъект, "ДатаЗагрузки", ТекущаяДатаСеанса(), Истина);
		КонецЕсли;
		
		ДокументОбъект.ДополнительныеСвойства.Вставить("ОбменСБанками", Истина);
		ДокументОбъект.Движения.ДенежныеСредстваБезналичные.ДополнительныеСвойства.Вставить("ОбменСБанками", Истина);
		ДокументОбъект.ПроверитьЗаполнение();
		
		Если ДокументОбъект.ДополнительныеСвойства.Свойство("ОшибкиЗаполнения") Тогда
			УстановитьСвойство(ДокументОбъект, "ОшибкиЗагрузки", ДокументОбъект.ДополнительныеСвойства.ОшибкиЗаполнения, Истина);
		КонецЕсли;
		
		Если ПроводитьДокументы
			И СокрЛП(ДокументОбъект.ОшибкиЗагрузки) = "" Тогда
			РежимЗаписи = РежимЗаписиДокумента.Проведение;
		Иначе
			РежимЗаписи = РежимЗаписиДокумента.Запись;
		КонецЕсли;
		
		ЗаписатьОбъект(ДокументОбъект, ?(СделатьНепроведенным, РежимЗаписиДокумента.ОтменаПроведения, РежимЗаписи), СтрокаДокумента);
	КонецЦикла;
	
КонецПроцедуры

&ИзменениеИКонтроль("ЗаполнитьСсылкиНаДокументы")
Процедура РСК_ЗаполнитьСсылкиНаДокументы(ДокументыКЗагрузке, ТаблицаДокументов, БанковскийСчет)

	Запрос = Новый Запрос;
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;

	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаДокументов.НомерСтроки,
	|	ТаблицаДокументов.ДатаДок,
	|	ТаблицаДокументов.Поступило,
	|	ТаблицаДокументов.Списано,
	|	ТаблицаДокументов.Номер,
	|	ТаблицаДокументов.НомерСокр,
	|	ТаблицаДокументов.Исходящий,
	|	ТаблицаДокументов.ТипПлатежногоДокумента,
	|	ТаблицаДокументов.ПолучательСчет,
	|	ТаблицаДокументов.ПлательщикСчет,
	|	ТаблицаДокументов.ПолучательИНН,
	|	ТаблицаДокументов.ПлательщикИНН,
	|	ТаблицаДокументов.ПолучательКПП,
	|	ТаблицаДокументов.ПлательщикКПП,
	|	ТаблицаДокументов.ПроверятьИНН,
	|	ТаблицаДокументов.ПроверятьКПП,
	|	ВЫРАЗИТЬ(ТаблицаДокументов.Код КАК Строка(25)) КАК Код,
	|	ВЫРАЗИТЬ(ТаблицаДокументов.ДанныеВыписки КАК Строка(1024)) КАК ДанныеВыписки,
	|	ВЫРАЗИТЬ(ТаблицаДокументов.Операция КАК Строка(128)) КАК Операция
	|
	|ПОМЕСТИТЬ ТаблицаДокументов
	|
	|ИЗ
	|	&ТаблицаДокументов КАК ТаблицаДокументов
	|";

	Запрос.УстановитьПараметр("ТаблицаДокументов", ТаблицаДокументов);
	Запрос.Выполнить();

	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаДокументов.НомерСтроки КАК НомерСтроки,
	|	ДанныеДокумента.Ссылка КАК Ссылка
	|
	|ИЗ
	|	ТаблицаДокументов
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.СписаниеБезналичныхДенежныхСредств КАК ДанныеДокумента
	|	ПО
	|		ДанныеДокумента.БанковскийСчет = &БанковскийСчет
	|		
	#Удаление
	|		И (НАЧАЛОПЕРИОДА(ДанныеДокумента.ДатаВходящегоДокумента, ДЕНЬ) = ТаблицаДокументов.ДатаДок
	|			И НЕ ДанныеДокумента.ПроведеноБанком
	|			ИЛИ НАЧАЛОПЕРИОДА(ДанныеДокумента.ДатаВходящегоДокумента, ДЕНЬ) = ТаблицаДокументов.ДатаДок
	|				И ДанныеДокумента.ДатаПроведенияБанком = ТаблицаДокументов.Списано
	|				И ДанныеДокумента.ПроведеноБанком)
	#КонецУдаления
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 20226
	|		И (НАЧАЛОПЕРИОДА(ДанныеДокумента.ДатаВходящегоДокумента, ДЕНЬ) = ТаблицаДокументов.ДатаДок)
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки
	|		
	|		И (ДанныеДокумента.НомерВходящегоДокумента = ТаблицаДокументов.Номер
	|			ИЛИ ДанныеДокумента.НомерВходящегоДокумента = ТаблицаДокументов.НомерСокр)
	|		И ДанныеДокумента.ТипПлатежногоДокумента = ТаблицаДокументов.ТипПлатежногоДокумента
	|	
	|		И (ДанныеДокумента.БанковскийСчетПолучатель.НомерСчета = ТаблицаДокументов.ПолучательСчет
	|			ИЛИ ДанныеДокумента.БанковскийСчетКонтрагента.НомерСчета = ТаблицаДокументов.ПолучательСчет
	|			ИЛИ (ЕСТЬNULL(ДанныеДокумента.БанковскийСчетПолучатель.НомерСчета, """") = """"
	|				И ЕСТЬNULL(ДанныеДокумента.БанковскийСчетКонтрагента.НомерСчета, """") = """")
	|			ИЛИ ТаблицаДокументов.ПолучательСчет = """"
	|			)
	//++ Локализация
	|		И (НЕ ТаблицаДокументов.ПроверятьИНН
	|			ИЛИ (ЕСТЬNULL(ДанныеДокумента.БанковскийСчетПолучатель.Владелец.ИНН, """") = """"
	|				И ЕСТЬNULL(ДанныеДокумента.БанковскийСчетКонтрагента.Владелец.ИНН, """") = """")
	|			ИЛИ ДанныеДокумента.БанковскийСчетПолучатель.Владелец.ИНН = ТаблицаДокументов.ПолучательИНН
	|			ИЛИ ДанныеДокумента.БанковскийСчетКонтрагента.Владелец.ИНН = ТаблицаДокументов.ПолучательИНН
	|			ИЛИ ДанныеДокумента.БанковскийСчетКонтрагента.ИННКорреспондента = ТаблицаДокументов.ПолучательИНН
	|			)
	|		И (
	|			(НЕ ТаблицаДокументов.ПроверятьКПП
	|			ИЛИ (ЕСТЬNULL(ДанныеДокумента.БанковскийСчетПолучатель.Владелец.КПП, """") = """"
	|				И ЕСТЬNULL(ДанныеДокумента.БанковскийСчетКонтрагента.Владелец.КПП, """") = """")
	|			ИЛИ ДанныеДокумента.БанковскийСчетПолучатель.Владелец.КПП = ТаблицаДокументов.ПолучательКПП
	|			ИЛИ ДанныеДокумента.БанковскийСчетКонтрагента.Владелец.КПП = ТаблицаДокументов.ПолучательКПП
	|			ИЛИ ДанныеДокумента.БанковскийСчетКонтрагента.КППКорреспондента = ТаблицаДокументов.ПолучательКПП
	|			)
	|			ИЛИ 
	|			(ВЫРАЗИТЬ(ДанныеДокумента.ДанныеВыписки КАК Строка(1024)) = ТаблицаДокументов.ДанныеВыписки
	|				И ВЫРАЗИТЬ(ДанныеДокумента.ДанныеВыписки КАК Строка(1024)) <> """"))
	//-- Локализация
	|		
	|ГДЕ
	|	ТаблицаДокументов.Исходящий
	|	И НЕ ДанныеДокумента.Ссылка ЕСТЬ NULL
	|	И НЕ ДанныеДокумента.ПометкаУдаления
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ
	|	ТаблицаДокументов.НомерСтроки КАК НомерСтроки,
	|	ДанныеДокумента.Ссылка КАК Ссылка
	|
	|ИЗ
	|	ТаблицаДокументов
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.ПоступлениеБезналичныхДенежныхСредств КАК ДанныеДокумента
	|	ПО
	|		ДанныеДокумента.БанковскийСчет = &БанковскийСчет
	//++ Локализация
	|		И НЕ ДанныеДокумента.ДанныеВыписки ПОДОБНО (""СЕКЦИЯДОКУМЕНТ=Операция по Яндекс.Кассе%"")
	//-- Локализация
	|		
	#Удаление
	|		И (НАЧАЛОПЕРИОДА(ДанныеДокумента.ДатаВходящегоДокумента, ДЕНЬ) = ТаблицаДокументов.ДатаДок
	|			И НЕ ДанныеДокумента.ПроведеноБанком
	|			ИЛИ НАЧАЛОПЕРИОДА(ДанныеДокумента.ДатаВходящегоДокумента, ДЕНЬ) = ТаблицаДокументов.ДатаДок
	|				И ДанныеДокумента.ДатаПроведенияБанком = ТаблицаДокументов.Поступило
	|				И ДанныеДокумента.ПроведеноБанком)
	#КонецУдаления
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 20226
	|		И (НАЧАЛОПЕРИОДА(ДанныеДокумента.ДатаВходящегоДокумента, ДЕНЬ) = ТаблицаДокументов.ДатаДок)
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки
	|		
	|		И (ДанныеДокумента.НомерВходящегоДокумента = ТаблицаДокументов.Номер
	|			ИЛИ ДанныеДокумента.НомерВходящегоДокумента = ТаблицаДокументов.НомерСокр)
	|		И ДанныеДокумента.ТипПлатежногоДокумента = ТаблицаДокументов.ТипПлатежногоДокумента
	|		
	|		И (ДанныеДокумента.БанковскийСчетОтправитель.НомерСчета = ТаблицаДокументов.ПлательщикСчет
	|			ИЛИ ДанныеДокумента.БанковскийСчетКонтрагента.НомерСчета = ТаблицаДокументов.ПлательщикСчет
	|			ИЛИ (ЕСТЬNULL(ДанныеДокумента.БанковскийСчетОтправитель.НомерСчета, """") = """"
	|				И ЕСТЬNULL(ДанныеДокумента.БанковскийСчетКонтрагента.НомерСчета, """") = """")
	|			ИЛИ ТаблицаДокументов.ПлательщикСчет = """"
	|			)
	//++ Локализация
	|		И (НЕ ТаблицаДокументов.ПроверятьИНН
	|			ИЛИ (ЕСТЬNULL(ДанныеДокумента.БанковскийСчетОтправитель.Владелец.ИНН, """") = """"
	|				И ЕСТЬNULL(ДанныеДокумента.БанковскийСчетКонтрагента.Владелец.ИНН, """") = """")
	|			ИЛИ ДанныеДокумента.БанковскийСчетОтправитель.Владелец.ИНН = ТаблицаДокументов.ПлательщикИНН
	|			ИЛИ ДанныеДокумента.БанковскийСчетКонтрагента.Владелец.ИНН = ТаблицаДокументов.ПлательщикИНН
	|			ИЛИ ДанныеДокумента.БанковскийСчетКонтрагента.ИННКорреспондента = ТаблицаДокументов.ПолучательИНН
	|			)
	|		
	|		И (НЕ ТаблицаДокументов.ПроверятьИНН
	|			ИЛИ (ЕСТЬNULL(ДанныеДокумента.Контрагент.ИНН, """") = """"
	|				И ЕСТЬNULL(ДанныеДокумента.ПодотчетноеЛицо.ИНН, """") = """")
	|			ИЛИ ДанныеДокумента.Контрагент.ИНН = ТаблицаДокументов.ПлательщикИНН
	|			ИЛИ ДанныеДокумента.ПодотчетноеЛицо.ИНН = ТаблицаДокументов.ПлательщикИНН)
	|		
	|		И ((НЕ ТаблицаДокументов.ПроверятьКПП
	|			ИЛИ ЕСТЬNULL(ДанныеДокумента.Контрагент.КПП, """") = """"
	|			ИЛИ ДанныеДокумента.Контрагент.КПП = ТаблицаДокументов.ПлательщикКПП)
	|			
	|			ИЛИ (ВЫРАЗИТЬ(ДанныеДокумента.ДанныеВыписки КАК Строка(1024)) = ТаблицаДокументов.ДанныеВыписки
	|				И ВЫРАЗИТЬ(ДанныеДокумента.ДанныеВыписки КАК Строка(1024)) <> """"))
	//-- Локализация
	|		И (
	//++ Локализация
	|			(НЕ ТаблицаДокументов.ПроверятьКПП
	|			ИЛИ (ЕСТЬNULL(ДанныеДокумента.БанковскийСчетОтправитель.Владелец.КПП, """") = """"
	|				И ЕСТЬNULL(ДанныеДокумента.БанковскийСчетКонтрагента.Владелец.КПП, """") = """")
	|			ИЛИ ДанныеДокумента.БанковскийСчетОтправитель.Владелец.КПП = ТаблицаДокументов.ПлательщикКПП
	|			ИЛИ ДанныеДокумента.БанковскийСчетКонтрагента.Владелец.КПП = ТаблицаДокументов.ПлательщикКПП
	|			ИЛИ ДанныеДокумента.БанковскийСчетКонтрагента.КППКорреспондента = ТаблицаДокументов.ПолучательКПП
	|			)
	|			ИЛИ 
	//-- Локализация
	|			(ВЫРАЗИТЬ(ДанныеДокумента.ДанныеВыписки КАК Строка(1024)) = ТаблицаДокументов.ДанныеВыписки
	|				И ВЫРАЗИТЬ(ДанныеДокумента.ДанныеВыписки КАК Строка(1024)) <> """"))
	|		
	|ГДЕ
	|	НЕ ТаблицаДокументов.Исходящий
	|	И НЕ ДанныеДокумента.Ссылка ЕСТЬ NULL
	|	И НЕ ДанныеДокумента.ПометкаУдаления
	//++ Локализация
	|	И НЕ ТаблицаДокументов.Операция ПОДОБНО (""Операция по Яндекс.Кассе%"")
	//-- Локализация
	|	
	//++ Локализация
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ // Проведение банком платежа ЯндексКассы
	|	ТаблицаДокументов.НомерСтроки КАК НомерСтроки,
	|	ДанныеДокумента.Ссылка КАК Ссылка
	|
	|ИЗ
	|	ТаблицаДокументов
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.ПоступлениеБезналичныхДенежныхСредств КАК ДанныеДокумента
	|	ПО
	|		ДанныеДокумента.БанковскийСчет = &БанковскийСчет
	|		И ДанныеДокумента.ИдентификаторПлатежа = ТаблицаДокументов.Код
	|		И ДанныеДокумента.ДанныеВыписки ПОДОБНО (""СЕКЦИЯДОКУМЕНТ=Операция по Яндекс.Кассе%"")
	|		
	|ГДЕ
	|	НЕ ТаблицаДокументов.Исходящий
	|	И НЕ ДанныеДокумента.Ссылка ЕСТЬ NULL
	|	И НЕ ДанныеДокумента.ПометкаУдаления
	|	И ТаблицаДокументов.Код <> """"
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ // Платеж ЯндексКассы
	|	ТаблицаДокументов.НомерСтроки КАК НомерСтроки,
	|	ДанныеДокумента.Ссылка КАК Ссылка
	|
	|ИЗ
	|	ТаблицаДокументов
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.ПоступлениеБезналичныхДенежныхСредств КАК ДанныеДокумента
	|	ПО
	|		ДанныеДокумента.БанковскийСчет = &БанковскийСчет
	|		И ДанныеДокумента.ИдентификаторПлатежа = ТаблицаДокументов.Код
	|		
	|ГДЕ
	|	НЕ ТаблицаДокументов.Исходящий
	|	И НЕ ДанныеДокумента.Ссылка ЕСТЬ NULL
	|	И НЕ ДанныеДокумента.ПометкаУдаления
	|	И ТаблицаДокументов.Код <> """"
	|	И ТаблицаДокументов.Операция ПОДОБНО (""Операция по Яндекс.Кассе%"")
	//-- Локализация
	|";

	Запрос.УстановитьПараметр("БанковскийСчет", БанковскийСчет);
	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл

		СтрокаДокумента = ДокументыКЗагрузке.Найти(Выборка.НомерСтроки, "НомерСтроки");
		Если СтрокаДокумента <> Неопределено Тогда

			// Если документ найден, создавать новый не будем. Если найдено несколько документов, то обновлять данные документа не нужно.
			Если ЗначениеЗаполнено(СтрокаДокумента.Документ) Тогда
				СтрокаДокумента.Загружать = Ложь;
			КонецЕсли;
			СтрокаДокумента.Документ = Выборка.Ссылка;
			СтрокаДокумента.НайденДокументВБазе = Истина;

		КонецЕсли;
	КонецЦикла;

КонецПроцедуры
