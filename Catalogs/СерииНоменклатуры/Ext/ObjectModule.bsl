﻿
&После("ОбработкаПроверкиЗаполнения")
Процедура РСК_ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)  
	
	Если ЗначениеЗаполнено(Артикул) Тогда
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Ссылка);
		Если НЕ МенеджерОбъекта.АртикулСерииУникален(ВидНоменклатуры, Артикул) Тогда
			ОбщегоНазначения.СообщитьПользователю("Введенный артикул неуникален для выбранного вида номенклатуры!",,"Артикул","Артикул",Отказ);	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
