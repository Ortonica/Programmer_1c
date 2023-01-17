﻿
&ИзменениеИКонтроль("АктуализироватьСчетаФактурыВыданныеПередЗаписью")
Процедура РСК_АктуализироватьСчетаФактурыВыданныеПередЗаписью(ПараметрыРегистрации, Знач РежимЗаписи, Знач ПометкаУдаления, Знач Проведен)

	СчетФактураВыданныйНеТребуется = СчетФактураВыданныйНеТребуется(ПараметрыРегистрации);
	ДокументПроведен = Ложь;
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ДокументПроведен = Истина;
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.Запись И Проведен Тогда
		ДокументПроведен = Истина;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаОснований.Ссылка
	|ПОМЕСТИТЬ СчетаФактуры
	|ИЗ
	|	Документ.СчетФактураВыданный.ДокументыОснования КАК ТаблицаОснований
	|ГДЕ
	|	ТаблицаОснований.ДокументОснование = &ДокументПродажи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СчетаФактуры.Ссылка КАК Ссылка,
	|	СчетаФактуры.Ссылка.Проведен КАК Проведен,
	|	СчетаФактуры.Ссылка.ПометкаУдаления КАК ПометкаУдаления,
	|	СчетаФактуры.Ссылка.Организация КАК Организация,
	|	КОЛИЧЕСТВО(ТаблицаОснований.ДокументОснование) КАК КоличествоОснований
	|ИЗ
	|	СчетаФактуры КАК СчетаФактуры
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.СчетФактураВыданный.ДокументыОснования КАК ТаблицаОснований
	|	ПО 
	|		СчетаФактуры.Ссылка = ТаблицаОснований.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	СчетаФактуры.Ссылка
	|";
	Запрос.УстановитьПараметр("ДокументПродажи", ПараметрыРегистрации.Ссылка);

	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		ПометитьНаУдаление = Ложь;
		ОтменитьПроведение = Ложь;
		#Вставка
		//++ РС Консалт: Минаков А.С. Задача 20226
		Провести = Ложь;
		//++ РС Консалт: Минаков А.С. Задача 20226
		#КонецВставки

		Если НЕ Выборка.ПометкаУдаления
			И (ПометкаУдаления
			Или Выборка.Организация <> ПараметрыРегистрации.Организация
			Или СчетФактураВыданныйНеТребуется) Тогда
			ПометитьНаУдаление = Истина;
		ИначеЕсли Выборка.Проведен И НЕ ДокументПроведен Тогда
			ОтменитьПроведение = Истина;
		#Вставка
		//++ РС Консалт: Минаков А.С. Задача 20226
		ИначеЕсли Не Выборка.Проведен И ДокументПроведен Тогда
			Провести = Истина
			//++ РС Консалт: Минаков А.С. Задача 20226
		#КонецВставки
		КонецЕсли;
		
		#Удаление
		Если ПометитьНаУдаление Или ОтменитьПроведение Тогда
		#КонецУдаления
		#Вставка
		//++ РС Консалт: Минаков А.С. Задача 20226
		Если ПометитьНаУдаление Или ОтменитьПроведение Или Провести Тогда
			//++ РС Консалт: Минаков А.С. Задача 20226
			#КонецВставки

			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Документ.СчетФактураВыданный");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();

		КонецЕсли;

		Если ПометитьНаУдаление Тогда
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			Если Выборка.КоличествоОснований = 1 Тогда
				ДокументОбъект.УстановитьПометкуУдаления(Истина);
			Иначе
				СтрокаКУдалению = ДокументОбъект.ДокументыОснования.Найти(ПараметрыРегистрации.Ссылка);
				Если СтрокаКУдалению <> Неопределено Тогда
					ДокументОбъект.ДокументыОснования.Удалить(СтрокаКУдалению);
				КонецЕсли;
				СтрокаКУдалениюПокупатели = ДокументОбъект.Покупатели.Найти(ПараметрыРегистрации.Ссылка);
				Если СтрокаКУдалениюПокупатели <> Неопределено Тогда
					ДокументОбъект.Покупатели.Удалить(СтрокаКУдалениюПокупатели);
					ДокументОбъект.КодВидаОперации = 
					Документы.СчетФактураВыданный.КодВидаОперации(ДокументОбъект.ДокументыОснования, 
					ДокументОбъект.Покупатели, ДокументОбъект.Дата);
				КонецЕсли;
				Если СтрокаКУдалению <> Неопределено Или СтрокаКУдалениюПокупатели <> Неопределено Тогда
					Если ДокументОбъект.Проведен Тогда
						РежимЗаписи = РежимЗаписиДокумента.Проведение;
					Иначе
						РежимЗаписи = РежимЗаписиДокумента.Запись;
					КонецЕсли;
					ДокументОбъект.Записать(РежимЗаписи);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

		Если ОтменитьПроведение Тогда
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			Если Выборка.КоличествоОснований = 1 Тогда
				ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			Иначе
				СтрокаКУдалению = ДокументОбъект.ДокументыОснования.Найти(ПараметрыРегистрации.Ссылка);
				Если СтрокаКУдалению <> Неопределено Тогда
					ДокументОбъект.ДокументыОснования.Удалить(СтрокаКУдалению);
				КонецЕсли;
				СтрокаКУдалениюПокупатели = ДокументОбъект.Покупатели.Найти(ПараметрыРегистрации.Ссылка);
				Если СтрокаКУдалениюПокупатели <> Неопределено Тогда
					ДокументОбъект.Покупатели.Удалить(СтрокаКУдалениюПокупатели);
					ДокументОбъект.КодВидаОперации = 
					Документы.СчетФактураВыданный.КодВидаОперации(ДокументОбъект.ДокументыОснования, 
					ДокументОбъект.Покупатели, ДокументОбъект.Дата);
				КонецЕсли;
				Если СтрокаКУдалению <> Неопределено Или СтрокаКУдалениюПокупатели <> Неопределено Тогда
					Если ДокументОбъект.Проведен Тогда
						РежимЗаписи = РежимЗаписиДокумента.Проведение;
					Иначе
						РежимЗаписи = РежимЗаписиДокумента.Запись;
					КонецЕсли;
					ДокументОбъект.Записать(РежимЗаписи);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		#Вставка
		//++ РС Консалт: Минаков А.С. Задача 20226
		Если Провести Тогда
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ДокументОбъект.ПометкаУдаления = Ложь;
			Если Выборка.КоличествоОснований = 1 Тогда
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				Сч = 0;
				Пока Сч < ДокументОбъект.ДокументыОснования Цикл
					СтрокаКУдалению = ДокументОбъект.ДокументыОснования.Получить(Сч);
					Если СтрокаКУдалению.ДокументОснование = ПараметрыРегистрации.Ссылка Тогда
						Сч = Сч + 1
					Иначе 
						ДокументОбъект.ДокументыОснования.Удалить(СтрокаКУдалению)
					КонецЕсли
				КонецЦикла;
				Сч = 0;
				Пока Сч < ДокументОбъект.Покупатели Цикл
					СтрокаКУдалению = ДокументОбъект.Покупатели.Получить(Сч);
					Если СтрокаКУдалению.ДокументОснование = ПараметрыРегистрации.Ссылка Тогда
						Сч = Сч + 1
					Иначе 
						ДокументОбъект.Покупатели.Удалить(СтрокаКУдалению)
					КонецЕсли
				КонецЦикла;
                ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение)
			КонецЕсли	
		КонецЕсли;
		//++ РС Консалт: Минаков А.С. Задача 20226
		#КонецВставки

	КонецЦикла;

	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры
