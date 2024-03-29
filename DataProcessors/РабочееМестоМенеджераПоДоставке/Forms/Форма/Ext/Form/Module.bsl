﻿
&НаСервере
&ИзменениеИКонтроль("СохранитьЗаданиеВСтроке")
Процедура РСК_СохранитьЗаданиеВСтроке(СтрокаЗадание, ПометитьНаУдаление)

	Если СтрокаЗадание = Неопределено Тогда
		СтрокаЗадание = СтрокаЗаданиеПоСтрокеПункта(ЗаданияНаПеревозкуПланируемые.НайтиПоИдентификатору(Элементы.ЗаданияНаПеревозкуПланируемые.ТекущаяСтрока));
	КонецЕсли;

	Если Не СтрокаЗадание.Модифицирован Тогда
		Возврат;
	КонецЕсли;
	ИДСтрокаЗадание = СтрокаЗадание.ПолучитьИдентификатор();
	НовоеЗадание = НЕ ЗначениеЗаполнено(СтрокаЗадание.Ссылка)
	Или НЕ ОбщегоНазначения.СсылкаСуществует(СтрокаЗадание.Ссылка);

	Если НовоеЗадание Тогда
		ДокОбъект = Документы.ЗаданиеНаПеревозку.СоздатьДокумент();
		Если ЗначениеЗаполнено(СтрокаЗадание.Ссылка) Тогда
			ДокОбъект.УстановитьСсылкуНового(СтрокаЗадание.Ссылка);
		КонецЕсли;
		ДокОбъект.Заполнить(Неопределено);
		ДокОбъект.Дата		= ТекущаяДатаСеанса();
		ДокОбъект.Приоритет = Справочники.Приоритеты.ПолучитьПриоритетПоУмолчанию(ДокОбъект.Приоритет);
		ДокОбъект.Статус	= Перечисления.СтатусыЗаданийНаПеревозку.Формируется;
		ДокОбъект.Операция  = ВидДоставки;
	Иначе
		Попытка
			ДокОбъект = СтрокаЗадание.Ссылка.ПолучитьОбъект();
			Если ПроверитьСообщитьЗаданиеИзменено(СтрокаЗадание) Тогда
				// Ожидается что пользователь получит сообщение об ошибке и нажимет кнопку "Обновить список".
				// При обновлении списка производится запись заданий с признаком модифицированности. По этой причине
				// снимается признак модифицированности с задания которое невозможно записать.
				УстановитьМодифицированность(СтрокаЗадание, ЗаданияМодифицированы, Ложь);
				Возврат;
			КонецЕсли;
			ДокОбъект.Заблокировать();
		Исключение
			Текст = НСтр("ru = 'Не удалось заблокировать %Задание% для изменений.';
			|en = 'Cannot lock %Задание% for editing.'");
			Текст = СтрЗаменить(Текст,"%Задание%", ДокОбъект.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ДокОбъект.Ссылка);
			Возврат;
		КонецПопытки;
	КонецЕсли;

	ДокОбъект.ТранспортноеСредство      = СтрокаЗадание.Транспорт;
	ДокОбъект.ДатаВремяРейсаПланС       = СтрокаЗадание.ВремяС;
	ДокОбъект.ДатаВремяРейсаПланПо      = СтрокаЗадание.ВремяПо;
	ДокОбъект.ДополнительнаяИнформация  = СтрокаЗадание.ДополнительнаяИнформация;
	ДокОбъект.Перевозчик                = СтрокаЗадание.Перевозчик;
	ДокОбъект.Контрагент                = СтрокаЗадание.Контрагент;
	ДокОбъект.БанковскийСчетПеревозчика = СтрокаЗадание.БанковскийСчетПеревозчика;
	ДокОбъект.ЗаданиеВыполняет          = СтрокаЗадание.ЗаданиеВыполняет;
	ДокОбъект.Статус                    = Перечисления.СтатусыЗаданийНаПеревозку.Формируется;

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТранспортныеСредства.Код КАК АвтомобильГосударственныйНомер,
	|	ТранспортныеСредства.Марка КАК АвтомобильМарка,
	|	ТранспортныеСредства.ВидПеревозки КАК ВидПеревозки,
	|	ТранспортныеСредства.Тип КАК АвтомобильТип,
	|	ТранспортныеСредства.ВместимостьВКубическихМетрах КАК АвтомобильВместимостьВКубическихМетрах,
	|	ТранспортныеСредства.ГрузоподъемностьВТоннах КАК АвтомобильГрузоподъемностьВТоннах,
	|	ТранспортныеСредства.ЛицензионнаяКарточкаВид КАК ЛицензионнаяКарточкаВид,
	|	ТранспортныеСредства.ЛицензионнаяКарточкаНомер КАК ЛицензионнаяКарточкаНомер,
	|	ТранспортныеСредства.ЛицензионнаяКарточкаРегистрационныйНомер КАК ЛицензионнаяКарточкаРегистрационныйНомер,
	|	ТранспортныеСредства.ЛицензионнаяКарточкаСерия КАК ЛицензионнаяКарточкаСерия,
	|	ТранспортныеСредства.Прицеп КАК Прицеп,
	|	ТранспортныеСредства.ГосударственныйНомерПрицепа КАК ГосударственныйНомерПрицепа
	|ИЗ
	|	Справочник.ТранспортныеСредства КАК ТранспортныеСредства
	|ГДЕ
	|	ТранспортныеСредства.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	ТипыТранспортныхСредств.Наименование,
	|	ТипыТранспортныхСредств.ВместимостьВКубическихМетрах,
	|	ТипыТранспортныхСредств.ГрузоподъемностьВТоннах,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО
	|ИЗ
	|	Справочник.ТипыТранспортныхСредств КАК ТипыТранспортныхСредств
	|ГДЕ
	|	ТипыТранспортныхСредств.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", СтрокаЗадание.Транспорт);
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ДокОбъект, Выборка);
	КонецЕсли;

	Если ТипЗнч(СтрокаЗадание.Склад) = Тип("Строка")
		ИЛИ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаЗадание.Склад,"ЭтоГруппа") = Истина Тогда
		ДокОбъект.Склад = Склад;
	Иначе
		ДокОбъект.Склад = СтрокаЗадание.Склад;
	КонецЕсли;
	ДокОбъект.Маршрут.Очистить();
	Для Каждого ПунктЗадания Из СтрокаЗадание.ПолучитьЭлементы() Цикл
		СтрокаТЧ = ДокОбъект.Маршрут.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, ПунктЗадания);
		#Вставка
		//++ РС Консалт: Минаков А.С. Задача 20226
		СтрокаТЧ.Доставлено = Истина;
		//++ РС Консалт: Минаков А.С. Задача 20226
		#КонецВставки
	КонецЦикла;
	
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 20226
	Соотв = ДокОбъект.Распоряжения.Выгрузить(, "Распоряжение, РСК_Накладная");
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки
	ДокОбъект.Распоряжения.Загрузить(Объект.РаспоряженияВЗаданияхНаПеревозку.Выгрузить(Новый Структура("Ссылка",СтрокаЗадание.Ссылка)));
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 20226
	Для Каждого СтрокаТЧ Из ДокОбъект.Распоряжения Цикл 
		СтрокаТЧ.Доставлено = Истина;
		СтараяСтрока = Соотв.Найти(СтрокаТЧ.Распоряжение, "Распоряжение");
		Если Не СтараяСтрока = Неопределено Тогда
			СтрокаТЧ.РСК_Накладная = СтараяСтрока.РСК_Накладная
		КонецЕсли
	КонецЦикла;
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки

	ДокОбъект.ДополнительныеСвойства.Вставить("ТоварыКДоставке", ТоварыКДоставке.Выгрузить((Новый Структура("ЗаданиеНаПеревозку",СтрокаЗадание.Ссылка))));

	Если ПометитьНаУдаление Тогда
		ДокОбъект.ПометкаУдаления = Истина;
		ДокОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	Иначе
		ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;

	Если НовоеЗадание Тогда
		ИсторияРаботыПользователя.Добавить(ДокОбъект.Ссылка);
	КонецЕсли;
	ДокОбъект.Разблокировать();

	СтрокаЗадание.ПорядокВМаршруте	= ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокОбъект.Ссылка, "Номер"), Истина, Истина);
	СтрокаЗадание.Ссылка            = ДокОбъект.Ссылка;
	СтрокаЗадание.ВерсияДанных      = ДокОбъект.ВерсияДанных;
	СтрокаЗадание.Модифицирован		= Ложь;

