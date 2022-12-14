import 'package:crime_alert/components/user_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({Key? key}) : super(key: key);
  final number = '0944751027';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: const Text('Emergency'),
        centerTitle: true,
        actions: const [
          Padding(
              padding: EdgeInsets.only(right: 20), child: UserProfileAvatar())
        ],
      ),
      body: Wrap(
        runSpacing: 15,
        children: [
          const Center(
            child: Icon(
              Icons.warning_rounded,
              size: 80,
              color: Color.fromARGB(255, 205, 192, 75),
            ),
          ),
          Center(
              child: Column(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "The mentioned contacts are not for drill and misuse of them is punishable by law!\n\nPlease use them responsibly.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Slide to the right to the get contact dialer",
                style: TextStyle(color: Colors.grey),
              )
            ],
          )),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                offset: const Offset(10, 10),
                blurRadius: 10,
              )
            ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Slidable(
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: ((context) async {
                          await FlutterPhoneDirectCaller.callNumber(number);
                        }),
                        icon: Icons.call,
                        backgroundColor: Colors.green,
                      )
                    ],
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 225, 235, 234),
                    ),
                    child: const ListTile(
                      title: Text("Police"),
                      subtitle: Text("991"),
                      leading: Icon(
                        Icons.local_police,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  )),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                offset: const Offset(10, 10),
                blurRadius: 10,
              )
            ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Slidable(
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: ((context) async {
                          await FlutterPhoneDirectCaller.callNumber(number);
                        }),
                        icon: Icons.call,
                        backgroundColor: Colors.green,
                      )
                    ],
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 225, 235, 234),
                    ),
                    child: const ListTile(
                      title: Text("Ambulance"),
                      subtitle: Text("907"),
                      leading: Icon(
                        FontAwesomeIcons.truckMedical,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  )),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                offset: const Offset(10, 10),
                blurRadius: 10,
              )
            ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Slidable(
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: ((context) async {
                          await FlutterPhoneDirectCaller.callNumber(number);
                        }),
                        icon: Icons.call,
                        backgroundColor: Colors.green,
                      )
                    ],
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 225, 235, 234),
                    ),
                    child: const ListTile(
                      title: Text("Fire"),
                      subtitle: Text("939"),
                      leading: Icon(
                        FontAwesomeIcons.fire,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
