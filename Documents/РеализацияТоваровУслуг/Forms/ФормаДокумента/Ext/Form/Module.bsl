﻿  
&НаСервере
&После("ПриСозданииНаСервере")
Процедура РСК_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//++ РС Консалт: Минаков А.С. Задача 20226
	НовыйЭлементГруппа = Элементы.Вставить("ГруппаВес", Тип("ГруппаФормы"), Элементы.ГруппаИтого, Элементы.ГруппаВсегоСкидка);
	НовыйЭлементГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	НовыйЭлементГруппа.ОтображатьЗаголовок = Ложь;
	
	НовыйЭлемент = Элементы.Добавить("РСК_Вес", Тип("ПолеФормы"), НовыйЭлементГруппа);	
	НовыйЭлемент.Заголовок = "Вес";
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "РСК_Вес";
	НовыйЭлемент.ТолькоПросмотр = Истина;
	НовыйЭлемент.Ширина = 12;
	НовыйЭлемент.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
	НовыйЭлемент.РастягиватьПоГоризонтали = Ложь;
	
	НовыйЭлементГруппа = Элементы.Вставить("ГруппаОбъем", Тип("ГруппаФормы"), Элементы.ГруппаИтого, НовыйЭлементГруппа);
	НовыйЭлементГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	НовыйЭлементГруппа.ОтображатьЗаголовок = Ложь;
	
	НовыйЭлемент = Элементы.Добавить("РСК_Кубатура", Тип("ПолеФормы"), НовыйЭлементГруппа);	
	НовыйЭлемент.Заголовок = "Объем";
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "РСК_Кубатура";
	НовыйЭлемент.ТолькоПросмотр = Истина;
	НовыйЭлемент.Ширина = 12;
	НовыйЭлемент.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
	НовыйЭлемент.РастягиватьПоГоризонтали = Ложь;
	//++ РС Консалт: Минаков А.С. Задача 20226
	
КонецПроцедуры

&НаСервере
&После("УстановитьВидимостьЭлементовПоОперацииСервер")
Процедура РСК_УстановитьВидимостьЭлементовПоОперацииСервер()
	
	//+РС Консалт Михайлов А.М. 4 июля 2022 г. 8:10:48  
	//возможность видимости для вида операции
	Если РеализацияЧерезКомиссионера Тогда
		МассивЭлементов = Новый Массив();
		МассивЭлементов.Добавить("ГруппаРеализацияПоЗаказам");
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Видимость", Истина);  
		
	КонецЕсли;
	//-РС Консалт Михайлов А.М. 4 июля 2022 г. 8:11:00
	
КонецПроцедуры

&НаКлиенте
Процедура РСК_ДоговорПриИзмененииПосле(Элемент)
	
	//++РС Консалт Назаров М.Ю. 26 июля 2022 г. 7:33:09                  
	Если Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионера") Тогда 
		Объект.КлиентДоговор = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Объект.Договор, "ДоговорСКомиссионером");
		КлиентДоговорПриИзменении(Элементы.КлиентДоговор);
	КонецЕсли;
	//--РС Консалт Назаров М.Ю. 26 июля 2022 г. 7:33:09
	
КонецПроцедуры

&НаКлиенте
&После("КлиентПартнерПриИзменении")
Процедура РСК_КлиентПартнерПриИзменении(Элемент)
	
	//++РС Консалт Назаров М.Ю. 26 июля 2022 г. 7:39:6 Установка договора комиссонера при смене договра с контрагента                 
	Если Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионера") Тогда 
		
		Если ЗначениеЗаполнено(Объект.Договор) Тогда 
			ДоговорСКомиссионером = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Объект.Договор, "ДоговорСКомиссионером");
			Если ЗначениеЗаполнено(ДоговорСКомиссионером) Тогда 
				Объект.КлиентДоговор = ДоговорСКомиссионером;
				КлиентДоговорПриИзменении(Элементы.КлиентДоговор);  
			КонецЕсли;
		КонецЕсли;            
		
	КонецЕсли;	
	//--РС Консалт Назаров М.Ю. 26 июля 2022 г. 7:39:06	
	
