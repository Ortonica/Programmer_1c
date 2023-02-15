﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДопСвойствоPayKeeperID = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("Имя", "РС_PayKeeperID");
	Если НЕ ЗначениеЗаполнено(ДопСвойствоPayKeeperID) Тогда
		Сообщить("Отсутствует доп. сведение ""РС_PayKeeperID""");
		Отказ = Истина;
		Возврат;
	КонецЕсли;   
	
	Если Не ЗначениеЗаполнено(Параметры.ОснованиеПлатежа) Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОснованиеПлатежа = Параметры.ОснованиеПлатежа;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РСК_НастройкиPayKeeper.Ссылка КАК Ссылка,
		|	РСК_НастройкиPayKeeper.Пользователь КАК Пользователь,
		|	РСК_НастройкиPayKeeper.Пароль КАК Пароль
		|ИЗ
		|	Справочник.РСК_НастройкиPayKeeper КАК РСК_НастройкиPayKeeper
		|ГДЕ
		|	РСК_НастройкиPayKeeper.Используется";
	ВДЗ = Запрос.Выполнить().Выбрать();
	Если ВДЗ.Следующий() Тогда  
		НастройкаОнлайнОплаты = Новый Структура;
		НастройкаОнлайнОплаты.Вставить("Пользователь", ВДЗ.Пользователь);
		НастройкаОнлайнОплаты.Вставить("Пароль", ВДЗ.Пароль);
	КонецЕсли;
	
	Если НастройкаОнлайнОплаты = Неопределено Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не обнаружены настройки подключения к PayKeeper';
													|en = 'PayKeeper connection settings are not found'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	PayKeeperID = УправлениеСвойствами.ЗначениеСвойства(ОснованиеПлатежа, ДопСвойствоPayKeeperID);
	ОбновлениеСтатусаСчета();
	
	// Заполняем контактную информация для отправки чеков
	ЗаполнитьСпискиКонтактнойИнформации();
	
	ТребуетсяОбновлениеДанныхВСервисе = Ложь;
	ТребуетсяОбновлениеКонтактнойИнформацииВСервисе = Ложь;
	ДанныеОснованияПлатежаВСервисеОбработаны = Ложь;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		ВариантОтправки = "ЭлектроннаяПочта";
	ИначеЕсли ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОтправкаSMS") Тогда
		ВариантОтправки = "Телефон";
	КонецЕсли;
	
	НастройкиШаблонов = ОнлайнОплатыСлужебный.НастройкиШаблоновСообщений();
	
	КлючПоложенияОкна = "";
	УправлениеЭлементамиФормыПоПодсистемам(КлючПоложенияОкна);
	
	ШаблонТекста = НСтр("ru = 'ОнлайнОплата.%1.%2';
						|en = 'ОнлайнОплата.%1.%2'");
	КлючСохраненияПоложенияОкна = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонТекста,
		ЭтотОбъект.Заголовок,
		КлючПоложенияОкна);
	
	ВосстановитьШаблоныПоУмолчанию();
	ОбновлениеОтображенияФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЭтотОбъект.ТолькоПросмотр Тогда
		ИнтернетПоддержкаПользователейКлиент.УстановитьОтображениеКнопкиКопироватьВБуфер(Элементы);
	КонецЕсли;   
	
КонецПроцедуры

#КонецОбласти



#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ОтправкаСсылки

