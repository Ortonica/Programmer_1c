﻿
&НаКлиенте
Процедура СопоставитьНоменклатуру(Команда)
	СопоставитьНоменклатуруНаСервере();
КонецПроцедуры

&НаСервере
Процедура СопоставитьНоменклатуруНаСервере()  
	
	ТаблицаСопоставления = ТаблицаСопоставления();
	
	Госуд = ГосударственныйКонтракт.ПолучитьОбъект();
	но = СопоставитьНоменклатуруКонтракта(Госуд, ТаблицаСопоставления);
	
	Госуд.НоменклатураОбъектовЗакупки.Загрузить(но);
	
	Попытка
		Госуд.Записать();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Успешно записан контракт");	
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));	
	КонецПопытки;
	
КонецПроцедуры    

&НаСервере
Функция СтатусДобавленаСтрока()
	Возврат 2;	
КонецФункции   

&НаСервере
Функция СтатусИзмененаСтрока()
	Возврат 1;	
КонецФункции

&НаСервере
Функция СопоставитьНоменклатуруКонтракта(Знач Госуд, Знач ТаблицаСопоставления)
	
	ПредварительнаяТаблица = Госуд.НоменклатураОбъектовЗакупки.Выгрузить().Скопировать();
	ПредварительнаяТаблица.Колонки.Добавить("Статус");
	
	Для Каждого Строка Из ТаблицаСопоставления Цикл 
		
		Отбор = Новый Структура;
		Отбор.Вставить("Идентификатор", Строка.Идентификатор);
		
		НайденныеСтроки = ПредварительнаяТаблица.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() > 0 Тогда 
			НоменклатураПартнера = НайденныеСтроки[0].НоменклатураПартнера;	
		КонецЕсли;
		
		Для Каждого Стр Из ПредварительнаяТаблица Цикл 
			ПредварительнаяТаблица.Удалить();
		КонецЦикла;
		
		Если НайденныеСтроки.Количество() > 0 Тогда 
			
			ЗаполненоЗначение = Ложь;
			
			Для Каждого Стр Из НайденныеСтроки Цикл
				
				Если Не ЗначениеЗаполнено(Стр.Номенклатура)
					И Не ЗначениеЗаполнено(Стр.Характеристика) Тогда 
					
					Стр.Номенклатура = Строка.Номенклатура;
					Стр.Характеристика = Строка.Характеристика;
					Если Не ЗначениеЗаполнено(Стр.НоменклатураПартнера) Тогда 
						Стр.НоменклатураПартнера = Стр.НоменклатураПартнера;
					КонецЕсли;
					
					Стр.Статус = СтатусИзмененаСтрока();
					
					ЗаполненоЗначение = Истина;
				Иначе
					
					Если Стр.Номенклатура = Строка.Номенклатура Тогда 
						ЗаполненоЗначение = Истина;
					Иначе
						
						Стр.Номенклатура = Строка.Номенклатура;
						Стр.Характеристика = Строка.Характеристика;
						Если Не ЗначениеЗаполнено(Стр.НоменклатураПартнера) Тогда 
							Стр.НоменклатураПартнера = Стр.НоменклатураПартнера;
						КонецЕсли;
						
						Стр.Статус = СтатусИзмененаСтрока();
						
						ЗаполненоЗначение = Истина;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если Не ЗаполненоЗначение Тогда 
				
				НоваяСтрока = ПредварительнаяТаблица.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Стр);
				
				НоваяСтрока.Номенклатура 			= Строка.Номенклатура;
				НоваяСтрока.Характеристика 			= Строка.Характеристика;
				НоваяСтрока.Статус = СтатусДобавленаСтрока();
				
			КонецЕсли;
			
		Иначе
			
			НоваяСтрока 						= ПредварительнаяТаблица.Добавить();
			НоваяСтрока.Идентификатор 			= Строка.Идентификатор;
			НоваяСтрока.Номенклатура 			= Строка.Номенклатура;
			НоваяСтрока.Характеристика 			= Строка.Характеристика;
			НоваяСтрока.НоменклатураПартнера 	= Строка.НоменклатураПартнера;
			
			НоваяСтрока.Статус = СтатусДобавленаСтрока();
			
		КонецЕсли;
		
	КонецЦикла; 
	
	Возврат ПредварительнаяТаблица;

КонецФункции