КонецПроцедуры

&НаСервере
&После("ПриЧтенииСозданииНаСервере")
Процедура РСК_ПриЧтенииСозданииНаСервере()
	
	//++РС Консалт Назаров М.Ю. 28 сентября 2022 г. 6:17:42                  
	УстановитьВидимостьЭлементовПоОперацииСервер();	
	//--РС Консалт Назаров М.Ю. 28 сентября 2022 г. 6:17:42
	
КонецПроцедуры

&НаСервере
&ИзменениеИКонтроль("ПриИзмененииПартнераСервер")
Процедура РСК_ПриИзмененииПартнераСервер()
	#Вставка
	//++РС Консалт Назаров М.Ю. 26 июля 2022 г. 7:10:07 Перезаполнение товаров при смене партнера                  
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияЧерезКомиссионера Тогда 
		КэшированныеТовары = Объект.Товары.Выгрузить();	
	КонецЕсли;
	//--РС Консалт Назаров М.Ю. 26 июля 2022 г. 7:10:07
	#КонецВставки

	МассивРеквизитов = Новый Массив;

	Если ИспользоватьСоглашенияСКлиентами Тогда
		ЗаполнитьУсловияПродаж();
		МассивРеквизитов.Добавить("Валюта");
		МассивРеквизитов.Добавить("ВалютаВзаиморасчетов");
		МассивРеквизитов.Добавить("Договор");
		МассивРеквизитов.Добавить("НаправлениеДеятельности");
		МассивРеквизитов.Добавить("Контрагент");
		МассивРеквизитов.Добавить("Организация");
		МассивРеквизитов.Добавить("Соглашение");
	Иначе
		ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Объект.Партнер, Объект.Контрагент);
		ИспользоватьДоговорыСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСКлиентами");
		Если ИспользоватьДоговорыСКлиентами Тогда
			ЗаполнитьДоговорПоУмолчанию();
		КонецЕсли;
	КонецЕсли;

	НоменклатураПартнеровСервер.ЗаполнитьНоменклатуруПартнераПоНоменклатуреПриИзмененииПартнера(Объект.Товары, Объект.Партнер);

	МассивРеквизитов.Добавить("Партнер");
	ВзаиморасчетыСервер.ФормаПриИзмененииРеквизитов(ЭтаФорма, МассивРеквизитов);

	УстановитьДоступностьЭлементовПоСтатусуСервер();

	СкладГруппа = ЭтоГруппаСкладовИСкладыИспользуютсяВТЧДокументовПродажи(Объект.Склад);
	СкладПриИзмененииСервер();
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();

	ПродажиСервер.УстановитьДоступностьДоговора(Объект, Элементы.Договор.Доступность, Элементы.ГруппаДоговор.Видимость, Объект.Договор);
	Элементы.ГруппаНадписьДоговор.Видимость = Элементы.ГруппаДоговор.Видимость;

	ОбновитьТекстДокументыНаОсновании();

	ЗаполнитьОснованиеДляПечати();

	Объект.БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Объект.Контрагент);
	ОбновитьДоступностьЭлементовВозвратнойТары(ЭтаФорма);

	ДоставкаТоваров.ЗаполнитьРеквизитыДоставки(Элементы, "Партнер", Объект);

	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	ПродажиСервер.ПартнерПриИзменении(Объект);
	ОтветственныеЛицаСервер.ЗаполнитьМенеджера(Объект);
	ЗаполнитьПодчиненныеСвойстваПоСтатистике("Контрагент");

	МногооборотнаяТараСервер.ОбновитьПризнакБезВозвратнойТары(Объект.Товары, Объект.ВернутьМногооборотнуюТару);
	ОбщегоНазначенияУТ.ЗаполнитьДубликатыЗависимыхРеквизитовВКоллекции(Объект.Товары, ЗависимыеРеквизиты());
	ПересчитатьСуммуСверхЗаказа();
	РассчитатьИтоговыеПоказатели();

	УстановитьВидимостьЗапретаОтгрузкиПартнеру();

	Если ИспользоватьНаправленияДеятельности Тогда
		НаправленияДеятельностиСервер.ЗаполнитьНаправлениеПоУмолчанию(Объект.НаправлениеДеятельности, Объект.Соглашение, Объект.Договор);
	КонецЕсли;
	НаправленияДеятельностиСервер.ПриИзмененииНаправленияДеятельности(ЭтотОбъект);
	#Вставка
	//++РС Консалт Назаров М.Ю. 26 июля 2022 г. 7:10:56                  
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияЧерезКомиссионера Тогда 
		Объект.Товары.Загрузить(КэшированныеТовары);	
	КонецЕсли;
	//--РС Консалт Назаров М.Ю. 26 июля 2022 г. 7:10:56
	#КонецВставки

	ФормированиеФискальныхЧековСервер.ФормаПриИзмененииРеквизитов(ЭтотОбъект);


	// ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС
	ЭлектронноеАктированиеЕИСУТ.ДоговорПриИзмененииЭлектронноеАктированиеЕИС(ЭтотОбъект, Объект);
	// Конец ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС


