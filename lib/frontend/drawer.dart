import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servio/backend/firebase_auth/get_userdata.dart';
import 'package:servio/backend/mysql/orders/order_controller.dart';
import 'package:servio/backend/variables.dart';
import 'package:servio/frontend/pages/auth/edit_profile.dart';
import 'package:servio/frontend/pages/home.dart';
import 'package:servio/main.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            ListTile(
              leading: const Icon(Icons.refresh_rounded),
              onTap: () async {
                await getOrderData();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              title: const Text('Aufträge aktualisieren'),
            ),
            const Spacer(),
            GestureDetector(
              onLongPressUp: () {
                setState(() {
                  if (devMode) {
                    devMode = false;
                  } else {
                    devMode = true;
                  }
                });
              },
              onTap: () async {
                await setUserdataOnEditProfilePage();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfile(),
                    ));
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Card(
                  surfaceTintColor: cardColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: 26,
                        child: const Icon(
                          Icons.account_circle_rounded,
                          size: 32,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(displayName, style: GoogleFonts.lato()),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005,
                      ),
                      Text(
                        email,
                        style: GoogleFonts.lato(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StartApp(),
                      ));
                  await getOrderData();
                },
                child: Row(
                  children: [
                    const Icon(Icons.exit_to_app_rounded),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.001,
                    ),
                    const Text('Abmelden')
                  ],
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            _showDevmodeBanner()
          ],
        ),
      ),
    );
  }

  _showDevmodeBanner() {
    if (devMode) {
      return Column(
        children: [
          Text(
            'Entwicklermodus aktiviert!',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 212, 55, 43).withOpacity(1)),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
