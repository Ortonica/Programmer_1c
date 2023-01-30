﻿
&ИзменениеИКонтроль("ОбновитьПредопределенныйВариантОтчета")
Функция РСК_ОбновитьПредопределенныйВариантОтчета(Режим, ОписаниеВарианта, Результат)
	
	НачатьТранзакцию();
	Попытка
		ВариантИзБазы = ОписаниеВарианта.ВариантИзБазы;
		Если Результат.ОбновлятьЗамеры Тогда
			Ключ = ?(ОписаниеВарианта.НайденВБазеДанных, ВариантИзБазы.КлючЗамеров, "");
			ЗарегистрироватьЗамерыВариантаКОбновлению(Ключ, ОписаниеВарианта.КлючЗамеров, ОписаниеВарианта.Наименование, Результат);
		КонецЕсли;
		Если ОписаниеВарианта.НайденВБазеДанных Тогда
			Если ВариантИзБазы.ПометкаУдаления = Истина // Описание получено => требуется снять пометку удаления
				Или ИзменилисьКлючевыеНастройкиПредопределенного(ОписаниеВарианта, ВариантИзБазы) Тогда
				Результат.ЕстьВажныеИзменения = Истина; // Перезапись ключевых настроек (потребуется обновление разделенных данных).
			ИначеЕсли Не ИзменилисьВторостепенныеНастройкиПредопределенного(ОписаниеВарианта, ВариантИзБазы) Тогда
				ЗафиксироватьТранзакцию();
				Возврат ВариантИзБазы.Ссылка;
			КонецЕсли;
			
			ВариантИзБазы = ОписаниеВарианта.ВариантИзБазы;
			
			Если Режим = "ОбщиеДанныеКонфигурации" Тогда
				ИмяТаблицы = "Справочник.ПредопределенныеВариантыОтчетов";
			ИначеЕсли Режим = "ОбщиеДанныеРасширений" Тогда
				ИмяТаблицы = "Справочник.ПредопределенныеВариантыОтчетовРасширений";
			КонецЕсли;
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ИмяТаблицы);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ВариантИзБазы.Ссылка);
			Блокировка.Заблокировать();
			
			ВариантОбъект = ВариантИзБазы.Ссылка.ПолучитьОбъект(); // СправочникОбъект.ПредопределенныеВариантыОтчетов, СправочникОбъект.ПредопределенныеВариантыОтчетовРасширений
			ВариантОбъект.Размещение.Очистить();
			Если ВариантОбъект.ПометкаУдаления Тогда
				ВариантОбъект.ПометкаУдаления = Ложь;
			КонецЕсли;
		Иначе
			Результат.ЕстьВажныеИзменения = Истина; // Регистрация нового (потребуется обновление разделенных данных).
			Если Режим = "ОбщиеДанныеКонфигурации" Тогда
				ВариантОбъект = Справочники.ПредопределенныеВариантыОтчетов.СоздатьЭлемент();
			ИначеЕсли Режим = "ОбщиеДанныеРасширений" Тогда
				ВариантОбъект = Справочники.ПредопределенныеВариантыОтчетовРасширений.СоздатьЭлемент();
			КонецЕсли;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ВариантОбъект, ОписаниеВарианта, 
			"Отчет, КлючВарианта, Включен, ВидимостьПоУмолчанию, ГруппироватьПоОтчету, Назначение");
		ПоляДляПоиска = ПоляДляПоиска(ВариантОбъект);
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
			МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
			
			Если ОбщегоНазначения.ЭтоОсновнойЯзык() Тогда
				ВариантОбъект.Наименование = ОписаниеВарианта.Наименование;
				ВариантОбъект.Описание     = ОписаниеВарианта.Описание;
			КонецЕсли;
			
			Если МодульМультиязычностьСервер.КодПервогоДополнительногоЯзыкаИнформационнойБазы() = ТекущийЯзык().КодЯзыка Тогда
				ВариантОбъект.НаименованиеЯзык1 = ?(ЗначениеЗаполнено(ОписаниеВарианта.Наименование), ОписаниеВарианта.Наименование,
					ВариантОбъект.Наименование);
				ВариантОбъект.ОписаниеЯзык1     = ?(ЗначениеЗаполнено(ОписаниеВарианта.Описание), ОписаниеВарианта.Описание,
					ВариантОбъект.Описание);
			КонецЕсли;
			
			Если МодульМультиязычностьСервер.КодВторогоДополнительногоЯзыкаИнформационнойБазы() = ТекущийЯзык().КодЯзыка Тогда
				ВариантОбъект.НаименованиеЯзык2 = ?(ЗначениеЗаполнено(ОписаниеВарианта.Наименование), ОписаниеВарианта.Наименование,
					ВариантОбъект.Наименование);
				ВариантОбъект.ОписаниеЯзык2     = ?(ЗначениеЗаполнено(ОписаниеВарианта.Описание), ОписаниеВарианта.Описание,
					ВариантОбъект.Описание);
			КонецЕсли;
		КонецЕсли;
		
		ПоляДляПоиска.Наименование = ОписаниеВарианта.Наименование;
		ПоляДляПоиска.Описание = ОписаниеВарианта.Описание;
		
		УстановитьПоляДляПоиска(ВариантОбъект, ПоляДляПоиска);
		
		ВариантОбъект.Родитель = ОписаниеВарианта.ВариантРодитель;
		#Вставка
		//++ РС Консалт: Трофимов Евгений 07.11.2022 Тикет 21731
		//e1cib/data/Документ.Задание?ref=b103112bebd786a8445289b23ad52d81
		УдалитьНеопределено = Ложь;
		//-- КонецТикета 21731		
		#КонецВставки
		
		РазмещениеВарианта = Новый Массив;
		Для Каждого Раздел Из ОписаниеВарианта.Размещение Цикл
			#Вставка
			//++ РС Консалт: Трофимов Евгений 07.11.2022 Тикет 21731
			//e1cib/data/Документ.Задание?ref=b103112bebd786a8445289b23ad52d81
			Если Раздел.Ключ = Неопределено Тогда
				УдалитьНеопределено = Истина;
				Продолжить;
			КонецЕсли;
			//-- КонецТикета 21731		
			#КонецВставки
			ПолноеИмя = ?(ТипЗнч(Раздел.Ключ) = Тип("Строка"), Раздел.Ключ, Раздел.Ключ.ПолноеИмя());
			РазмещениеВарианта.Добавить(ПолноеИмя);
		КонецЦикла;
		#Вставка
		//++ РС Консалт: Трофимов Евгений 07.11.2022 Тикет 21731
		//e1cib/data/Документ.Задание?ref=b103112bebd786a8445289b23ad52d81
		Если УдалитьНеопределено Тогда
			ОписаниеВарианта.Размещение.Удалить(Неопределено);
		КонецЕсли;
		//-- КонецТикета 21731		
		#КонецВставки
		ИдентификаторыПодсистем = ОбщегоНазначения.ИдентификаторыОбъектовМетаданных(РазмещениеВарианта);
		Для Каждого РазмещениеОтчета Из ОписаниеВарианта.Размещение Цикл
			СтрокаРазмещения = ВариантОбъект.Размещение.Добавить();
			ПолноеИмя = ?(ТипЗнч(РазмещениеОтчета.Ключ) = Тип("Строка"), РазмещениеОтчета.Ключ, РазмещениеОтчета.Ключ.ПолноеИмя());
			СтрокаРазмещения.Подсистема = ИдентификаторыПодсистем[ПолноеИмя];
			СтрокаРазмещения.Важный  = (НРег(РазмещениеОтчета.Значение) = НРег("Важный"));
			СтрокаРазмещения.СмТакже = (НРег(РазмещениеОтчета.Значение) = НРег("СмТакже"));
		КонецЦикла;
		
		Если Результат.ОбновлятьЗамеры Тогда
			ВариантОбъект.КлючЗамеров = ОписаниеВарианта.КлючЗамеров;
		КонецЕсли;
		
		Результат.ЕстьИзменения = Истина;
		ЗаписатьПредопределенный(ВариантОбъект);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат ВариантОбъект.Ссылка;
