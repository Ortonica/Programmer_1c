﻿//++ Конарев 26.01.2023  Определет настройки по указанному подразделению
Функция НаборНастроекДляПодразделения(Подразделение) Экспорт 
	
	Запрос = Новый Запрос; 
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РСК_НастройкиМониторингаСрокаЖизниРезерва.ЦКГ КАК ЦКГ,
	|	РСК_НастройкиМониторингаСрокаЖизниРезерва.Категория КАК Категория,
	|	РСК_НастройкиМониторингаСрокаЖизниРезерва.Приоритет КАК Приоритет
	|ИЗ
	|	РегистрСведений.РСК_НастройкиМониторингаСрокаЖизниРезерва КАК РСК_НастройкиМониторингаСрокаЖизниРезерва
	|ГДЕ
	|	РСК_НастройкиМониторингаСрокаЖизниРезерва.Подразделение = &Подразделение
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет";
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции  

//Определяет приоритет заказа по настройкам мониторинга сроков жизни резерва
Функция ПриоритетЗаказаПоНастройкам(Партнер, Подразделение) Экспорт
	
	ЗаданныеНастройки = НаборНастроекДляПодразделения(Подразделение);     
	
	Для Каждого СтрокаНастройки Из ЗаданныеНастройки Цикл 
				
		Если НЕ ЗначениеЗаполнено(СтрокаНастройки.ЦКГ) И НЕ ЗначениеЗаполнено(СтрокаНастройки.Категория) Тогда
			Возврат СтрокаНастройки.Приоритет; 
		КонецЕсли;  
		
		ЦКГСоответствуетУсловию 	  = Истина;
		КатегорияСоответствуетУсловию = Истина;
		
		ЦКГСвойство 	  = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаНастройки.ЦКГ,"Владелец");
		КатегорияСвойство = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаНастройки.Категория,"Владелец"); 
		
		Если ЗначениеЗаполнено(СтрокаНастройки.ЦКГ) Тогда
			ЦКГПартнера = УправлениеСвойствами.ЗначениеСвойства(Партнер, ЦКГСвойство);
			ЦКГСоответствуетУсловию = (ЦКГПартнера = СтрокаНастройки.ЦКГ);
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаНастройки.Категория) Тогда
			КатегорияПартнера = УправлениеСвойствами.ЗначениеСвойства(Партнер, КатегорияСвойство);
	        КатегорияСоответствуетУсловию = (КатегорияПартнера = СтрокаНастройки.Категория);
		КонецЕсли;
		
		Если ЦКГСоответствуетУсловию И КатегорияСоответствуетУсловию Тогда
			Возврат	СтрокаНастройки.Приоритет;	
		КонецЕсли;
	КонецЦикла;  
	
	Возврат Неопределено;
	
КонецФункции