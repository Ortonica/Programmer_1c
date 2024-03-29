﻿
&НаСервере
Процедура РСК_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	//++ РС Консалт: Трофимов Евгений 01.11.2022 Задача 21414
	//e1cib/data/Документ.Задание?ref=b3ff9ccd1442090a40674c6b43454ea1
	ОбновитьВидимостьЭлементовПолучателяТСР();
	//-- КонецЗадачи 21414
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 01.11.2022 Задача 21414
//e1cib/data/Документ.Задание?ref=b3ff9ccd1442090a40674c6b43454ea1
&НаСервере
Процедура ОбновитьВидимостьЭлементовПолучателяТСР()

	Элементы.РСК_СНИЛС.Видимость = Объект.РСК_ЭтоПолучательТСР;
	Элементы.РСК_СтатусПолучателяТСР.Видимость = Объект.РСК_ЭтоПолучательТСР;
	Элементы.РСК_ДокументУЛ.Видимость = Объект.РСК_ЭтоПолучательТСР;
	Элементы.РСК_ПаллиативнаяПомощь.Видимость = Объект.РСК_ЭтоПолучательТСР;

КонецПроцедуры // ОбновитьВидимостьЭлементовПолучателяТСР()

//++ РС Консалт: Трофимов Евгений 01.11.2022 Задача 21414
//e1cib/data/Документ.Задание?ref=b3ff9ccd1442090a40674c6b43454ea1
&НаКлиенте
Процедура РСК_РСК_ЭтоПолучательТСРПриИзмененииПосле(Элемент)
	ОбновитьВидимостьЭлементовПолучателяТСР();
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 01.11.2022 Задача 21414
//e1cib/data/Документ.Задание?ref=b3ff9ccd1442090a40674c6b43454ea1
&НаКлиенте
Процедура РСК_РСК_СтатусПолучателяТСРПриИзмененииПосле(Элемент)
	Если Объект.РСК_СтатусПолучателяТСР = ПредопределенноеЗначение("Перечисление.РСК_СтатусыПолучателяТСР.Умер") Тогда
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПослеВопросаОбАннулированииАктовВыдачиТСР", ЭтаФорма), 
			"Аннулировать подготовленные акты выдачи?",
			РежимДиалогаВопрос.ДаНет
		);
	КонецЕсли;
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 01.11.2022 Задача 21414
//e1cib/data/Документ.Задание?ref=b3ff9ccd1442090a40674c6b43454ea1
&НаКлиенте
Процедура ПослеВопросаОбАннулированииАктовВыдачиТСР(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Парам = Новый Структура("СлужебноеИспользование");
	Парам.Вставить("Партнер", Объект.Ссылка);
	ОткрытьФорму("Обработка.РСК_ОтменаАктовПриСмертиПолучателяТСР.Форма.Форма", Парам, ЭтаФорма);
	
КонецПроцедуры

// Кнопка Телефоны для СМС
//++ РС Консалт: Трофимов Евгений 05.11.2022 Задача 21666
//e1cib/data/Документ.Задание?ref=9c32d5284cfd59a04da1fbac6171ed0a
&НаКлиенте
Процедура РСК_ТелефоныДляСМСПосле(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПоказатьПредупреждение(,"Сначала нужно записать карточку Партнёра");
		Возврат;
	КонецЕсли;
	
	Парам = Новый Структура;
	Парам.Вставить("АдресТаблицыТелефонов", ПолучитьАдресТаблицыТелефонов());
	Парам.Вставить("Партнер", Объект.Ссылка);
	ОткрытьФорму(
		"Справочник.Партнеры.Форма.РСК_ТелефоныДляСМС",
		Парам,
		ЭтаФорма,,,, 
		Новый ОписаниеОповещения("ПослеУказанияТелефоновДляСМС", ЭтаФорма), 
	);
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 05.11.2022 Задача 21666
//e1cib/data/Документ.Задание?ref=9c32d5284cfd59a04da1fbac6171ed0a
&НаКлиенте
Процедура ПослеУказанияТелефоновДляСМС(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьФлагиОтправкиСМСдляТелефонов(Результат.АдресТаблицыТелефонов);

КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 05.11.2022 Задача 21666
//e1cib/data/Документ.Задание?ref=9c32d5284cfd59a04da1fbac6171ed0a
&НаСервере
Процедура УстановитьФлагиОтправкиСМСдляТелефонов(АдресТаблицыТелефонов)

	тзТелефоны = ПолучитьИзВременногоХранилища(АдресТаблицыТелефонов);
	НЗ = РегистрыСведений.РСК_ТелефоныДляРассылкиСМС.СоздатьНаборЗаписей();
	НЗ.Отбор.Партнер.Установить(Объект.Ссылка);
	НЗ.Записать();
	
	Для Каждого Стр Из тзТелефоны Цикл
		Запись = НЗ.Добавить();
		Запись.Партнер = Объект.Ссылка;
		Запись.НомерТелефона = Стр.НомерТелефона;
	КонецЦикла;
	НЗ.Записать();

КонецПроцедуры // УстановитьФлагиОтправкиСМСдляТелефонов()


// Получает адрес временного хранилища таблыцы телефонов
//++ РС Консалт: Трофимов Евгений 05.11.2022 Задача 21666
//e1cib/data/Документ.Задание?ref=9c32d5284cfd59a04da1fbac6171ed0a
&НаСервере
Функция ПолучитьАдресТаблицыТелефонов()

	тзТелефоны = Объект.КонтактнаяИнформация.Выгрузить(
		Новый Структура("Вид", Справочники.ВидыКонтактнойИнформации.ТелефонПартнера),
		"НомерТелефона"
	);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РСК_ТелефоныДляРассылкиСМС.НомерТелефона КАК НомерТелефона
		|ИЗ
		|	РегистрСведений.РСК_ТелефоныДляРассылкиСМС КАК РСК_ТелефоныДляРассылкиСМС
		|ГДЕ
		|	РСК_ТелефоныДляРассылкиСМС.Партнер = &Партнер";
	
	Запрос.УстановитьПараметр("Партнер", Объект.Ссылка);
	тзТелефоны.Колонки.Добавить("ДляСМС", Новый ОписаниеТипов("Булево"));
	
	МассивДляСМС = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("НомерТелефона");
	Для Каждого Стр Из тзТелефоны Цикл
		ИндексМассива = МассивДляСМС.Найти(Стр.НомерТелефона);
		Если ИндексМассива <> Неопределено Тогда
			Стр.ДляСМС = Истина;
			МассивДляСМС.Удалить(ИндексМассива);
		КонецЕсли;
	КонецЦикла;
	Для Каждого НомерТелефона Из МассивДляСМС Цикл
		Стр = тзТелефоны.Добавить();
		Стр.НомерТелефона = НомерТелефона;
		Стр.ДляСМС = Истина;
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(тзТелефоны, УникальныйИдентификатор);

КонецФункции // ПолучитьАдресТаблиыТелефонов()

