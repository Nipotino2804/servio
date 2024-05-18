import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servio/backend/mysql/orders/order_controller.dart';
import 'package:servio/backend/variables.dart';
import 'package:servio/backend/mysql/protocols/get_protocols.dart';
import 'package:servio/frontend/widgets.dart';

class Protocol extends StatefulWidget {
  const Protocol({super.key});

  @override
  State<Protocol> createState() => _ProtocolState();
}

class _ProtocolState extends State<Protocol> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Protokoll',
          style: GoogleFonts.plusJakartaSans(
              fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            inputField(context,
                controller: protocolOrderIdController,
                icon: const Icon(Icons.numbers_rounded),
                hintText: 'Auftragsnummer',
                passwordField: false,
                readOnly: true),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            inputField(context,
                maxLines: 5,
                minLines: 3,
                onChanged: (value) => newDescription = value,
                controller: protocolDescriptionController,
                icon: const Icon(Icons.subtitles_rounded),
                hintText: 'Beschreibung',
                passwordField: false,
                readOnly: _dynamicReadOnly()),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            inputField(context,
                controller: protocolWorkerController,
                icon: const Icon(Icons.work_rounded),
                hintText: 'Bearbeiter',
                passwordField: false,
                readOnly: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Problem gelöst',
                  style: GoogleFonts.plusJakartaSans(fontSize: 17),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                ),
                Switch(
                    value: protocolSolvedController,
                    activeColor: Colors.blue.shade400,
                    onChanged: (value) {
                      if (protocolReadOnly) {
                        protocolSolvedController = protocolSolvedController;
                      } else {
                        setState(() {
                          protocolSolvedController = value;
                        });
                      }
                    })
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: primaryColor, width: 3),
                    color: primaryColor),
                width: MediaQuery.of(context).size.width * 0.85,
                child: MaterialButton(
                  onPressed: () async {
                    await saveProtocol();
                    await completeOrder2(context);
                  },
                  child: Text(
                    'Speichern',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  _dynamicReadOnly() {
    if (protocolSaved == false || devMode) {
      protocolReadOnly = false;
      return false;
    } else {
      protocolReadOnly = true;
      return true;
    }
  }
}
