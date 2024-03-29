﻿
&Перед("ПередЗаписью")
Процедура РСК_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	//++ РС Консалт: Минаков А.С. Задача 20226
	Если Не ОбменДанными.Загрузка
		И ЗначениеЗаполнено(Ссылка)
		И Статус = Перечисления.СтатусыРасходныхОрдеров.Отгружен
		И НачалоДня(ДатаОтгрузки) < НачалоДня(ТекущаяДатаСеанса())
		И Не УправлениеДоступом.ЕстьРоль("РСК_РедактированиеСкладскихОрдеровПрошлыхПериодов") Тогда		
		
		ОбщегоНазначения.СообщитьПользователю("Недостаточно прав", Ссылка,,, Отказ)
	КонецЕсли;	
	//++ РС Консалт: Минаков А.С. Задача 20226
	
	//++ РС Консалт: Трофимов Евгений 24.12.2022 Задача 22673
	//e1cib/data/Документ.Задание?ref=9101d1f9ae8437de4cf0d52d47dd0665
	тзИсполнители = Ответственные.Выгрузить();
	УдаляемыеСтроки = Новый Массив;
	Для Каждого Стр Из тзИсполнители Цикл
		Если НЕ ЗначениеЗаполнено(Стр.Пользователь) Тогда
			УдаляемыеСтроки.Добавить(Стр);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
		тзИсполнители.Удалить(УдаляемаяСтрока);
	КонецЦикла;                                
	Ответственные.Загрузить(тзИсполнители);
	
	Если Ответственные.Количество() > 0 И НЕ ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Ответственные[0].Пользователь;
	КонецЕсли;
	//-- КонецЗадачи 22673
	
КонецПроцедуры
