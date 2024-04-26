import 'package:flutter/material.dart';

import 'balady_exports.dart';

class BaladyServicesPage extends StatefulWidget {
  const BaladyServicesPage({super.key});

  @override
  State<BaladyServicesPage> createState() => _BaladyServicesPageState();
}

class _BaladyServicesPageState extends State<BaladyServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(children: [
        //!     Home Cards
        // Saudi Calendar
        //  const CalendarHomeCard(),
        const SizedBox(
          height: 32,
        ),

        // Events Home Card
        //   const EventsHomeCard(),

        // Prayers Card
        const PrayerHomeCard(),

        //! Map Cards
        // Complaince Map Card
        ComplainceMapCard(
          onClose: () {},
        ),
        const SizedBox(
          height: 32,
        ),

//Event Map Card
        EventMapCard(data: SearchEventsItem(), onClose: () {}),
        const SizedBox(
          height: 32,
        ),

// Opprtunity Map Card
        OpportunityMapCard(onClose: () {}, type: ""),

        const SizedBox(
          height: 32,
        ),

// WhiteLand Map Card
        WhiteLandMapCard(
          onClose: () {},
        ),

        const SizedBox(
          height: 80,
        ),
      ])),
    );
  }
}
