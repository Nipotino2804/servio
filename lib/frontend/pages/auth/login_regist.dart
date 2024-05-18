import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servio/backend/firebase_auth/get_userdata.dart';
import 'package:servio/backend/variables.dart';
import 'package:servio/frontend/pages/auth/edit_profile.dart';
import 'package:servio/frontend/pages/home.dart';
import 'package:servio/frontend/widgets.dart';
import 'package:servio/main.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Future<User?> loginWithEmailAndPassword(
      {required String email,
      required String password,
      required context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseException catch (e) {
      setState(() {
        falseLoginCode = e.code;
      });
    }
    return user;
  }

  Future<User?> registWithEmailAndPassword(
      {required String email,
      required String password,
      required context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseException catch (e) {
      setState(() {
        falseLoginCode = e.code;
      });
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Bei $appTitle anmelden',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.035),
          inputField(context,
              readOnly: false,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              icon: const Icon(Icons.email_rounded),
              hintText: 'E-Mail Adresse',
              passwordField: false),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          inputField(context,
              keyboardType: TextInputType.visiblePassword,
              readOnly: false,
              controller: passwordController,
              icon: const Icon(Icons.key_rounded),
              hintText: 'Passwort',
              passwordField: true),
          SizedBox(height: MediaQuery.of(context).size.height * 0.001),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        if (emailController.text.isEmpty) {
                          falseLoginCode = 'no-entered-email';
                        } else {
                          auth.sendPasswordResetEmail(email: email);
                        }
                      });
                    },
                    child: const Text('Passwort vergessen?')),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: primaryColor, width: 3),
                  color: primaryColor),
              width: MediaQuery.of(context).size.width * 0.85,
              child: MaterialButton(
                onPressed: () async {
                  user = await loginWithEmailAndPassword(
                      email: emailController.text.trim().toLowerCase(),
                      password: passwordController.text,
                      context: context);
                  if (user != null) {
                    displayName = '${user!.displayName}';
                    email = '${user!.email}';
                    if (displayName == 'null') {
                      await setUserdataOnEditProfilePage();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const EditProfile(),
                      ));
                    } else {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ));
                    }
                  }
                },
                child: Text(
                  'Anmelden',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: primaryColor.withOpacity(.7), width: 3)),
              width: MediaQuery.of(context).size.width * 0.85,
              child: MaterialButton(
                onPressed: () async {
                  user = await registWithEmailAndPassword(
                      email: emailController.text.trim().toLowerCase(),
                      password: passwordController.text,
                      context: context);
                  if (user != null) {
                    email = '${user!.email}';
                    await setUserdataOnEditProfilePage();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const EditProfile(),
                    ));
                  }
                },
                child: Text(
                  'Registrieren',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 17, fontWeight: FontWeight.w400),
                ),
              )),
          _falsePassword(),
        ],
      ),
    );
  }

  _falsePassword() {
    switch (falseLoginCode) {
      case 'invalid-credential':
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Die eingegebenen Zugangsdaten sind falsch!',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 18, color: Colors.red),
              ),
            )
          ],
        );
      case 'user-disabled':
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Der Benutzeraccount wurde durch einen Administrator deaktiviert!',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 18, color: Colors.red),
              ),
            )
          ],
        );
      case 'weak-password':
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Das von ihnen gewählte Passwort ist zu kurz!',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 18, color: Colors.red),
              ),
            )
          ],
        );
      case 'invalid-email':
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Die eingegebene E-Mail Adresse ist ungültig!',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 18, color: Colors.red),
              ),
            )
          ],
        );
      case 'email-already-in-use':
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Die eingegebene E-Mail Adresse ist bereits Registriert!',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 18, color: Colors.red),
              ),
            )
          ],
        );
      case 'no-entered-email':
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Bitte geben sie eine E-Mail Adresse ein!',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 18, color: Colors.red),
              ),
            )
          ],
        );
      case 'no-entered-password':
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Bitte geben sie ein Passwort ein!',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 18, color: Colors.red),
              ),
            )
          ],
        );
      case 'no-entered-data':
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Bitte geben sie ihre Zugangsdaten ein!',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 18, color: Colors.red),
              ),
            )
          ],
        );
      default:
        return const SizedBox();
    }
  }
}
