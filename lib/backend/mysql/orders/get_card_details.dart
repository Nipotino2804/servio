import 'package:flutter/material.dart';
import 'package:servio/backend/variables.dart';

getCardDetails() {
  if (finishedCardDetails) {
    finishedTitle.value =
        TextEditingValue(text: finishedTitles[finishedHomeIndex]);

    finishedDescription.value =
        TextEditingValue(text: finishedDescriptions[finishedHomeIndex]);

    finishedClient.value =
        TextEditingValue(text: finishedClients[finishedHomeIndex]);
    finishedOrderId.value =
        TextEditingValue(text: finishedOrderIds[finishedHomeIndex]);
  } else {
    title.value = TextEditingValue(text: titles[homeIndex]);

    description.value = TextEditingValue(text: descriptions[homeIndex]);

    client.value = TextEditingValue(text: clients[homeIndex]);

    orderId.value = TextEditingValue(text: orderIds[homeIndex]);
  }
}

selectController(String controller) {
  if (finishedCardDetails) {
    switch (controller) {
      case 'title':
        return finishedTitle;
      case 'description':
        return finishedDescription;
      case 'orderId':
        return finishedOrderId;
      case 'client':
        return finishedClient;
    }
  } else {
    switch (controller) {
      case 'title':
        return title;
      case 'description':
        return description;
      case 'orderId':
        return orderId;
      case 'client':
        return client;
    }
  }
}

formatCreateTime(type) {
  if (finishedCardDetails) {
    String createInfo = finishedCreateTimes[finishedHomeIndex];
    List newCreateInfo = createInfo.split(' ');
    // Sepperate Date for better format
    List createDateSepperated = newCreateInfo[0].split('-');
    String sepperatedDateDay = createDateSepperated[2];
    String sepperatedDateMonth = createDateSepperated[1];
    String sepperatedDateYear = createDateSepperated[0];
    // Remove Seconds from Time
    List createTimeSepperated = newCreateInfo[1].split(':');
    switch (type) {
      case 'date':
        return '$sepperatedDateDay.$sepperatedDateMonth.$sepperatedDateYear';
      case 'time':
        return '${createTimeSepperated[0]}:${createTimeSepperated[1]}';
    }
  } else {
    String createInfo = createTimes[homeIndex];
    List newCreateInfo = createInfo.split(' ');
    // Sepperate Date for better format
    List createDateSepperated = newCreateInfo[0].split('-');
    String sepperatedDateDay = createDateSepperated[2];
    String sepperatedDateMonth = createDateSepperated[1];
    String sepperatedDateYear = createDateSepperated[0];
    // Remove Seconds from Time
    List createTimeSepperated = newCreateInfo[1].split(':');
    switch (type) {
      case 'date':
        return '$sepperatedDateDay.$sepperatedDateMonth.$sepperatedDateYear';
      case 'time':
        return '${createTimeSepperated[0]}:${createTimeSepperated[1]}';
    }
  }
}