&НаКлиенте
Процедура ШаблонСообщенияЭлектроннаяПочтаПриИзменении(Элемент)
	
	ВариантОтправки = "ЭлектроннаяПочта";
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонСообщенияТелефонПриИзменении(Элемент)
	
	ВариантОтправки = "Телефон";
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ОбновлениеСтатусаСчета() 
	
	Если НЕ ЗначениеЗаполнено(PayKeeperID) Тогда
		Возврат;
	КонецЕсли;
	
	СоединениеHTTP = Новый HTTPСоединение("ortonica.server.paykeeper.ru", , НастройкаОнлайнОплаты.Пользователь, НастройкаОнлайнОплаты.Пароль, , , Новый ЗащищенноеСоединениеOpenSSL);
	ЗапросHTTP = Новый HTTPЗапрос("/info/invoice/byid/?id=" + PayKeeperID); 
	ОтветHTTP = СоединениеHTTP.Получить(ЗапросHTTP);
 
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ОтветHTTP.ПолучитьТелоКакСтроку());
 
	Попытка
		ОбъектJSON = ПрочитатьJSON(ЧтениеJSON);
	Исключение
		Сообщить("Ошибка при получении статуса счета");
		Возврат;
	КонецПопытки;
 
	Если ОбъектJSON.Свойство("status") Тогда
		СтатусСчета = ОбъектJSON.status;
		ПлатежнаяСсылка = "https://ortonica.server.paykeeper.ru/bill/" + PayKeeperID;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновлениеОтображенияФормы() 
	
	ЕстьСсылка = ЗначениеЗаполнено(ПлатежнаяСсылка);
	СчетОтправлен = СтатусСчета = "sent" ИЛИ СтатусСчета = "paid";

	Элементы.ОбновитьСсылку.Видимость = НЕ СчетОтправлен; 
	Элементы.КопироватьВБуфер.Доступность = ЕстьСсылка;
	Элементы.ОтправитьСсылку.Доступность = НЕ СчетОтправлен;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСсылкуНаСервере() 
	
	СоединениеHTTP = Новый HTTPСоединение("ortonica.server.paykeeper.ru", , НастройкаОнлайнОплаты.Пользователь, НастройкаОнлайнОплаты.Пароль, , , Новый ЗащищенноеСоединениеOpenSSL);
	Токен = ПолучитьТокенPayKeeper(СоединениеHTTP); 
	
	Если НЕ ЗначениеЗаполнено(Токен) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказКлиента.Номер КАК Номер,
		|	ЗаказКлиента.СуммаДокумента КАК СуммаДокумента
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаказКлиентаТовары.НоменклатураПартнера КАК НоменклатураПартнера,
		|	ЗаказКлиентаТовары.Номенклатура КАК Номенклатура,
		|	ЗаказКлиентаТовары.Характеристика КАК Характеристика,
		|	ЗаказКлиентаТовары.КоличествоУпаковок КАК КоличествоУпаковок,
		|	ЗаказКлиентаТовары.СтавкаНДС КАК СтавкаНДС,
		|	ЗаказКлиентаТовары.СуммаСНДС КАК СуммаСНДС,
		|	спрНоменклатура.ТипНоменклатуры КАК ТипНоменклатуры,
		|	спрНоменклатура.КодТРУ КАК КодТРУ,
		|	СтавкиНДС.ПеречислениеСтавкаНДС КАК ПеречислениеСтавкаНДС 
		|ИЗ
		|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК спрНоменклатура
		|		ПО ЗаказКлиентаТовары.Номенклатура = спрНоменклатура.Ссылка
		|			И ЗаказКлиентаТовары.НоменклатураНабора = спрНоменклатура.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтавкиНДС КАК СтавкиНДС
		|		ПО ЗаказКлиентаТовары.СтавкаНДС = СтавкиНДС.Ссылка
		|ГДЕ
		|	ЗаказКлиентаТовары.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗаказКлиентаТовары.НомерСтроки";	
	Запрос.УстановитьПараметр("Ссылка", ОснованиеПлатежа);
	ПакетЗапроса = Запрос.ВыполнитьПакет();
	Шапка = ПакетЗапроса[ПакетЗапроса.Количество() - 2].Выбрать();
	Шапка.Следующий();
	Товары = ПакетЗапроса[ПакетЗапроса.Количество() - 1].Выбрать();
	
	ЗапросHTTP = Новый HTTPЗапрос("/change/invoice/preview/");
	ЗапросHTTP.Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");
	
	СтрокаЗапроса = "token=" + Токен;
	СтрокаЗапроса = СтрокаЗапроса + "&pay_amount=" + Формат(Шапка.СуммаДокумента, "ЧГ=0"); 
	СтрокаЗапроса = СтрокаЗапроса + "&orderid=" + Шапка.Номер;       
	СтрокаЗапроса = СтрокаЗапроса + "&client_email=" + ДоставкаЧекаЭлектроннаяПочта; 
	Если ЗначениеЗаполнено(ДоставкаЧекаТелефон) Тогда       
		СтрокаЗапроса = СтрокаЗапроса + "&client_phone=" + ДоставкаЧекаТелефон;
	КонецЕсли;  
	
	СтрокаТоваров = Новый Структура;
	СтрокаТоваров.Вставить("service_name", "Указана корзина товаров");
	СтрокаТоваров.Вставить("cart", Новый Массив);
	Пока Товары.Следующий() Цикл 
		
		ТекТовар = Новый Структура; 
		
		Если ЗначениеЗаполнено(Товары.НоменклатураПартнера) Тогда
			НаименованиеТовара = "" + Товары.НоменклатураПартнера + " (" + Товары.Номенклатура + ")";
		Иначе     
			НаименованиеТовара = "" + Товары.Номенклатура + ?(ЗначениеЗаполнено(Товары.Характеристика), " (" + Товары.Характеристика + ")", "");
		КонецЕсли;
		Если СтрДлина(СокрЛП(НаименованиеТовара)) > 128 Тогда   
			НаименованиеТовара = Лев(НаименованиеТовара, 128);
		КонецЕсли; 
		ТекТовар.Вставить("name", НаименованиеТовара);
		ТекТовар.Вставить("price", Формат(Товары.СуммаСНДС / Товары.КоличествоУпаковок, "ЧДЦ=2; ЧГ=0"));
		ТекТовар.Вставить("quantity", Формат(Товары.КоличествоУпаковок, "ЧГ=0")); 
		
		Если ЗначениеЗаполнено(Товары.КодТРУ) Тогда     
			ТекТовар.Вставить("tru_code", СокрЛП(Товары.КодТРУ));
		КонецЕсли;
		
		ТекТовар.Вставить("sum", Формат(Товары.СуммаСНДС, "ЧГ=0"));  
		Если Товары.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга Тогда
			ТекТовар.Вставить("item_type", "service");
		ИначеЕсли Товары.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа Тогда
        	ТекТовар.Вставить("item_type", "work");    
		Иначе   
			ТекТовар.Вставить("item_type", "goods");
		КонецЕсли;
		Если Товары.ПеречислениеСтавкаНДС = Перечисления.СтавкиНДС.НДС20_120 Тогда
			ТекТовар.Вставить("tax", "vat120");	
		ИначеЕсли Товары.ПеречислениеСтавкаНДС = Перечисления.СтавкиНДС.НДС10_110 Тогда
			ТекТовар.Вставить("tax", "vat110"); 
		ИначеЕсли Товары.ПеречислениеСтавкаНДС = Перечисления.СтавкиНДС.НДС20 Тогда
			ТекТовар.Вставить("tax", "vat20");
		ИначеЕсли Товары.ПеречислениеСтавкаНДС = Перечисления.СтавкиНДС.НДС10 Тогда
			ТекТовар.Вставить("tax", "vat10");
		ИначеЕсли Товары.ПеречислениеСтавкаНДС = Перечисления.СтавкиНДС.НДС0 Тогда
			ТекТовар.Вставить("tax", "vat0");
		Иначе
			ТекТовар.Вставить("tax", "none");
		КонецЕсли;
		
		СтрокаТоваров.cart.Добавить(ТекТовар);
		
	КонецЦикла;
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, СтрокаТоваров);
	СтрокаТоваров = ЗаписьJSON.Закрыть();
	
	СтрокаЗапроса = СтрокаЗапроса + "&service_name=" + СтрокаТоваров;   
	ЗапросHTTP.УстановитьТелоИзСтроки(СтрокаЗапроса);
	
	ОтветHTTP = СоединениеHTTP.ОтправитьДляОбработки(ЗапросHTTP);
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ОтветHTTP.ПолучитьТелоКакСтроку());

	Попытка
		ОтветОбъект = ПрочитатьJSON(ЧтениеJSON);
	Исключение
		Сообщить("Ошибка при выставлении счёта");
		Возврат;
	КонецПопытки;

	РезультатЗапроса = "";
	Если ОтветОбъект.Свойство("result", РезультатЗапроса) Тогда
		Если РезультатЗапроса = "fail" Тогда
			Сообщить(ОтветОбъект.msg);			
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	PayKeeperID = ОтветОбъект.invoice_id;
	
	МенеджерЗаписи = РегистрыСведений.ДополнительныеСведения.СоздатьМенеджерЗаписи();  
	МенеджерЗаписи.Объект = ОснованиеПлатежа;
	МенеджерЗаписи.Свойство = ДопСвойствоPayKeeperID;
	МенеджерЗаписи.Значение = PayKeeperID;
	МенеджерЗаписи.Записать(Истина); 
	
	ПлатежнаяСсылка = ОтветОбъект.invoice_url; 
	
	СтатусСчета = "created";
	
	ОбновлениеОтображенияФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСсылку(Команда)
	
	ОбновитьСсылкуНаСервере();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТокенPayKeeper(СоединениеHTTP)
 
	ЗапросHTTP = Новый HTTPЗапрос("/info/settings/token/");
 
	ОтветHTTP = СоединениеHTTP.Получить(ЗапросHTTP);
 
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ОтветHTTP.ПолучитьТелоКакСтроку());
 
	Попытка
		ОбъектJSON = ПрочитатьJSON(ЧтениеJSON);
	Исключение
		Сообщить("Ошибка при получении токена безопасности");
		Возврат "";
	КонецПопытки;
 
	Токен = "";
	Если ОбъектJSON.Свойство("token", Токен) Тогда
		Возврат Токен;
	Иначе
		Сообщить(ОбъектJSON.msg);
		Возврат "";
	КонецЕсли;
 
