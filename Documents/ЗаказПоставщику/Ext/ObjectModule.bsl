﻿
&После("ОбработкаПроведения")
Процедура РСК_ОбработкаПроведения(Отказ, РежимПроведения)
	
	//++ РС Консалт: Трофимов Евгений 30.10.2022 Задача 21497
	//e1cib/data/Документ.Задание?ref=b63498223cf5fa7d40b7ac5139674423
	//Изменение алгоритма переноса заказов поставщику до 01.01.2022
	УдалениеПроводокПоЛишнимРегистрам(Отказ);
	//-- КонецЗадачи 21497	
	
	//++ РС Консалт: Трофимов Евгений 07.07.2022 Задача 18725
	//e1cib/data/Документ.Задание?ref=82a4670c1ac44f3949c1b038bf806fda
	ПроведениеПоРегиструТоварыКПартиямПоставки();
	//-- КонецЗадачи 18725	
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 07.07.2022 Задача 18725
//e1cib/data/Документ.Задание?ref=82a4670c1ac44f3949c1b038bf806fda
Процедура ПроведениеПоРегиструТоварыКПартиямПоставки()

	Движения.РСК_ТоварыКПартиямПоставки.Записать();
	Движения.РСК_ТоварыКПартиямПоставки.Записывать = Истина;
	
	УчетныеХозОперации = Новый Массив;
	УчетныеХозОперации.Добавить(Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпортуТоварыВПути);
	УчетныеХозОперации.Добавить(Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС);
	
	Если УчетныеХозОперации.Найти(ХозяйственнаяОперация) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	тзТовары = Товары.Выгрузить(Новый Структура("Отменено", Ложь));
	Для Каждого Стр Из тзТовары Цикл
		Движение = Движения.РСК_ТоварыКПартиямПоставки.ДобавитьПриход();
		Движение.Период = Дата;
		Движение.ЗаказПоставщику = Ссылка;
		Движение.НомерСтрокиЗаказа = Стр.КодСтроки;
		Движение.Количество = Стр.Количество;
	КонецЦикла;

КонецПроцедуры

// Удаление проводок по лишним регистрам
//++ РС Консалт: Трофимов Евгений 30.10.2022 Задача 21497
//e1cib/data/Документ.Задание?ref=b63498223cf5fa7d40b7ac5139674423
//
// Параметры:
//  Отказ			 - Булево - 
//
Процедура УдалениеПроводокПоЛишнимРегистрам(Отказ)

	Если Дата >= '2022.01.01' ИЛИ Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МассивНужныхРегистров = Новый Массив;
	МассивНужныхРегистров.Добавить("РегистрНакопления.ЗаказыПоставщикам");
	МассивНужныхРегистров.Добавить("РегистрНакопления.ТоварыКПоступлению");
	МассивНужныхРегистров.Добавить("РегистрНакопления.РСК_ТоварыКПартиямПоставки");
	МассивНужныхРегистров.Добавить("РегистрНакопления.ЗапасыИПотребности");
	МассивНужныхРегистров.Добавить("РегистрНакопления.РаспределениеЗапасовДвижения");
	
	Для Каждого НЗ Из Движения Цикл
		
		Если МассивНужныхРегистров.Найти(НЗ.Метаданные().ПолноеИмя()) = Неопределено Тогда
			НЗ.ДополнительныеСвойства.Вставить("РассчитыватьИзменения", Ложь);
			Если НЗ.ДополнительныеСвойства.Свойство("ТаблицыКонтроля") Тогда
				НЗ.ДополнительныеСвойства.Удалить("ТаблицыКонтроля");
			КонецЕсли;
			НЗ.ОбменДанными.Загрузка = Истина;
			
			НЗ.Очистить();
			НЗ.Записать();
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры
