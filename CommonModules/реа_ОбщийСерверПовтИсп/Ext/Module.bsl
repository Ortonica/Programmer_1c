﻿
Функция ПолучитьПредопределенноеЗначение(Идентификатор, Параметр = Неопределено, СообщатьОбОшибке = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);		
	Если Идентификатор = "ДатаНачалаАвтоматическихРеализаций" Тогда
		Результат = Дата("30000101")
	Иначе
		Результат = Неопределено
	КонецЕсли; 
		
	Запрос = Новый Запрос( 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ПредопределенныеЗначения.Значение КАК Значение,
	|	ПредопределенныеЗначения.ЗначениеНеогрСтрока КАК ЗначениеНеогрСтрока
	|ИЗ
	|	РегистрСведений.реа_ПредопределенныеЗначения КАК ПредопределенныеЗначения
	|ГДЕ
	|	ПредопределенныеЗначения.Идентификатор = &Идентификатор
	|	И (ПредопределенныеЗначения.Параметр = НЕОПРЕДЕЛЕНО
	|			ИЛИ ПредопределенныеЗначения.Параметр = &Параметр)");
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Запрос.УстановитьПараметр("Параметр", Параметр);
	
	Выборка = Запрос.Выполнить().Выбрать();					   
	Если Выборка.Следующий() Тогда
		Если ЗначениеЗаполнено(Выборка.ЗначениеНеогрСтрока) Тогда
			Результат = Выборка.ЗначениеНеогрСтрока
		Иначе
			Результат = Выборка.Значение
		КонецЕсли		
	ИначеЕсли СообщатьОбОшибке Тогда
		ОписаниеОшибки = "Ошибка: не найдено предопределенное значение.
		|Идентификатор: " + Идентификатор + "
		|Параметр тип: " + ТипЗнч(Параметр) + "
		|Значение параметра " + Строка(Параметр) + "
		|
		|Пожалуйста, обратитесь к разработчику!";
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки)	
	КонецЕсли;               
	
	Возврат Результат
	
КонецФункции