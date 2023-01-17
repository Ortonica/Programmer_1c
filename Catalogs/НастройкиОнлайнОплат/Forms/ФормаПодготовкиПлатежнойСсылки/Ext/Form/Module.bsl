﻿
&НаСервере
Процедура РСК_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(ДоставкаЧекаТелефон) тогда
		ВариантОтправки = "Телефон";
	КонецЕсли;  
	//++РС Консалт Петрова Мария 
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ЗаказКлиентаЭтапыГрафикаОплаты.ВариантОплаты КАК ВариантОплаты,
	|	ЗаказКлиентаЭтапыГрафикаОплаты.СуммаПлатежа КАК Сумма
	|ИЗ
	|	Документ.ЗаказКлиента.ЭтапыГрафикаОплаты КАК ЗаказКлиентаЭтапыГрафикаОплаты
	|ГДЕ
	|	ЗаказКлиентаЭтапыГрафикаОплаты.Ссылка = &Ссылка"); 
	Запрос.УстановитьПараметр("Ссылка", ОснованиеПлатежа);   
	Результат = Запрос.Выполнить().Выгрузить();
	н = 0;
	для каждого стр из Результат цикл 
		н = н + 1;
		НовСтр = ТаблицаОплат.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр,стр);
		НовСтр.Ссылка = "Сформировать ссылку";  
		НовСтр.УИП = ПолучитьУникальныйИдентификаторПлатежа();   
		НовСтр.УИП = Лев(НовСтр.УИП,СтрДлина(НовСтр.УИП) - СтрДлина(н));     
		НовСтр.УИП = НовСтр.УИП + Строка(н);
	КонецЦикла;
	Элементы.ТаблицаОплат.Видимость = ТаблицаОплат.Количество() > 1;
КонецПроцедуры

&НаКлиенте
Процедура РСК_ТаблицаОплатВыборПосле(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)     
	Если Поле.Имя = "ТаблицаОплатСсылка" тогда 
		ТекущаяСтрока = Элементы.ТаблицаОплат.ТекущиеДанные;  
		Если ТекущаяСтрока.Сумма <> 0 тогда 
			НачатьФормированиеПлатежнойСсылки_Строка(ТекущаяСтрока.Сумма, ТекущаяСтрока.УИП);    
			ЗаполнитьДанныеОснованияПлатежаВСервисе_Строка(ТекущаяСтрока.УИП);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НачатьФормированиеПлатежнойСсылки_Строка(Сумма,УИП, Знач ОписаниеОповещения = Неопределено)
	
	ОчиститьСообщения();
	КонтактныеДанныеЧека = КонтактныеДанныеЧека();
	
	Если Не ПроверитьВозможностьФормированияПлатежнойСсылки(КонтактныеДанныеЧека) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = "ПлатежнаяСсылка";
	ВходящиеПараметры = Новый Структура;
	ВходящиеПараметры.Вставить("ОснованиеПлатежа", ОснованиеПлатежа);
	ВходящиеПараметры.Вставить("НастройкаОнлайнОплаты", НастройкаОнлайнОплаты);
	ВходящиеПараметры.Вставить("КонтактныеДанныеЧека", КонтактныеДанныеЧека);
	ВходящиеПараметры.Вставить("СуммаСтроки", Сумма);    
	ВходящиеПараметры.Вставить("УИП", УИП);
	
	ДлительнаяОперация = ФормированиеПлатежнойСсылкиВСервисе(ВходящиеПараметры, УникальныйИдентификатор);
	
	Элементы.ДекорацияПояснениеКФорме.Заголовок = НСтр("ru = 'Ожидание формирования платежной ссылки.';
														|en = 'Pending the payment link generation.'");
	ОжидатьЗавершенияМетодаСервиса(ИмяМетода, ДлительнаяОперация, ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьУникальныйИдентификаторПлатежа()
	
	Префикс = ПолучитьПрефиксДляУИП(ОснованиеПлатежа.Ссылка);
	Дата = Формат(ОснованиеПлатежа.Дата, "ДФ=yyMM");
	Номер = СтрЗаменить(ОснованиеПлатежа.Номер, "-", "");
	Код = Строка(Префикс) + Строка(Дата) + Строка(Номер);
	УИН = ПолучитьУникальныйИдентификаторПлатежаСКонтрольнымРазрядом(Код);
	
	Возврат УИН;
	
КонецФункции

&НаСервере
Функция ПолучитьПрефиксДляУИП(Ссылка)
	
	Соответствие = Новый Соответствие();
	Соответствие.Вставить("ЗаказКлиента",        "ЗК");
	Соответствие.Вставить("СчетНаОплатуКлиенту", "СЧ");
	
	Возврат Соответствие[Ссылка.Метаданные().Имя];
	
КонецФункции     

&НаСервере
Функция ПолучитьУникальныйИдентификаторПлатежаСКонтрольнымРазрядом(Код,Сдвиг = Неопределено)
	
	//Конец замены
	Если СтрДлина(Код)<20 Тогда
		СтрокаКода = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Код,20,"0","Справа");
	Иначе
		СтрокаКода = Лев(Код,20);
	КонецЕсли;
		
	Возврат СтрокаКода;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьДанныеОснованияПлатежаВСервисе_Строка(УИП)
	
	ИмяМетода = "ДанныеОснованияПлатежаВСервисе";
	
	ВходящиеПараметры = Новый Структура;
	ВходящиеПараметры.Вставить("ОснованиеПлатежа", ОснованиеПлатежа);
	ВходящиеПараметры.Вставить("НастройкаОнлайнОплаты", НастройкаОнлайнОплаты); 
	ВходящиеПараметры.Вставить("УИП", УИП);

	
	ДлительнаяОперация = ДанныеОснованияПлатежаВСервисе(ВходящиеПараметры, УникальныйИдентификатор); 
	
	Элементы.ДекорацияПояснениеКФорме.Заголовок = НСтр("ru = 'Ожидание ответа сервиса о текущем состоянии счета.';
														|en = 'Waiting for service response about the current account state.'");
	ОжидатьЗавершенияМетодаСервиса(ИмяМетода, ДлительнаяОперация);
	
КонецПроцедуры

