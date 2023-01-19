﻿
&НаКлиенте
Процедура САВ_ПриОткрытииПосле(Отказ)
	//Вставить содержимое обработчика 
	РезультатЗапроса();
	//Закладка = ЭтаФорма.ХарактеристикиИзделия.ПолучитьЭлементы();
	//Если Закладка.Количество()>0 Тогда
	//	ЭтаФорма.Элементы.СтраницаХарактеристикиИзделия.Видимость=Истина;
	//Иначе                                                                
	//	ЭтаФорма.Элементы.СтраницаХарактеристикиИзделия.Видимость=Ложь;
	//КонецЕсли;
	//
		
КонецПроцедуры 


&НаСервере
Процедура РезультатЗапроса() 
	Запрос=Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ
			|				Хар.НомерПараметра,
			|				Хар.Родитель,
			|				Хар.Ссылка, 
			|				РегХар.ВладелецПараметра,
			|				Хар.Ссылка КАК Наименование,
			|				Хар.Характеристика,
			|				РегХар.ЗначениеПоУмолчанию
			|			ИЗ
			|				Справочник.САВ_ВидыСвойствНоменклатуры   КАК Хар    
			|			Левое Соединение  РегистрСведений.САВ_ХарактеристикиНоменклатуры КАК РегХар
			|			ПО
			|			Хар.Ссылка=РегХар.СвойствоПараметра.Ссылка
			|			ГДЕ
			|				   РегХар.ВладелецПараметра=&Номенклатура
			|				УПОРЯДОЧИТЬ ПО
			|					Хар.Родитель.Код,
			|				    Хар.Ссылка.Код
			|ИТОГИ ПО
			|    Хар.Родитель ИЕРАРХИЯ
			|АВТОУПОРЯДОЧИВАНИЕ"; 


			Запрос.УстановитьПараметр("Номенклатура",Объект.Ссылка);
Результат = Запрос.Выполнить(); 
Дерево_ = Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);       
ЗначениеВРеквизитФормы(Дерево_, "ХарактеристикиИзделия");

	
КонецПроцедуры

&НаКлиенте
Процедура САВ_ЗагрузитьДругиеПараметрыПосле(Команда) 
		 СтандартнаяОбработка=ложь;
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = "Выберите файл";
	Диалог.ПолноеИмяФайла = ""; 
	Фильтр = "Excel (*.xlsx)|*.xlsx"; 
	Диалог.Фильтр = Фильтр; 
    Диалог.МножественныйВыбор = Ложь;
	Диалог.Каталог = "D:\";
	Если Диалог.Выбрать() Тогда
		ИмяФайла = Диалог.ПолноеИмяФайла;
	КонецЕсли;

	




	Попытка
		Эксель = Новый COMОбъект("Excel.Application");
		Эксель.DisplayAlerts = 0;
		Эксель.Visible = 0;
	Исключение
   		Сообщить(ОписаниеОшибки()); 
   		Возврат;
	КонецПопытки;
				
	ЭксельКнига = Эксель.Workbooks.Open(ИмяФайла);	
	
	// Перебираем все листы
	    ТекГр="";
		ТекГрНаим=""; 
		Груп="";
		Лист = ЭксельКнига.Sheets(1);
		КоличествоСтрок = 350;//Лист.Cells(1, 1).SpecialCells(11).Row;
		КоличествоКолонок = 3;//Лист.Cells(1, 1).SpecialCells(11).Column;
 
 
 Номенкл=ТекущийОбъект();
 
	ОчиститьРегистр(Номенкл); 		
		// Перебираем строки
		Для НомерСтроки = 18 По КоличествоСтрок Цикл  
			Попытка
				Груп=Лист.Cells(НомерСтроки, 1).Value;
			Исключение
				Груп="";
			КонецПопытки;
			
			Если Груп=Неопределено Тогда
				ТекГрНаим=СокрЛП(Строка(Лист.Cells(НомерСтроки, 2).Value)); 
				СоздатьГруппу(ТекГрНаим);
				
			Иначе
					ТекНом=Лист.Cells(НомерСтроки, 1).Value;
				Попытка
					ТекПар=Лист.Cells(НомерСтроки, 2).Value;
				Исключение
					ТекПар="";
				КонецПопытки;
			    Попытка
					ТекЗнач=Лист.Cells(НомерСтроки, 3).Value;
				Исключение
					ТекЗнач="";
				КонецПопытки;   
				////Если НЕ ЭтотОбъект.Номенклатура.Пустая() Тогда
				////	Номенкл=ЭтотОбъект.Номенклатура;
				////КонецЕсли;

				////Если НЕ ЭтотОбъект.Характеристика.Пустая() Тогда
				////	Номенкл=ЭтотОбъект.Характеристика;
				////КонецЕсли;

				////Если НЕ ЭтотОбъект.Серия.Пустая() Тогда
				////	Номенкл=ЭтотОбъект.Серия;
				////КонецЕсли;

				
				СоздатьЭлемент(ТекГрНаим,ТекПар,ТекЗнач,Номенкл,ТекНом);
				
				
			КонецЕсли;
			
			КонецЦикла;
			

		
	Эксель.Workbooks.Close();
	Эксель.Application.Quit();
    РезультатЗапроса();
	
