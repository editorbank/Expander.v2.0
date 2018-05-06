# Expander.v2.0

Утилита для генерации большого количества текстовых файлов различных типов по файлам шаблонам.
Всё содержимое генерируемого файла берется из файла шаблона (с расширением .tmpl), 
а в места отмеченных %имя_переменной% подставляются значения переменных определенных в ранее 
указанных инициализационных файлах (.ini). Утилита производит действия по мере чтения параметров.
По этому в коммандной строке файл(ы) с определениями переменных должен(ы) указываться впереди файлов шаблонов (.tmpl).

Пример вызова: 
```
Expander test.ini config.xml.tmpl
```
В результате появися файл config.xml.

В одном вызове может указываться несколько инициализационных и файлов фаблонов.
Имя генеритуемого файла формируется из имени файла шаблона путьем отбрасывания расширения (.tmpl).
Например, если имя шаблона config.xml.tmpl, то сгенерованный файл будет иметь имя config.xml.


Утилита состоит из одного пакетного файла src/Expander.cmd.
Он представляет собой синтаксически корректый текст как с точки зрения командного файла Windows (.cmd), 
так и сточки зрения языка JScritp WSH(Windows Script Host).
И состоит из двух частей:
-- первоая часть (пакетный файл windows) - обработка параметров и вызов второй части; 
-- вторая часть (JSrtipt-файл), на котором реализована основная логика приложения.

Эта утилита была создана для генерации конфигурационных файлов в большом проекте 
с разнообразным программным обеспечением работающем в едином комплексе на одном сервере.
Каждое ПО использует для настройки свои настроечные файлы разных форматов.
Использование этой утилиты в качестве "конфигуратора конфигов" позволило оперативно настраивать
все приложения комплекса при установке новых версий приложений или изменений инфраструктуры 
в тестовых и промышленых средах. 

Предыдущая версия 1.х была полностью реализована на CMD без проверки инициализации переменных,
что приводило к ошибкам настройки ПО при появлении новых переменных.

Особенность этой версии в создании ошибочных сообщений при попытке использовать неинициализированную
переменную для их обнаружения.
