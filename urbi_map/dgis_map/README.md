# dgis_map

A flutter plugin for displaying 2Gis map on iOS and Android

|             | Android |   iOS   |
|-------------|---------|---------|
| __Support__ | SDK 21+ | iOS 12+ |

__Disclaimer__: When using, refer to these [terms of use](https://law.2gis.ae/api-rules/)

## Getting started

## Getting API keys

To work with MobileSDK, you need to get the key file `dgissdk.key` with the obligatory indication of the appId of the application for which this key is created. This key will be used to connect to 2GIS servers and retrieve the geographical data, as well as to use offline and the navigator. This key is unique to the SDK and cannot be used with other 2GIS products for developers.

To obtain this key file, fill in the form at dev.2gis.com.

### Adding key for Android

`dgissdk.key` should be added to the `assets` folder of android application, because plugin relies on that specific method.

Your file tree may look like this:

```
...
android
|__app
|____src
|______main
|________assets // here
```

### Adding key for iOS

`dgissdk.key` for iOS may be placed anywhere in your filesystem, as long as Xcode has permission to read and use it.

You should add this file to `Copy Bundle Resources` phase of your build in Runner's project settings.

## Dev notes

- Нужен дебаг экран и вот это всё. Сложно прыгать между точками на карте. Плюс возможно включать/выключать логи, переключать сервера и т.п.
- Подумать над инициализацией карты на нативе. Чтоб файлы ключей, конфиги и т.д. прокидывать с флаттера.
- В целом параметры инициализации сдк: логирование и т.п.
- Склеить platform interface и основной пакет для упрощения публикации.
- Вероятно есть смысл что-то из экзампла перенести в плагин (или наоборот).
- Из-за того, что не используется навигация, основной экран довольно сложный. Было хорошее предложение Арины
  использовать механизм overlay. В целом можно обойтись и стэком, описать большие стэйты как слои (io, idle, general, navigation). Но я бы всё-таки это делал в приложении или отдельном пакете, или экзампле, а плагину оставил общение с СДК и какая-то внутренняя логика.
- Стоит посмотреть на DgisController - уже становится большой и выделить в нем отдельные контроллеры (начал так делать в навигаторе кажется выходит неплохо).
- Цвета, стили текстов и вот это всё надо выделить. Идеально - в theme extensions. 
- Почти нигде нет error state и loading state.
- Нет кастомизации контролов. Если пойдут в плагин — надо делать. Если нет — пофиг, в конкретном приложении сделают.
- Почти отсутствует обработка ошибок))
- Документации в коде очень мало.
- все *Message файлы по идее надо скрыть за мапперами. Они предназначены только для обмена данными с нативом. Либо они все издохнут с приходом кодегена.
