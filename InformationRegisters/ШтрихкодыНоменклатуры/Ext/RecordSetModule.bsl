﻿
&ИзменениеИКонтроль("ПередЗаписью")
Процедура РСК_ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	#Вставка
	Если НЕ РегистрыСведений.ДСТ_ШтрихкодыСерий.ШтрихкодУникален(ЭтотОбъект.Отбор.Штрихкод.Значение) Тогда
		ОбщегоНазначения.СообщитьПользователю("Указанный штрихкод уже установлен для серии номенклатуры в регистре ""Штрихкоды серий""!",,,,Отказ);	
	КонецЕсли;
	#КонецВставки
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	ПодготовкаИзмеренийПередЗаписью(Отказ);

КонецПроцедуры
