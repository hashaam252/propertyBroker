import 'package:flutter/material.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/models/propertiesmodel.dart';
import 'package:property_broker/models/pushNotificationModel.dart';

class NotificationNotifier extends ChangeNotifier {
  static List<NotificationResult> propertyResult = [];
  static int count = 0;
  static ValueNotifier notificationCount = ValueNotifier(null);
  static ValueNotifier<List<NotificationResult>> dataNotifier =
      ValueNotifier<List<NotificationResult>>(null);
  void fetchNotifications(context) {
    BaseHelper().getNotificaitons(dataNotifier, context).then((value) {
      propertyResult = value;
      print("my properties: ${dataNotifier.value.length}");
      // count = dataNotifier.value.length;
      count = 0;
      dataNotifier.value = propertyResult;
      for (int i = 0; i < dataNotifier.value.length; i++) {
        if (dataNotifier.value[i].isRead == "0" ||
            dataNotifier.value[i].isRead == 0) {
          count = count + 1;
        }
      }
      notificationCount.value = count;
    });

    notifyListeners();
  }

  Future<List<PropertyResult>> setEmpty(context) {
    dataNotifier = ValueNotifier<List<NotificationResult>>(null);

    notifyListeners();
    // return _dataNotifier;
  }
}

final notificationsNotifier = NotificationNotifier();
