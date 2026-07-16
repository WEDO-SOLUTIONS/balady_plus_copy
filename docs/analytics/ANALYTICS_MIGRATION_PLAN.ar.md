> [English](ANALYTICS_MIGRATION_PLAN.md) · [Русский](ANALYTICS_MIGRATION_PLAN.ru.md) · [العربية](ANALYTICS_MIGRATION_PLAN.ar.md)

# خطة ترحيل تحليلات Balady+ إلى الواجهة الموحّدة `BaladyAnalytics`

> الحالة: وثيقة حيّة. الفرع `feat/BALADY-0000/posthog-infra-experiment` ينفّذ
> المرحلة 1 (تجربة PostHog + أول تدفّق قديم تحت المظلّة).
> خريطة الأنظمة القديمة — `ANALYTICS_REPORT.md`؛ الجانب الخادمي — `infra/analytics/README.md`؛
> الدليل الهندسي للواجهة — `mapness/lib/features/balady_analytics/README.md`.

## الصورة المستهدفة

واجهة واحدة للتطبيق كلّه — `BaladyAnalytics.instance` — مع قنوات مسمّاة:

```
feature code ──► BaladyAnalytics.track(name, properties, channels: {...})
                        │
        ┌───────────────┼───────────────────────────────┐
        ▼               ▼                               ▼
   ours (PostHog)   urbi (balady-metrics.urbi.ae)   insider / byteplus / mixpanel / bss
   gated by           BaladyAnalyticsChannel.urbi     future channels (adapters
   BALADY_ANALYTICS_MODE  (already implemented)       on top of existing SDKs)
```

المبادئ:

- **مواضع الاستدعاء (call sites) تتخاطب مع الواجهة فقط.** الاستدعاءات المباشرة لحِزم SDK القديمة من داخل الميزات هي دَين تقني
  يتقلّص إلى الصفر عبر المراحل أدناه.
- **القناة = مُهايئ `BaladyAnalyticsSink`** فوق SDK/عميل موجود.
  إضافة قناة لا تمسّ مواضع الاستدعاء؛ وإزالة نظام قديم = إزالة مُهايئه.
- **الوضع `BALADY_ANALYTICS_MODE`** (`legacy` | `dual` | `ours`) يتحكّم في قناة `ours` فقط.
  القنوات القديمة تدفّقات إنتاجية — تستمر في الجريان حتى تُغلَق مرحلتها.
- **التخلّص من النظام القديم = إيقاف القناة**، وليس إعادة هيكلة مئات مواضع الاستدعاء.

## جرد التدفّقات والمراحل

| المرحلة | التدفّق | ماذا يحمل | أين يُستدعى اليوم | ما العمل |
|---|---|---|---|---|
| 1 ✅ | **Urbi Analytics / AdvancedMetrics** | مقاييس البحث (`Search::*`، `search_duration`)، `mapInteraction`، مشاهدات الشاشات | `urbiAnalyticsProvider` (نحو 50 موضعًا في mapness) | قناة `urbi` والمُهايئ `UrbiBaladyAnalyticsSink` جاهزان؛ تمرّ عبر الواجهة `trackWithPrint` وجميع استدعاءات `stopSearchResponse`. بقية استدعاءات `.track(...)` المباشرة تُنقَل إلى `BaladyAnalytics.instance.track(..., channels: {ours, urbi})` كلّما لُمِس الكود. لا تُكرِّر `screen()` — فـ `RoutesObserver` يرسل بالفعل إلى النظامين. |
| 2 | **Mixpanel** (توقيتات `timeEvent`/`track`) | مُدد عمليات البحث | `mapness/lib/entry_point.dart` (init)، و`search.dart` وغيرها (`mixpanel?.timeEvent`) | القياس بـ `Stopwatch` والإرسال عبر `track('...', properties: {'duration_ms': ...})` إلى `ours`؛ لا تُنشأ قناة `mixpanel` إلا إذا لزم الحفاظ على التدفّق نفسه. ثم يُحذف الـ SDK. |
| 3 | **Insider + BytePlus (RangersAppLog)** | أحداث المنتج في الغلاف المضيف (host shell) | `CommonFunctions.sendAnalyticsEvent[WithProperties]` (host shell)، و`appAnalyticsProvider` | تنفيذ مُهايئات `AppAnalyticsRepository` كقناتَي `insider` و`byteplus`؛ وتحويل `CommonFunctions.sendAnalyticsEvent*` إلى الواجهة مع `channels: {ours, insider, byteplus}`. مواضع الاستدعاء لا تُمَسّ — فهي تمرّ أصلًا عبر `CommonFunctions`. |
| 4 | **BSS** | تدفّق خادمي للبحث/الخريطة (مهم للواجهة الخلفية) | `BssService.instance` | يستمر التدفّق في العمل باستقلال. يمكن للواجهة أن تكرّر أحداثه إلى `ours` عبر قناة مُهايئ `bss`؛ ولا يُوقَف BSS نفسه. |
| 5 | الختام | — | — | يُحوَّل prod إلى `dual` ثم إلى `ours`؛ وتُوقَف القنوات القديمة واحدة تلو الأخرى (حذف المُهايئ + الـ SDK). |
| — | **Adjust** (الإسناد)، **Sentry** (الأعطال) | — | — | خارج نطاق الواجهة، لا نمسّهما. |

## كيفية ترحيل تدفّق واحد (قائمة تحقّق)

1. كتابة مُهايئ `XxxBaladyAnalyticsSink implements BaladyAnalyticsSink` فوق الـ SDK الموجود.
2. إضافة قيمة إلى `BaladyAnalyticsChannel`، وتسجيل المُهايئ في `entry_point.dart`
   (`registerChannel`) بجوار `configure()`.
3. تحويل نقاط دخول التدفّق (الغلاف/الخدمة، لا كلّ موضع استدعاء) إلى
   `BaladyAnalytics.instance.track(..., channels: {ours, xxx})`.
4. التحقّق في PostHog (وصول الحدث إلى `ours`) وفي النظام القديم (التدفّق لم يتغيّر).
5. عندما لا تعود هناك حاجة إلى النظام القديم: إزالة القناة من مجموعات `channels`، وحذف المُهايئ والـ SDK.

## إصلاحات عرضية معروفة (أُنجزت في المرحلة 1)

- كان `stopSearchResponse` يمرّر نص الاستعلام ونوع البحث في حقول متبادلة
  (كان `search_query_type` يحتوي نص المستخدم) — أُصلح في `urbi_metrics_utils.dart`.
- أحداث البحث لم تكن تصل إلى الواجهة إطلاقًا (كانت تذهب إلى Urbi فقط) — تُكرَّر الآن.

## قواعد PII لقناة `ours`

- `distinct_id` — تجزئة (hash) لقيمة `sub` من SSO فقط؛ لا يُستخدم رقم الهوية الوطنية بشكل مكشوف.
- إعادة تشغيل الجلسات (session replay) معطّلة حتى إجراء مراجعة PII مستقلّة.
- يحمل `APIError` قيمتَي `Headers`/`QueryString` — عند نقله إلى الواجهة يجب اقتطاعهما/إدراجهما في قائمة منع
  (قد تحتويان على رموز وصول).