КонецПроцедуры

&НаСервере
Функция ТекущийОбъект()
	Возврат Объект.Ссылка;
КонецФункции



Функция СоздатьГруппу(НаимГр) 
	ТекГр=""; 
	Запрос=Новый Запрос;
	Запрос.Текст="Выбрать
		| Ссылка
		|ИЗ
		|	Справочник.САВ_ВидыСвойствНоменклатуры КАК ВС
		|ГДЕ
		|	ВС.Наименование=&Наименование
		|И
		| 	ВС.ЭтоГруппа=Истина";
	Запрос.УстановитьПараметр("Наименование",НаимГр);
	Результат=Запрос.Выполнить().Выбрать();
	Если Результат.Количество()=0 Тогда
		ТекГр=Справочники.САВ_ВидыСвойствНоменклатуры.СоздатьГруппу();
		ТекГр.Наименование=НаимГр;
		ТекГр.Записать(); 
	КонецЕсли;
	
	Возврат НаимГр;
КонецФункции   

Процедура ОчиститьРегистр(номен)
		НаборЗаписей = РегистрыСведений.САВ_ХарактеристикиНоменклатуры.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ВладелецПараметра.Установить(Номен);
	НаборЗаписей.Записать(); 
КонецПроцедуры

Процедура СоздатьЭлемент(ТекГрНаим,ТекПар,ТекЗнач, Номен, ТекНом) 
	ПВХ="";
	Запрос=Новый Запрос;
	Запрос.Текст="Выбрать
		| Ссылка
		|ИЗ
		|	Справочник.САВ_ВидыСвойствНоменклатуры КАК ВС
		|ГДЕ
		|	ВС.Наименование=&Наименование
		|И
		| 	ВС.ЭтоГруппа=Ложь";
	Запрос.УстановитьПараметр("Наименование",ТекПар);
	Результат=Запрос.Выполнить().Выбрать();
	Если Результат.Количество()=0 Тогда  
		Сообщить(ТекПар);
		ТекЭл=Справочники.САВ_ВидыСвойствНоменклатуры.СоздатьЭлемент();
		ТекЭл.Наименование=ТекПар;  
		ТекЭл.НомерПараметра=ТекНом;
		ТекЭл.Родитель=Справочники.САВ_ВидыСвойствНоменклатуры.НайтиПоНаименованию(ТекГрНаим).Ссылка;
		Если ПВХ=ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(ТекПар) Тогда
			ТекЭл.Характеристика=ПВХ; 
		Иначе 
 КЧ = Новый КвалификаторыСтроки(100);
 Массив = Новый Массив;
 Массив.Очистить();
 Массив.Добавить(Тип("СправочникСсылка.ЗначенияСвойствОбъектов"));
 ТЧ=Новый ОписаниеТипов(Массив,КЧ);
 НовЭл=ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.СоздатьЭлемент();
 НовЭл.Наименование=ТекПар;
 //НовЭл.НазначениеСвойства = Справочники.Номенклатура;
 НовЭл.ТипЗначения = ТЧ; 
 НовЭл.Заголовок=ТекПар;
 НовЭл.Записать();

 ТекЭл.Характеристика=ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(ТекПар);
			
			
			
		КонецЕсли;
 ТекЭл.Записать();
Иначе
 	Если Результат.Следующий() Тогда
 		ТекЭл=Результат.Ссылка; 
	Иначе
		Сообщить("Системная ошибка загрузки. Обратитесь к администратору 1С!"); 
		Возврат;
	КонецЕсли;
	
КонецЕсли;	

