﻿
&НаКлиенте
Процедура РСК_РС_ЗаполнитьНоменклатуруПартнераГосКонтрактаПосле(Команда) 
	
	Если Элементы.СписокВыполняются.ТекущаяСтрока <> Неопределено Тогда 
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросПроХарактеристикуЗавершение", ЭтотОбъект), "Использовать 'Характеристику' при синхронизации? (рекомендуем использовать)", РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПроХарактеристикуЗавершение(Результат, ДополнительныеПараметры) Экспорт   
	
	Если Результат <> Неопределено Тогда 
		
		Если Результат = КодВозвратаДиалога.Отмена Тогда 
			Возврат;
		КонецЕсли;
		
		ИспользоватьХарактеристикуПриСопоставлении = Результат = КодВозвратаДиалога.Да;
		
		// 1. Запуск фонового задания на сервере
		ДлительнаяОперация = НачатьЗаполнениеНоменклатуры(Элементы.СписокВыполняются.ТекущаяСтрока, ИспользоватьХарактеристикуПриСопоставлении);
		
		// 2. Подключение обработчика завершения фонового задания.
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		ПараметрыОжидания.Интервал = 1;            
		
		Оповещение = Новый ОписаниеОповещения("ЗаполнениеНоменклатурыЗавершение", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НачатьЗаполнениеНоменклатуры(Ссылка, ИспользоватьХарактеристикуПриСопоставлении = Истина)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	ПараметрыФункции = Новый Структура("Ссылка, ИспользоватьХарактеристикуПриСопоставлении", Ссылка, ИспользоватьХарактеристикуПриСопоставлении);
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, "Справочники.ГосударственныеКонтракты.ЗаполнитьНоменклатуруПартнераВДокументахСДоговорами", ПараметрыФункции);
	
КонецФункции

&НаКлиенте
Процедура ЗаполнениеНоменклатурыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено
		И Результат.Статус = "Выполнено" Тогда
		
		Контекст = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);	
		
		Сообщения = Контекст.Сообщения;
		
		Для Каждого Сообщение Из Сообщения Цикл 
			ОбщегоНазначенияКлиент.СообщитьПользователю(Сообщение.Текст, Сообщение.Ключ);
		КонецЦикла;                                  
		
	ИначеЕсли Результат <> Неопределено
		И Результат.Статус = "Ошибка" Тогда
		
		ТекстОшибки = НСтр("ru = 'Во время редактирования данных произошла ошибка. 
		|Подробнее см. в журнале регистрации. " + Результат.ПодробноеПредставлениеОшибки + "'");
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
		
	ИначеЕсли Результат = Неопределено Тогда 
		
	КонецЕсли;
		
КонецПроцедуры