КонецПроцедуры

&НаСервере
&ИзменениеИКонтроль("ПеренестиСтрокиСервер")
Функция РСК_ПеренестиСтрокиСервер(ИДСтрокиНазначения)

	МассивИДВыбранныхСтрок = Элементы.РаспоряженияНаДоставку.ВыделенныеСтроки;
	СтрокаНазначения = ЗаданияНаПеревозкуПланируемые.НайтиПоИдентификатору(ИДСтрокиНазначения);
	СтрокаЗадание = СтрокаЗаданиеПоСтрокеПункта(СтрокаНазначения);
	ПунктыТекущегоЗаданияНаПеревозку = СтрокаЗадание.ПолучитьЭлементы();

	Если Не ПопытатьсяЗаблокироватьПолучитьСсылкуПоСтрокеЗадания(СтрокаЗадание) Тогда
		Возврат Новый Массив;
	КонецЕсли;

	Если ПроверитьСообщитьЗаданиеИзменено(СтрокаЗадание) Тогда
		Возврат Новый Массив;
	КонецЕсли;
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 20226
	ПараметрыОбновленияОрдера = РСК_ВызовСервера.ПараметрыОбновленияОрдера();
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки

	РаспоряженияКорневыеСтроки = РаспоряженияНаДоставку.ПолучитьЭлементы();

	ИзмененныеДобавленныеСтрокиРаспоряжений = Новый Массив;
	РаспоряженияСОсобымиУсловиями = Новый Массив;
	Для каждого ИДСтроки Из МассивИДВыбранныхСтрок Цикл

		ТекущаяСтрокаРаспоряжений = РаспоряженияНаДоставку.НайтиПоИдентификатору(ИДСтроки);

		// Если текущую строку уже удалили вместе с родителем
		Если ТекущаяСтрокаРаспоряжений = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		ВершинаТекущейВеткиРаспоряжений = ТекущаяСтрокаРаспоряжений.ПолучитьРодителя();

		// Если в выбранных строках есть родитель этой строки, ничего не делаем, строка будет обработана вместе с родителем.
		Если ВершинаТекущейВеткиРаспоряжений <> Неопределено
			И МассивИДВыбранныхСтрок.Найти(ВершинаТекущейВеткиРаспоряжений.ПолучитьИдентификатор())<>Неопределено Тогда
			Продолжить;
		КонецЕсли;

		Если ВершинаТекущейВеткиРаспоряжений = Неопределено Тогда
			ТекущаяВеткаРаспоряжений = ТекущаяСтрокаРаспоряжений.ПолучитьЭлементы();
			ВершинаТекущейВеткиРаспоряжений = ТекущаяСтрокаРаспоряжений;
		Иначе
			ТекущаяВеткаРаспоряжений = ВершинаТекущейВеткиРаспоряжений.ПолучитьЭлементы();
		КонецЕсли;

		КоллекцияПодчиненныхСтрок = ТекущаяСтрокаРаспоряжений.ПолучитьЭлементы();

		Если КоллекцияПодчиненныхСтрок.Количество() = 0 Тогда
			КоллекцияПодчиненныхСтрок = Новый Массив(1);
			КоллекцияПодчиненныхСтрок[0] = ТекущаяСтрокаРаспоряжений;
			Если ЗонаГруппаИлиПустая Тогда
				ТекущаяСтрокаРаспоряжений.ПолучитьРодителя().Вес = ТекущаяСтрокаРаспоряжений.ПолучитьРодителя().Вес - ТекущаяСтрокаРаспоряжений.Вес;
				ТекущаяСтрокаРаспоряжений.ПолучитьРодителя().Объем = ТекущаяСтрокаРаспоряжений.ПолучитьРодителя().Объем - ТекущаяСтрокаРаспоряжений.Объем;
			КонецЕсли;
		КонецЕсли;

		ИтогоВес = ИтогоВес - ТекущаяСтрокаРаспоряжений.Вес;
		ИтогоОбъем = ИтогоОбъем - ТекущаяСтрокаРаспоряжений.Объем;
		СтрокаЗадание.Вес = СтрокаЗадание.Вес + ТекущаяСтрокаРаспоряжений.Вес;
		СтрокаЗадание.Объем = СтрокаЗадание.Объем + ТекущаяСтрокаРаспоряжений.Объем;

		Для Каждого СтрокаРаспоряжений Из КоллекцияПодчиненныхСтрок Цикл
			#Вставка
			//++ РС Консалт: Минаков А.С. Задача 20226
			ПараметрыОбновленияОрдера.Распоряжение = СтрокаРаспоряжений.Распоряжение;
			ПараметрыОбновленияОрдера.ДатаОтгрузки = СтрокаРаспоряжений.Дата;
			ПараметрыОбновленияОрдера.Склад = СтрокаРаспоряжений.Склад;
			
			РСК_ВызовСервера.ВыполнитьПроверкуИзменениеОрдера(ПараметрыОбновленияОрдера, Ложь);
			//++ РС Консалт: Минаков А.С. Задача 20226
			#КонецВставки
			СтрокаМаршрута = Неопределено;

			// Возможно, распоряжение уже есть в задании, тогда новая строка не добавляется
			СтруктураПоиска = Новый Структура("Ссылка, Склад, Распоряжение",
			СтрокаЗадание.Ссылка, СтрокаРаспоряжений.Склад, СтрокаРаспоряжений.Распоряжение);
			НайденныеСтроки = Объект.РаспоряженияВЗаданияхНаПеревозку.НайтиСтроки(СтруктураПоиска);
			РаспоряжениеУжеВЗадании = НайденныеСтроки.Количество() > 0;

			Если РаспоряжениеУжеВЗадании Тогда

				СтрокаРаспоряжениеВЗаданиях = НайденныеСтроки[0];
				СтрокаМаршрута = СтрокаПунктМаршрутаПоКлючу(СтрокаЗадание, СтрокаРаспоряжениеВЗаданиях.КлючСвязи);
				СтрокаРаспоряжениеВЗаданиях.Вес = СтрокаРаспоряжениеВЗаданиях.Вес + СтрокаРаспоряжений.Вес;
				СтрокаРаспоряжениеВЗаданиях.Объем = СтрокаРаспоряжениеВЗаданиях.Объем + СтрокаРаспоряжений.Объем;
				СтрокаМаршрута.Вес = СтрокаМаршрута.Вес + СтрокаРаспоряжений.Вес;
				СтрокаМаршрута.Объем = СтрокаМаршрута.Объем + СтрокаРаспоряжений.Объем;

			Иначе

				СтрокаМаршрута = ДоставкаТоваров.ДобавитьИзменитьПунктПоРеквизитамДоставки(ПунктыТекущегоЗаданияНаПеревозку,
				СтрокаРаспоряжений, СтрокаЗадание.ВремяС);
				СтрокаМаршрута.Ссылка = СтрокаЗадание.Ссылка;
				СтрокаМаршрута.ПереходДаты = 0;

				СтрокаЗадание.КоличествоРаспоряжений = СтрокаЗадание.КоличествоРаспоряжений + 1;
				СтрокаМаршрута.КоличествоРаспоряжений = СтрокаМаршрута.КоличествоРаспоряжений + 1;

			КонецЕсли;

			СтрокаМаршрута.ЭтоНашаДоставка = 1;
			СтрокаМаршрута.АдресЗначенияПолей = СтрокаРаспоряжений.АдресДоставкиЗначенияПолей;

			УстановитьМодифицированность(СтрокаМаршрута, ЗаданияМодифицированы);
			КлючСвязи = СтрокаМаршрута.КлючСвязи;
			ИДСтрокиНазначения = СтрокаМаршрута.ПолучитьИдентификатор();

			Если Не РаспоряжениеУжеВЗадании Тогда

				СтрокаРаспоряжениеВЗаданиях = Объект.РаспоряженияВЗаданияхНаПеревозку.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРаспоряжениеВЗаданиях, СтрокаРаспоряжений);
				СтрокаРаспоряжениеВЗаданиях.Ссылка = СтрокаЗадание.Ссылка;
				СтрокаРаспоряжениеВЗаданиях.КлючСвязи = КлючСвязи;
				СтрокаРаспоряжениеВЗаданиях.ЭтоПоручениеЭкспедитору = (СтрокаРаспоряжений.Распоряжение.Метаданные() = Метаданные.Документы.ПоручениеЭкспедитору);

			КонецЕсли;

			ИзмененныеДобавленныеСтрокиРаспоряжений.Добавить(СтрокаРаспоряжениеВЗаданиях);

			СтруктураПоиска = Новый Структура("ИдентификаторВДеревеРаспоряжений", СтрокаРаспоряжений.ПолучитьИдентификатор());
			СтрокиРаспоряженийСТоварами = ТоварыРаспоряженийКДоставке.НайтиСтроки(СтруктураПоиска);
			Для Каждого Стр Из СтрокиРаспоряженийСТоварами Цикл
				СтрокаТоварыКДоставке = ТоварыКДоставке.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТоварыКДоставке, Стр);
				СтрокаТоварыКДоставке.ЗаданиеНаПеревозку = СтрокаЗадание.Ссылка;
				ТоварыРаспоряженийКДоставке.Удалить(Стр);
			КонецЦикла;

			Если СтрокаРаспоряжений.ОсобыеУсловияПеревозки Тогда
				РаспоряженияСОсобымиУсловиями.Добавить(СтрокаРаспоряжений.Распоряжение);
			КонецЕсли;

		КонецЦикла;

		Если ВершинаТекущейВеткиРаспоряжений = ТекущаяСтрокаРаспоряжений Тогда
			РаспоряженияКорневыеСтроки.Удалить(ТекущаяСтрокаРаспоряжений);
		Иначе
			ТекущаяВеткаРаспоряжений.Удалить(ТекущаяСтрокаРаспоряжений);
			// Если удалили последний элемент в ветке, удалим родителя
			Если ТекущаяВеткаРаспоряжений.Количество() = 0 Тогда
				РаспоряженияКорневыеСтроки.Удалить(ВершинаТекущейВеткиРаспоряжений);
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;

	ПеренумероватьИЗаполнитьПризнакиПереходаДатВСпискеЗаданий(ИДСтрокиНазначения);
	ЗаполнитьСкладыПунктовИЗаданий();
	ДоставкаТоваров.ЗаполнитьПризнакиОформленияРаспоряжений(РаспоряженияНаДоставку, ЗонаГруппаИлиПустая);
	Элементы.ЗаданияНаПеревозкуПланируемые.ТекущаяСтрока = ИДСтрокиНазначения;
	УстановитьДоступностьЭлементов();

	ДоставкаТоваров.ЗаполнитьПризнакДоставляетсяПолностью(ТоварыКДоставке.Выгрузить((Новый Структура("ЗаданиеНаПеревозку",СтрокаЗадание.Ссылка))),
	Объект.РаспоряженияВЗаданияхНаПеревозку, ИзмененныеДобавленныеСтрокиРаспоряжений);
	СохранитьЗаданиеВСтроке(СтрокаЗадание);

	Возврат РаспоряженияСОсобымиУсловиями;

