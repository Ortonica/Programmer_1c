﻿
&НаКлиенте
Процедура РСК_ОбновитьПредставлениеПосле(Команда)
	ОбновитьПредставлениеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставлениеНаСервере()

	МенЗаписи = РеквизитФормыВЗначение("Запись");
	Запись.Представление = РегистрыСведений.ДокументыФизическихЛиц.ПредставлениеЗаписи(МенЗаписи);
	Модифицированность = Истина;
	
КонецПроцедуры // ОбновитьПредставлениеНаСервере()
