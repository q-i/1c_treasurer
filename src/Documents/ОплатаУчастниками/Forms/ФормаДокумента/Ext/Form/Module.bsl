﻿

&НаКлиенте
Процедура ОплатыВТабличнойЧастиПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимость();
	
КонецПроцедуры


//
&НаКлиенте
Процедура УстановитьВидимость()
	
	Элементы.ГруппаШапка.Видимость = (НЕ Объект.ОплатыВТабличнойЧасти);
	Элементы.ГруппаТабЧасть.Видимость = Объект.ОплатыВТабличнойЧасти;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВсеДолгиУчастникаНаСервере(ВыбранныйУчастник)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОстаткиЗУ.Мероприятие КАК Мероприятие,
	|	ОстаткиЗУ.Участник КАК Участник,
	|	ОстаткиЗУ.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.ЗадолженностьУчастников.Остатки(, Участник = &ВыбранныйУчастник) КАК ОстаткиЗУ
	|ГДЕ
	|	ОстаткиЗУ.СуммаОстаток > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Мероприятие
	|АВТОУПОРЯДОЧИВАНИЕ";
	Запрос.УстановитьПараметр("ВыбранныйУчастник", ВыбранныйУчастник);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли; 

	НайденныеСтроки = Объект.Оплаты.НайтиСтроки(Новый Структура("Участник", ВыбранныйУчастник));
	Для Каждого СтрокаТЧ Из НайденныеСтроки Цикл
		Объект.Оплаты.Удалить(СтрокаТЧ);
	КонецЦикла;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.Оплаты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура ЗаполнитьВсеДолгиУчастника(Команда)
	
	ТекущиеДанные = Элементы.Оплаты.ТекущиеДанные;
	ВыбранныйУчастник = ?(ТекущиеДанные <> Неопределено, ТекущиеДанные.Участник, ПредопределенноеЗначение("Справочник.Участники.ПустаяСсылка"));
	ВыбранныйУчастник = Ждать ВвестиЗначениеАсинх(ВыбранныйУчастник, "Выберите участника", Тип("СправочникСсылка.Участники"));
	Если ВыбранныйУчастник <> Неопределено Тогда
		ЗаполнитьВсеДолгиУчастникаНаСервере(ВыбранныйУчастник);
	КонецЕсли;
	
КонецПроцедуры