КонецПроцедуры

&НаСервере
&ИзменениеИКонтроль("ДоговорПриИзмененииСервер")
Процедура РСК_ДоговорПриИзмененииСервер() 
	#Вставка
	//++РС Консалт Назаров М.Ю. 26 июля 2022 г. 7:03:03 Перезаполнение товаров при смене договора   
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияЧерезКомиссионера Тогда 
		КэшированныеТовары = Объект.Товары.Выгрузить();	                                                                     
	КонецЕсли;
	//--РС Консалт Назаров М.Ю. 26 июля 2022 г. 7:03:03
	#КонецВставки

	ПродажиСервер.ЗаполнитьБанковскиеСчетаПоДоговору(Объект.Договор, Объект.БанковскийСчетОрганизации, Объект.БанковскийСчетКонтрагента);
	ОтветственныеЛицаСервер.ЗаполнитьМенеджера(Объект);
	ЗаполнитьПодчиненныеСвойстваПоСтатистике("Договор");

	Если ИспользоватьНаправленияДеятельности Тогда
		НаправленияДеятельностиСервер.ЗаполнитьНаправлениеПоУмолчанию(Объект.НаправлениеДеятельности, Объект.Соглашение, Объект.Договор);
	КонецЕсли;
	НаправленияДеятельностиСервер.ПриИзмененииНаправленияДеятельности(ЭтотОбъект);

	ЗаполнитьДоговорКонечногоКлиентаПоУмолчанию();

	ЗаполнитьНалогообложениеНДСПродажи();
	НалогообложениеНДСПриИзмененииСервер();
	ВзаиморасчетыСервер.ФормаПриИзмененииРеквизитов(ЭтаФорма, "Договор");
	ЗаполнитьОснованиеДляПечати();
	Объект.ВариантВыбытияМаркируемойПродукции = Объект.Договор.ВариантВыбытияМаркируемойПродукции;
	#Вставка     
	//++РС Консалт Назаров М.Ю. 26 июля 2022 г. 7:03:23                  
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияЧерезКомиссионера Тогда 
		Если Объект.Товары.Количество() = 0 Тогда 
			Объект.Товары.Загрузить(КэшированныеТовары);            
		КонецЕсли; 
	КонецЕсли;
	//--РС Консалт Назаров М.Ю. 26 июля 2022 г. 7:03:23
	#КонецВставки

	УстановитьДоступностьВидимостьЭлементовСборкиИДоставки();

	УстановитьВидимостьКомандыЗаполненияВидаЦенПоДоговору();


	// ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС
	ЭлектронноеАктированиеЕИСУТ.ДоговорПриИзмененииЭлектронноеАктированиеЕИС(ЭтотОбъект, Объект);
	// Конец ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС


	ПриИзмененииКлючевыхРеквизитовСостояниеЭДО();

КонецПроцедуры

&НаСервере
&После("РассчитатьИтоговыеПоказатели")
Процедура РСК_РассчитатьИтоговыеПоказатели()
	
	//++ РС Консалт: Минаков А.С. Задача 20226
	РСК_РассчитатьВГХ()
	//++ РС Консалт: Минаков А.С. Задача 20226
		
