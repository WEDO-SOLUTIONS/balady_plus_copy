# BE-90 — lock screen live activity, скриншоты

Ветка `feat/BE-90/lock-screen-widgets`, iPhone 17 Pro / iOS 26 (симулятор), сборка `dev`.
Данные фейковые — из демо-драйвера (`-BaladyLADemo`, TEMP-код, помечен `TEMP-DEBUG-BE90`).
Скриншот всего экрана; виджет — внизу, над кнопками локскрина.

| # | Файл | Сценарий | Как воспроизвести | Что смотреть |
|---|------|----------|-------------------|--------------|
| 1 | `01-car-navigating.png` | Авто, обычная навигация | `-BaladyLADemo` | Иконка манёвра в плашке, «1 km» + улица, спидометр 100 с лимитом 110, иконка Balady. Таймлайн: пройденное `#F1F1F1`, дальше accent `#2AB3A9` → jam `#FFEF03` → пробка `#F63319`. Маркер 24px — `assets/icons/makkah/directions.svg`, повёрнут на 90° по часовой, fill accent-950 `#0C3330`, border 1px accent/on-container `#249A91`. Внизу три равные колонки: осталось / прибытие / расстояние |
| 2 | `02-car-gps-lost.png` | Авто, потеря GPS | `-BaladyLADemo -BaladyLADemoGpsLost` | Первый ряд заменён красной пилюлей «GPS signal lost» (error/default), остальное без изменений |
| 3 | `03-car-reroute.png` | Авто, перестроение маршрута | `-BaladyLADemo -BaladyLADemoReroute` | Зелёная пилюля «Re-route» (success/default) |
| 4 | `04-pedestrian-navigating.png` | Пешком | `-BaladyLADemo -BaladyLADemoPedestrian` | Вместо пробок — штрихи 3×12, gap 2, радиус только сверху; пройденные 40% opacity; маркер — кружок accent 24px (2× высоты штриха) с фигуркой. Спидометра нет |
| 5 | `05-car-arabic-rtl.png` | Авто, арабский (RTL) | `-BaladyLADemo -BaladyLADemoArabic` | Зеркалится вся раскладка и таймлайн (стрелка смотрит влево), иконка манёвра НЕ зеркалится, единицы «كم / د» |
| 6 | `06-arrival.png` | Прибытие | `-BaladyLADemo -BaladyLADemoArrived` | «You arrived» + адрес, две кнопки: `Open Balady+` (soft) и `End trip` (error/default). Спидометр и таймлайн скрыты; во время движения кнопок нет |

## Не попало в скриншоты

- **Dynamic Island** — expanded-вид собран по той же схеме (манёвр + скорость + таймлайн + три колонки), но этот симулятор Live Activity в островке не показывает вообще (пустая «таблетка»). Проверю на устройстве / реальном маршруте.
- **Превышение скорости** (лимит заливается красным) — в демо не эмулируется, приходит из `exceedingMaxSpeedLimitChannel`.
- **Реальные пробки** — здесь фиксированные 45/20/35%; на боевом маршруте сегменты берутся из `traffic.speedColors`.
