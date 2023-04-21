﻿
&ИзменениеИКонтроль("ПараметрыКомандыСоздатьОбновитьЗаказНовыйПротокол")
Функция РСК_ПараметрыКомандыСоздатьОбновитьЗаказНовыйПротокол(Знач ПараметрыСервиса, Знач ПараметрыОнлайнОплаты, Знач ВходящиеПараметры, Отказ)

	Параметры = Новый Структура;

	// Проверим основание платежа
	Если Не ПроверитьЗаполнениеОснованияПлатежа(ВходящиеПараметры.ОснованиеПлатежа) Тогда
		Отказ = Истина;
		Возврат Параметры;
	КонецЕсли;

	ДанныеОснованияПлатежа = ДанныеОснованияПлатежа(ВходящиеПараметры.ОснованиеПлатежа);
	Если ВходящиеПараметры.Свойство("КонтактныеДанныеЧека") Тогда
		ДанныеОснованияПлатежа.Покупатель.КонтактныеДанныеЧека = ВходящиеПараметры.КонтактныеДанныеЧека;
	КонецЕсли;

	НастройкаОнлайнОплаты = ПараметрыОнлайнОплаты.Настройка;

	КодировкаURL = СпособКодированияСтроки.КодировкаURL; 
	#Вставка
	Если ВходящиеПараметры.Свойство("УИП") тогда
		ИдентификаторПлатежа = КодироватьСтроку(Строка(ВходящиеПараметры.УИП), КодировкаURL);
	Иначе  
	#КонецВставки
	ИдентификаторПлатежа = КодироватьСтроку(Строка(ДанныеОснованияПлатежа.Идентификатор), КодировкаURL);
    #Вставка
	КонецЕсли;
	#КонецВставки

	Параметры = Новый Структура;

	Параметры.Вставить("ДанныеАутентификации", ПараметрыСервиса.ДанныеАутентификации);
	Параметры.Вставить("ИдентификаторМагазина", Формат(НастройкаОнлайнОплаты.ИдентификаторМагазина,"ЧГ="));
	Параметры.Вставить("ИдентификаторПлатежа", ИдентификаторПлатежа);


	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("directLink", ?(ДанныеОснованияПлатежа.ПропускатьСтраницуСчета = Истина, "true", "false"));
	ПараметрыЗапроса.Вставить("details", ДанныеОснованияПлатежа.НазначениеПлатежа);    
	#Вставка
	Если ВходящиеПараметры.Свойство("СуммаСтроки") тогда
		ПараметрыЗапроса.Вставить("sum", Формат(ВходящиеПараметры.СуммаСтроки,"ЧРД=.; ЧГ="));
    Иначе
	#КонецВставки
	ПараметрыЗапроса.Вставить("sum", Формат(ДанныеОснованияПлатежа.Сумма,"ЧРД=.; ЧГ=")); 
	#Вставка
	КонецЕсли;
	#КонецВставки    
	ПараметрыЗапроса.Вставить("paymentMethodType", "BANK_CARD");  
	ПараметрыЗапроса.Вставить(
	"customerNumber",
	КодироватьСтроку(ДанныеОснованияПлатежа.Покупатель.Идентификатор, КодировкаURL));    
	ПараметрыЗапроса.Вставить("orderItems", ДанныеОснованияПлатежаТоварыЗаказ(ДанныеОснованияПлатежа));   
	ПараметрыЗапроса.Вставить("supplierInfo", ДанныеОснованияПлатежаПродавец(ДанныеОснованияПлатежа));

	// receipt
	Если НастройкаОнлайнОплаты.ОтправкаЧековЧерезСервис Тогда

		СтруктураЧека = Новый Структура;  
		#Вставка
		Если ВходящиеПараметры.Свойство("СуммаСтроки") тогда   
			СтруктураЧека.Вставить("items", ДанныеОснованияПлатежаТоварыЧек_Строка(ДанныеОснованияПлатежа, ВходящиеПараметры.СуммаСтроки));	
		Иначе
		#КонецВставки
		СтруктураЧека.Вставить("items", ДанныеОснованияПлатежаТоварыЧек(ДанныеОснованияПлатежа));  
		#Вставка
		КонецЕсли;
		#КонецВставки
		СтруктураЧека.Вставить("customer", ДанныеОснованияПлатежаПокупатель(ДанныеОснованияПлатежа.Покупатель));
		СтруктураЧека.Вставить("taxSystemCode", ДанныеОснованияПлатежа.Продавец.УчетнаяПолитика);

		ПараметрыЗапроса.Вставить("receipt", СтруктураЧека);

	КонецЕсли;

	НоменклатураДляХеша = ДанныеОснованияПлатежаДляСервиса_Номенклатура(ДанныеОснованияПлатежа);
	ПараметрыЗапроса.Вставить("checksum", ХешСумма(ЗаписатьДанныеВJSON(НоменклатураДляХеша)));

	Параметры.Вставить("ПараметрыЗапроса", ПараметрыЗапроса);

	Возврат Параметры;

КонецФункции    

