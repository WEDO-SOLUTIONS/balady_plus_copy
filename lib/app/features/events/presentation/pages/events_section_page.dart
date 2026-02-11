/*
class DariyahEventPage extends StatelessWidget {
  const DariyahEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    /* List<String> category = [
      "shopping".tr(),
      "food".tr(),
      "traditions".tr(),
    ];*/
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 455,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      ImagePath.dariyahImage,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          IconPath.vdAppBarBack,
                        ),
                        EventsDayMonthEvent(
                          color: const Color(0xFF145E75),
                          monthStyle: AppStyle.eventsMonthStyle1,
                          dayStyle: AppStyle.eventsDayStyle1,
                        ),
                      ],
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    SizedBox(
                      height: 120,
                      child: EventImageSwiper2(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    EventsTitleLocationWidget(
                      title: 'dariyah_season'.tr(),
                      city: '',
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    EventCategoryWidget(
                      category: ,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    EventsDescriptionWidget(
                      description: 'events_description2'.tr(),
                    ),
                    const SizedBox(
                      height: 200,
                    ),
                    ElevatedIconButtonWidget.export(
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
