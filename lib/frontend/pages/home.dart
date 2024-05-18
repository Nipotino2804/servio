import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servio/backend/mysql/orders/get_card_details.dart';
import 'package:servio/backend/variables.dart';
import 'package:servio/frontend/drawer.dart';
import 'package:servio/frontend/pages/card_details.dart';
import 'package:servio/frontend/pages/new_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: const HomeDrawer()),
      drawerEnableOpenDragGesture: false,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            newCardTitle.text = '';
            newCardDescription.text = '';
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NewCard()));
          },
          backgroundColor: primaryColor,
          tooltip: 'Neuen Auftrag erstellen',
          child: const Icon(Icons.add_rounded)),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, verticalIndex) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            Center(
              child: Text(
                'Hallo 👋',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.11),
            Text(
              'Laufende Aufträge:',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.26,
                width: MediaQuery.of(context).size.width * 0.98,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: orderIds.length,
                  itemBuilder: (context, index) {
                    homeIndex = index;
                    return GestureDetector(
                        onTap: () async {
                          finishedCardDetails = false;
                          getCardDetails();
                          homeIndex = index;
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CardDetails(),
                          ));
                        },
                        child: _runningOrders(context));
                  },
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              'Abgeschlossene Aufträge:',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.26,
                width: MediaQuery.of(context).size.width * 0.98,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: finishedOrderIds.length,
                  itemBuilder: (context, finishedIndex) {
                    return GestureDetector(
                        onTap: () async {
                          finishedCardDetails = true;
                          getCardDetails();
                          finishedHomeIndex = finishedIndex;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CardDetails(),
                              ));
                        },
                        child: _finishedOrdersNew(context, finishedIndex));
                  },
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  _dynamicWorker(index, context, workerList) {
    if (workerList[index].toLowerCase() == 'null'.toLowerCase()) {
      return const SizedBox(height: 0);
    } else {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.005,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text('Bearbeiter: ${workerList[index]}')],
          ),
        ],
      );
    }
  }

  _descriptionLengthControll(index, finished) {
    switch (finished) {
      case true:
        if (finishedDescriptions[index].length > 90) {
          return '${finishedDescriptions[index].substring(0, 90)}... [für mehr klicken]';
        } else {
          return finishedDescriptions[index];
        }
      case false:
        if (descriptions[index].length > 100) {
          return '${descriptions[index].substring(0, 90)}... [für mehr klicken]';
        } else {
          return descriptions[index];
        }
    }
  }

  _runningOrders(context) {
    if (orderIds.isEmpty) {
      return const SizedBox(height: 0);
    } else {
      return SizedBox(
          height: MediaQuery.of(context).size.height * 0.26,
          width: MediaQuery.of(context).size.height * 0.32,
          child: Card(
              surfaceTintColor: cardColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 21.0, left: 26, right: 21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titles[homeIndex],
                      style: GoogleFonts.lato(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text(
                      _descriptionLengthControll(homeIndex, false),
                      style: GoogleFonts.lato(fontWeight: FontWeight.w400),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text('Erstellt von: ${clients[homeIndex]}')],
                    ),
                    _dynamicWorker(homeIndex, context, workers),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ],
                ),
              )));
    }
  }

  _finishedOrdersNew(context, index) {
    if (finishedOrderIds.isEmpty) {
      return const SizedBox(width: 0);
    } else {
      return SizedBox(
          height: MediaQuery.of(context).size.height * 0.26,
          width: MediaQuery.of(context).size.height * 0.32,
          child: Card(
              surfaceTintColor: cardColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 21.0, left: 26, right: 21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      finishedTitles[index],
                      style: GoogleFonts.lato(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text(
                      _descriptionLengthControll(index, true),
                      style: GoogleFonts.lato(fontWeight: FontWeight.w400),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Erstellt von: ${finishedClients[index]}')
                      ],
                    ),
                    _dynamicWorker(index, context, finishedWorkers),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ],
                ),
              )));
    }
  }
}
