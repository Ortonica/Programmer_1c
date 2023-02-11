﻿
	
Процедура РС_ЗаполнитьОбъектыЗакупки(Контракт, Объект) 
	
	Объект.ОбъектыЗакупки.Очистить();
	Объект.СтраныПроисхождения.Очистить();
	Для Каждого СтрокаЭД Из Контракт.ОбъектыЗакупки Цикл
		НоваяСтрока = Объект.ОбъектыЗакупки.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЭД);
		
		НоваяСтрока.ЕдиницаИзмерения = СтрокаЭД.ОКЕИ.Код;
		НоваяСтрока.ЕдиницаИзмеренияНаименование = СтрокаЭД.ОКЕИ.Наименование;
		
		Если СтрокаЭД.ЭтоЛекарственныйПрепарат Тогда
			Объект.ЕстьЛекарственныеПрепараты = Истина;
		КонецЕсли;
		
		Если СтрокаЭД.ЭтаРаботаИлиУслуга Тогда
			Объект.ЕстьРаботыИлиУслуги = Истина;
		Иначе
			Объект.ЕстьТовары = Истина;
		КонецЕсли;
		
		Если СтрокаЭД.Классификатор = ЭлектронноеАктированиеЕИС.КлассификаторКТРУ() Тогда
			НоваяСтрока.КодТовараДляЕИС = СтрокаЭД.КТРУ.Код;
		ИначеЕсли СтрокаЭД.Классификатор = ЭлектронноеАктированиеЕИС.КлассификаторОКПД2() Тогда
			НоваяСтрока.КодТовараДляЕИС = СтрокаЭД.ОКПД2.Код;
		ИначеЕсли СтрокаЭД.Классификатор = ЭлектронноеАктированиеЕИС.КлассификаторОКПД() Тогда
			НоваяСтрока.КодТовараДляЕИС = СтрокаЭД.ОКПД.Код;
		КонецЕсли;
		
		НоваяСтрока.ЭтоПриобретениеЖилыхПомещений = ЭлектронноеАктированиеЕИС.ЭтоКодТовараПоПриобретениюЖилыхПомещений(
			НоваяСтрока.КодТовараДляЕИС);
		
		КодПоСправочникуЛП = "";
		КодМНН = "";
		Если СтрокаЭД.СведенияОЛекарственномПрепарате <> Неопределено Тогда
			Если СтрокаЭД.СведенияОЛекарственномПрепарате.СписокМНН.Количество() > 0 Тогда
				МНН = СтрокаЭД.СведенияОЛекарственномПрепарате.СписокМНН[0];
				КодМНН = МНН.КодМНН;
				Если МНН.ПозицииПоТорговомуНаименованиюЛП.Количество() > 0 Тогда
					ПозицияПоМНН = МНН.ПозицииПоТорговомуНаименованиюЛП[0];
					КодПоСправочникуЛП = ПозицияПоМНН.КодПоСправочникуЛП;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		НоваяСтрока.КодМНН = КодМНН;
		НоваяСтрока.КодПоСправочникуЛП = КодПоСправочникуЛП;
		
		НоваяСтрока.СтавкаНДС = ЭлектронноеАктированиеЕИС.СтавкаНДСОбъектаЗакупки(СтрокаЭД);
		НоваяСтрока.СуммаНДС = СтрокаЭД.СуммаНДС;

		// Расчет цены без НДС.
		// Цена без НДС рассчитывается с точностью для 11 знаков, в дальнейшем помещается в УПД.
		// В УПД помещается в СведТов/ЦенаТов.
		СтавкиНДС = Новый Соответствие;
		СтавкиНДС.Вставить("0", 0);
		СтавкиНДС.Вставить("10", 0.10);
		СтавкиНДС.Вставить("18", 0.18);
		СтавкиНДС.Вставить("20", 0.2);
		СтавкиНДС.Вставить("n", 0);
		Ставка = СтавкиНДС[СтрокаЭД.СтавкаНДС];
		Если Ставка = Неопределено Тогда
			Шаблон = НСтр("ru = 'Неизвестная ставка НДС в контракте: %1%%';
							|en = 'Unknown VAT rate in the contract: %1%%'");
			ОписаниеОшибки = СтрШаблон(Шаблон, СтрокаЭД.СтавкаНДС);
			ВызватьИсключение(ОписаниеОшибки);
		КонецЕсли;
		
		НоваяСтрока.ЦенаЗаЕдиницуИзмерения =
			Окр(НоваяСтрока.Цена / (1 + Ставка), 11);

		НоваяСтрока.Тип = СтрокаЭД.Тип;
		НоваяСтрока.ЭтоРаботаИлиУслуга = НоваяСтрока.Тип = Перечисления.ТипыОбъектовЗакупкиЕИС.Работа
			ИЛИ НоваяСтрока.Тип = Перечисления.ТипыОбъектовЗакупкиЕИС.Услуга;
			
		Для Каждого Страна Из СтрокаЭД.СтраныПроисхождения Цикл
			ДанныеСтраны = УправлениеКонтактнойИнформацией.
				ДанныеКлассификатораСтранМираПоКоду(Страна.Код);
			Если ДанныеСтраны = Неопределено Тогда
				ДанныеСтраны= Новый Структура;
				ДанныеСтраны.Вставить("Код", Страна.Код);
				ДанныеСтраны.Вставить("Наименование", Страна.ПолноеНаименование);
				ДанныеСтраны.Вставить("НаименованиеПолное", Страна.ПолноеНаименование);
			КонецЕсли;
			СтранаМира = УправлениеКонтактнойИнформацией.
				СтранаМираПоКодуИлиНаименованию(Страна.Код, ДанныеСтраны);
			СтрокаСтраны = Объект.СтраныПроисхождения.Добавить();
			СтрокаСтраны.Страна = СтранаМира;
			СтрокаСтраны.ИдентификаторСтроки = НоваяСтрока.Идентификатор;
		КонецЦикла;
		
		Если СтрокаЭД.СтраныПроисхождения.Количество() > 0 Тогда
			Страна = УправлениеКонтактнойИнформацией.СтранаМираПоКодуИлиНаименованию(
						СтрокаЭД.СтраныПроисхождения[0].Код);
			НоваяСтрока.СтранаПроизводителя = Страна;
			НоваяСтрока.СтранаПроисхождения = Страна;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

	
//+РС Консалт Назаров М.Ю. 27.01.2023 13:52:00
// Заполнение  гос. контратка но без перезаполнения номенклатуры объектов закупки

// Заполнить из данных контракта.
// 
// Параметры:
//  Контракт - Структура - данные контракта, тип описан в ЭлектронноеАктированиеЕИС.НовыеДанныеКонтракта
//  Объект - СправочникСсылка.ГосударственныеКонтрактыЕИС
Процедура РС_ЗаполнитьИзДанныхКонтракта(Контракт, Объект) Экспорт
	
	Объект.РеестровыйНомерКонтракта = Контракт.НомерРеестровойЗаписи;
	Объект.НомерИГК = Контракт.ИГК;
	Объект.ВнутреннийИдентификаторЕИС = Контракт.Идентификатор;
	Объект.ИдентификационныйКодЗакупки = Контракт.ИдентификационныйКодЗакупки;
	Если НЕ ЗначениеЗаполнено(Контракт.НомерКонтракта) Тогда
		Объект.Номер = "б/н";
	Иначе
		Объект.Номер = Контракт.НомерКонтракта;
	КонецЕсли;
	
	// Заполнение номера ИГК.
	Если Контракт.ТребуетсяКазначейскоеСопровождение
		И НЕ ЗначениеЗаполнено(Контракт.ИГК) Тогда
			
		РезультатПолучения = ЭлектронноеАктированиеЕИС.СведенияОКонтрактеПоставщика(
			Объект.Организация, Контракт.НомерРеестровойЗаписи);
			
		Если НЕ РезультатПолучения.Выполнено Тогда
			Шаблон = НСтр("ru = 'Ошибка при получении данных контракта %1 в ЛК ЕИС: %2';
							|en = 'An error occurred when receiving the %1 contract data in the personal UIS account: %2'");
			ОписаниеОшибки = СтрШаблон(Шаблон,
				Контракт.НомерРеестровойЗаписи,
				РезультатПолучения.ОписаниеОшибки);
			ВызватьИсключение(ОписаниеОшибки);
		КонецЕсли;
		
		Если РезультатПолучения.Контракты.Количество() = 0 Тогда
			Шаблон = НСтр("ru = 'Данные контракта %1 не найдены в ЛК ЕИС.';
							|en = '%1 contract data is not found in the personal UIS account.'");
			ОписаниеОшибки = СтрШаблон(Шаблон, Контракт.НомерРеестровойЗаписи);
			ВызватьИсключение(ОписаниеОшибки);
		КонецЕсли;
		
		СодержимоеКонтракта = РезультатПолучения.Контракты[0];
		
		Объект.НомерИГК = СодержимоеКонтракта.ИГК;
		
	КонецЕсли;
		
	Объект.ДатаЗаключенияКонтракта = Контракт.ДатаЗаключенияКонтракта;
	Объект.ЕстьАвансы = Контракт.ЕстьАвансовыеПлатежиПоКонтракту;
	Объект.ЕстьАвансыПоЭтапам = Контракт.ЕстьАвансовыеПлатежиПоЭтапам;
	Объект.ПредметОтноситсяКРаботамПоСтроительству = Контракт.ПредметОтноситсяКРаботамПоСтроительству;
	Объект.Наименование =
		ЭлектронноеАктированиеЕИС.НаименованиеЭлементаСправочникаГосконтрактов(Объект);
	Объект.Статус = Контракт.ТекущееСостояние;
	Объект.ТребуетсяБанковскоеСопровождение = Контракт.ТребуетсяБанковскоеСопровождение;
	Объект.ТребуетсяКазначейскоеСопровождение = Контракт.ТребуетсяКазначейскоеСопровождение;
	Объект.ТипНаправленияДеятельности = ?(Контракт.ЭтоГОЗ,
											Перечисления.ТипыНаправленийДеятельности.КонтрактГОЗ,
											Перечисления.ТипыНаправленийДеятельности.ГосударственныйКонтракт);
	Объект.НомерГОЗ = Контракт.НомерКонтрактаГОЗ;
	Объект.ПредметКонтракта = Контракт.ПредметКонтракта;
	
	Если ЗначениеЗаполнено(Контракт.ИдентификаторУчастникаДокументооборотаЗаказчика) Тогда
		Объект.ИдентификаторУчастникаДокументооборотаЗаказчика =
			Контракт.ИдентификаторУчастникаДокументооборотаЗаказчика;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		ДанныеКонтрагента = СведенияОКонтрагентеИзСведенийОКонтракте(Контракт);
		Объект.Контрагент = ЭлектронноеАктированиеЕИС.
			НайтиСоздатьКонтрагентаПоСведениямОЗаказчике(ДанныеКонтрагента);
	КонецЕсли;
	Объект.ПолноеНаименованиеЗаказчика =
		Контракт.СведенияОЗаказчике.КодыОрганизации.ПолноеНаименование;
	Объект.ИННЗаказчика = Контракт.СведенияОЗаказчике.ИНН;
	Объект.КППЗаказчика = Контракт.СведенияОЗаказчике.КПП;
	Объект.ЕстьЛекарственныеПрепараты = Ложь;
	Объект.ЕстьРаботыИлиУслуги = Ложь;
	Объект.ЕстьТовары = Ложь;
	Объект.УказанаМаксимальнаяЦена = Контракт.УказанаМаксимальнаяЦена;
	Объект.НевозможноУказатьКоличество = Контракт.НевозможноУказатьКоличество;
	Объект.ФормулаЦены = Контракт.ИнформацияОЦенах.ФормулаЦены;
	
	РС_ЗаполнитьОбъектыЗакупки(Контракт, Объект);// перезаполняем все кроме НоменклатураОбъектовЗакупки, чтобы не слетело сопоставление
	
	КоличествоСтрок = Объект.ОбъектыЗакупки.Количество();
	Если КоличествоСтрок <> 0 Тогда
		Объект.ЕстьПриобретениеЖилыхПомещений =
			Объект.ОбъектыЗакупки.Итог("ЭтоПриобретениеЖилыхПомещений") = КоличествоСтрок;
	КонецЕсли;
		
	Объект.ЭтапыИсполнения.Очистить();
	Для каждого Этап Из Контракт.ЭтапыИсполнения Цикл
		Строка = Объект.ЭтапыИсполнения.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, Этап);
	КонецЦикла;
	
	Если Контракт.СведенияОПоставщиках.Количество() > 0 Тогда
		ДанныеПоставщика = Контракт.СведенияОПоставщиках[0];
		Объект.ПолноеНаименованиеПоставщика = ДанныеПоставщика.ПолноеНаименование;
		Объект.ИННПоставщика = ДанныеПоставщика.ИНН;
		Объект.КПППоставщика = ДанныеПоставщика.КПП;
	Иначе
		Настройки = ЭлектронноеАктированиеЕИС.НастройкиОбменаЕИС(Объект.Организация);
		Если ЗначениеЗаполнено(Настройки) Тогда
			Объект.ПолноеНаименованиеПоставщика = Настройки.НаименованиеОрганизации;
		КонецЕсли;
	КонецЕсли;  
	
	Объект.ДатаЗаключения = Объект.ДатаЗаключенияКонтракта;	
	Объект.ГодЗаключения = Год(Объект.ДатаЗаключенияКонтракта);
	Объект.ГодОкончанияСрокаДействия = Год(Контракт.ДатаОкончанияИсполнения);
	
КонецПроцедуры
//-РС Консалт Назаров М.Ю. 27.01.2023 13:52:00
	
&ИзменениеИКонтроль("ЗаполнитьНоменклатуруКонтракта")
Процедура РСК_ЗаполнитьНоменклатуруКонтракта(Контракт, Объект)

	Если ТипЗнч(Объект) = Тип("ДанныеФормыСтруктура") Тогда
		ТаблицаНоменклатуры = Объект.НоменклатураОбъектовЗакупки.Выгрузить();
		ТаблицаНоменклатуры.Очистить();
	Иначе
		ТаблицаНоменклатуры = Объект.НоменклатураОбъектовЗакупки.ВыгрузитьКолонки();
	КонецЕсли;
	ТаблицаНоменклатуры.Колонки.Добавить("ИД", ОбщегоНазначения.ОписаниеТипаСтрока(300));
		
	Объект.НоменклатураОбъектовЗакупки.Очистить();
	Объект.ОбъектыЗакупки.Очистить();
	Объект.СтраныПроисхождения.Очистить();
	Для Каждого СтрокаЭД Из Контракт.ОбъектыЗакупки Цикл
		НоваяСтрока = Объект.ОбъектыЗакупки.Добавить();
		НоваяСтрокаНоменклатура = ТаблицаНоменклатуры.Добавить();
		НоваяСтрокаНоменклатура.Идентификатор = СтрокаЭД.Идентификатор;
		НоваяСтрокаНоменклатура.Количество = СтрокаЭД.Количество;
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЭД);
		
		НоваяСтрока.ЕдиницаИзмерения = СтрокаЭД.ОКЕИ.Код;
		НоваяСтрока.ЕдиницаИзмеренияНаименование = СтрокаЭД.ОКЕИ.Наименование;
		
		Если СтрокаЭД.ЭтоЛекарственныйПрепарат Тогда
			Объект.ЕстьЛекарственныеПрепараты = Истина;
		КонецЕсли;
		
		Если СтрокаЭД.ЭтаРаботаИлиУслуга Тогда
			Объект.ЕстьРаботыИлиУслуги = Истина;
		Иначе
			Объект.ЕстьТовары = Истина;
		КонецЕсли;
		
		Если СтрокаЭД.Классификатор = ЭлектронноеАктированиеЕИС.КлассификаторКТРУ() Тогда
			НоваяСтрока.КодТовараДляЕИС = СтрокаЭД.КТРУ.Код;
		ИначеЕсли СтрокаЭД.Классификатор = ЭлектронноеАктированиеЕИС.КлассификаторОКПД2() Тогда
			НоваяСтрока.КодТовараДляЕИС = СтрокаЭД.ОКПД2.Код;
		ИначеЕсли СтрокаЭД.Классификатор = ЭлектронноеАктированиеЕИС.КлассификаторОКПД() Тогда
			НоваяСтрока.КодТовараДляЕИС = СтрокаЭД.ОКПД.Код;
		КонецЕсли;
		
		НоваяСтрока.ЭтоПриобретениеЖилыхПомещений = ЭлектронноеАктированиеЕИС.ЭтоКодТовараПоПриобретениюЖилыхПомещений(
			НоваяСтрока.КодТовараДляЕИС);
		
		КодПоСправочникуЛП = "";
		КодМНН = "";
		Если СтрокаЭД.СведенияОЛекарственномПрепарате <> Неопределено Тогда
			Если СтрокаЭД.СведенияОЛекарственномПрепарате.СписокМНН.Количество() > 0 Тогда
				МНН = СтрокаЭД.СведенияОЛекарственномПрепарате.СписокМНН[0];
				КодМНН = МНН.КодМНН;
				Если МНН.ПозицииПоТорговомуНаименованиюЛП.Количество() > 0 Тогда
					ПозицияПоМНН = МНН.ПозицииПоТорговомуНаименованиюЛП[0];
					КодПоСправочникуЛП = ПозицияПоМНН.КодПоСправочникуЛП;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		НоваяСтрока.КодМНН = КодМНН;
		НоваяСтрока.КодПоСправочникуЛП = КодПоСправочникуЛП;
		
		НоваяСтрока.СтавкаНДС = ЭлектронноеАктированиеЕИС.СтавкаНДСОбъектаЗакупки(СтрокаЭД);
		НоваяСтрока.СуммаНДС = СтрокаЭД.СуммаНДС;

		// Расчет цены без НДС.
		// Цена без НДС рассчитывается с точностью для 11 знаков, в дальнейшем помещается в УПД.
		// В УПД помещается в СведТов/ЦенаТов.
		СтавкиНДС = Новый Соответствие;
		СтавкиНДС.Вставить("0", 0);
		СтавкиНДС.Вставить("10", 0.10);
		СтавкиНДС.Вставить("18", 0.18);
		СтавкиНДС.Вставить("20", 0.2);
		СтавкиНДС.Вставить("n", 0);
		Ставка = СтавкиНДС[СтрокаЭД.СтавкаНДС];
		Если Ставка = Неопределено Тогда
			Шаблон = НСтр("ru = 'Неизвестная ставка НДС в контракте: %1%%';
							|en = 'Unknown VAT rate in the contract: %1%%'");
			ОписаниеОшибки = СтрШаблон(Шаблон, СтрокаЭД.СтавкаНДС);
			ВызватьИсключение(ОписаниеОшибки);
		КонецЕсли;
		
		НоваяСтрока.ЦенаЗаЕдиницуИзмерения =
			Окр(НоваяСтрока.Цена / (1 + Ставка), 11);

		НоваяСтрока.Тип = СтрокаЭД.Тип;
		НоваяСтрока.ЭтоРаботаИлиУслуга = НоваяСтрока.Тип = Перечисления.ТипыОбъектовЗакупкиЕИС.Работа
			ИЛИ НоваяСтрока.Тип = Перечисления.ТипыОбъектовЗакупкиЕИС.Услуга;
			
		Для Каждого Страна Из СтрокаЭД.СтраныПроисхождения Цикл
			ДанныеСтраны = УправлениеКонтактнойИнформацией.
				ДанныеКлассификатораСтранМираПоКоду(Страна.Код);
			Если ДанныеСтраны = Неопределено Тогда
				ДанныеСтраны= Новый Структура;
				ДанныеСтраны.Вставить("Код", Страна.Код);
				ДанныеСтраны.Вставить("Наименование", Страна.ПолноеНаименование);
				ДанныеСтраны.Вставить("НаименованиеПолное", Страна.ПолноеНаименование);
			КонецЕсли;
			СтранаМира = УправлениеКонтактнойИнформацией.
				СтранаМираПоКодуИлиНаименованию(Страна.Код, ДанныеСтраны);
			СтрокаСтраны = Объект.СтраныПроисхождения.Добавить();
			СтрокаСтраны.Страна = СтранаМира;
			СтрокаСтраны.ИдентификаторСтроки = НоваяСтрока.Идентификатор;
		КонецЦикла;
		
		Если СтрокаЭД.СтраныПроисхождения.Количество() > 0 Тогда
			Страна = УправлениеКонтактнойИнформацией.СтранаМираПоКодуИлиНаименованию(
						СтрокаЭД.СтраныПроисхождения[0].Код);
			НоваяСтрока.СтранаПроизводителя = Страна;
			НоваяСтрока.СтранаПроисхождения = Страна;
		КонецЕсли;
		
		НоваяСтрокаНоменклатура.ИД = ИдентификаторТовараПоСтроке(ВРег(СтрЗаменить(СтрокаЭД.Наименование, " ", ""))
		+ "#" + ВРег(СтрЗаменить(СтрокаЭД.ОКПД2.Код, " ", ""))
		+ "#" + ВРег(СтрЗаменить(СтрокаЭД.КТРУ.Код, " ", ""))
		+ "#" + ВРег(СтрЗаменить(СтрокаЭД.КодМедицинскогоИзделия, " ", ""))
		+ "#" + ВРег(СтрЗаменить(КодМНН, " ", "")));
	КонецЦикла;
	
	Если ЭлектронноеАктированиеЕИС.СопоставлятьНоменклатуруКонтракта() Тогда
		Объект.НоменклатураОбъектовЗакупки.Очистить();
	Иначе
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТЗ.ИД КАК ИД,
	|	ТЗ.Идентификатор КАК Идентификатор,
	|	ТЗ.Количество КАК Количество
	|ПОМЕСТИТЬ ВТ_ТЗ
	|ИЗ
	|	&ТЗ КАК ТЗ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НоменклатураКонтрагентовБЭД.Номенклатура КАК Номенклатура,
	|	НоменклатураКонтрагентовБЭД.Ссылка КАК НоменклатураПартнера,
	|	ВТ_ТЗ.Идентификатор КАК Идентификатор,
	|	ВТ_ТЗ.Количество КАК Количество,
	|	НоменклатураКонтрагентовБЭД.Характеристика КАК Характеристика,
	|	НоменклатураКонтрагентовБЭД.Упаковка КАК Упаковка
	|ИЗ
	|	ВТ_ТЗ КАК ВТ_ТЗ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураКонтрагентов КАК НоменклатураКонтрагентовБЭД
	|		ПО (НоменклатураКонтрагентовБЭД.Владелец = &Владелец)
	|		И (НоменклатураКонтрагентовБЭД.Идентификатор = ВТ_ТЗ.ИД)";
	#Вставка
	//++ РС Консалт: Трофимов Евгений 22.09.2022 Тикет 20359
	//e1cib/data/Документ.Задание?ref=94e137c71231048947b8209affeeaed4
	//В типовом запросе не учитывается, что в базе могут быть задублированы идентификаторы.
	//Сделал игнорирование помеченных на удаление и сгруппировал.
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТЗ.ИД КАК ИД,
		|	ТЗ.Идентификатор КАК Идентификатор,
		|	ТЗ.Количество КАК Количество
		|ПОМЕСТИТЬ ВТ_ТЗ
		|ИЗ
		|	&ТЗ КАК ТЗ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(НоменклатураКонтрагентовБЭД.Номенклатура) КАК Номенклатура,
		|	МАКСИМУМ(НоменклатураКонтрагентовБЭД.Ссылка) КАК НоменклатураПартнера,
		|	ВТ_ТЗ.Идентификатор КАК Идентификатор,
		|	ВТ_ТЗ.Количество КАК Количество,
		|	МАКСИМУМ(НоменклатураКонтрагентовБЭД.Характеристика) КАК Характеристика,
		|	МАКСИМУМ(НоменклатураКонтрагентовБЭД.Упаковка) КАК Упаковка
		|ИЗ
		|	ВТ_ТЗ КАК ВТ_ТЗ
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураКонтрагентов КАК НоменклатураКонтрагентовБЭД
		|		ПО (НоменклатураКонтрагентовБЭД.Владелец = &Владелец)
		|			И ВТ_ТЗ.ИД = НоменклатураКонтрагентовБЭД.Идентификатор
		|			И (НЕ НоменклатураКонтрагентовБЭД.ПометкаУдаления)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ТЗ.Идентификатор,
		|	ВТ_ТЗ.Количество
		|";
	//-- КонецТикета 20359	
	#КонецВставки
	
	Запрос.УстановитьПараметр("ТЗ", ТаблицаНоменклатуры);
	Запрос.УстановитьПараметр("Владелец", Объект.Контрагент.Партнер);
	
	Объект.НоменклатураОбъектовЗакупки.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&После("ЗаполнитьИзДанныхКонтракта")
Процедура РСК_ЗаполнитьИзДанныхКонтракта(Контракт, Объект)
	
	//+РС Консалт Назаров М.Ю. 10.02.2023 11:52:01
	Объект.ДатаЗаключения = Объект.ДатаЗаключенияКонтракта;	
	Объект.ГодЗаключения = Год(Объект.ДатаЗаключенияКонтракта);
	Объект.ГодОкончанияСрокаДействия = Год(Контракт.ДатаОкончанияИсполнения);
	//-РС Консалт Назаров М.Ю. 10.02.2023 11:52:01
	
КонецПроцедуры