КонецПроцедуры

&НаСервере
Процедура РСК_РассчитатьВГХ() 
	
	//++ РС Консалт: Минаков А.С. Задача 20226
	Запрос = Новый Запрос(	
	"ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ТаблицаТовары.Упаковка КАК Упаковка,
	|	ТаблицаТовары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК ПустаяУпаковка
	|ПОМЕСТИТЬ ВтТаблицаТовары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВтТаблицаТовары.КоличествоУпаковок * ЕСТЬNULL(ВЫБОР
	|				КОГДА ВтТаблицаТовары.ПустаяУпаковка
	|					ТОГДА ШтучныйВесОбъем.Вес
	|				ИНАЧЕ УпаковкиЕдиницыИзмерения.Вес
	|			КОНЕЦ, 0)) КАК Вес,
	|	СУММА(ВтТаблицаТовары.КоличествоУпаковок * ЕСТЬNULL(ВЫБОР
	|				КОГДА ВтТаблицаТовары.ПустаяУпаковка
	|					ТОГДА ШтучныйВесОбъем.Объем
	|				ИНАЧЕ УпаковкиЕдиницыИзмерения.Объем
	|			КОНЕЦ, 0)) КАК Объем
	|ИЗ
	|	ВтТаблицаТовары КАК ВтТаблицаТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
	|		ПО ВтТаблицаТовары.Упаковка = УпаковкиЕдиницыИзмерения.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			Упаковки.Владелец КАК Номенклатура,
	|			МИНИМУМ(Упаковки.Вес) КАК Вес,
	|			МИНИМУМ(Упаковки.Объем) КАК Объем
	|		ИЗ
	|			Справочник.УпаковкиЕдиницыИзмерения КАК Упаковки
	|		ГДЕ
	|			Упаковки.Владелец В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						ВтТаблицаТовары.Номенклатура
	|					ИЗ
	|						ВтТаблицаТовары КАК ВтТаблицаТовары
	|					ГДЕ
	|						ВтТаблицаТовары.ПустаяУпаковка)
	|			И НЕ Упаковки.ПометкаУдаления
	|			И Упаковки.Числитель = 1
	|			И Упаковки.Знаменатель = 1
	|		
	|		СГРУППИРОВАТЬ ПО
	|			Упаковки.Владелец) КАК ШтучныйВесОбъем
	|		ПО ВтТаблицаТовары.Номенклатура = ШтучныйВесОбъем.Номенклатура");
	
	Запрос.УстановитьПараметр("ТаблицаТовары", Объект.Товары.Выгрузить(, "Номенклатура,КоличествоУпаковок,Упаковка"));
	
	ВыборкаВГХ = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаВГХ.Следующий() Тогда
		РСК_Вес = ВыборкаВГХ.Вес;
		РСК_Кубатура = ВыборкаВГХ.Объем
	Иначе
		РСК_Вес = 0;
		РСК_Кубатура = 0
	КонецЕсли
	//++ РС Консалт: Минаков А.С. Задача 20226
	
КонецПроцедуры


&НаКлиенте
Процедура РСК_РС_ПрикрепитьПриложенияЕИСПосле(Команда)
	
	//+РС Консалт Назаров М.Ю. 02.12.2022 8:29:12  
	// Стандартная функция прикрепления файлов при выгрузке в ЕИС
	ЭлектронноеАктированиеЕИСКлиент.ОткрытьСписокПриложенныхФайловДокумента(Объект.Ссылка, ЭтотОбъект);
	//-РС Консалт Назаров М.Ю. 02.12.2022 8:29:12
	
КонецПроцедуры

&НаКлиенте
&После("РеализацияПоЗаказамПриИзмененииЗавершение")
Процедура РСК_РеализацияПоЗаказамПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) 
	РСК_Менеджер();
	// Вставить содержимое метода.
КонецПроцедуры