КонецФункции

&НаКлиенте
Процедура КопироватьВБуфер(Команда)
	
	// Копирование происходит с предварительной очисткой через обработчик, для обхода поведения платформы
	// при повторном копировании - при определенных условиях копирование не происходит.
	ЭтотОбъект.БуферОбмена = "";
	ПодключитьОбработчикОжидания("КопироватьСсылкуВБуфер", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСсылку(Команда)
	
	Если ЗначениеЗаполнено(ПлатежнаяСсылка) Тогда
		
		Закрыть();
		ОтправитьПлатежнуюСсылку();
	
	Иначе
		
		Сообщить("Платежная ссылка ещё не сформирована");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОтправкаСсылки

&НаКлиенте
Процедура ОтправитьПлатежнуюСсылку()
	
	ШаблоныИспользуются = НастройкиШаблонов.Используется;
	
	Если ВариантОтправки = "ЭлектроннаяПочта" Тогда
		
		Если ШаблоныИспользуются И ЗначениеЗаполнено(ШаблонСообщенияЭлектроннаяПочта) Тогда
			СформироватьСообщениеДляОтправки(КонструкторПараметровОтправки(ШаблонСообщенияЭлектроннаяПочта, "Письмо"));
		Иначе
			Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
				МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
				МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(КонструкторПараметровОтправкиБезШаблона());
			КонецЕсли;
		КонецЕсли;
	
	ИначеЕсли ВариантОтправки = "Телефон" Тогда
		
		Если ШаблоныИспользуются И ЗначениеЗаполнено(ШаблонСообщенияТелефон) Тогда
			СформироватьСообщениеДляОтправки(КонструкторПараметровОтправки(ШаблонСообщенияТелефон, "СообщениеSMS"));
		Иначе
			ПоказатьФормуСообщения(
				Новый Структура("Текст, Получатель, ДополнительныеПараметры", ПлатежнаяСсылка, СписокПолучателей())
				,
				"СообщениеSMS",
				ОснованиеПлатежа);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция КонструкторПараметровОтправки(Шаблон, ВидСообщения)
	
	ПараметрыОтправки = Новый Структура();
	ПараметрыОтправки.Вставить("Шаблон", Шаблон);
	ПараметрыОтправки.Вставить("Предмет", ОснованиеПлатежа);
	ПараметрыОтправки.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыОтправки.Вставить("ДополнительныеПараметры", Новый Структура);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПреобразовыватьHTMLДляФорматированногоДокумента", Истина);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ВидСообщения", ВидСообщения);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПроизвольныеПараметры", Новый Соответствие);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ОтправитьСразу", Ложь);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПлатежнаяСсылка", ПлатежнаяСсылка);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("КонтактныеДанныеЧека", КонтактныеДанныеЧека());
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("СценарийЗаполнения", "ОнлайнОплаты");
	
	Возврат ПараметрыОтправки;
	
