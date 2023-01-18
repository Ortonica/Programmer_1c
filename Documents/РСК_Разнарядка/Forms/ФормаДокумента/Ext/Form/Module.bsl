﻿&НаСервере
//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Если Параметры.Ключ.Пустая() Тогда
	//	Объект.Владелец = ПараметрыСеанса.ТекущийПользователь.ОрганизацияСоисполнителя;
	//КонецЕсли;	
	ОбновитьДоступностьЭлементов();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура ПриОткрытии(Отказ)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции
 
// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
 
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
 
#КонецОбласти


&НаСервере
//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура ЗагрузитьТаблицуРазнарядки(АдресХранилища)
	Рез = ПолучитьИзВременногоХранилища(АдресХранилища);
	//проверим, есть ли подобные значения в ТЧ Реестр
	СтруктПоиска = Новый Структура("ТСР,НомерНаправления,ДатаНаправления,Заявитель");
	Для Каждого стрРез Из Рез Цикл
		ЗаполнитьЗначенияСвойств(СтруктПоиска, стрРез);
		
		Найдено = Объект.Реестр.НайтиСтроки(СтруктПоиска);
		Если Найдено.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(Найдено[0],стрРез,,"КлючСтроки");
		Иначе
			НовСтр = Объект.Реестр.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр,стрРез);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Функция ПроверкаЗаполнения()
	Вернем = Неопределено;
	Если НЕ ЗначениеЗаполнено(Объект.Контракт) Тогда
		Вернем = "Выберите контракт!";
		Возврат Вернем;
	КонецЕсли;
	
	//Тер. группа
	Если НЕ ЗначениеЗаполнено(Объект.Контракт.реа_ТерриториальнаяГруппа) Тогда
		Вернем = "Заполните значение Тер. группы в Контракте!";
		Возврат Вернем;
	КонецЕсли;
	//Значения ТСР с количеством и ценой
	Если Объект.Контракт.Товары.Количество()=0 Тогда
		Вернем = "Заполните табличную часть!";
		Возврат Вернем;
	Иначе
		Для каждого стр из Объект.Контракт.Товары Цикл
			Если НЕ ЗначениеЗаполнено(стр.НоменклатураПартнера) Тогда
				Вернем = "в Контракте заполните ТСР в строке: "+стр.НомерСтроки+" !";
				Возврат Вернем;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат Вернем;
КонецФункции

&НаКлиенте
//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура Импорт(Команда)
	МожноИмпортировать = ПроверкаЗаполнения();
	Если  МожноИмпортировать <> Неопределено Тогда
		 ПоказатьПредупреждение(
        ,
        МожноИмпортировать, // предупреждение
        0, // (необ.) таймаут в секундах
        "Это предупреждение." // (необ.) заголовок
    );
	Иначе
		ПараметрКонтракта = Новый Структура("Контракт",Объект.Контракт);
		Оповещение = Новый ОписаниеОповещения("ЗагрузитьТаблицуРазнарядкиЗавершение", ЭтотОбъект);
		ОткрытьФорму("Обработка.РСК_ЗагрузкаДляАльфа.Форма.Форма",ПараметрКонтракта , ЭтотОбъект,,,,Оповещение);
	КонецЕсли;
КонецПроцедуры