&НаСервере
Процедура РСК_Менеджер()
	ОтветственныеЛицаСервер.ЗаполнитьМенеджера(Объект);
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 08.02.2023 Тикет 23696
//e1cib/data/Документ.Задание?ref=839a72ccbc41c5584759b4b724f8b01a
&НаКлиенте
Процедура ОбновитьВидимостьЭлементовТабличнойЧастиТовары() Экспорт
	
	ё=0;
	Для Каждого Стр Из Объект.Товары Цикл
		ё=ё+1;
		Состояние("Пересчёт...",ё*100/Объект.Товары.Количество(),""+ё+" из "+Объект.Товары.Количество());
		ТекущаяСтрока = Элементы.Товары.ДанныеСтроки(Стр.ПолучитьИдентификатор());
		
		#Область КодПроцедуры_ТоварыНоменклатураПриИзменении
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
		СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
		СтруктураДействий.Вставить("ПроверитьЗаполнитьСклад", ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруЗаполненияСкладаВСтрокеТЧ(Объект, СкладГруппа));
		
		//Если (ИспользоватьСоглашенияСКлиентами И ЗначениеЗаполнено(Объект.Соглашение)) 
		//	Или (Не ИспользоватьСоглашенияСКлиентами И ИспользуетсяЦенообразование25) Тогда
		//	СтруктураДействий.Вставить("ЗаполнитьУсловияПродаж", ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруЗаполненияУсловийПродажВСтрокеТЧ(Объект));
		//Иначе
		//	СтруктураДействий.Вставить("ЗаполнитьЦенуПродажи", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияЦеныВСтрокеТЧ(Объект));
		//КонецЕсли;
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(Объект));
		СтруктураДействий.Вставить("ЗаполнитьКодТНВЭД", Объект.НалогообложениеНДС);
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДСВозвратнойТары", Объект.ВернутьМногооборотнуюТару);
		СтруктураДействий.Вставить("ЗаполнитьПризнакБезВозвратнойТары", Объект.ВернутьМногооборотнуюТару);
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
		СтруктураДействий.Вставить("ПересчитатьСумму");
		СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомРучнойСкидки", Новый Структура("Очищать", Истина));
		СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомАвтоматическойСкидки", Новый Структура("Очищать", Истина));
		СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомСкидкиБонуснымиБаллами");
		СтруктураДействий.Вставить("ОчиститьСуммуВзаиморасчетов");
		СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
		СтруктураДействий.Вставить("ЗаполнитьДубликатыЗависимыхРеквизитов", ЗависимыеРеквизиты());
		СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
		СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("Склад, ПараметрыУказанияСерий", ТекущаяСтрока.Склад, ПараметрыУказанияСерий));
		СтруктураДействий.Вставить("ПересчитатьСуммуСверхЗаказа", Новый Структура("РеализацияПоступлениеПоЗаказу, ТребуетсяЗалогЗаТару",
			Объект.РеализацияПоЗаказам, Объект.ТребуетсяЗалогЗаТару));
		СтруктураДействий.Вставить("ПриИзмененииТипаНоменклатуры", Новый Структура("ЕстьРаботы, ЕстьОтменено", Истина, Ложь));
		НаправленияДеятельностиКлиентСервер.СтруктураДействийВставитьПриДобавленииСтроки(ЭтаФорма, СтруктураДействий);
		
		ОбработкаТабличнойЧастиКлиентСерверЛокализация.ДополнитьСтруктуруДействийПриИзмененииЭлемента(ЭтотОбъект, "Номенклатура", СтруктураДействий);
		УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ДополнитьОписаниеНастроекЗаполненияСлужебныхРеквизитовТабличнойЧасти(СтруктураДействий);
		
		СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
			ЭтаФорма.ИмяФормы, "Товары"));
			
		СтруктураДействий.Вставить("ЗаполнитьПодразделениеВСтрокеТЧ", Новый Структура("Подразделение", Объект.Подразделение));
		
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		
		РассчитатьИтоговыеПоказатели();
		СкидкиНаценкиЗаполнениеКлиент.СброситьФлагСкидкиРассчитаны(ЭтаФорма);
		УстановитьПризнакЗаполненияСклада();		
		#КонецОбласти
		
	КонецЦикла;
КонецПроцедуры // ОбновитьВидимостьЭлементовТабличнойЧасти()