КонецФункции

&НаКлиенте
Функция КонструкторПараметровОтправкиБезШаблона()
	
	ПараметрыСообщения = Новый Структура;
	
	ПараметрыСообщения.Вставить("Получатель", СписокПолучателей());
	ПараметрыСообщения.Вставить("Предмет", ОснованиеПлатежа);
	ПараметрыСообщения.Вставить("ПлатежнаяСсылка", ПлатежнаяСсылка);
	ПараметрыСообщения.Вставить("Тема", НСтр("ru = 'Ссылка для оплаты';
											|en = 'Link for payment'"));
	
	Если ИнтернетПоддержкаПользователейВызовСервера.ОтправлятьПисьмаВФорматеHTML() Тогда
		ПараметрыСообщения.Вставить(
			"Текст",
			Новый Структура(
				"ТекстHTML, СтруктураВложений",
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстПисьмаБезШаблонаHTML(),
					ПлатежнаяСсылка),
				Новый Структура()));
	Иначе
		ПараметрыСообщения.Вставить(
			"Текст",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПисьмаБезШаблонаТекст(), ПлатежнаяСсылка));
	КонецЕсли;
	
	ИнтеграцияПодсистемБИПКлиент.ЗаполнитьПараметрыСообщенияБезШаблона(ПараметрыСообщения);
	ОнлайнОплатыКлиентПереопределяемый.ЗаполнитьПараметрыСообщенияБезШаблона(ПараметрыСообщения);
	
	Возврат ПараметрыСообщения;
	
