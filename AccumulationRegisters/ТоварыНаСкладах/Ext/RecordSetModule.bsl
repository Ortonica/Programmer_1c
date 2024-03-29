﻿
&После("ПередЗаписью")
Процедура РСК_ПередЗаписью(Отказ, Замещение)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//++ РС Консалт: Трофимов Евгений 19.12.2022 Задача 22609
	//e1cib/data/Документ.Задание?ref=8f6241e32875100f4d26ad49a6190c97
	Если РегистрыСведений.реа_ПредопределенныеЗначения.Значение("Отключить контроль записи ТоварыНаСкладах") Тогда
		Возврат;
	КонецЕсли;

	Если Пользователи.ЭтоПолноправныйПользователь(,,Ложь) 
		ИЛИ РСК_ВызовСервера.ЕстьРоль("РСК_ПроведениеТоваровНаСкладахПрошлойДатой") Тогда
		Возврат;
	КонецЕсли;
	
	Регистратор = ЭтотОбъект.Отбор.Регистратор.Значение;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ТоварыНаСкладах.Период КАК Период
		|ИЗ
		|	РегистрНакопления.ТоварыНаСкладах КАК ТоварыНаСкладах
		|ГДЕ
		|	ТоварыНаСкладах.Регистратор = &Регистратор
		|	И ТоварыНаСкладах.Период < &Сегодня";
	
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	Запрос.УстановитьПараметр("Сегодня", НачалоДня(ТекущаяДатаСеанса()));
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ОбщегоНазначения.СообщитьПользователю(
			"Запрещено проведение по регистру ТоварыНаСкладах прошлой датой. Для разрешения необходимо добавить пользователю роль «Проведение товаров на складах прошлой датой (РСК)»",
			Регистратор,,,
			Отказ
		);
		Возврат;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Запись.Период < НачалоДня(ТекущаяДатаСеанса()) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				"Запрещено проведение по регистру ТоварыНаСкладах прошлой датой. Для разрешения необходимо добавить пользователю роль «Проведение товаров на складах прошлой датой (РСК)»",
				Регистратор,,,
				Отказ
			);
			Возврат;			
		КонецЕсли;
	КонецЦикла;
	//-- КонецЗадачи 22609	
КонецПроцедуры