//Создание записи регистра
 
	
 	НаборЗаписей = РегистрыСведений.САВ_ХарактеристикиНоменклатуры.СоздатьМенеджерЗаписи(); 
 	НаборЗаписей.ВладелецПараметра=Номен;
	НаборЗаписей.СвойствоПараметра=Справочники.САВ_ВидыСвойствНоменклатуры.НайтиПоНаименованию(ТекПар); 
	
	ЗСО=Справочники.ЗначенияСвойствОбъектов.НайтиПоНаименованию(ТекЗнач,Ложь,,ТекЭл.Характеристика);  
	Запрос1 =Новый Запрос;
	Запрос1.Текст="ВЫБРАТЬ
		|	Ссылка
		|ИЗ
		|  	Справочник.ЗначенияСвойствОбъектов КАК ЗСО
		|ГДЕ
		|	ЗСО.Владелец=&ТекЭл
		|И
		|	ЗСО.Наименование ПОДОБНО &ТекЗнач";
	Запрос1.УстановитьПараметр("текЭл",ТекЭл.Характеристика);
	Запрос1.УстановитьПараметр("ТекЗнач","%"+ТекЗнач+"%");
	Рез=Запрос1.Выполнить().Выбрать();
	Если Рез.Следующий() Тогда
		ЗСО=Рез.Ссылка;
	Иначе
		
	
	Запрос2=Новый Запрос; 
	Запрос2.Текст="ВЫБРАТЬ
		|	*
		|ИЗ
		|  	Справочник.ЗначенияСвойствОбъектов КАК ЗСО
		|ГДЕ
		|	ЗСО.Владелец=&ТекЭл";
	Запрос2.УстановитьПараметр("ТекЭл",ТекЭл.Характеристика);
	Результат=Запрос2.Выполнить().Выбрать();
	НомерЗн=Результат.Количество();
		ЗСО=Справочники.ЗначенияСвойствОбъектов.СоздатьЭлемент();
		ЗСО.Наименование= Строка(НомерЗн+1)+". "+ТекЗнач;
		ЗСО.Владелец=ТекЭл.Характеристика;  
		ЗСО.Записать();
	КонецЕсли;
	
	
	НаборЗаписей.ЗначениеПоУмолчанию=ЗСО;
	НаборЗаписей.Записать();



//************************
	
	
		

	КонецПроцедуры
	
	

&НаКлиенте
Процедура САВ_ХарактеристикиИзделияЗначениеПоУмолчаниюПриИзмененииПосле(Элемент)
	//Сообщить(ЭтотОбъект.Элементы.ХарактеристикиИзделия.ТекущиеДанные.Наименование+", "+Элемент.ТекстРедактирования); 
	ПереписатьПараметр(ЭтотОбъект.Элементы.ХарактеристикиИзделия.ТекущиеДанные.Наименование,ЭтотОбъект.Элементы.ХарактеристикиИзделия.ТекущиеДанные.НомерПараметра,Элемент.ТекстРедактирования);
КонецПроцедуры   
&НаСервере
Процедура ПереписатьПараметр(Параметр,НомерПараметра,НовоеЗначениеПараметра) 
	 Запрос = Новый Запрос;
    Запрос.Текст = 
    "ВЫБРАТЬ
    |    ХН.ЗначениеПоУмолчанию КАК ЗначениеПоУмолчанию
    |ИЗ
    |    РегистрСведений.САВ_ХарактеристикиНоменклатуры КАК ХН
    |ГДЕ
    |    ХН.ВладелецПараметра = &ВладелецПараметра И
    |    ХН.СвойствоПараметра = &СвойствоПараметра";
    
    Запрос.УстановитьПараметр("ВладелецПараметра", Объект.Ссылка);
    Запрос.УстановитьПараметр("СвойствоПараметра", Параметр);

    Выборка = Запрос.Выполнить().Выбрать();
    Если НЕ Выборка.Следующий() Тогда
        ТекЗапись = РегистрыСведений.САВ_ХарактеристикиНоменклатуры.СоздатьМенеджерЗаписи();
        ТекЗапись.ВладелецПараметра = Объект.Ссылка;
        ТекЗапись.СвойствоПараметра = Параметр;  
		ТекЗапись.ЗначениеПоУмолчанию=Справочники.ЗначенияСвойствОбъектов.НайтиПоНаименованию(НовоеЗначениеПараметра,Истина,,ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(Параметр));
        Попытка        
            ТекЗапись.Записать();
        Исключение
        КонецПопытки;
    Иначе
        ТекЗапись = РегистрыСведений.САВ_ХарактеристикиНоменклатуры.СоздатьМенеджерЗаписи();
        ТекЗапись.ВладелецПараметра = Объект.Ссылка;
        ТекЗапись.СвойствоПараметра = Параметр;
		
		ТекЗапись.Прочитать();
        
        ТекЗапись.ЗначениеПоУмолчанию  = Справочники.ЗначенияСвойствОбъектов.НайтиПоНаименованию(НовоеЗначениеПараметра,Истина,,ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(Параметр));
        //Попытка
            ТекЗапись.Записать();
        //Исключение
        //КонецПопытки;

    КонецЕсли;   
	
