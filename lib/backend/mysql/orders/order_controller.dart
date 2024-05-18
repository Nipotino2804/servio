import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:servio/backend/mysql/orders/get_card_details.dart';
import 'package:servio/backend/mysql/protocols/get_protocols.dart';
import 'package:servio/backend/variables.dart';
import 'package:servio/frontend/pages/home.dart';
import 'package:servio/frontend/pages/protocol.dart';

Future<void> getOrderData() async {
  titles = [];
  descriptions = [];
  clients = [];
  workers = [];
  completeds = [];
  createTimes = [];
  orderIds = [];
  finishedTitles = [];
  finishedDescriptions = [];
  finishedClients = [];
  finishedWorkers = [];
  finishedCompleteds = [];
  finishedCreateTimes = [];
  finishedOrderIds = [];
  final conn = await MySQLConnection.createConnection(
      host: dbHost,
      port: dbPort,
      userName: dbUser,
      password: dbPassword,
      databaseName: dbName);

  await conn.connect();

  var resultData = await conn
      .execute("SELECT * FROM orders WHERE orders.completed = 'false'");
  for (final row in resultData.rows) {
    Map listViewMap = row.assoc();
    listViewMap.forEach((key, value) {
      switch (key.toString()) {
        case 'title':
          titles.add(value.toString());
          break;
        case 'description':
          descriptions.add(value.toString());
          break;
        case 'client':
          clients.add(value.toString());
          break;
        case 'worker':
          workers.add(value.toString());
          break;
        case 'create-time':
          createTimes.add(value.toString());
          break;
        case 'order-id':
          orderIds.add(value.toString());
          break;
      }
    });
  }

  var finishedResultData = await conn
      .execute("SELECT * FROM orders WHERE orders.completed = 'true'");
  for (final row in finishedResultData.rows) {
    Map finishedListViewMap = row.assoc();
    finishedListViewMap.forEach((key, value) {
      switch (key.toString()) {
        case 'title':
          finishedTitles.add(value.toString());
          break;
        case 'description':
          finishedDescriptions.add(value.toString());
          break;
        case 'client':
          finishedClients.add(value.toString());
          break;
        case 'worker':
          finishedWorkers.add(value.toString());
          break;
        case 'create-time':
          finishedCreateTimes.add(value.toString());
          break;
        case 'order-id':
          finishedOrderIds.add(value.toString());
          break;
      }
    });
  }
  await conn.close();
}

Future<void> editOrderData(context) async {
  final conn = await MySQLConnection.createConnection(
      host: dbHost,
      port: dbPort,
      userName: dbUser,
      password: dbPassword,
      databaseName: dbName);
  await conn.connect();
  await getCardDetails();

  if (finishedCardDetails) {
    await conn.execute(
        "UPDATE `orders` SET `title` = '$newTitle', `description` = '$newDescription' WHERE orders.`order-id` = ${finishedOrderIds[finishedHomeIndex]}");
  } else {
    await conn.execute(
        "UPDATE `orders` SET `title` = '$newTitle', `description` = '$newDescription' WHERE orders.`order-id` = ${orderIds[homeIndex]}");
  }
  await getOrderData();
  await conn.close();
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ));
}

Future<void> createNewOrder(context) async {
  final conn = await MySQLConnection.createConnection(
      host: dbHost,
      port: dbPort,
      userName: dbUser,
      password: dbPassword,
      databaseName: dbName);
  await conn.connect();
  await conn.execute(
      "INSERT INTO `orders` (`title`, `description`, `client`, `worker`, `order-id`, `completed`, `create-time`) VALUES ('${newCardTitle.text}', '${newCardDescription.text}', '$displayName', NULL, NULL, 'false', CURRENT_TIMESTAMP);");
  await conn.close();
  await getOrderData();
  await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()));
}

Future<void> deleteOrder(context) async {
  final conn = await MySQLConnection.createConnection(
      host: dbHost,
      port: dbPort,
      userName: dbUser,
      password: dbPassword,
      databaseName: dbName);
  await conn.connect();
  if (finishedCardDetails) {
    await conn.execute(
        "DELETE FROM `orders` WHERE orders.`order-id` = ${finishedOrderIds[finishedHomeIndex]}");
  } else {
    await conn.execute(
        "DELETE FROM `orders` WHERE orders.`order-id` = ${orderIds[homeIndex]}");
  }
  await conn.close();
  await getOrderData();
  await Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const HomePage()));
}

Future<void> acceptOrder(context) async {
  final conn = await MySQLConnection.createConnection(
      host: dbHost,
      port: dbPort,
      userName: dbUser,
      password: dbPassword,
      databaseName: dbName);
  await conn.connect();

  if (finishedCardDetails) {
    await conn.execute(
        "UPDATE `orders` SET `worker` = '$displayName' WHERE orders.`order-id` = ${finishedOrderIds[finishedHomeIndex]}");
  } else {
    await conn.execute(
        "UPDATE `orders` SET `worker` = '$displayName' WHERE orders.`order-id` = ${orderIds[homeIndex]}");
  }
  await conn.close();
  await getOrderData();
  await Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => const HomePage(),
  ));
}

Future<void> completeOrder(context) async {
  await createNewProtocol();
  await getProtocolDataFromDatabase();
  await loadProtocolData();
  await Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => const Protocol(),
  ));
}

Future<void> completeOrder2(context) async {
  final conn = await MySQLConnection.createConnection(
      host: dbHost,
      port: dbPort,
      userName: dbUser,
      password: dbPassword,
      databaseName: dbName);
  await conn.connect();
  await conn.execute(
      "UPDATE `orders` SET `completed` = 'true' WHERE orders.`order-id` = ${orderIds[homeIndex]}");
  await conn.close();
  await getOrderData();
  await Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => const HomePage(),
  ));
}