КонецФункции

&НаСервере
&ИзменениеИКонтроль("ОбновитьДокументыДляПеревозчиковСервер")
Процедура РСК_ОбновитьДокументыДляПеревозчиковСервер()

	ДокументыДляПеревозчиков.Очистить();
	Если НЕ ЗначениеЗаполнено(Склад) Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос(ТекстЗапросаДокументыДляПеревозчиков());
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Перевозчик", Перевозчик);
	Запрос.УстановитьПараметр("ПеревозчикНеЗаполнен", Не ЗначениеЗаполнено(Перевозчик));
	Запрос.УстановитьПараметр("ДатаНачала", ПериодДокументовДляПеревозчиков.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ПериодДокументовДляПеревозчиков.ДатаОкончания);
	Запрос.УстановитьПараметр("БезДатыНачала", Не ЗначениеЗаполнено(ПериодДокументовДляПеревозчиков.ДатаНачала));
	Запрос.УстановитьПараметр("БезДатыОкончания", Не ЗначениеЗаполнено(ПериодДокументовДляПеревозчиков.ДатаОкончания));
	#Удаление
	Запрос.УстановитьПараметр("СиламиПеревозчикаСоСклада", Перечисления.СпособыДоставки.СиламиПеревозчика); 
	#КонецУдаления
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 22756
	СиламиПеревозчикаСоСклада = Новый Массив(3);
	СиламиПеревозчикаСоСклада[0] = Перечисления.СпособыДоставки.СиламиПеревозчика;
	СиламиПеревозчикаСоСклада[1] = Перечисления.СпособыДоставки.РСК_ПеревозчикДоКлиента;
	СиламиПеревозчикаСоСклада[2] = Перечисления.СпособыДоставки.РСК_ПеревозчикДоПВЗ;
	Запрос.УстановитьПараметр("СиламиПеревозчикаСоСклада", СиламиПеревозчикаСоСклада);
	#КонецВставки

	Результат = Запрос.Выполнить().Выгрузить();
	ДокументыДляПеревозчиков.Загрузить(Результат);