КонецПроцедуры

&НаКлиенте
Процедура САВ_ХарактеристикиИзделияЗначениеПоУмолчаниюНачалоВыбораПосле(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;	
	
	ЗначениеОтбора = Новый Структура("Владелец",ТекСпр(Элементы.ХарактеристикиИзделия.ТекущиеДанные.Наименование));
	ПараметрыВыбора1 = Новый Структура("Отбор", ЗначениеОтбора, Истина);
	ПараметрыВыбора1.Вставить("РежимВыбора",Истина);
	
	ОткрытьФорму("Справочник.ЗначенияСвойствОбъектов.Форма.ФормаСписка",ПараметрыВыбора1,Элемент);

КонецПроцедуры


&НаСервере
Функция ТекСпр(НаименованиеОбъекта)
	Возврат ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(НаименованиеОбъекта.Наименование);
КонецФункции

&НаКлиенте
Процедура РСК_ГиперссылкаПерейтиШтрихкодыСерийНоменклатурыОбработкаНавигационнойСсылкиВместо(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	//++ РС Консалт: Минаков А.С. Задача 20226
	СтандартнаяОбработка = Ложь;
	ГиперссылкаПерейтиСформироватьПараметрыИВопрос(Элемент.Имя, НавигационнаяСсылкаФорматированнойСтроки)
    //++ РС Консалт: Минаков А.С. Задача 20226
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
&Вместо("ИмяЭлементаПереходаКСвязанномуСписку")
Функция РСК_ИмяЭлементаПереходаКСвязанномуСписку(Элементы, ИмяЭлемента, ИмяГиперссылки)
	
	НовоеИмя = ПродолжитьВызов(Элементы, ИмяЭлемента, ИмяГиперссылки); 

	//++ РС Консалт: Минаков А.С. Задача 20226
	Если ИмяГиперссылки Тогда
		Если ИмяЭлемента = Элементы.ГиперссылкаПерейтиШтрихкодыСерийНоменклатуры.Имя Тогда
			НовоеИмя = Элементы.КомандаПерейтиШтрихкодыСерийНоменклатуры.Имя
		КонецЕсли
	Иначе
		Если ИмяЭлемента = Элементы.КомандаПерейтиШтрихкодыСерийНоменклатуры.Имя Тогда
			НовоеИмя = Элементы.ГиперссылкаПерейтиШтрихкодыСерийНоменклатуры.Имя
		КонецЕсли
	КонецЕсли;
	//++ РС Консалт: Минаков А.С. Задача 20226

	Возврат НовоеИмя
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
&Вместо("ЭлементПереходаКСвязанномуСписку")
Функция РСК_ЭлементПереходаКСвязанномуСписку(Элементы, ИмяЭлемента)
	
	ЭлементПереходаКСвязанномуСписку = ПродолжитьВызов(Элементы, ИмяЭлемента);
	
	//++ РС Консалт: Минаков А.С. Задача 20226
	Если ИмяЭлемента = Элементы.ГиперссылкаПерейтиШтрихкодыСерийНоменклатуры.Имя Тогда
		
		ЭлементПереходаКСвязанномуСписку = Истина
		
	КонецЕсли;
	//++ РС Консалт: Минаков А.С. Задача 20226
	
	Возврат ЭлементПереходаКСвязанномуСписку
	
КонецФункции

&НаКлиенте
&Вместо("ПараметрыПереходаПоГиперссылке")
Функция РСК_ПараметрыПереходаПоГиперссылке(ИмяЭлемента, Гиперссылка)
	
	ПараметрыПереходаПоГиперссылке = ПродолжитьВызов(ИмяЭлемента, Гиперссылка);
	
	//++ РС Консалт: Минаков А.С. Задача 20226
	Если ИмяЭлемента = "ГиперссылкаПерейтиШтрихкодыСерийНоменклатуры" Тогда
		
		ПараметрыФормы = Новый Структура("Номенклатура", Объект.Ссылка);
		
		ПараметрыПереходаПоГиперссылке.ИмяФормы       = "РегистрСведений.ДСТ_ШтрихкодыСерий.ФормаСписка";
		ПараметрыПереходаПоГиперссылке.ПараметрыФормы = ПараметрыФормы
		
	КонецЕсли;
	//++ РС Консалт: Минаков А.С. Задача 20226
	
	Возврат ПараметрыПереходаПоГиперссылке 

КонецФункции

&НаСервере
Процедура РСК_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	ЗаполнитьТаблицуДокументации();
КонецПроцедуры  

&НаСервере
Процедура ЗаполнитьТаблицуДокументации()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВладелецФайла",Объект.Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НоменклатураПрисоединенныеФайлы.Ссылка КАК Ссылка,
	|	ЕСТЬNULL(НоменклатураПрисоединенныеФайлы.ИндексКартинки, -1) КАК ИндексКартинки,
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(НоменклатураПрисоединенныеФайлы.Ссылка) КАК ИмяФайла,
	|	ДокументацияНоменклатуры.Ссылка КАК ТипДокумента
	|ИЗ
	|	Перечисление.ДокументацияНоменклатуры КАК ДокументацияНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураПрисоединенныеФайлы КАК НоменклатураПрисоединенныеФайлы
	|		ПО ДокументацияНоменклатуры.Ссылка = НоменклатураПрисоединенныеФайлы.ТипДокумента
	|			И (НоменклатураПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла)
	|			И (НоменклатураПрисоединенныеФайлы.ПометкаУдаления = ЛОЖЬ)";    
	
	Результат = Запрос.Выполнить().Выгрузить(); 
	Документация.Загрузить(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура РСК_ДокументацияВыборПосле(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда 
		Обработчик = Новый ОписаниеОповещения("ВыполнитьДействиеСПрисоединеннымиФайламиПослеЗаписи", ЭтотОбъект,Элемент);
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
			|Работа с файлами возможна только после записи данных.
			|Данные будут записаны.';
			|en = 'Data is not written yet.
			|You can use files only after data is written.
			|Data will be written.'");
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	Иначе
		ОбработатьДействиеПрисоединенныеФайлы(Элемент);	
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработатьДействиеПрисоединенныеФайлы(Элемент)
	
	ТекущиеДанные = Элементы.Документация.ТекущиеДанные; 
	Если ТекущиеДанные = Неопределено Или Элемент.ТекущийЭлемент.Имя = "ДокументацияТипДокумента" Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Ссылка.Пустая() Тогда
		ДобавитьПрисоединенныйФайл();
	Иначе
		ОткрытьПрисоединенныйФайл();
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеСПрисоединеннымиФайламиПослеЗаписи(Ответ,Элемент) Экспорт
	
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ЭтаФорма.Записать();
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьДействиеПрисоединенныеФайлы(Элемент);
	
КонецПроцедуры 

&НаКлиенте
Процедура ОткрытьПрисоединенныйФайл()
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Документация.ТекущиеДанные.Ссылка,
		Неопределено, УникальныйИдентификатор, Неопределено);  
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
	
КонецПроцедуры   

&НаКлиенте
Процедура ДобавитьПрисоединенныйФайл() 
	
	ТекущиеДанные = Элементы.Документация.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ТипДокумента) Тогда
		Сообщить("Укажите тип документа");
		Возврат
	КонецЕсли;  
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.МножественныйВыбор = Ложь;
	ОписаниеОповещение = Новый ОписаниеОповещения("ДиалогВыбораФайловПослеВыбора", ЭтотОбъект);
	Диалог.Показать(ОписаниеОповещение); 
		
КонецПроцедуры  

&НаКлиенте
Процедура ДиалогВыбораФайловПослеВыбора(ВыбранныйФайл, ДополнительныеПараметры) Экспорт
	
	Если Не ТипЗнч(ВыбранныйФайл) = Тип("Массив") 
		Или Не ВыбранныйФайл.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Документация.ТекущиеДанные;
	Файл = Новый Файл(ВыбранныйФайл[0]);
	ОбщиеНастройки = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ОбщиеНастройкиРаботыСФайлами;
	РаботаСФайламиСлужебныйКлиент.ПроверитьВозможностьЗагрузкиФайлаСТипом(Файл);
		
	Если ОбщиеНастройки.ИзвлекатьТекстыФайловНаСервере Тогда
		АдресВременногоХранилищаТекста = "";
	Иначе
		АдресВременногоХранилищаТекста = РаботаСфайламиСлужебныйКлиент.ИзвлечьТекстФайлаВоВременноеХранилище(ВыбранныйФайл[0], УникальныйИдентификатор);
	КонецЕсли;
    ВремяИзмененияУниверсальное = Файл.ПолучитьУниверсальноеВремяИзменения();
	ПомещаемыеФайлы = Новый Массив;
	Описание = Новый ОписаниеПередаваемогоФайла(Файл.ПолноеИмя, "");
	ПомещаемыеФайлы.Добавить(Описание);
	
	ПомещенныеФайлы = Новый Массив;		
	Если НЕ ПоместитьФайлы(ПомещаемыеФайлы, ПомещенныеФайлы, , Ложь, УникальныйИдентификатор) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Ошибка при помещении файла
		|""%1""
		|в программу.';
		|en = 'An error occurred when storing file
		|""%1""
		|to the application.'"),
		Файл.ПолноеИмя) );
	КонецЕсли;
	
	АдресВременногоХранилищаФайла = ПомещенныеФайлы[0].Хранение;
	РасширениеФайла 			  = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(Файл.Расширение);
	ИмяФайлаБезРасширения 		  = Файл.ИмяБезРасширения;
	
	ТекущиеДанные.ИмяФайла = ИмяФайлаБезРасширения; 
	
	Если ТекущиеДанные.Ссылка.Пустая() Тогда 
		ПараметрыФайла 							   = РаботаСФайламиСлужебныйКлиентСервер.ПараметрыДобавленияФайла();
		ПараметрыФайла.ГруппаФайлов 			   = Неопределено;
		ПараметрыФайла.ВладелецФайлов 			   = Объект.Ссылка;
		ПараметрыФайла.ИмяБезРасширения 		   = ИмяФайлаБезРасширения;
		ПараметрыФайла.РасширениеБезТочки 		   = РасширениеФайла;
		ПараметрыФайла.ВремяИзмененияУниверсальное = ВремяИзмененияУниверсальное;
		ПараметрыФайла.Вставить("ТипДокумента",ТекущиеДанные.ТипДокумента);
		
		ПрисоединенныйФайл = РаботаСФайламиСлужебныйВызовСервера.ДобавитьФайл(ПараметрыФайла,
			АдресВременногоХранилищаФайла, АдресВременногоХранилищаТекста);		
			
		Если ПрисоединенныйФайл <> Неопределено Тогда
			ТекущиеДанные.Ссылка = ПрисоединенныйФайл;
		КонецЕсли;
	Иначе
		ИнформацияОФайле = Новый Структура;
		ИнформацияОФайле.Вставить("АдресФайлаВоВременномХранилище",АдресВременногоХранилищаФайла);
		ИнформацияОФайле.Вставить("АдресВременногоХранилищаТекста",АдресВременногоХранилищаТекста);
		ИнформацияОФайле.Вставить("ИмяБезРасширения",ИмяФайлаБезРасширения);
		ИнформацияОФайле.Вставить("ДатаМодификацииУниверсальная",ВремяИзмененияУниверсальное);
		ИнформацияОФайле.Вставить("Расширение",РасширениеФайла); 
		ИнформацияОФайле.Вставить("Редактирует",Неопределено);
		ИнформацияОФайле.Вставить("Кодировка",Неопределено);
		
		ОбновитьПрисоединенныйФайл(ТекущиеДанные.Ссылка,ИнформацияОФайле);
	КонецЕсли;  
	
	ТекущиеДанные.ИндексКартинки  = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(РасширениеФайла);  
	
