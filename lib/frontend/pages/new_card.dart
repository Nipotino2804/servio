import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servio/backend/mysql/orders/order_controller.dart';
import 'package:servio/backend/variables.dart';
import 'package:servio/frontend/widgets.dart';

class NewCard extends StatelessWidget {
  const NewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Neuer Auftrag',
          style: GoogleFonts.plusJakartaSans(
              fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            inputField(context,
                readOnly: false,
                controller: newCardTitle,
                icon: const Icon(Icons.title),
                hintText: 'Title',
                passwordField: false),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: TextField(
                maxLines: 3,
                minLines: 1,
                obscureText: false,
                controller: newCardDescription,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.subtitles),
                    hintText: 'Beschreibung',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16))),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(16)),
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.06,
              child: RawMaterialButton(
                onPressed: () async {
                  createNewOrder(context);
                },
                child: Text('Erstellen',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 17, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
