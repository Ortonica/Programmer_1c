﻿
&НаКлиенте
Процедура РСК_ПриОткрытииВместо(Отказ)
	//Трофимов: На копии выключил
	Если РСК_Клиент.ЭтоКопия() Тогда
		НеПоказывать(Неопределено);
		Возврат;
	Иначе
		ПродолжитьВызов(Отказ);
	КонецЕсли;
КонецПроцедуры