Функция ДанныеОснованияПлатежаТоварыЧек_Строка(Знач ДанныеОснованияПлатежа, Сумма) 

	СоответствиеПолей = Новый Структура;
	
	СоответствиеПолей.Вставить("СтавкаНДСКод",          "vat");
	СоответствиеПолей.Вставить("Наименование",          "description");
	СоответствиеПолей.Вставить("Количество",            "quantity");
	СоответствиеПолей.Вставить("Цена",                  "amount");
	СоответствиеПолей.Вставить("ПредметРасчетаСтрокой", "paymentSubject");
	СоответствиеПолей.Вставить("КодТовара",                    "productCode");
	СоответствиеПолей.Вставить("КодСтраныПроисхожденияТовара", "countryOfOriginCode");
	СоответствиеПолей.Вставить("НомерТаможеннойДекларации",    "customsDeclarationNumber");
	СоответствиеПолей.Вставить("СуммаАкциза",                  "excise");
	
	Номенклатура = Новый Массив;
	СуммаДокумента = ДанныеОснованияПлатежа.Сумма;     
	ОбщаяСумма = 0;
	Для каждого СтрокаНоменклатуры Из ДанныеОснованияПлатежа.Номенклатура Цикл
		
		СтрокаДанных = Новый Структура;
	
		Для каждого Поле Из СоответствиеПолей Цикл
			
			ПолеКлюч = Поле.Ключ;
			ПолеЗначение = Поле.Значение;
			Значение = СтрокаНоменклатуры[ПолеКлюч];
			
			Если Не ЗначениеЗаполнено(Значение) Тогда
				Продолжить;
			КонецЕсли;
			
			Если ПолеКлюч = "Цена" Тогда   
				ВесЦены = Значение / СуммаДокумента;
				ЗначениеЦены = Окр(ВесЦены * Сумма,2,РежимОкругления.Окр15как20);    
				ОбщаяСумма = ОбщаяСумма + ЗначениеЦены; 
				СтрокаДанных.Вставить(ПолеЗначение, Новый Структура("currency, value", "RUB",ЗначениеЦены));
			Иначе 
				СтрокаДанных.Вставить(ПолеЗначение, Значение);
			КонецЕсли;
			
		КонецЦикла;
		
		СтрокаДанных.paymentSubject = ВРег(СтрокаДанных.paymentSubject);
		
		Номенклатура.Добавить(СтрокаДанных);
		
	КонецЦикла;
	Остаток = Сумма - ОбщаяСумма;	  
	Если Остаток <> 0 и Номенклатура.Количество() <> 0 тогда
		 Номенклатура[0].amount.value = Номенклатура[0].amount.value + Остаток;
	КонецЕсли;
	Возврат Номенклатура;
	
КонецФункции


&ИзменениеИКонтроль("ПараметрыКомандыПолучитьДанныеПоЗаказу")
Функция РСК_ПараметрыКомандыПолучитьДанныеПоЗаказу(Знач ПараметрыСервиса, Знач ПараметрыОнлайнОплаты, Знач ВходящиеПараметры, Отказ)

	ДанныеОснованияПлатежа = ДанныеОснованияПлатежа(ВходящиеПараметры.ОснованиеПлатежа);

	Параметры = Новый Структура;

	Параметры.Вставить("ДанныеАутентификации", ПараметрыСервиса.ДанныеАутентификации); 
	Параметры.Вставить("shopId", Формат(ПараметрыОнлайнОплаты.Настройка.ИдентификаторМагазина,"ЧГ="));
   	#Вставка
	Если ВходящиеПараметры.Свойство("УИП") тогда
		ИдентификаторПлатежа = Строка(ВходящиеПараметры.УИП);     
		ДанныеОснованияПлатежа.Идентификатор = ИдентификаторПлатежа; 
	КонецЕсли;  
	#КонецВставки
	Если ПараметрыОнлайнОплаты.Настройка.СДоговором Тогда
		Параметры.Вставить("orderNumber", Строка(ДанныеОснованияПлатежа.Идентификатор));
	Иначе
		Параметры.Вставить("orderNumber", Строка(ВходящиеПараметры.ОснованиеПлатежа.УникальныйИдентификатор()));	
	КонецЕсли;

	Возврат Параметры;

КонецФункции


&ИзменениеИКонтроль("ПроверитьСоответствиеСумм")
Процедура РСК_ПроверитьСоответствиеСумм(ИмяКоманды, СуммаЗаказа, МассивТоваров, Отказ)

	СуммаТоваров = 0;

	Для Каждого Товар Из МассивТоваров Цикл
		Если Товар.Свойство("sum") Тогда
			СуммаТоваров = СуммаТоваров + Товар.sum;
		КонецЕсли;
	КонецЦикла;
	
	#Удаление
	Если СуммаТоваров <> Число(СуммаЗаказа) Тогда
		Отказ = Истина;
		ПараметрыСообщения = Новый Структура();
		ПараметрыСообщения.Вставить("ИмяКоманды", ИмяКоманды);
		ОбработатьОшибку("СуммыТоваровИДокументаНеСовпадают", ПараметрыСообщения, Отказ);
	КонецЕсли;
	#КонецУдаления

КонецПроцедуры