&НаСервере
//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура удалить_СоздатьАктыНаСервере()
	
	ЭтотОбъект.Записать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РСК_СостояниеЗаказовКлиентовПоВыдаче.ТСР КАК ТСР,
		|	РСК_СостояниеЗаказовКлиентовПоВыдаче.Номенклатура КАК Номенклатура,
		|	РСК_СостояниеЗаказовКлиентовПоВыдаче.Характеристика КАК Характеристика,
		|	РСК_СостояниеЗаказовКлиентовПоВыдаче.Серия КАК Серия,
		|	МАКСИМУМ(РСК_СостояниеЗаказовКлиентовПоВыдаче.Цена) КАК Цена
		|ПОМЕСТИТЬ Цены
		|ИЗ
		|	РегистрНакопления.РСК_СостояниеЗаказовКлиентовПоВыдаче КАК РСК_СостояниеЗаказовКлиентовПоВыдаче
		|ГДЕ
		|	РСК_СостояниеЗаказовКлиентовПоВыдаче.ТСР В(&МассивТСР)
		|	И РСК_СостояниеЗаказовКлиентовПоВыдаче.Регистратор = &Заказ
		|
		|СГРУППИРОВАТЬ ПО
		|	РСК_СостояниеЗаказовКлиентовПоВыдаче.ТСР,
		|	РСК_СостояниеЗаказовКлиентовПоВыдаче.Номенклатура,
		|	РСК_СостояниеЗаказовКлиентовПоВыдаче.Характеристика,
		|	РСК_СостояниеЗаказовКлиентовПоВыдаче.Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РСК_СостояниеЗаказовКлиентовПоВыдачеОстатки.ТСР КАК ТСР,
		|	РСК_СостояниеЗаказовКлиентовПоВыдачеОстатки.Номенклатура КАК Номенклатура,
		|	РСК_СостояниеЗаказовКлиентовПоВыдачеОстатки.Характеристика КАК Характеристика,
		|	РСК_СостояниеЗаказовКлиентовПоВыдачеОстатки.Серия КАК Серия,
		|	РСК_СостояниеЗаказовКлиентовПоВыдачеОстатки.КСозданиюОстаток КАК Остаток,
		|	ЕСТЬNULL(Цены.Цена, 0) КАК Цена
		|ИЗ
		|	РегистрНакопления.РСК_СостояниеЗаказовКлиентовПоВыдаче.Остатки(
		|			&МоментОстатков,
		|			Заказ = &Заказ
		|				И ТСР В (&МассивТСР)) КАК РСК_СостояниеЗаказовКлиентовПоВыдачеОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ Цены КАК Цены
		|		ПО РСК_СостояниеЗаказовКлиентовПоВыдачеОстатки.ТСР = Цены.ТСР
		|			И РСК_СостояниеЗаказовКлиентовПоВыдачеОстатки.Номенклатура = Цены.Номенклатура
		|			И РСК_СостояниеЗаказовКлиентовПоВыдачеОстатки.Характеристика = Цены.Характеристика
		|			И РСК_СостояниеЗаказовКлиентовПоВыдачеОстатки.Серия = Цены.Серия
		|ГДЕ
		|	РСК_СостояниеЗаказовКлиентовПоВыдачеОстатки.КСозданиюОстаток > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РСК_РазнарядкаРеестр.ТСР КАК ТСР,
		|	РСК_РазнарядкаРеестр.НомерНаправления КАК НомерНаправления,
		|	РСК_РазнарядкаРеестр.ДатаНаправления КАК ДатаНаправления,
		|	РСК_РазнарядкаРеестр.Заявитель КАК Заявитель,
		|	ПоручениеЭкспедитору.Ссылка КАК Акт
		|ИЗ
		|	Документ.РСК_Разнарядка.Реестр КАК РСК_РазнарядкаРеестр
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПоручениеЭкспедитору КАК ПоручениеЭкспедитору
		|		ПО РСК_РазнарядкаРеестр.ТСР = ПоручениеЭкспедитору.РСК_ТСР
		|			И РСК_РазнарядкаРеестр.Заявитель = ПоручениеЭкспедитору.Пункт
		|			И РСК_РазнарядкаРеестр.НомерНаправления = ПоручениеЭкспедитору.РСК_НомерНаправления
		|			И РСК_РазнарядкаРеестр.ДатаНаправления = ПоручениеЭкспедитору.РСК_ДатаНаправления
		|ГДЕ
		|	РСК_РазнарядкаРеестр.Ссылка = &Ссылка
		|	И НЕ ПоручениеЭкспедитору.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Заказ", Объект.Контракт);
	Запрос.УстановитьПараметр("МассивТСР", Объект.Реестр.Выгрузить(,"ТСР").ВыгрузитьКолонку("ТСР"));
	Запрос.УстановитьПараметр("МоментОстатков", Объект.Ссылка.МоментВремени());
	Результаты = Запрос.ВыполнитьПакет();
	тзОстаткиТСР = Результаты[1].Выгрузить();
	тзПредварительныеАкты = Результаты[2].Выгрузить();
	Фильтр = Новый Структура("ТСР,Заявитель,НомерНаправления,ДатаНаправления");
	
	Отказ = Ложь;
	НачатьТранзакцию();
	Для Каждого Стр Из Объект.Реестр Цикл
		ЗаполнитьЗначенияСвойств(Фильтр, Стр);
		ПредварительныеАкты = тзПредварительныеАкты.НайтиСтроки(Фильтр);
		Требуется = Стр.Количество;
		ДоступныеОстатки = тзОстаткиТСР.НайтиСтроки(Новый Структура("ТСР", Стр.ТСР));
		Для Каждого ДоступныйОстаток Из ДоступныеОстатки Цикл
			Если Требуется <= 0 Тогда
				Прервать;
			КонецЕсли;
			Если ДоступныйОстаток.Остаток <= 0 Тогда
				Продолжить;
			КонецЕсли;
			
			МожноСписать = Мин(Требуется, ДоступныйОстаток.Остаток);

			//++ РС Консалт: Трофимов Евгений 21.11.2022 Тикет 21992
			//e1cib/data/Документ.Задание?ref=bce88b7b95480ed04b9d7db9cc08aabe
			//Было:
			//Акт = Документы.ПоручениеЭкспедитору.СоздатьДокумент();
			//Стало:
			Если ПредварительныеАкты.Количество() = 1 И ДоступныеОстатки.Количество() = 1 Тогда
				Акт = ПредварительныеАкты[0].Акт.ПолучитьОбъект();
				Акт.Основания.Очистить();
			Иначе
				Акт = Документы.ПоручениеЭкспедитору.СоздатьДокумент();
			КонецЕсли;
			//-- КонецТикета 21992			
			СтрокаОснования = Акт.Основания.Добавить();
			СтрокаОснования.Основание = Объект.Контракт;			
			Акт.РСК_АктВыдачиТСР	= Истина;
			Акт.СпособДоставки		= Перечисления.СпособыДоставки.ПоручениеЭкспедиторуСоСклада;
			Акт.Пункт				= стр.Заявитель;
			Акт.Дата				= ТекущаяДата();
			Если ПустаяСтрока(Акт.Номер) Тогда
				Акт.УстановитьНовыйНомер();
			КонецЕсли;
			Акт.РСК_НомерНаправления= стр.НомерНаправления;
			Акт.РСК_ДатаНаправления	= стр.ДатаНаправления;
			Акт.РСК_ТСР				= стр.ТСР;
			Акт.РСК_Номенклатура	= ДоступныйОстаток.Номенклатура;
			Акт.РСК_Характеристика	= ДоступныйОстаток.Характеристика;
			Акт.РСК_Серия 			= ДоступныйОстаток.Серия;
			Акт.РСК_Количество 		= МожноСписать;
			Акт.РСК_НомерРеестра    = стр.НомерРеестра;
			Акт.РСК_ДатаРеестра     = стр.ДатаРеестра;
			Акт.КонтактноеЛицо 		= стр.ДовЛицо;
			Акт.Склад = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Стр.Район, "Родитель.РСК_СкладВыдачиТСР");
			Если ПустаяСтрока(Стр.Комментарий) Тогда
				Акт.ОсобыеУсловияПеревозкиОписание = ".";
			Иначе
				Акт.ОсобыеУсловияПеревозкиОписание = Стр.Комментарий;
			КонецЕсли;

			Акт.АдресДоставки = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
				стр.Заявитель,
				Справочники.ВидыКонтактнойИнформации.АдресПартнера,
				ТекущаяДата(),
				Истина
			);
			Акт.ЗонаДоставки = Стр.Район;
			
			Акт.Комментарий = Стр.Комментарий;
			СтатусПолучателя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(стр.Заявитель, "РСК_СтатусПолучателяТСР");
			Если СтатусПолучателя = Перечисления.РСК_СтатусыПолучателяТСР.Умер Тогда
				Акт.РСК_СтатусАктаВыдачиТСР = Перечисления.РСК_СтатусыАктовВыдачи.Аннулирован;
				Акт.Комментарий = Акт.Комментарий + " Получатель умер, поручение аннулировано."
			Иначе
				Акт.РСК_СтатусАктаВыдачиТСР = Перечисления.РСК_СтатусыАктовВыдачи.Подготовлен;
			КонецЕсли; 
			Акт.РСК_Цена = ДоступныйОстаток.Цена;
			Акт.РСК_Сумма = Акт.РСК_Количество * Акт.РСК_Цена;
			
			Попытка
				Акт.Записать(РежимЗаписиДокумента.Проведение);
			Исключение
				Акт.ОбменДанными.Загрузка = Истина;
				Акт.Записать();
				ОбщегоНазначения.СообщитьПользователю("Не удалось провести " + Акт.Ссылка,Акт.Ссылка);
			КонецПопытки;
			
			стрАкт = Объект.Акты.Добавить();
			стрАкт.Акт = Акт.Ссылка;
			стрАкт.Количество = МожноСписать;
			стрАкт.КлючСвязи = Стр.КлючСтроки;
			
			Требуется = Требуется - МожноСписать;
			ДоступныйОстаток.Остаток = ДоступныйОстаток.Остаток - МожноСписать;
		КонецЦикла;
		
		Если Требуется > 0 Тогда
			//++ РС Консалт: Трофимов Евгений 21.11.2022 Тикет 21992
			//e1cib/data/Документ.Задание?ref=bce88b7b95480ed04b9d7db9cc08aabe
			//Было:
			//Акт = Документы.ПоручениеЭкспедитору.СоздатьДокумент();
			//Стало:
			Если ПредварительныеАкты.Количество() = 1 И ДоступныеОстатки.Количество() = 0 Тогда
				Акт = ПредварительныеАкты[0].Акт.ПолучитьОбъект();
				Акт.Основания.Очистить();
			Иначе
				Акт = Документы.ПоручениеЭкспедитору.СоздатьДокумент();
			КонецЕсли;
			//-- КонецТикета 21992			
			СтрокаОснования = Акт.Основания.Добавить();
			СтрокаОснования.Основание = Объект.Контракт;			
			Акт.РСК_АктВыдачиТСР	= Истина;
			Акт.СпособДоставки		= Перечисления.СпособыДоставки.ПоручениеЭкспедиторуСоСклада;
			Акт.Пункт				= стр.Заявитель;
			Акт.Дата				= ТекущаяДата();
			Акт.УстановитьНовыйНомер();
			Акт.РСК_НомерНаправления= стр.НомерНаправления;
			Акт.РСК_ДатаНаправления	= стр.ДатаНаправления;
			Акт.РСК_ТСР				= стр.ТСР;
			Акт.РСК_Количество 		= Требуется;
			Акт.РСК_НомерРеестра    = стр.НомерРеестра;
			Акт.РСК_ДатаРеестра     = стр.ДатаРеестра;
			Акт.КонтактноеЛицо 		= стр.ДовЛицо;
			Акт.Склад = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Стр.Район, "Родитель.РСК_СкладВыдачиТСР");
			Если ПустаяСтрока(Стр.Комментарий) Тогда
				Акт.ОсобыеУсловияПеревозкиОписание = ".";
			Иначе
				Акт.ОсобыеУсловияПеревозкиОписание = Стр.Комментарий;
			КонецЕсли;

			Акт.АдресДоставки = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
				стр.Заявитель,
				Справочники.ВидыКонтактнойИнформации.АдресПартнера,
				ТекущаяДата(),
				Истина
			);
			Акт.ЗонаДоставки = Стр.Район;
			
			Акт.Комментарий = Стр.Комментарий;
			СтатусПолучателя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(стр.Заявитель, "РСК_СтатусПолучателяТСР");
			Если СтатусПолучателя = Перечисления.РСК_СтатусыПолучателяТСР.Умер Тогда
				Акт.РСК_СтатусАктаВыдачиТСР = Перечисления.РСК_СтатусыАктовВыдачи.Аннулирован;
				Акт.Комментарий = Акт.Комментарий + " Получатель умер, поручение аннулировано."
			Иначе
				Акт.РСК_СтатусАктаВыдачиТСР = Перечисления.РСК_СтатусыАктовВыдачи.Создан;
			КонецЕсли; 
			
			Попытка
				Акт.Записать(РежимЗаписиДокумента.Проведение);
				
			Исключение
				Акт.ОбменДанными.Загрузка = Истина;
				Акт.Записать();
				ОбщегоНазначения.СообщитьПользователю("Не удалось провести " + Акт.Ссылка,Акт.Ссылка);
			КонецПопытки;
			
			стрАкт = Объект.Акты.Добавить();
			стрАкт.Акт = Акт.Ссылка;
			стрАкт.Количество = Требуется;
			стрАкт.КлючСвязи = Стр.КлючСтроки;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Отказ Тогда
		Объект.Акты.Очистить();
		ОтменитьТранзакцию();
	Иначе
		Записать();
		ЗафиксироватьТранзакцию();
	КонецЕсли;
	ОбновитьДоступностьЭлементов();
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 30.11.2022 Задача 22227
//e1cib/data/Документ.Задание?ref=8abe56615d62eef54233cc6d23f2bd61
&НаСервере
Процедура СоздатьАктыНаСервере()
	
	ЭтотОбъект.Записать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказКлиентаТовары.НоменклатураПартнера КАК ТСР,
		|	МАКСИМУМ(ЗаказКлиентаТовары.Номенклатура) КАК Номенклатура,
		|	МАКСИМУМ(ЗаказКлиентаТовары.Характеристика) КАК Характеристика,
		|	МАКСИМУМ(ЗаказКлиентаТовары.Серия) КАК Серия,
		|	ЗаказКлиентаТовары.Цена КАК Цена
		|ИЗ
		|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
		|ГДЕ
		|	ЗаказКлиентаТовары.Ссылка = &ЗаказКлиента
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказКлиентаТовары.НоменклатураПартнера,
		|	ЗаказКлиентаТовары.Цена
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РСК_РазнарядкаРеестр.ТСР КАК ТСР,
		|	РСК_РазнарядкаРеестр.НомерНаправления КАК НомерНаправления,
		|	РСК_РазнарядкаРеестр.ДатаНаправления КАК ДатаНаправления,
		|	РСК_РазнарядкаРеестр.Заявитель КАК Заявитель,
		|	ПоручениеЭкспедитору.Ссылка КАК Акт
		|ИЗ
		|	Документ.РСК_Разнарядка.Реестр КАК РСК_РазнарядкаРеестр
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПоручениеЭкспедитору КАК ПоручениеЭкспедитору
		|		ПО РСК_РазнарядкаРеестр.ТСР = ПоручениеЭкспедитору.РСК_ТСР
		|			И РСК_РазнарядкаРеестр.Заявитель = ПоручениеЭкспедитору.Пункт
		|			И РСК_РазнарядкаРеестр.НомерНаправления = ПоручениеЭкспедитору.РСК_НомерНаправления
		|			И РСК_РазнарядкаРеестр.ДатаНаправления = ПоручениеЭкспедитору.РСК_ДатаНаправления
		|ГДЕ
		|	РСК_РазнарядкаРеестр.Ссылка = &Ссылка
		|	И НЕ ПоручениеЭкспедитору.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("ЗаказКлиента", Объект.Контракт);
	Результаты = Запрос.ВыполнитьПакет();
	тзТоварыЗаказа = Результаты[0].Выгрузить();
	тзПредварительныеАкты = Результаты[1].Выгрузить();
	ФильтрАктов = Новый Структура("ТСР,Заявитель,НомерНаправления,ДатаНаправления");
	ФильтрТоваров = Новый Структура("ТСР,Цена");
	
	Отказ = Ложь;
	НачатьТранзакцию();
	Для Каждого Стр Из Объект.Реестр Цикл
		ЗаполнитьЗначенияСвойств(ФильтрАктов, Стр);
		ПредварительныеАкты = тзПредварительныеАкты.НайтиСтроки(ФильтрАктов);
		ЗаполнитьЗначенияСвойств(ФильтрТоваров, Стр);
		НайденныеТовары = тзТоварыЗаказа.НайтиСтроки(ФильтрТоваров);
		
		Если ПредварительныеАкты.Количество() = 1 Тогда
			Акт = ПредварительныеАкты[0].Акт.ПолучитьОбъект();
			Акт.Основания.Очистить();
		Иначе
			Акт = Документы.ПоручениеЭкспедитору.СоздатьДокумент();
		КонецЕсли;

		СтрокаОснования = Акт.Основания.Добавить();
		СтрокаОснования.Основание = Объект.Контракт;			
		Акт.РСК_АктВыдачиТСР	= Истина;
		Акт.СпособДоставки		= Перечисления.СпособыДоставки.ПоручениеЭкспедиторуСоСклада;
		Акт.Пункт				= стр.Заявитель;
		Акт.Дата				= ТекущаяДатаСеанса();
		Если ПустаяСтрока(Акт.Номер) Тогда
			Акт.УстановитьНовыйНомер();
		КонецЕсли;
		Акт.РСК_НомерНаправления= стр.НомерНаправления;
		Акт.РСК_ДатаНаправления	= стр.ДатаНаправления;
		Акт.РСК_ТСР				= стр.ТСР;
		Если НайденныеТовары.Количество() > 0 Тогда
			Акт.РСК_Номенклатура	= НайденныеТовары[0].Номенклатура;
			Акт.РСК_Характеристика	= НайденныеТовары[0].Характеристика;
			Акт.РСК_Серия 			= НайденныеТовары[0].Серия;
		КонецЕсли;
		Акт.РСК_Количество 		= стр.Количество;;
		Акт.РСК_НомерРеестра    = стр.НомерРеестра;
		Акт.РСК_ДатаРеестра     = стр.ДатаРеестра;
		Акт.КонтактноеЛицо 		= стр.ДовЛицо;
		Акт.Склад = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Стр.Район, "Родитель.РСК_СкладВыдачиТСР");
		Если ПустаяСтрока(Стр.КомментарийАкта) Тогда
			Акт.ОсобыеУсловияПеревозкиОписание = ".";
		Иначе
			Акт.ОсобыеУсловияПеревозкиОписание = Стр.КомментарийАкта;
		КонецЕсли;

		Акт.АдресДоставки = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
			стр.Заявитель,
			Справочники.ВидыКонтактнойИнформации.АдресПартнера,
			ТекущаяДата(),
			Истина
		);
		Акт.ЗонаДоставки = Стр.Район;
		
		Акт.Комментарий = Стр.КомментарийАкта;
		СтатусПолучателя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(стр.Заявитель, "РСК_СтатусПолучателяТСР");
		Если СтатусПолучателя = Перечисления.РСК_СтатусыПолучателяТСР.Умер Тогда
			Акт.РСК_СтатусАктаВыдачиТСР = Перечисления.РСК_СтатусыАктовВыдачи.Аннулирован;
			Акт.Комментарий = Акт.КомментарийАкта + " Получатель умер, поручение аннулировано."
		Иначе
			Если НайденныеТовары.Количество() > 0 Тогда
				Акт.РСК_СтатусАктаВыдачиТСР = Перечисления.РСК_СтатусыАктовВыдачи.Подготовлен;
			Иначе
				Акт.РСК_СтатусАктаВыдачиТСР = Перечисления.РСК_СтатусыАктовВыдачи.Создан;
			КонецЕсли;
		КонецЕсли; 
		Акт.РСК_Цена = Стр.Цена;
		Акт.РСК_Сумма = Акт.РСК_Количество * Акт.РСК_Цена;
		
		Попытка
			Акт.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Акт.ОбменДанными.Загрузка = Истина;
			Акт.Записать();
			ОбщегоНазначения.СообщитьПользователю("Не удалось провести " + Акт.Ссылка,Акт.Ссылка);
		КонецПопытки;
		
		стрАкт = Объект.Акты.Добавить();
		стрАкт.Акт = Акт.Ссылка;
		стрАкт.Количество = Стр.Количество;
		стрАкт.КлючСвязи = Стр.КлючСтроки;
		
	КонецЦикла;
	
	Если Отказ Тогда
		Объект.Акты.Очистить();
		ОтменитьТранзакцию();
	Иначе
		Записать();
		ЗафиксироватьТранзакцию();
	КонецЕсли;
	ОбновитьДоступностьЭлементов();
