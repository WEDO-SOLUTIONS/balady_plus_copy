> [English](README.md) · [Русский](README.ru.md) · [العربية](README.ar.md)

# التحليلات الخاصة بـ Balady+ — PostHog مستضاف ذاتيًا (تجربة)

دليل تشغيلي (Runbook): من خادم فارغ إلى لوحات المعلومات. يغطي أيضًا الأسرار التي
تنشأ أثناء العملية وكيفية حذف التجربة بالكامل. السياق: `docs/analytics/DEVOPS_BRIEF.md`،
وخطة ترحيل التدفقات في `ANALYTICS_MIGRATION_PLAN.md` (جذر المستودع).

> **حالة التجربة.** يُقدَّم PostHog المستضاف ذاتيًا رسميًا «كما هو»: دون دعم من
> المورّد، والميزات المدفوعة متاحة فقط في نسختهم السحابية (Cloud)، والترقيات
> مسؤوليتنا نحن (`https://posthog.com/docs/self-host`). قبلنا ذلك عن وعي
> لأغراض التجربة. إن لم تنجح — انظر «كيفية حذف التجربة».

## 1. الخادم

الحد الأدنى (وفق وثائق PostHog ومؤكَّد بالتجربة):

| المعامل | القيمة |
|---|---|
| نظام التشغيل | Ubuntu 22.04/24.04 LTS، **x86_64** (السكربت الرسمي مصمَّم لـ Ubuntu) |
| CPU / RAM | 4 vCPU / **16 GB** (يُعد 8 GB الحد الأدنى المطلق وسيكون ضيقًا) |
| القرص | 60+ GB SSD (يتضخم كل من ClickHouse وKafka؛ للإنتاج خصِّص 100+) |
| الشبكة | عنوان IP عام، فتح المنفذين **80/443**، اتصال إنترنت صادر |
| DNS | سجل A لنطاق فرعي يشير إلى الـ IP، أو دون DNS خاص بك: `<IP>.sslip.io` — يُحلّ تلقائيًا، ويحصل Caddy على شهادة LetsEncrypt |

بيئة التجربة: Selectel (كازاخستان)، `153.80.192.8`، Ubuntu 24.04،
4 vCPU / 16 GB / 60 GB، النطاق `153.80.192.8.sslip.io`. الوصول عبر مفاتيح SSH.

## 2. نشر PostHog (المسار الرسمي hobby)

```bash
ssh root@<server>
mkdir -p /opt/posthog && cd /opt/posthog
curl -fsSL https://raw.githubusercontent.com/PostHog/posthog/master/bin/deploy-hobby -o deploy-hobby
chmod +x deploy-hobby
# review the script before running; then (tag and domain as args, non-interactive):
./deploy-hobby latest <IP>.sslip.io
```

يقوم السكربت بنفسه بتثبيت Docker، واستنساخ `posthog/posthog`، وتوليد `/opt/posthog/.env`
(أسرار المثيل — POSTHOG_SECRET وغيرها)، وتنزيل GeoIP، وتشغيل نحو 30 حاوية.
تستغرق ترحيلات قاعدة البيانات وإصدار شهادة TLS من 5 إلى 10 دقائق؛ التحقق من الجاهزية:
`curl -s localhost/_health` → `200`. السجل: `/opt/posthog/deploy.log`.

ملاحظات:
- خدمات Rust (منها capture) تُسحب دائمًا بالوسم `:master` بصرف النظر عن وسم
  التطبيق الذي اخترته — مقبول للتجربة، وللإنتاج ثبِّت الـ digests.
- إذا بدأ capture يعيد 503 فالسبب على الأرجح الذاكرة: `docker stats`،
  وافحص ClickHouse/Kafka.
- الإدارة: `cd /opt/posthog && docker-compose stop|start`.

## 3. الإعداد الأولي (في واجهة المستخدم، مرة واحدة)

1. افتح `https://<IP>.sslip.io` → **سجِّل المستخدم الأول** (الحساب محلي،
   ولا حاجة لأي تسجيل لدى المورّد) → أنشئ منظمة ومشروعًا.
2. **Project API key ‏(`phc_…`)** و**project id** (رقم): Settings → Project.
   يذهب المفتاح إلى التطبيق (`BALADY_ANALYTICS_KEY`).
3. **Personal API key ‏(`phx_…`)**: الملف الشخصي → Personal API keys → أنشئ مفتاحًا
   بالنطاقات `dashboard:read` و`dashboard:write` و`insight:write`. لازم فقط
   لتهيئة لوحات المعلومات (provisioning).

## 4. اختبار الدخان دون التطبيق

```bash
POSTHOG_HOST=https://<IP>.sslip.io ./smoke_test.sh phc_YOUR_KEY
```

يجب أن يظهر الحدث `infra_smoke_test` في واجهة المستخدم: Activity → Explore. إذا
وصل، فالبنية التحتية سليمة ويمكن بعدها ربط التطبيق.