КонецФункции

&ИзменениеИКонтроль("ОписаниеВарианта")
Функция РСК_ОписаниеВарианта(Настройки, Отчет, КлючВарианта)
	Если ТипЗнч(Отчет) = Тип("СтрокаТаблицыЗначений") Тогда
		ОписаниеОтчета = Отчет;
	Иначе
		ОписаниеОтчета = ОписаниеОтчета(Настройки, Отчет);
	КонецЕсли;

	Если Настройки.Найти(ОписаниеОтчета.Тип, "Тип") = Неопределено Тогда 
		Возврат ОписаниеОтчета;
	КонецЕсли;

	МетаданныеОтчета = ОписаниеОтчета.Метаданные; // ОбъектМетаданныхОтчет
	КлючВариантаОтчета = ?(ПустаяСтрока(КлючВарианта), ОписаниеОтчета.ОсновнойВариант, КлючВарианта);

	Поиск = Новый Структура("Отчет, КлючВарианта, ЭтоВариант", ОписаниеОтчета.Отчет, КлючВариантаОтчета, Истина);
	Результат = Настройки.НайтиСтроки(Поиск);
	#Вставка
	//++ РС Консалт: Трофимов Евгений 13.01.2023 Тикет 22980
	//e1cib/data/Документ.Задание?ref=81529cd3f0b97b57465a80b14c432f11
	//Обход некритичной ошибки при обновлении релиза
	Если Результат.Количество() <> 1 Тогда
		ФейкОтвет = Новый Структура;
		Для Каждого Колонка Из Настройки.Колонки Цикл
			Если Настройки.Количество() = 0 Тогда
				ФейкОтвет.Вставить(Колонка.Имя);
			Иначе
				ФейкОтвет.Вставить(Колонка.Имя, РСК_ВызовСервера.ПустоеЗначение(Настройки[0][Колонка.Имя]));
			КонецЕсли;
		КонецЦикла;
		Возврат ФейкОтвет;
	КонецЕсли;
	//-- КонецТикета 22980	
	#КонецВставки

	Если Результат.Количество() <> 1 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Недопустимое значение параметра %1 в функции %2:
		|вариант ""%3"" отсутствует в отчете ""%4"".';
		|en = 'Invalid value of ""%1"" parameter specified. Procedure %2.
		|Report ""%4"" is missing option ""%3"".'"),
		"КлючВарианта", "ВариантыОтчетов.ОписаниеВарианта", КлючВариантаОтчета, МетаданныеОтчета.Имя);
	КонецЕсли;

	ЗаполнитьОписаниеСтрокиВарианта(Результат[0], ОписаниеОтчета);

	Возврат Результат[0];
КонецФункции