КонецПроцедуры



&НаКлиенте
//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура СоздатьАкты(Команда)
	СоздатьАктыНаСервере();
	ПоказатьПредупреждение(,"Готово!");
КонецПроцедуры

//Ввести направление
&НаКлиенте
//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура ЗагрузитьТаблицуРазнарядкиЗавершение(Результат, ДополнительныеПараметры) Экспорт 
    Если Результат = Неопределено Тогда
        Возврат;
    КонецЕсли;
    ЗагрузитьТаблицуРазнарядки(Результат);
КонецПроцедуры


&НаСервере
//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Функция ОрганизацияСоисполнителя()
	Если объект.Владелец <> РСК_ПовтИсп.ПолучитьПартнёра_Реамед() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

&НаСервере
//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура ОбновитьДоступностьЭлементов()

	Если Объект.Акты.Количество() > 0 Тогда
		Элементы.СоздатьАкты.Доступность = Ложь;
		Элементы.Импорт.Доступность = Ложь;
		Элементы.РеестрУдалитьВыделенныеСтроки.Доступность = Ложь;
		Элементы.РеестрКоличество.ТолькоПросмотр = Истина;
		Элементы.РеестрКоличество.ЦветФонаЗаголовка = Новый Цвет();
	КонецЕсли;

КонецПроцедуры // ОбновитьДоступностьЭлементов()

&НаКлиенте
//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура УдалитьВыделенныеСтроки(Команда)
	МассивУдаляемых = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.Реестр.ВыделенныеСтроки Цикл
		МассивУдаляемых.Добавить(Объект.Реестр.НайтиПоИдентификатору(ВыделеннаяСтрока));
	КонецЦикла;
	Для Каждого УдаляемаяСтрока Из МассивУдаляемых Цикл
		Объект.Реестр.Удалить(УдаляемаяСтрока);
	КонецЦикла;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура АктыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
    ДанныеСтроки = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
    //ИмяПоля = Сред(Поле.Имя, СтрДлина(Элемент.Имя)+1);
    ПоказатьЗначение(, ДанныеСтроки.Акт);		
КонецПроцедуры

&НаКлиенте
//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура РеестрВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    ДанныеСтроки = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
    ИмяПоля = Сред(Поле.Имя, СтрДлина(Элемент.Имя)+1);
	Если ИмяПоля <> "Количество" Тогда
		СтандартнаяОбработка = Ложь;
    	ПоказатьЗначение(, ДанныеСтроки[ИмяПоля]);		
	КонецЕсли;
КонецПроцедуры