КонецПроцедуры  

&НаСервереБезКонтекста
Процедура ОбновитьПрисоединенныйФайл(Файл,ИнформацияОФайле)
	РаботаСФайлами.ОбновитьФайл(Файл,ИнформацияОФайле);		
КонецПроцедуры

&НаКлиенте
Процедура РСК_ОбновитьФайлПосле(Команда)
	ДобавитьПрисоединенныйФайл();
КонецПроцедуры

&НаКлиенте
Процедура РСК_УдалитьФайлПосле(Команда)
	
	ТекущиеДанные = Элементы.Документация.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда		
		Возврат;
	КонецЕсли;
	
	РезультатУдаления = УдалитьПрисоединенныйФайлНаСервере(ТекущиеДанные.Ссылка); 
	
	Если НЕ ЗначениеЗаполнено(РезультатУдаления.ТекстПредупреждения) Тогда
		ТекущиеДанные.Ссылка  		 = ПредопределенноеЗначение("Справочник.НоменклатураПрисоединенныеФайлы.ПустаяСсылка");
		ТекущиеДанные.ИмяФайла 		 = "";
		ТекущиеДанные.ИндексКартинки = -1;
    КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Функция УдалитьПрисоединенныйФайлНаСервере(Файл)
	Возврат РаботаСФайламиСлужебныйВызовСервера.РезультатУдаленияДанных(Файл,УникальныйИдентификатор);	
