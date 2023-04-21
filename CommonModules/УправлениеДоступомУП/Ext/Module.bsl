﻿
&ИзменениеИКонтроль("ДобавитьПрофильМенеджераПоПереработкеДавальческогоСырья")
Процедура РСК_ДобавитьПрофильМенеджераПоПереработкеДавальческогоСырья(ОписанияПрофилей)
	
	// Профиль "Менеджер по переработке давальческого сырья".
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Имя           = "МенеджерПоПереработкеДавальческогоСырья";
	ОписаниеПрофиля.Идентификатор = "7387da79-e932-11e2-a832-c86000df10d3";
	ОписаниеПрофиля.Родитель      = "Производство";
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Менеджер по переработке давальческого сырья';
										|en = 'Provided material processing officer'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	ДополнитьПрофильОбязательнымиРолями(ОписаниеПрофиля);
	
	///////////////////////////////////////////////////////////////////////
	// Базовые права.
	ОписаниеПрофиля.Роли.Добавить("БазовыеПраваУТ");
	
	///////////////////////////////////////////////////////////////////////
	// Справочники, чтение.
	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНазначений");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКалендарей");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеАссортимента");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеМаршрутныхКарт");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТехнологическихПроцессов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСоглашенийСКлиентами");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСоглашенийСПоставщиками");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДоговоровКонтрагентов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеИнформацииПоПартнерам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеИнформацииПоНоменклатуре");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеШаблоновЭтикетокИЦенников");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеПроизводстваВПанелиНавигацииНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНормативноСправочнойИнформации");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПодключаемогоОборудованияOffline");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОрганизацийИБанковскихСчетовОрганизаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКасс");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВидовРаботСотрудников");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРесурсныхСпецификаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСтатейКалькуляции");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСтруктурыРабочихЦентров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПроизводственныхУчастков");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПриоритетов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПричинОтменыЗаказовКлиентов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПричинОтменыЗаказовПоставщикам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНоменклатурыКонтрагентовБЭД");
	
	///////////////////////////////////////////////////////////////////////
	// Справочники, добавление изменение.
	
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДоговоровКонтрагентов");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНазначений");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНоменклатурыПартнеров");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНоменклатурыКонтрагентовБЭД");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеСделок");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеТранспортныхСредств");
	ОписаниеПрофиля.Роли.Добавить("ИзменениеСкладскойИнформацииПоНоменклатуре");
	ОписаниеПрофиля.Роли.Добавить("РегистрацияШтрихкодовНоменклатуры");
	
	///////////////////////////////////////////////////////////////////////
	// Регистры, чтение.
	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЦенПартнеров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЦенНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТоваровОрганизаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРасчетовСКлиентами");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРасчетовСПоставщиками");	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковТоваровНаСкладах");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковДоступныхТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковМатериаловИРаботВПроизводстве");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковЗаказовПоставщикам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковТоваровКОтгрузке");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковТоваровКПоступлению");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковДенежныхСредствКРасходу");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТоваровКОформлениюДокументовИмпорта");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеАссортимента");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСостоянийДоставки");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСостоянияЗаказовКлиента");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеМоделейФормированияСтоимости");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОсновныхМаршрутныхКарт");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковЗаказовКлиентовЗаявокНаВозврат");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовПоставщикам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеАналоговМатериалов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеГрафикаПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТоваровКОформлениюДокументовИмпорта");
	//++ Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПотреблениеМатериаловИУслугВПроизводстве");
	//-- Устарело_Производство21
	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСебестоимостиТоваров");
	// Регистры расширенной аналитики управленческого учета
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВыручкиОтПродаж");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДвиженийНоменклатураКонтрагент");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДвиженийНоменклатураДоходыРасходы");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДвиженийНоменклатураНоменклатура");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПроизводственныхЗатрат");
	
	///////////////////////////////////////////////////////////////////////
	// Документы, чтение.
	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаданийНаПеревозку");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковВзаиморасчетов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковДенежныхСредств");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковОПродажахЗаПрошлыеПериоды");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковПоФинансовымИнструментам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковПрочиеРасходы");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковПрочихАктивовПассивов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковРасчетовПоЭквайрингу");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковСПодотчетниками");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПервичныхДокументов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКассовыхОрдеров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОтчетовКомитенту");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОтчетовКомиссионеров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПеремещенийТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДвиженийПродукцииИМатериалов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСборокТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПрочихОприходованийТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОперацийПоПлатежнойКарте");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОтчетовОРозничныхПродажах");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДокументовКорректировкиЗадолженности");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДокументовСписанияПоступленияБезналичныхДС");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДокументовПередачиТоваровМеждуОрганизациями");
	//++ Устарело_Переработка24
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДокументовПоПереработкеДавальческогоСырья");
	//-- Устарело_Переработка24
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовДавальцев2_5");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОтчетовДавальцам2_5");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКорректировокОбособленногоУчетаЗапасов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРеализацийУслугПрочихАктивов"); 
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаданийНаПеревозку");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеУпаковочныхЛистов");
	//++ Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПередачМатериаловВПроизводство");
	//-- Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОперацийСПодарочнымиСертификатами");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЧековККМ");
	
	///////////////////////////////////////////////////////////////////////
	// Документы, добавление изменение.
	
	//++ Устарело_Переработка24
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеВозвратовДавальцам");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеЗаказовДавальцев");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеОтчетовДавальцам");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПередачДавальцам");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПоступленийОтДавальцев");
	//-- Устарело_Переработка24
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеВыкуповВозвратнойТарыКлиентами");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеЗаказовДавальцев2_5");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПриемкиТоваровНаХранение");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеОтгрузкиТоваровСХранения");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеОтчетовОСписанииПринятыхНаХранениеТоваров");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеВыкуповПринятыхНаХранениеТоваров");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеОтчетовДавальцам2_5");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеТранспортныхНакладных");
	#Удаление
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРасходныхОрдеровНаТовары");
	#КонецУдаления
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДокументовКорректировкиЗадолженностиЗачетОплаты");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПорученийЭкспедиторам");
	ОписаниеПрофиля.Роли.Добавить("ЗачетОплаты");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеАктовОРасхожденияхПослеПоступленияОтДавальца");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеАктовОРасхожденияхПослеОтгрузкиДавальцу");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеКорректировокРеализаций");
	
	///////////////////////////////////////////////////////////////////////
	// Обработки, отчеты.
	
	//++ Устарело_Переработка24
	ОписаниеПрофиля.Роли.Добавить("ОтчетыПроизводстваИзДавальческогоСырья");
	//-- Устарело_Переработка24
	ОписаниеПрофиля.Роли.Добавить("ОтчетыПроизводстваИзДавальческогоСырья2_5");
	ОписаниеПрофиля.Роли.Добавить("ОтчетыМенеджераПоПродажам");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетаОстаткиИДоступностьТоваров");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетаСостояниеВыполненияДокумента");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетаТоварыСИстекающимиСертификатами");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрЭтаповОплатыКлиентом");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиЖурналДокументовВнутреннегоТовародвижения");
	//++ Устарело_Переработка24
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиЖурналДокументовПереработки");
	//-- Устарело_Переработка24
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиЖурналДокументовПриемаВПереработку2_5");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеУправлениеПеремещениемОбособленныхТоваров");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрКомандыСостояниеОбеспеченияЗаказов");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиПечатьЭтикетокИЦенников");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиСостояниеОбеспеченияЗаказов");
	
	///////////////////////////////////////////////////////////////////////
	// Видимые подсистемы КИ
	
	ОписаниеПрофиля.Роли.Добавить("РазделПродажи");
	ОписаниеПрофиля.Роли.Добавить("ПодсистемаСклад");
	ОписаниеПрофиля.Роли.Добавить("РазделПродажиПриемВПереработку");
	ОписаниеПрофиля.Роли.Добавить("РазделНормативноСправочнаяИнформация");
	
	///////////////////////////////////////////////////////////////////////
	// Виды доступа
	
	ОписаниеПрофиля.ВидыДоступа.Добавить("ВидыЦен",									"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ГруппыПартнеров",							"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ГруппыФизическихЛиц",						"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ГруппыНоменклатуры",						"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации",								"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("Склады",									"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ВидыЦен",									"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("Подразделения",							"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ВидыОперацийВзаимозачетаЗадолженности", 	"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ХозяйственныеОперации",					"Предустановленный");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ТипыОснованийАктаОРасхождениях",			"Предустановленный");
	
	///////////////////////////////////////////////////////////////////////
	// Значения доступа
	
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ХозяйственныеОперации", "Перечисление.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья2_5");
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ХозяйственныеОперации", "Перечисление.ХозяйственныеОперации.ПоступлениеОтДавальца2_5");
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ХозяйственныеОперации", "Перечисление.ХозяйственныеОперации.ПередачаДавальцу2_5");
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ХозяйственныеОперации", "Перечисление.ХозяйственныеОперации.ВозвратДавальцу2_5");
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ХозяйственныеОперации", "Перечисление.ХозяйственныеОперации.ОтчетДавальцу2_5");
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ХозяйственныеОперации", "Перечисление.ХозяйственныеОперации.СписаниеТоваровДавальцаЗаСчетДавальца");
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ХозяйственныеОперации", "Перечисление.ХозяйственныеОперации.СписаниеТоваровДавальцаНаРасходы");
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ХозяйственныеОперации", "Перечисление.ХозяйственныеОперации.ВыкупТоваровДавальца");
	
	//++ Устарело_Переработка24
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ХозяйственныеОперации", "Перечисление.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья");
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ХозяйственныеОперации", "Перечисление.ХозяйственныеОперации.ПоступлениеОтДавальца");
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ХозяйственныеОперации", "Перечисление.ХозяйственныеОперации.ПередачаДавальцу");
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ХозяйственныеОперации", "Перечисление.ХозяйственныеОперации.ВозвратДавальцу");
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ХозяйственныеОперации", "Перечисление.ХозяйственныеОперации.ОтчетДавальцу");
	//-- Устарело_Переработка24
	
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ТипыОснованийАктаОРасхождениях", "Перечисление.ТипыОснованияАктаОРасхождении.ПоступлениеОтДавальца");
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ТипыОснованийАктаОРасхождениях", "Перечисление.ТипыОснованияАктаОРасхождении.ПередачаДавальцу");
	ОписаниеПрофиля.ЗначенияДоступа.Добавить("ТипыОснованийАктаОРасхождениях", "Перечисление.ТипыОснованияАктаОРасхождении.ВозвратДавальцу");
	
	///////////////////////////////////////////////////////////////////////
	// Дополнительные права.
	
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНастройкиПечатиОбъектов");
	ОписаниеПрофиля.Роли.Добавить("СохранениеНастроекПечатиОбъектовПоУмолчанию");
	ОписаниеПрофиля.Роли.Добавить("ИзменениеКурсаВДокументахПродажи");
	
	ОписаниеПрофиля.Роли.Добавить("ОтклонениеОтУсловийПродаж");
	
	УчетОригиналовПервичныхДокументов.ДополнитьПрофильРольюДляИзмененияСостоянийОригиналовДокументов(ОписаниеПрофиля);
	
	УправлениеДоступомЛокализация.ДобавитьРолиМенеджераПоПереработкеДавальческогоСырья(ОписаниеПрофиля);
	
	///////////////////////////////////////////////////////////////////////
	// Описание поставляемого профиля.
	
	ОписаниеПрофиля.Описание =
		НСтр("ru = 'Под профилем выполняются задачи:
					|1. Оформление заказов давальцев;
					|2. Отражения поступлений от давальцев и передач давальцам;
					|3. Оформление отчетов давальцам о выполнении услуг по переработке.';
					|en = 'The following tasks are completed under the profile:
					|1. Registration of material provider orders
					|2. Recording of receipts from material providers and transfers to material providers
					|3. Registration of reports to material providers on provision of the processing services.'");
	
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры
