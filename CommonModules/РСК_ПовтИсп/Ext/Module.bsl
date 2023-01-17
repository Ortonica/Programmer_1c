﻿// Возвращает колонку загрузки ТСР в виде ссылки на элемент справочника РСК_КолонкиИмпорта 
// РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
//
// Параметры:
//  ПредопределённоеИмя	 - Строка - 
// 
Функция ПолучитьКолонкуЗагрузкиТСР(ПредопределённоеИмя = "") Экспорт

	Если ПустаяСтрока(ПредопределённоеИмя) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РСК_КолонкиИмпорта.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.РСК_КолонкиИмпорта КАК РСК_КолонкиИмпорта
		|ГДЕ
		|	РСК_КолонкиИмпорта.ПредопределённоеИмя = &ПредопределённоеИмя";
	
	Запрос.УстановитьПараметр("ПредопределённоеИмя", ПредопределённоеИмя);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Ссылка;
	КонецЦикла;
	
КонецФункции

// РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
Функция ПолучитьПартнёра_Реамед() Экспорт

	Возврат Справочники.Партнеры.ПолучитьСсылку(Новый УникальныйИдентификатор("f33f8ce2-5b91-11e4-8049-080027009417"));

КонецФункции // ПолучитьПартнёра_Реамед()

// РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
Функция Получить_Справочники_ВидыКонтактнойИнформации_ПоИдентификатору(ИдентификаторДляФормул) Экспорт
	//Код создан генератором: https://infostart.ru/public/1482423/
	
	Спр = Справочники.ВидыКонтактнойИнформации.НайтиПоРеквизиту("ИдентификаторДляФормул", ИдентификаторДляФормул);
	     
	Если НЕ ЗначениеЗаполнено(Спр) Тогда
		оСпр = Справочники.ВидыКонтактнойИнформации.СоздатьЭлемент();
		оСпр.Наименование = ИдентификаторДляФормул;
		
		оСпр.Родитель = Справочники.ВидыКонтактнойИнформации.СправочникПартнеры;
		оСпр.ВидРедактирования = "ПолеВводаИДиалог";
		оСпр.Используется = Истина;
		оСпр.МожноИзменятьСпособРедактирования = Истина;
		оСпр.ПроверятьПоФИАС = Истина;
		оСпр.РеквизитДопУпорядочивания = 9;
		оСпр.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
		оСпр.ИмяГруппы = "СправочникПартнеры";
		оСпр.ИдентификаторДляФормул = ИдентификаторДляФормул;

		оСпр.Записать();
		Спр = оСпр.Ссылка;
	КонецЕсли;
	
	Возврат Спр;

КонецФункции

// РС Консалт: Трофимов Евгений 05.07.2022 Выдача ТСР
Функция Получить_Справочники_ВидыКонтактнойИнформации_АдресКонтактногоЛица() Экспорт
	//Код создан генератором: https://infostart.ru/public/1482423/
	
	ИдентификаторДляФормул = "АдресКонтактногоЛица";
	Спр = Справочники.ВидыКонтактнойИнформации.НайтиПоРеквизиту("ИдентификаторДляФормул", ИдентификаторДляФормул);
	     
	Если НЕ ЗначениеЗаполнено(Спр) Тогда
		оСпр = Справочники.ВидыКонтактнойИнформации.СоздатьЭлемент();
		оСпр.Наименование = "Адрес";
		
		оСпр.Родитель = Справочники.ВидыКонтактнойИнформации.СправочникКонтактныеЛицаПартнеров;
		оСпр.ВидРедактирования = "ПолеВводаИДиалог";
		оСпр.ВидПоляДругое = "МногострочноеШирокое";
		оСпр.Используется = Истина;
		оСпр.МожноИзменятьСпособРедактирования = Истина;
		оСпр.РеквизитДопУпорядочивания = 12;
		оСпр.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
		оСпр.ИмяГруппы = "СправочникКонтактныеЛицаПартнеров";
		оСпр.ИдентификаторДляФормул = ИдентификаторДляФормул;

		оСпр.Записать();
		Спр = оСпр.Ссылка;
	КонецЕсли;
	
	Возврат Спр;

КонецФункции

//++ РС Консалт: Трофимов Евгений 25.07.2022 Задача 19001 Выдача ТСР
//e1cib/data/Документ.Задание?ref=96dd9eec45a943c14094b81302446221
Функция Получить_ПланыВидовХарактеристик_ДопСведение_Номер_филиала() Экспорт
	//Код создан генератором: https://infostart.ru/public/1482423/
	
	Имя = "НомерФилиала";
	Спр = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("Имя", Имя);
	     
	Если НЕ ЗначениеЗаполнено(Спр) Тогда
		оСпр = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.СоздатьЭлемент();
		оСпр.Наименование = "Номер филиала";
		
		оСпр.ТипЗначения = Новый ОписаниеТипов("Строка");
		оСпр.Виден = Истина;
		оСпр.Доступен = Истина;
		оСпр.Заголовок = "Номер филиала";
		оСпр.Имя = "НомерФилиала";
		оСпр.Подсказка = "Используется в печатных формах Отчёт о выдаче ТСР";
		оСпр.ЭтоДополнительноеСведение = Истина;
		оСпр.НаборСвойств = Справочники.НаборыДополнительныхРеквизитовИСведений.НайтиПоРеквизиту("ИмяПредопределенногоНабора", "Справочник_Партнеры_Общие");
		оСпр.ИдентификаторДляФормул = "НомерФилиала";

		оСпр.Записать();
		Спр = оСпр.Ссылка;
	КонецЕсли;
	
	Возврат Спр;