КонецПроцедуры

&НаСервере
&ИзменениеИКонтроль("ТекстЗапросаДокументыДляПеревозчиков")
Функция РСК_ТекстЗапросаДокументыДляПеревозчиков()

	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТИПЗНАЧЕНИЯ(РаспоряженияНаДоставку.Распоряжение) КАК ВидДокумента,
	|	РаспоряженияНаДоставку.Распоряжение КАК Ссылка,
	|	РаспоряженияНаДоставку.Дата КАК Дата,
	|	РаспоряженияНаДоставку.ПолучательОтправитель,
	|	РаспоряженияНаДоставку.Адрес КАК АдресДоставки,
	|	РаспоряженияНаДоставку.Перевозчик КАК Перевозчик,
	|	РаспоряженияНаДоставку.Номер КАК Номер,
	|	РаспоряженияНаДоставку.Склад КАК Склад,
	|	ВЫРАЗИТЬ(РаспоряженияНаДоставку.ДополнительнаяИнформация КАК СТРОКА(1000)) КАК ДополнительнаяИнформация
	|ИЗ
	|	РегистрСведений.СостоянияИРеквизитыДоставки КАК РаспоряженияНаДоставку
	|ГДЕ
	|	(РаспоряженияНаДоставку.Перевозчик = &Перевозчик
	|			ИЛИ &ПеревозчикНеЗаполнен)
	#Удаление
	|	И РаспоряженияНаДоставку.СпособДоставки = &СиламиПеревозчикаСоСклада
	#КонецУдаления
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 22756
	|	И РаспоряженияНаДоставку.СпособДоставки В (&СиламиПеревозчикаСоСклада)
	#КонецВставки
	|	И РаспоряженияНаДоставку.Склад В ИЕРАРХИИ(&Склад)
	|	И (РаспоряженияНаДоставку.Дата <= &ДатаОкончания ИЛИ &БезДатыОкончания)
	|	И (РаспоряженияНаДоставку.Дата >= &ДатаНачала ИЛИ &БезДатыНачала)
	| УПОРЯДОЧИТЬ ПО РаспоряженияНаДоставку.Дата";

	Возврат ТекстЗапроса;

КонецФункции

