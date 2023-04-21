﻿ //РСК+ Кикинева А.Г. задача 258203 право снятия запрета просроченной задолженности 
&НаСервере
Процедура РСК_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)  
	
	Если Объект.Согласован Тогда
		
		Если Пользователи.РолиДоступны("РСК_ПравоСнятьЗапретЗадолженностиВДоговоре",
			Пользователи.ТекущийПользователь()) 
			
			И Не Пользователи.РолиДоступны("Администрирование",
			Пользователи.ТекущийПользователь())   Тогда
			
			Элементы.СтраницаОсновное.ТолькоПросмотр 		       	     = Истина;
			Элементы.СтраницаУчетнаяИнформация.ТолькоПросмотр   	     = Истина;
			Элементы.ГруппаНалогообложениеНДС.ТолькоПросмотр 		     = Истина;
			Элементы.ГруппаПорядокРасчетовПоДоговору.ТолькоПросмотр      = Истина;
			Элементы.ЛокализацияГруппаНастроитьГОЗ.ТолькоПросмотр        = Истина;   
			Элементы.ЗапрещаетсяПросроченнаяЗадолженность.Доступность    = Истина;
			Элементы.ДопустимаяСуммаЗадолженности.Доступность            = Ложь;
			Элементы.ОграничиватьСуммуЗадолженности.Доступность          = Ложь; 
		КонецЕсли;
	КонецЕсли;   
	
КонецПроцедуры
      //РСК- Кикинева А.Г. задача 258203 право снятия запрета просроченной задолженности 