## 5. ربط التطبيق

في `.env.dev` (أو أي flavor آخر مخصص للتجربة):

```
BALADY_ANALYTICS_MODE=dual
BALADY_ANALYTICS_URL=https://<IP>.sslip.io
BALADY_ANALYTICS_KEY=phc_...
```

إذا تُرك URL/KEY فارغين = يبقى النقل في وضع التسجيل فقط، ولا يُرسل أي شيء إلى أي مكان.
البناء: `fvm flutter run --flavor dev` (أو بالطريقة المتّبعة). قائمة التحقق:

- [ ] التنقل بين الشاشات → أحداث `$screen` في Activity؛
- [ ] تنفيذ بحث → `searchByText` (مع الخاصية `query`)، و`Search::*`،
      و`search_duration` (الخصائص `search_response_duration` و`search_query_type`
      و`search_query_value`)؛
- [ ] الأحداث تحتوي على `$os` و`$app_version` معبَّأين؛
- [ ] تسجيل الدخول → حدث identify (يتوقف الشخص عن كونه anonymous)، وتسجيل الخروج → reset؛
- [ ] أوقف الشبكة، ولِّد بعض الأحداث، ثم أعد تشغيلها → تصل الأحداث (تحتفظ SDK
      بالطابور دون اتصال).

## 6. لوحات المعلومات

```bash
cd infra/analytics/dashboards
POSTHOG_HOST=https://<IP>.sslip.io POSTHOG_PROJECT_ID=1 POSTHOG_API_KEY=phx_... \
  python3 provision.py
```

ينشئ 4 لوحات معلومات: Audience ‏(DAU/WAU/MAU، الاحتفاظ، المنصات/الإصدارات)،
وSearch (أكثر الاستعلامات، القُمع، النتائج الفارغة)، وScreens & navigation، وTech
(الاستثناءات، APIError، أزمنة البحث). العملية idempotent؛ ويعيد `--force` الإنشاء.

تعديل لوحات المعلومات: عدِّل ملفات `*.json` هنا وأعد التشغيل مع `--force` — لا
تعدِّلها يدويًا في واجهة المستخدم (ستُستبدل). إذا رفض PostHog مخطط الاستعلام بعد
ترقية: ابنِ الـ insight في واجهة المستخدم، واحصل على `query` عبر
`GET /api/projects/<id>/insights/<id>` وحدِّث ملف JSON.

## 7. الأسرار: أين يعيش كل شيء وكيف يُسلَّم

| السر | أين يُستخدم | أين يُخزَّن |
|---|---|---|
| مفاتيح SSH للخادم | الوصول إلى الجهاز الافتراضي (VM) | لكل شخص مفتاحه الخاص؛ ويمنح مالك الخادم صلاحية root |
| بيانات دخول مسؤول واجهة PostHog | الواجهة الويب | مدير كلمات مرور للفريق (1Password/Bitwarden — حسب المتّبع) |
| مفتاح المشروع `phc_…` | التطبيق (`BALADY_ANALYTICS_KEY` في `.env.*`) | مدير كلمات المرور + ملفات `.env` المحلية (لا تودِع قيم prod في المستودع) |
| المفتاح الشخصي `phx_…` | provision.py فقط | شخصي، لكل فرد مفتاحه؛ ولا يلزم وضعه في vault |
| `/opt/posthog/.env` على الخادم | أسرار المثيل (POSTHOG_SECRET وغيرها) | على الخادم فقط؛ وعند النقل احتفظ بنسخة احتياطية منه مع قاعدة البيانات |

المستودع يحتوي على قيم بديلة (placeholders) فقط. لا تلتقط خطاطيف Git كل تسريب:
لا تضع المفاتيح في الإيداعات (commits). مفتاح `phc_` «عام» تقنيًا (يُضمَّن في البناء)،
لكن لا داعي لكشفه خارج الفريق.

## 8. كيفية حذف التجربة

1. أوقف/أعد الخادم (تموت معه كل البيانات وأسرار المثيل).
2. في المستودع: `git rm -r infra/analytics ANALYTICS_MIGRATION_PLAN.md` (الخطة — إن
   قررتم عدم الاستمرار نهائيًا).
3. في Flutter: احذف `posthog_balady_analytics_sink.dart`، وأزل `posthog_flutter` من
   `mapness/pubspec.yaml`، و`com.posthog.posthog.AUTO_INIT` من
   `AndroidManifest.xml`/`Info.plist`؛ وأزل المعامل `sink:` في استدعاءي
   `configure()` (المضيف `app.dart`، وmapness ‏`entry_point.dart`).
4. `.env.*`: احذف `BALADY_ANALYTICS_URL`/`BALADY_ANALYTICS_KEY`.
5. الواجهة (facade) والقنوات و`UrbiBaladyAnalyticsSink` **تبقى** — فهي غير مرتبطة
   بـ PostHog ولازمة للترحيل إلى أي خلفية (backend) أخرى.
