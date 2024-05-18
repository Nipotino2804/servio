import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servio/backend/variables.dart';
import 'package:servio/frontend/widgets.dart';
import 'package:servio/main.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Profil bearbeiten'),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            inputField(context, onChanged: (value) {
              newDisplayName = value;
              displayName = value;
            },
                controller: displayNameController,
                icon: const Icon(Icons.account_circle_rounded),
                hintText: 'Name',
                passwordField: false,
                readOnly: false),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            inputField(context, onChanged: (value) {
              newEmail = value;
              email = value;
            },
                controller: emailController,
                icon: const Icon(Icons.mail_rounded),
                hintText: 'E-Mail Adresse',
                passwordField: false,
                readOnly: false),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            inputField(context,
                controller: passwordController,
                icon: const Icon(Icons.password),
                hintText: 'Passwort ändern',
                passwordField: true,
                readOnly: false),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            Container(
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(16)),
              width: MediaQuery.of(context).size.width * 0.85,
              child: MaterialButton(
                onPressed: () async {
                  await user!.updateDisplayName(newDisplayName);
                  if (passwordController.text.isNotEmpty) {
                    user!.updatePassword(passwordController.text);
                  }
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StartApp(),
                      ));
                },
                child: Text('Speichern',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 17, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ));
  }
}