&НаСервере
Функция ТаблицаСопоставления()
	
	табл = Новый ТаблицаЗначений;
	табл.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	табл.Колонки.Добавить("НоменклатураПартнера", Новый ОписаниеТипов("СправочникСсылка.НоменклатураКонтрагентов"));
	табл.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	табл.Колонки.Добавить("Идентификатор");
	табл.Колонки.Добавить("Количество");
	табл.Колонки.Добавить("Упаковка");
	
	ТоварыРеализации = ДокументСопоставления.Товары.Выгрузить();
	ОбъектыЗакупки = ГосударственныйКонтракт.ОбъектыЗакупки.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Товары.Номенклатура КАК Номенклатура,
	               |	Товары.НоменклатураПартнера КАК НоменклатураПартнера,
	               |	Товары.Характеристика КАК Характеристика,
	               |	Товары.Цена КАК Цена
	               |ПОМЕСТИТЬ Товары
	               |ИЗ
	               |	&Товары КАК Товары
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Товары.Номенклатура КАК Номенклатура,
	               |	Товары.Характеристика КАК Характеристика,
	               |	Товары.Цена КАК Цена,
	               |	Товары.НоменклатураПартнера КАК НоменклатураПартнера
	               |ИЗ
	               |	Товары КАК Товары
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Товары.Номенклатура,
	               |	Товары.Характеристика,
	               |	Товары.Цена,
	               |	Товары.НоменклатураПартнера";
	
	Запрос.УстановитьПараметр("Товары", ТоварыРеализации);
	
	Товары = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Стр Из Товары Цикл
		
		Отбор = Новый Структура;
		Отбор.Вставить("Цена", Стр.Цена);
		
		НайденныеСтроки = ОбъектыЗакупки.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() > 0 Тогда 

			// Проверка уникальности идентификаторов
			УникальностьЕсть = Истина;
			Ид = НайденныеСтроки[0].Идентификатор;
			Для Каждого Сткап Из НайденныеСтроки Цикл 
				
				Если Ид <> Сткап.Идентификатор Тогда 
					УникальностьЕсть = Ложь;					
				КонецЕсли;
				
			КонецЦикла;  
			
			Если Не УникальностьЕсть Тогда 
				Продолжить;;	
			КонецЕсли;
			
			
			Для Каждого Сткап Из НайденныеСтроки Цикл 
				
				ИдентификаторТовара = Сткап.Идентификатор;
				
				НоваяСТрока = табл.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСТрока, Стр);
				
				НоваяСТрока.Идентификатор = ИдентификаторТовара;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла; 
	
	Возврат табл;

КонецФункции

&НаСервере
Процедура РеализацияТоваровИУслугПриИзмененииНаСервере()

	ГосударственныйКонтракт = ДокументСопоставления.Договор.ГосударственныйКонтракт;
	ГосударственныйКонтрактПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура РеализацияТоваровИУслугПриИзменении(Элемент)
	РеализацияТоваровИУслугПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ГосударственныйКонтрактПриИзменении(Элемент)
	
	ГосударственныйКонтрактПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ГосударственныйКонтрактПриИзмененииНаСервере()

	НоменклатураОбъектовЗакупкиТекущая.Загрузить(ГосударственныйКонтракт.НоменклатураОбъектовЗакупки.Выгрузить());
	НоменклатураОбъектовЗакупкиТекущая.Сортировать("Идентификатор");
	
	ЗаполнитьПредварительныйПросмотр();
	
КонецПроцедуры  

&НаСервере
Процедура ЗаполнитьПредварительныйПросмотр()
	
	Если Не ЗначениеЗаполнено(ДокументСопоставления) Или Не ЗначениеЗаполнено(ГосударственныйКонтракт) Тогда 
		Возврат;
	КонецЕсли;
	
	Если ДокументСопоставления.Договор.ГосударственныйКонтракт <> ГосударственныйКонтракт Тогда 
		Возврат;
	КонецЕсли;
	
	ТаблицаСопоставления = ТаблицаСопоставления();		
	
	Нменклта = СопоставитьНоменклатуруКонтракта(ГосударственныйКонтракт, ТаблицаСопоставления);
	
	НоменклатураОбъектовЗакупкиПредварительныйПросмотр.Загрузить(Нменклта);
	
	НоменклатураОбъектовЗакупкиПредварительныйПросмотр.Сортировать("Идентификатор");
	
КонецПроцедуры

