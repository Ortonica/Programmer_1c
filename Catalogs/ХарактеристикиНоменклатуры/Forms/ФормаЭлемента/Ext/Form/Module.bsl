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
		КоличествоСтрок = 359;//Лист.Cells(1, 1).SpecialCells(11).Row;
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


&НаСервере
Функция ПроверкаБазы()
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
		|	Количество(Ссылка)	
		|ИЗ
		|	РегистрСведений.САВ_ХарактеристикиНоменкладуры КАК ХН	
		|ГДЕ
		|	ХН.ВладелеПараметра=&ВП";
	Запрос.УстановитьПараметр("ВП",Объект.Ссылка);
	Рез=Запрос.Выполнить().Выбрать();
	Если Рез.Следующий() Тогда
		Результат=Истина;
	Иначе
		Результат=Ложь;
	КонецЕсли;
	
	Возврат Результат;	
КонецФункции


&НаКлиенте
Процедура САВ_ХарактеристикиИзделияЗначениеПоУмолчаниюПриИзмененииПосле(Элемент)
	ПереписатьПараметр(ЭтотОбъект.Элементы.ХарактеристикиИзделия.ТекущиеДанные.Наименование,ЭтотОбъект.Элементы.ХарактеристикиИзделия.ТекущиеДанные.НомерПараметра,Элемент.ТекстРедактирования);
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
	Возврат ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(НаименованиеОбъекта);
КонецФункции


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


&НаСервере
Процедура САВ_СкопироватьПараметрыПослеНаСервере() 
	Запрос= Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
		|	*
		|ИЗ
		|  	Справочник.САВ_ВидыСвойствНоменклатуры КАК Спр";
Рез=Запрос.Выполнить().Выбрать();
Пока Рез.Следующий() Цикл 
	
	
	ИсходнаяЗапись = РегистрыСведений.САВ_ХарактеристикиНоменклатуры.СоздатьМенеджерЗаписи();
	ИсходнаяЗапись.ВладелецПараметра = Объект.Ссылка.Владелец; 
	ИсходнаяЗапись.СвойствоПараметра = Рез.Ссылка;
	ИсходнаяЗапись.Прочитать();
	
	Если ИсходнаяЗапись.Выбран() Тогда
		
		НоваяЗапись = РегистрыСведений.САВ_ХарактеристикиНоменклатуры.СоздатьМенеджерЗаписи();
		НоваяЗапись.ВладелецПараметра =  Объект.Ссылка;
		
		ЗаполнитьЗначенияСвойств(НоваяЗапись, ИсходнаяЗапись, , "ВладелецПараметра");
		НоваяЗапись.Записать();
		
	КонецЕсли;
КонецЦикла;	
КонецПроцедуры


&НаКлиенте
Процедура САВ_СкопироватьПараметрыПосле(Команда)
	САВ_СкопироватьПараметрыПослеНаСервере();
КонецПроцедуры


&НаСервере
Процедура РСК_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	//++Конарев Артикулы характеристик 
	НовыйЭлемент = Элементы.Вставить("Артикул", Тип("ПолеФормы"), Элементы.СтраницаОбщая,Элементы.ДекорацияПредупреждение);	
	НовыйЭлемент.Заголовок = "Артикул";
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "Объект.Артикул";
	
КонецПроцедуры


&НаКлиенте
Процедура РСК_ХарактеристикиИзделияПередУдалениемПосле(Элемент, Отказ)
		УдалитьПараметр(Элемент.ТекущиеДанные.Наименование);

КонецПроцедуры


&НаСервере
Процедура УдалитьПараметр(Параметр) 
	 
		ТекЗапись = РегистрыСведений.САВ_ХарактеристикиНоменклатуры.СоздатьНаборЗаписей();
		ТекЗапись.Отбор.ВладелецПараметра.Установить(Объект.Ссылка); 
		ТекЗапись.Отбор.СвойствоПараметра.Установить(Параметр); 
		
		ТекЗапись.Записать();
	
КонецПроцедуры