КонецФункции

&НаКлиенте
Процедура СформироватьСообщениеДляОтправки(ПараметрыОтправки)
	
	Результат = СформироватьСообщениеНаСервере(ПараметрыОтправки);
	
	ПоказатьФормуСообщения(Результат, ПараметрыОтправки.ДополнительныеПараметры.ВидСообщения, ПараметрыОтправки.Предмет);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СформироватьСообщениеНаСервере(ПараметрыОтправки)
	
	МодульШаблоныСообщений = ОбщегоНазначения.ОбщийМодуль("ШаблоныСообщений");
	
	Результат = МодульШаблоныСообщений.СформироватьСообщение(
		ПараметрыОтправки.Шаблон,
		ПараметрыОтправки.Предмет,
		ПараметрыОтправки.УникальныйИдентификатор,
		ПараметрыОтправки.ДополнительныеПараметры);

	Вложения = Новый Массив;
	
	Для каждого ЭлементКоллекции Из Результат.Вложения Цикл
		
		ТекущееВложение = Новый Структура;
		
		ТекущееВложение.Вставить("Представление");
		ТекущееВложение.Вставить("АдресВоВременномХранилище");
		ТекущееВложение.Вставить("Кодировка");
		ТекущееВложение.Вставить("Идентификатор");
		
		ЗаполнитьЗначенияСвойств(ТекущееВложение, ЭлементКоллекции);
		
		Вложения.Добавить(ТекущееВложение);
		
	КонецЦикла;
	
	Результат.Вложения = Вложения;
		
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьФормуСообщения(Сообщение, ВидСообщения, Предмет)
	
	Если ВидСообщения = "СообщениеSMS" Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОтправкаSMS") Тогда 
			
			ДополнительныеПараметры = Новый Структура("ИсточникКонтактнойИнформации, ПеревестиВТранслит");
			
			Если Сообщение.ДополнительныеПараметры <> Неопределено Тогда
				ЗаполнитьЗначенияСвойств(ДополнительныеПараметры, Сообщение.ДополнительныеПараметры);
			КонецЕсли;
			
			ДополнительныеПараметры.ИсточникКонтактнойИнформации = Предмет;
			Текст  = ?(Сообщение.Свойство("Текст"), Сообщение.Текст, "");
			
			Получатели = Новый Массив;
			
			ЗаполнитьПолучателейИзСообщения(Получатели, Сообщение);
			
			МодульОтправкаSMSКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОтправкаSMSКлиент");
			
			МодульОтправкаSMSКлиент.ОтправитьSMS(Получатели, Текст, ДополнительныеПараметры);
			
		Иначе
			КопироватьСсылкуВБуфер();
		КонецЕсли;
	Иначе
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
			МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
			МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(Сообщение);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПолучателейИзСообщения(Получатели, Сообщение)
	
	Если Не Сообщение.Свойство("Получатель") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Сообщение.Получатель) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ЭлементКоллекции Из Сообщение.Получатель Цикл
		
		КонтактныеДанные = Новый Структура;
		
		КонтактныеДанные.Вставить("Телефон",                      ЭлементКоллекции.Значение);
		КонтактныеДанные.Вставить("Представление",                ЭлементКоллекции.Представление);
		КонтактныеДанные.Вставить("ИсточникКонтактнойИнформации", Неопределено);
		
		Получатели.Добавить(КонтактныеДанные);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ТекстПисьмаБезШаблонаHTML()
	
	HTMLСтрока =
	
	"<html>
	|<head>
	|<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" />
	|<meta http-equiv=""X-UA-Compatible"" content=""IE=Edge"" />
	|<meta name=""format-detection"" content=""telephone=no"" />
	|</head>
	|<body>
	|<p>Ссылка для оплаты: <a href=""%1"">%1</a></p>
	|
	|</body>
	|</html>";
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1';
																		|en = '%1'"), HTMLСтрока);
	