КонецФункции

&НаСервере
&ИзменениеИКонтроль("ПриСозданииНаСервере")
Процедура РСК_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);

	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);

	УправлениеДоступом.ПриСозданииФормыЗначенияДоступа(ЭтаФорма);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	ЕстьПравоРедактирования = Справочники.ГруппыДоступаНоменклатуры.ЕстьПравоИзменения(Объект);

	ПараметрыДополнительныхСвойств = Новый Структура;
	ПараметрыДополнительныхСвойств.Вставить("Объект", Объект);
	ПараметрыДополнительныхСвойств.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ПараметрыДополнительныхСвойств.Вставить("СкрытьУдаленные", Ложь);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ПараметрыДополнительныхСвойств);
	#Вставка
	ЕстьПравоДобавленияФайлов = Пользователи.РолиДоступны("РСК_ДобавлениеДокументацииНоменклатуры",Пользователи.ТекущийПользователь());
	#КонецВставки
	
	Если Не ЕстьПравоРедактирования Тогда
		#Вставка
		Если НЕ ЕстьПравоДобавленияФайлов Тогда
		#КонецВставки
		Элементы.СтраницыКарточкаНоменклатуры.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет; 
		#Вставка
		Иначе
			Элементы.СтраницаХарактеристикиИзделия.Видимость = Ложь;
		КонецЕсли;
		#КонецВставки
		Элементы.СтраницаРеквизитыНоменклатуры.Видимость = Ложь;
		КарточкаНоменклатуры = Справочники.Номенклатура.ТабличныйДокументКарточкиНоменклатуры(Объект, Неопределено, Ложь);
		Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
			Элементы.ПодменюПерейти.Видимость = Ложь;
		КонецЕсли;
		ОбновитьКешРеквизитовВидаНоменклатуры();
		ПриСозданииНаСервереЛокализация(Отказ, СтандартнаяОбработка);
		СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
		НастроитьФормуИОбновитьКарточку();
		Возврат;
	КонецЕсли;

	// Запрет редактирования
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);

	ИспользоватьТоварныеКатегории = ПолучитьФункциональнуюОпцию("ИспользоватьТоварныеКатегории");

	Если Параметры.Свойство("РежимВыбора")
		И Параметры.РежимВыбора Тогда
		ДляВыбора = Истина;
	КонецЕсли;

	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовНоменклатуры") Тогда
		МассивВидов = Справочники.ВидыНоменклатуры.ПолучитьПредустановленныеВидыНоменклатуры();
		Элементы.ВидНоменклатурыПереключатель.СписокВыбора.ЗагрузитьЗначения(МассивВидов);
		Элементы.ВидНоменклатурыПереключательОбязательныеПоля.СписокВыбора.ЗагрузитьЗначения(МассивВидов);
	КонецЕсли;

	КоэффициентПересчетаВКубическиеМетры = 
	НоменклатураСервер.КоэффициентПересчетаВКубическиеМетры(Константы.ЕдиницаИзмеренияОбъема.Получить());

	ПоказатьСоветПереходКРедактированию = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("Справочник.Номенклатура.Форма.ФормаЭлемента",
	"ПоказатьСоветПереходКРедактированию",
	Истина);

	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		// Установим доступность
		// ... формы в целом 
		ЭтаФорма.ТолькоПросмотр = Не ЕстьПравоРедактирования;

		// ... полей шаблонов этикетки и ценника
		Элементы.ИспользоватьИндивидуальныйШаблонЦенника.ТолькоПросмотр   = Не ПравоДоступа("Редактирование", Метаданные.Справочники.Номенклатура.Реквизиты.ИспользоватьИндивидуальныйШаблонЦенника);
		Элементы.ИспользоватьИндивидуальныйШаблонЭтикетки.ТолькоПросмотр = Не ПравоДоступа("Редактирование", Метаданные.Справочники.Номенклатура.Реквизиты.ИспользоватьИндивидуальныйШаблонЭтикетки);

		// ... поля картинки и кнопок его панели
		ЕстьПравоРедактированияКартинки    = ПравоДоступа("Редактирование", Метаданные.Справочники.Номенклатура.Реквизиты.ФайлКартинки);
		Элементы.ФайлКартинки.Доступность = ЕстьПравоРедактированияКартинки;
		Элементы.ДобавитьИзображение.Доступность = ЕстьПравоРедактированияКартинки;
		Элементы.ИзменитьИзображение.Доступность = ЕстьПравоРедактированияКартинки;
		Элементы.ОчиститьИзображение.Доступность = ЕстьПравоРедактированияКартинки;
		Элементы.ВыбратьКартинкуИзПрисоединенныхФайлов.Видимость = ЕстьПравоРедактированияКартинки;

		// ... поля описание для сайта и кнопки его выбора
		ЕстьПравоРедактированияОписания = ПравоДоступа("Редактирование", Метаданные.Справочники.Номенклатура.Реквизиты.ФайлОписанияДляСайта);
		Элементы.ФайлОписанияДляСайта.ТолькоПросмотр = Не ЕстьПравоРедактированияОписания;

		// Режим редактирования
		Элементы.СтраницыКарточкаНоменклатуры.ТекущаяСтраница = Элементы.СтраницаКарточкаНоменклатуры;
		НастройкаВидимостиФормы = "СвернутьВсеГруппы";
		РежимВидимостиПоказатьТолькоВажные = Ложь;

		СкрытьРаскрытьВсеГруппы(Истина);
		Элементы.ГруппаГруппировкаЛевоПраво.Видимость=Ложь;

		Элементы.НастройкаВидимостиФормы.СписокВыбора.Удалить(0);

		ОбновитьКешРеквизитовВидаНоменклатуры();
		ОбновитьЭлементыДополнительныхРеквизитов(Ложь);
		НастроитьДоступностьБлокируемыхРеквизитов();

	Иначе	

		ПараметрыСозданияСтруктура = Новый Структура;
		ПараметрыСозданияСтруктура.Вставить("Наименование", "");
		ПараметрыСозданияСтруктура.Вставить("НаименованиеПолное", "");
		ПараметрыСозданияСтруктура.Вставить("ИсточникКопирования", Параметры.ЗначениеКопирования);

		ПереданныеДополнительныеПараметры = Неопределено;
		Если Параметры.Свойство("ДополнительныеПараметры", ПереданныеДополнительныеПараметры) И ПереданныеДополнительныеПараметры <> Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыСозданияСтруктура, ПереданныеДополнительныеПараметры, Истина);
		КонецЕсли;

		Если Параметры.Свойство("ТекстЗаполнения")
			И Не ПустаяСтрока(Параметры.ТекстЗаполнения) Тогда

			ПараметрыСозданияСтруктура.Наименование = Параметры.ТекстЗаполнения;

		КонецЕсли;

		ПараметрыСоздания = Новый ФиксированнаяСтруктура(ПараметрыСозданияСтруктура);

		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			// Режим копирования
			Элементы.СтраницыКарточкаНоменклатуры.ТекущаяСтраница = Элементы.СтраницаРеквизитыНоменклатуры;
			НастройкаВидимостиФормы = "ПоказатьВсе";
			РежимВидимостиПоказатьТолькоВажные = Ложь;

			СкрытьРаскрытьВсеГруппы(Ложь);

			ЗаполнитьПоОбъектуКопирования();

			ВидНоменклатурыДоИзменения = Объект.ВидНоменклатуры;
		Иначе
			// Режим создания
			Элементы.СтраницыКарточкаНоменклатуры.ТекущаяСтраница = Элементы.СтраницаРеквизитыНоменклатуры;
			НастройкаВидимостиФормы = "ПоказатьОсновные";
			РежимВидимостиПоказатьТолькоВажные = Истина;

			СкрытьРаскрытьВсеГруппы(Ложь);
		КонецЕсли;

		ЗаполнитьПоПараметрамСоздания();

		ПриСозданииЧтенииНаСервере();

	КонецЕсли;

	ПриСозданииНаСервереЛокализация(Отказ, СтандартнаяОбработка);

	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

	НастроитьФормуИОбновитьКарточку();

	ФормаИнициализирована = Истина;

КонецПроцедуры






