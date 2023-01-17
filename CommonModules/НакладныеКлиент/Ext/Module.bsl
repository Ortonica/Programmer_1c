﻿
&ИзменениеИКонтроль("ДанныеДляОформленияПоОрдерам")
Функция РСК_ДанныеДляОформленияПоОрдерам(ДанныеРаспоряжений, ИдентификаторыСтрок, ПоляГруппировки, СписокОшибок, ПолеОшибки, МетаданныеНакладных, ПоНоменклатуре)

	ГруппировкиРаспоряжений          = Новый Массив;
	ОдновременноОформляемыеНакладные = Новый Соответствие;
	ИдентификаторыЗначений           = Новый Соответствие;
	СтруктураПолейГруппировки        = Новый Структура(
	"Ссылка" + ?(ЗначениеЗаполнено(ПоляГруппировки), ",", "") + ПоляГруппировки);
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 20226
	ПроверкаРеквизитов = Неопределено;
	ПараметрыОбновленияОрдера = РСК_ВызовСервера.ПараметрыОбновленияОрдера();
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки

	Для Каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл

		Строка = ДанныеРаспоряжений.НайтиПоИдентификатору(ИдентификаторСтроки);
		#Вставка
		//++ РС Консалт: Минаков А.С. Задача 20226
		Если ПроверкаРеквизитов = Неопределено Тогда
			ПроверкаРеквизитов = Строка.Свойство("Ордер") И Строка.Свойство("СтатусСборки")	
		КонецЕсли;
		
		Если Строка.НакладнаяНаОтгрузку И ПроверкаРеквизитов Тогда	
			ПараметрыОбновленияОрдера.Ордер = Строка.Ордер;
			ПараметрыОбновленияОрдера.ЗаданиеНаПеревозку = Строка.ЗаданиеНаПеревозку;
			ПараметрыОбновленияОрдера.Распоряжение = Строка.Ссылка;
			ПараметрыОбновленияОрдера.Склад = Строка.Склад;
			ПараметрыОбновленияОрдера.ЗаполнитьЗадание = Истина;
			ПараметрыОбновленияОрдера.НовыйСтатус = "КОтгрузке";
			ПараметрыОбновленияОрдера.ИсключаемыеСтатусы = "КОтгрузке,Отгружен";
			ПараметрыОбновленияОрдера.ЗаполнитьПоОтбору = Истина;
			
			Отказ = Ложь;
			РСК_ВызовСервера.ВыполнитьПроверкуИзменениеОрдера(ПараметрыОбновленияОрдера, Отказ);
			Если Отказ Тогда
				Продолжить
			КонецЕсли;
			
			Если Строка.СостояниеОрдераНаОтгрузку = 1 Тогда
				Строка.СостояниеОрдераНаОтгрузку = 3	
			КонецЕсли	
		КонецЕсли;	
		//++ РС Консалт: Минаков А.С. Задача 20226
		#КонецВставки
		ТекстОшибки = "";

		Если Строка.НакладнаяНаОтгрузку И Строка.НакладнаяНаПриемку Тогда
			ПоОрдерам = НСтр("ru = 'по отгрузке (приемке)';
			|en = 'by shipment (receiving)'");
		ИначеЕсли Строка.НакладнаяНаОтгрузку Тогда
			ПоОрдерам = НСтр("ru = 'по отгрузке';
			|en = 'by shipment'");
		ИначеЕсли Строка.НакладнаяНаПриемку Тогда
			ПоОрдерам = НСтр("ru = 'по приемке';
			|en = 'by receiving'");
		КонецЕсли;

		Если (Строка.СостояниеОрдераНаОтгрузку = 0 Или Не Строка.НакладнаяНаОтгрузку)
			И (Строка.СостояниеОрдераНаПриемку = 0 Или Не Строка.НакладнаяНаПриемку) Тогда
			ТекстОшибки = НСтр("ru = 'Для распоряжения %1 невозможно оформить накладную %2, т.к. ордера соответствуют накладным.';
			|en = 'Cannot register the %2 invoice for the %1 reference as notes correspond to the invoices.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Строка.Ссылка, ПоОрдерам);
		ИначеЕсли (Строка.СостояниеОрдераНаОтгрузку = 1 Или Не Строка.НакладнаяНаОтгрузку)
			И (Строка.СостояниеОрдераНаПриемку = 1 Или Не Строка.НакладнаяНаПриемку) Тогда
			ТекстОшибки = НСтр("ru = 'Для распоряжения %1 невозможно оформить накладную %2, т.к. нет ни одного ордера.';
			|en = 'Cannot register the %2 invoice for the %1 reference as there are no notes.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Строка.Ссылка, ПоОрдерам);
		ИначеЕсли (Строка.СостояниеОрдераНаОтгрузку = 4 Или Не Строка.НакладнаяНаОтгрузку)
			И (Строка.СостояниеОрдераНаПриемку = 4 Или Не Строка.НакладнаяНаПриемку) Тогда
			ТекстОшибки = НСтр("ru = 'Для распоряжения %1 невозможно оформить накладную %2, т.к. ордера не используются.';
			|en = 'Cannot register the %2 invoice for the %1 reference as notes are not used.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Строка.Ссылка, ПоОрдерам);
		КонецЕсли;

		Если ПустаяСтрока(ТекстОшибки) Тогда
			Если Строка.СостояниеНакладной = 4 Тогда

				МассивКлючей = Новый Массив;
				Для каждого ЭлементСтруктуры Из СтруктураПолейГруппировки Цикл

					Идентификатор = ИдентификаторыЗначений.Получить(Строка[ЭлементСтруктуры.Ключ]);
					Если Идентификатор = Неопределено Тогда
						ИдентификаторыЗначений.Вставить(Строка[ЭлементСтруктуры.Ключ], Новый УникальныйИдентификатор);
						Идентификатор = ИдентификаторыЗначений.Получить(Строка[ЭлементСтруктуры.Ключ]);
					КонецЕсли;	

					МассивКлючей.Добавить(Идентификатор);

				КонецЦикла;	

				КлючДанных = СтрСоединить(МассивКлючей, "\");

				ДанныеОформляемыхНакладных = ОдновременноОформляемыеНакладные.Получить(КлючДанных);
				Если ДанныеОформляемыхНакладных = Неопределено Тогда
					ОдновременноОформляемыеНакладные.Вставить(КлючДанных, Новый Массив);
					ДанныеОформляемыхНакладных = ОдновременноОформляемыеНакладные.Получить(КлючДанных);
				КонецЕсли;

				ДанныеОформляемыхНакладных.Добавить(Строка);

			Иначе
				Группировка = ПолучитьГруппировку(ГруппировкиРаспоряжений, Строка, ПоляГруппировки, МетаданныеНакладных, Истина);
				Группировка.МассивЗаказов.Добавить(Строка.Ссылка);
				Группировка.ЕстьНакладные = Группировка.ЕстьНакладные Или (Строка.СостояниеНакладной <> 1);

				Если ПоНоменклатуре Тогда
					ДополнитьОтборПоТоварам(Группировка.ПоляЗаполнения, Строка.Ссылка, Строка.Номенклатура, Строка.Характеристика);
				КонецЕсли;	

			КонецЕсли;
		Иначе
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, ПолеОшибки, ТекстОшибки, Неопределено);
		КонецЕсли;

	КонецЦикла;

	Если ОдновременноОформляемыеНакладные.Количество() > 1 Или ЗначениеЗаполнено(ГруппировкиРаспоряжений) Тогда

		Для каждого ДанныеОформляемыхНакладных Из ОдновременноОформляемыеНакладные Цикл

			Строка = ДанныеОформляемыхНакладных.Значение[0];

			ТекстОшибки = НСтр("ru = 'Одновременное оформление %1 накладной %2 вместе с другими распоряжениями невозможно. Выберите накладную отдельно.';
			|en = 'Cannot register the %1 invoice %2 with other references simultaneously. Select the invoice separately.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, ПоОрдерам, Строка.Ссылка);

			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, ПолеОшибки, ТекстОшибки, Неопределено);

		КонецЦикла;	

	ИначеЕсли ОдновременноОформляемыеНакладные.Количество() = 1 Тогда

		Для каждого ДанныеОформляемыхНакладных Из ОдновременноОформляемыеНакладные Цикл

			Для каждого Строка Из ДанныеОформляемыхНакладных.Значение Цикл

				Группировка = ПолучитьГруппировку(ГруппировкиРаспоряжений, Строка, ПоляГруппировки, МетаданныеНакладных, Истина);
				Группировка.МассивЗаказов.Добавить(Строка.Ссылка);
				Группировка.Вставить("ЭтоНакладная", Истина);

				Если ПоНоменклатуре Тогда
					ДополнитьОтборПоТоварам(Группировка.ПоляЗаполнения, Строка.Ссылка, Строка.Номенклатура, Строка.Характеристика);
				КонецЕсли;

			КонецЦикла;

		КонецЦикла;	

	КонецЕсли;

	Если ГруппировкиРаспоряжений.Количество() = 0 И ИдентификаторыСтрок.Количество() > 1 Тогда

		ТекстОшибки = НСтр("ru = 'Не выбрано ни одного документа, который можно было бы оформить по ордерам.';
		|en = 'No documents selected which can be registered by notes.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, ПолеОшибки, ТекстОшибки, Неопределено);

	КонецЕсли;

	Возврат ГруппировкиРаспоряжений;

КонецФункции
