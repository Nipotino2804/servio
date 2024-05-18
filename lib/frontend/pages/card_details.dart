import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servio/backend/mysql/orders/get_card_details.dart';
import 'package:servio/backend/mysql/orders/order_controller.dart';
import 'package:servio/backend/mysql/protocols/get_protocols.dart';
import 'package:servio/backend/variables.dart';
import 'package:servio/frontend/pages/protocol.dart';
import 'package:servio/frontend/widgets.dart';

class CardDetails extends StatefulWidget {
  const CardDetails({super.key});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (finishedCardDetails) {
                      newTitle = finishedTitle.text;
                      newDescription = finishedDescription.text;
                    } else {
                      newTitle = title.text;
                      newDescription = description.text;
                    }
                    readOnly = false;
                  });
                },
                icon: _dynamicOrderEditIcon(comand: 'display'))
          ],
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Auftragsinformationen',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, avvc) {
            getCardDetails();
            return _cardDetails(context,
                clientController: selectController('client'),
                descriptionController: selectController('description'),
                orderIdController: selectController('orderId'),
                titleController: selectController('title'));
          },
        ));
  }

  _cardDetails(context,
      {required orderIdController,
      required titleController,
      required descriptionController,
      required clientController}) {
    return Column(
      children: [
        Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            inputField(context,
                readOnly: true,
                controller: orderIdController,
                icon: const Icon(Icons.numbers_rounded),
                hintText: 'Auftragsnummer',
                passwordField: false),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            inputField(context,
                onChanged: (value) => newTitle = value,
                readOnly: readOnly,
                controller: titleController,
                icon: const Icon(Icons.title),
                hintText: 'Title',
                passwordField: false),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: TextField(
                onChanged: (value) => newDescription = value,
                maxLines: 5,
                minLines: 1,
                readOnly: readOnly,
                obscureText: false,
                controller: descriptionController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.subtitles),
                    hintText: 'Beschreibung',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16))),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            inputField(context,
                readOnly: true,
                controller: clientController,
                icon: const Icon(Icons.account_circle_rounded),
                hintText: 'Ersteller',
                passwordField: false),
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            _dynamicOrderButton(context),
            _showDeleteButton(context),
            _showDevButton(context),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Text(
              'Erstellet am ${formatCreateTime('date')} um ${formatCreateTime('time')} Uhr',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
          ],
        ),
      ],
    );
  }

  _showDevButton(context) {
    if (devMode) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 181, 33, 23).withOpacity(1),
                  borderRadius: BorderRadius.circular(18)),
              width: MediaQuery.of(context).size.width * 0.85,
              child: MaterialButton(
                onPressed: () {
                  deleteOrder(context);
                },
                child: Text(
                  'Auftrag löschen',
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.normal, fontSize: 17),
                ),
              )),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  _showDeleteButton(context) {
    if (readOnly == false) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 181, 33, 23).withOpacity(1),
                  borderRadius: BorderRadius.circular(18)),
              width: MediaQuery.of(context).size.width * 0.85,
              child: MaterialButton(
                onPressed: () async {
                  newTitle = '';
                  newDescription = '';
                  await getOrderData();
                  Navigator.pop(context);
                },
                child: Text(
                  'Änderung verwerfen',
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.normal, fontSize: 17),
                ),
              )),
        ],
      );
    }
    if (finishedCardDetails) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          Container(
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(18)),
              width: MediaQuery.of(context).size.width * 0.85,
              child: MaterialButton(
                onPressed: () async {
                  loadProtocolData();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Protocol(),
                      ));
                },
                child: Text(
                  'Protokoll anschauen',
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.normal, fontSize: 17),
                ),
              )),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 181, 33, 23).withOpacity(1),
                  borderRadius: BorderRadius.circular(18)),
              width: MediaQuery.of(context).size.width * 0.85,
              child: MaterialButton(
                onPressed: () {
                  deleteOrder(context);
                },
                child: Text(
                  'Auftrag löschen',
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.normal, fontSize: 17),
                ),
              )),
        ],
      );
    }
  }

  _dynamicOrderButton(context) {
    if (readOnly == false) {
      return Container(
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(18)),
          width: MediaQuery.of(context).size.width * 0.85,
          child: MaterialButton(
            onPressed: () {
              setState(() {
                readOnly = true;
                editOrderData(context);
              });
            },
            child: Text(
              'Änderungen speichern',
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.normal, fontSize: 17),
            ),
          ));
    } else {
      if (finishedCardDetails) {
        return Container(
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(18)),
            width: MediaQuery.of(context).size.width * 0.85,
            child: MaterialButton(
              onPressed: () {},
              child: Text(
                'Auftrag abgeschlossen',
                style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.normal, fontSize: 17),
              ),
            ));
      } else {
        if (workers[homeIndex] == 'null') {
          return Container(
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(18)),
              width: MediaQuery.of(context).size.width * 0.85,
              child: MaterialButton(
                onPressed: () async {
                  await acceptOrder(context);
                },
                child: Text(
                  'Auftrag annehmen',
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.normal, fontSize: 17),
                ),
              ));
        } else {
          return Container(
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(18)),
              width: MediaQuery.of(context).size.width * 0.85,
              child: MaterialButton(
                onPressed: () {
                  completeOrder(context);
                },
                child: Text(
                  'Auftrag abschließen',
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.normal, fontSize: 17),
                ),
              ));
        }
      }
    }
  }

  _dynamicOrderEditIcon({required String comand}) {
    if (readOnly) {
      return const Icon(Icons.edit);
    } else {
      return const SizedBox(height: 0);
    }
  }
}