КонецФункции

&НаКлиенте
Функция ТекстПисьмаБезШаблонаТекст()
	
	Возврат НСтр("ru = 'Ссылка для оплаты: %1';
				|en = 'Link for payment: %1 '");
	
КонецФункции

&НаСервере
Функция СписокПолучателей()
	
	СписокПолучателей = Новый СписокЗначений;
	
	Если ВариантОтправки = "ЭлектроннаяПочта" И ЗначениеЗаполнено(ДоставкаЧекаЭлектроннаяПочта) Тогда
		СписокПолучателей.Добавить(ДоставкаЧекаЭлектроннаяПочта);
	ИначеЕсли ВариантОтправки = "Телефон" И ЗначениеЗаполнено(ДоставкаЧекаТелефон) Тогда
		СписокПолучателей.Добавить(ДоставкаЧекаТелефон);
	Иначе
		ИнтеграцияПодсистемБИП.ПриФормированииСпискаПолучателейСообщения(
			ОснованиеПлатежа,
			ВариантОтправки,
			СписокПолучателей);
		ОнлайнОплатыПереопределяемый.ПриФормированииСпискаПолучателейСообщения(
			ОснованиеПлатежа,
			ВариантОтправки,
			СписокПолучателей);
	КонецЕсли;
	
	Возврат СписокПолучателей;
	
КонецФункции

#КонецОбласти

#Область РаботаССервисом

&НаКлиенте
Процедура КопироватьСсылкуВБуфер()
	
	ЭтотОбъект.БуферОбмена = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"<!DOCTYPE html>
		|<html>
		|	<body onload='copy()'>
		|		<input id='input' type='text'/>
		|		<script>
		|			function copy() {
		|				var text = '%1';
		|				var ua = navigator.userAgent;
		|				if (ua.search(/MSIE/) > 0 || ua.search(/Trident/) > 0) {
		|					window.clipboardData.setData('Text', text);
		|				} else {
		|					var copyText = document.getElementById('input');
		|					copyText.value = text;
		|					copyText.select();
		|					document.execCommand('copy');
		|				}
		|			}
		|		</script>
		|	</body>
		|</html>",
		ПлатежнаяСсылка);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Ссылка получена';
			|en = 'Link is received'"),
		,
		НСтр("ru = 'Ссылка для оплаты через PayKeeper скопирована в буфер обмена';
			|en = 'Link to the page of payment via PayKeeper is copied to the clipboard'"));
	
КонецПроцедуры

#КонецОбласти

#Область КонтактнаяИнформация

&НаСервере
Процедура УстановитьВариантДоставкиЧека(КонтактныеДанныеЭлектронногоЧека)
	
	ЭтоАдресЭлектроннойПочты = ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(
		КонтактныеДанныеЭлектронногоЧека);
	
	Если ЭтоАдресЭлектроннойПочты Тогда
		
		ДоставкаЧекаЭлектроннаяПочта = КонтактныеДанныеЭлектронногоЧека;
		ВариантДоставкиЧека = "ЭлектроннаяПочта";
		
	Иначе
		
		ДоставкаЧекаТелефон = ФорматироватьНомер(КонтактныеДанныеЭлектронногоЧека);
		ВариантДоставкиЧека = "Телефон";
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиКонтактнойИнформации()
	
	КонтактнаяИнформация = ОнлайнОплатыСлужебный.КонтактнаяИнформацияОснованияПлатежа(ОснованиеПлатежа);
	
	Для Каждого Телефон Из КонтактнаяИнформация.Телефоны Цикл
		
		ДоставкаЧекаТелефон = ФорматироватьНомер(Телефон);
		
	КонецЦикла;
	
	Для Каждого ЭлектроннаяПочта Из КонтактнаяИнформация.ЭлектроннаяПочта Цикл
		
		ДоставкаЧекаЭлектроннаяПочта = ЭлектроннаяПочта;
		
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Функция КонтактныеДанныеЧека()
	
	КонтактныеДанныеЧека = "";
	
	Если ВариантДоставкиЧека = "ЭлектроннаяПочта" 
		И ЗначениеЗаполнено(ДоставкаЧекаЭлектроннаяПочта) Тогда
		
		КонтактныеДанныеЧека = ДоставкаЧекаЭлектроннаяПочта;
		
	КонецЕсли;
	
	Если ВариантДоставкиЧека = "Телефон" 
		И ЗначениеЗаполнено(ДоставкаЧекаТелефон) Тогда
		
		КонтактныеДанныеЧека = ФорматироватьНомер(ДоставкаЧекаТелефон);
		
	КонецЕсли;
			
	Возврат КонтактныеДанныеЧека;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста 
Функция ФорматироватьНомер(Номер)
	Результат = "";
	ДопустимыеСимволы = "+1234567890";
	Для Позиция = 1 По СтрДлина(Номер) Цикл
		Символ = Сред(Номер,Позиция,1);
		Если СтрНайти(ДопустимыеСимволы, Символ) > 0 Тогда
			Результат = Результат + Символ;
		КонецЕсли;
	КонецЦикла;
	
	Если СтрДлина(Результат) > 10 Тогда
		ПервыйСимвол = Лев(Результат, 1);
		Если ПервыйСимвол = "8" Тогда
			Результат = "+7" + Сред(Результат, 2);
		ИначеЕсли ПервыйСимвол <> "+" Тогда
			Результат = "+" + Результат;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормыПоПодсистемам(КлючПоложенияОкна = "")
	
	ЕстьЭлектроннаяПочта = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями");
	ЕстьОтправкаSMS = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОтправкаSMS");
	ИспользуютсяШаблоны = НастройкиШаблонов.Используется;
	
	ЕстьВыборВариантаОтправки = ЕстьЭлектроннаяПочта И ЕстьОтправкаSMS;

	Элементы.ГруппаВариантОтправкиЭлектроннаяПочта.Видимость = ЕстьЭлектроннаяПочта;
	Элементы.НадписьВариантОтправкиЭлектроннаяПочта.Видимость = Не ЕстьВыборВариантаОтправки;
	Элементы.ВариантОтправкиЭлектроннаяПочта.Видимость = ЕстьВыборВариантаОтправки;
	
	Элементы.ГруппаВариантОтправкиТелефон.Видимость = ЕстьОтправкаSMS;
	Элементы.НадписьВариантОтправкиТелефон.Видимость = Не ЕстьВыборВариантаОтправки;
	Элементы.ВариантОтправкиТелефон.Видимость = ЕстьВыборВариантаОтправки;
	
	Если Не ЕстьЭлектроннаяПочта И Не ЕстьОтправкаSMS Тогда
		Элементы.ГруппаВариантОтправки.Видимость = Ложь;
	КонецЕсли;
	
	Если Не (ЕстьВыборВариантаОтправки ИЛИ ИспользуютсяШаблоны) Тогда
		
		Элементы.ГруппаВариантОтправки.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Не ИспользуютсяШаблоны Тогда
		Элементы.ГруппаВариантОтправки.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		Элементы.ГруппаВариантОтправкиПереключатели.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		Элементы.ШаблонСообщенияЭлектроннаяПочта.Видимость = Ложь;
		Элементы.ШаблонСообщенияТелефон.Видимость = Ложь;
		Элементы.ДекорацияКонвертОтправка.Видимость = Ложь;
		Элементы.ДекорацияСообщенияОтправка.Видимость = Ложь;
	КонецЕсли;
	
	КлючПоложенияОкна = КлючПоложенияОкна
		+ Строка(Элементы.ГруппаВариантОтправки.Видимость)
		+ Строка(Элементы.ГруппаВариантОтправки.Группировка)
		+ Строка(Элементы.ГруппаВариантОтправкиЭлектроннаяПочта.Видимость)
		+ Строка(Элементы.ГруппаВариантОтправкиТелефон.Видимость);
	
КонецПроцедуры

#КонецОбласти

#Область НастройкиФормы

&НаСервереБезКонтекста
Процедура СохранитьШаблоныПоУмолчанию(ОснованиеПлатежа, ШаблонСообщенияЭлектроннаяПочта, ШаблонСообщенияТелефон)
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ОснованиеПлатежа)) Тогда
		ПредставлениеОснования = ОснованиеПлатежа.Метаданные().ПолноеИмя();
	Иначе
		ПредставлениеОснования = ОснованиеПлатежа;
	КонецЕсли;
	
	// Шаблоны электронной почты
	КлючНастроек = "ШаблоныСообщенийЭлектроннойПочты";
	
	Настройки = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
		"ФормаПодготовкиПлатежнойСсылки",
		КлючНастроек);
	
	Если Настройки = Неопределено Тогда
		ШаблоныПоУмолчанию = Новый Соответствие();
	Иначе
		ШаблоныПоУмолчанию = Настройки;
	КонецЕсли;
	
	ШаблоныПоУмолчанию.Вставить(ПредставлениеОснования, ШаблонСообщенияЭлектроннаяПочта);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		"ФормаПодготовкиПлатежнойСсылки",
		КлючНастроек,
		ШаблоныПоУмолчанию);
	
	// Шаблоны SMS сообщений
	КлючНастроек = "ШаблоныСообщенийSMS";
	
	Настройки = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
		"ФормаПодготовкиПлатежнойСсылки",
		КлючНастроек);
	
	Если Настройки = Неопределено Тогда
		ШаблоныПоУмолчанию = Новый Соответствие();
	Иначе
		ШаблоныПоУмолчанию = Настройки;
	КонецЕсли;
	
	ШаблоныПоУмолчанию.Вставить(ПредставлениеОснования, ШаблонСообщенияТелефон);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		"ФормаПодготовкиПлатежнойСсылки",
		КлючНастроек,
		ШаблоныПоУмолчанию);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьШаблоныПоУмолчанию()
	
	Если НастройкиШаблонов.Используется 	
		И ЗначениеЗаполнено(ОснованиеПлатежа) Тогда
		
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ОснованиеПлатежа)) Тогда
			ПредставлениеОснования = ОснованиеПлатежа.Метаданные().ПолноеИмя();
		Иначе
			ПредставлениеОснования = ОснованиеПлатежа;
		КонецЕсли;
		
		// Шаблоны электронной почты
		Настройки = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
			"ФормаПодготовкиПлатежнойСсылки",
			"ШаблоныСообщенийЭлектроннойПочты");
		
		Если Настройки <> Неопределено
			И ТипЗнч(Настройки) = Тип("Соответствие")
			И Настройки[ПредставлениеОснования] <> Неопределено Тогда
			
			ШаблонСообщенияЭлектроннаяПочта = Настройки[ПредставлениеОснования];
			
		КонецЕсли;
		
		// Шаблоны SMS сообщений
		Настройки = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
			"ФормаПодготовкиПлатежнойСсылки",
			"ШаблоныСообщенийSMS");
		
		Если Настройки <> Неопределено
			И ТипЗнч(Настройки) = Тип("Соответствие")
			И Настройки[ПредставлениеОснования] <> Неопределено Тогда
			
			ШаблонСообщенияТелефон = Настройки[ПредставлениеОснования];
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