КонецФункции

//Используется в ПФ «Упаковочный лист»
//++ РС Консалт: Трофимов Евгений 17.08.2022 Задача 19406
//e1cib/data/Документ.Задание?ref=8801aed8a4c061714c61a3f05ae02271
Функция Получить_ПВХ_ДополнительныеРеквизитыИСведения_Наименование_для_печати_Англ() Экспорт
	//Код создан генератором: https://infostart.ru/public/1482423/
	УстановитьПривилегированныйРежим(Истина);
	Имя = "НаименованиеДляПечатиАнгл";
	Спр = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("Имя", Имя);
	     
	Если НЕ ЗначениеЗаполнено(Спр) Тогда
		оСпр = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.СоздатьЭлемент();
		оСпр.Наименование = "Наименование для печати (Англ.)";
		
		оСпр.ТипЗначения = Новый ОписаниеТипов("Строка");
		оСпр.Виден = Истина;
		оСпр.Доступен = Истина;
		оСпр.Заголовок = "Наименование для печати (Англ.)";
		оСпр.Имя = Имя;
		оСпр.НаборСвойств = Справочники.НаборыДополнительныхРеквизитовИСведений.ПолучитьСсылку(
			Новый УникальныйИдентификатор("b03509f2-680f-459b-ac16-d5a7c34ebfc6") //Общие
		);
		оСпр.ИдентификаторДляФормул = Имя;

		оСпр.Записать();
		Спр = оСпр.Ссылка;
		
		оНаборСвойств = оСпр.НаборСвойств.ПолучитьОбъект();
		НС = оНаборСвойств.ДополнительныеРеквизиты.Добавить();
		НС.Свойство = Спр;
		НС.ИмяПредопределенногоНабора = "Справочник_Номенклатура_Общие";
		оНаборСвойств.Записать();
		
	КонецЕсли;
	
	Возврат Спр;

КонецФункции

//Используется в ПФ «Проформа инвойс»
//++ РС Консалт: Трофимов Евгений 23.08.2022 Задача 19406
//e1cib/data/Документ.Задание?ref=8801aed8a4c061714c61a3f05ae02271
Функция Получить_ПВХ_ДополнительныеРеквизитыИСведения_ТекстовоеОписание_Англ() Экспорт
	//Код создан генератором: https://infostart.ru/public/1482423/
	
	УстановитьПривилегированныйРежим(Истина);
	
	Имя = "ТекстовоеОписаниеАнгл";
	Спр = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("Имя", Имя);
	     
	Если НЕ ЗначениеЗаполнено(Спр) Тогда
		оСпр = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.СоздатьЭлемент();
		оСпр.Наименование = "Текстовое описание (Англ.)";
		
		оСпр.ТипЗначения = Новый ОписаниеТипов("Строка");
		оСпр.Виден = Истина;
		оСпр.Доступен = Истина;
		оСпр.Заголовок = оСпр.Наименование;
		оСпр.Имя = Имя;
		оСпр.НаборСвойств = Справочники.НаборыДополнительныхРеквизитовИСведений.ПолучитьСсылку(
			Новый УникальныйИдентификатор("b03509f2-680f-459b-ac16-d5a7c34ebfc6") //Общие
		);
		оСпр.ИдентификаторДляФормул = Имя;

		оСпр.Записать();
		Спр = оСпр.Ссылка;
		
		оНаборСвойств = оСпр.НаборСвойств.ПолучитьОбъект();
		НС = оНаборСвойств.ДополнительныеРеквизиты.Добавить();
		НС.Свойство = Спр;
		НС.ИмяПредопределенногоНабора = "Справочник_Номенклатура_Общие";
		оНаборСвойств.Записать();
		
	КонецЕсли;
	
	Возврат Спр;

КонецФункции

// Возвращает валюту USD
//++ РС Консалт: Трофимов Евгений 24.08.2022
// 
Функция ВалютаДолларСША() Экспорт

	Возврат Справочники.Валюты.ПолучитьСсылку(Новый УникальныйИдентификатор("2b1348cf-b19b-11ec-a3ce-107d1afd3175"));

КонецФункции // ДолларСША()

// Возвращает валюту CNY
//++ РС Консалт: Трофимов Евгений 24.08.2022
// 
Функция ВалютаКитайскийЮань() Экспорт

	Возврат Справочники.Валюты.ПолучитьСсылку(Новый УникальныйИдентификатор("39496c37-b19b-11ec-a3ce-107d1afd3175"));

КонецФункции

// Возвращает валюту RUB
//++ РС Консалт: Трофимов Евгений 24.08.2022
// 
Функция ВалютаРоссийскийРубль() Экспорт

	Возврат Справочники.Валюты.ПолучитьСсылку(Новый УникальныйИдентификатор("7f917c97-b0f0-11ec-90a6-d8bbc15fbe40"));

КонецФункции

// Возвращает группу видов номенклатуры коляски
//++ РС Консалт: Трофимов Евгений 24.08.2022
// 
Функция ГруппаВидовНоменклатуры_Коляски() Экспорт

	ГруппаКоляски = РегистрыСведений.реа_ПредопределенныеЗначения.Значение(
		"РС_ГруппаВидовКоляски",
		Справочники.ВидыНоменклатуры.НайтиПоНаименованию("Инвалидные коляски", Истина)
	);
	Возврат ГруппаКоляски;	

КонецФункции // ГруппаВидовНоменклатуры_Коляски()


