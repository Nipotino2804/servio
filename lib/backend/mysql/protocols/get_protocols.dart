import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:servio/backend/variables.dart';

createNewProtocol() async {
  //Used
  final conn = await MySQLConnection.createConnection(
      host: dbHost,
      port: dbPort,
      userName: dbUser,
      password: dbPassword,
      databaseName: dbName);
  await conn.connect();
  await conn.execute(
      "INSERT INTO `protocols` (`order-id`, `description`, `worker`, `solved`) VALUES ('${orderIds[homeIndex]}', NULL, '$displayName', NULL)");
  await conn.close();
}

getProtocolDataFromDatabase() async {
  //used
  protocolOrderId = [];
  protocolDescription = [];
  protocolSolved = [];
  protocolWorker = [];
  final conn = await MySQLConnection.createConnection(
      host: dbHost,
      port: dbPort,
      userName: dbUser,
      password: dbPassword,
      databaseName: dbName);
  await conn.connect();
  var resultData = await conn.execute("SELECT * FROM protocols");
  for (final row in resultData.rows) {
    Map listViewMap = row.assoc();
    listViewMap.forEach((key, value) {
      switch (key.toString()) {
        case 'order-id':
          protocolOrderId.add(value.toString());
          break;
        case 'description':
          protocolDescription.add(value.toString());
          break;
        case 'solved':
          protocolSolved.add(value.toString());
          break;
        case 'worker':
          protocolWorker.add(value.toString());
          break;
      }
    });
  }
  await conn.close();
}

loadProtocolData() async {
  //used
  int index = protocolOrderId.indexOf(orderIds[homeIndex]);
  protocolOrderIdController.value =
      TextEditingValue(text: protocolOrderId[index]);
  protocolDescriptionController.value =
      TextEditingValue(text: protocolDescription[index]);
  protocolWorkerController.value =
      TextEditingValue(text: protocolWorker[index]);
  if (protocolSolved[index] == 'null') {
    protocolSaved = false;
  } else {
    protocolSaved = true;
  }
  if (protocolSaved == false) {
    protocolDescriptionController.clear();
  }
}

saveProtocol() async {
  final conn = await MySQLConnection.createConnection(
      host: dbHost,
      port: dbPort,
      userName: dbUser,
      password: dbPassword,
      databaseName: dbName);
  await conn.connect();
  await conn.execute(
      "UPDATE `protocols` SET `description` = '${protocolDescriptionController.text}', `solved` = '${protocolSolvedController.toString()}' WHERE protocols.`order-id` = ${orderIds[homeIndex]}");
  await conn.close();
}

deleteProtocol() async {
  if (devMode) {
    final conn = await MySQLConnection.createConnection(
        host: dbHost,
        port: dbPort,
        userName: dbUser,
        password: dbPassword,
        databaseName: dbName);
    await conn.connect();
    await conn.execute(
        'DELETE FROM protocols WHERE protocols.order-id = ${finishedOrderIds[finishedHomeIndex]}');
    await conn.close();
  }
}
