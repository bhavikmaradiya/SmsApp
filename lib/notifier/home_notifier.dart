import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sms_advanced/contact.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../model/sms_model.dart';

class HomeScreenNotifier extends ChangeNotifier {
  bool isLoading = false;
  bool isFromRefresh = false;
  SmsQuery? query;
  ScrollController? messagesListController = ScrollController();
  SmsReceiver? smsReceiver;
  List<SmsModel> messagesToDisplay = [];
  List<SmsModel> originalData = [];
  bool isPermissionEnabled = false;
  int totalMonths = 0;

  TextEditingController searchController = TextEditingController();
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future<void> init() async {
    [
      Permission.contacts,
      Permission.sms,
    ].request().then((value) => {
          if (value.values.first == PermissionStatus.granted &&
              value.values.last == PermissionStatus.granted)
            {
              isPermissionEnabled = true,
              query = SmsQuery(),
              smsReceiver = SmsReceiver(),
              fetchAllSms(),
              registerSmsReceiver()
            }
          else
            {
              isPermissionEnabled = false,
              Fluttertoast.showToast(
                  msg: "Please enable permission to see messages!",
                  toastLength: Toast.LENGTH_LONG)
            },
          notifyListeners()
        });
  }

  Future<void> uploadData(BuildContext context) async {
    if (originalData.isNotEmpty) {
      String udid = await FlutterUdid.udid;
      Navigator.pop(context);
      context.loaderOverlay.show();
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
      DatabaseReference messageRef = databaseRef.child("messages").child(udid);
      await messageRef.remove();
      Map messageJson = <String, dynamic>{};
      for (var element in originalData) {
        messageJson[messageRef.push().key] = element.toJson();
      }
      messageRef
          .set(messageJson)
          .then((value) => {
                context.loaderOverlay.hide(),
                Fluttertoast.showToast(
                    msg: "Backup has been taken successfully!",
                    toastLength: Toast.LENGTH_LONG)
              })
          .onError((error, stackTrace) => {
                context.loaderOverlay.hide(),
                Fluttertoast.showToast(
                    msg: "Error while storing messages!",
                    toastLength: Toast.LENGTH_LONG)
              });
    }
  }

  void registerSmsReceiver() {
    smsReceiver?.onSmsReceived?.listen((SmsMessage msg) => {
          Fluttertoast.showToast(
              msg: "We've found new message!", toastLength: Toast.LENGTH_LONG),
          init()
        });
  }

  void fetchAllSms() {
    if (!isPermissionEnabled) {
      isFromRefresh = false;
      init();
      return;
    }
    if (!isFromRefresh) {
      isLoading = true;
    }
    notifyListeners();

    query ??= SmsQuery();
    query?.querySms(kinds: [SmsQueryKind.Inbox]).then((value) async {
      isLoading = false;
      originalData.clear();
      for (var element in value) {
        var sms = SmsModel(element);
        if (element.address != null && element.address!.trim().isNotEmpty) {
          sms.contact = await ContactQuery().queryContact(element.address);
        }
        originalData.add(sms);
      }
      originalData.sort((a, b) {
        var dateA = a.date;
        var dateB = b.date;
        return dateA == null
            ? 1
            : dateB == null
                ? -1
                : dateB.compareTo(dateA);
      });
      messagesToDisplay = originalData;
      notifyListeners();

      searchText(searchController.text);
    });
  }

  _fetchTotalMonths() {
    if (messagesToDisplay.isNotEmpty) {
      totalMonths = 0;
      var lastDate = messagesToDisplay.last.date;
      var firstDate = messagesToDisplay.first.date;
      if (lastDate != null && firstDate != null) {
       /* while (lastDate.isBefore(firstDate)) {
          totalMonths += 1;
        }*/
      totalMonths = extractMonthsInRange(lastDate, firstDate).length;
      }
      notifyListeners();
    }
  }

  void searchText(String value) {
    if (value.trim().isNotEmpty && originalData.isNotEmpty) {
      messagesToDisplay = originalData
          .where((element) =>
              element.sender != null &&
                  element.sender!
                      .toLowerCase()
                      .startsWith(value.toLowerCase()) ||
              element.contact != null &&
                  element.contact!.fullName != null &&
                  element.contact!.fullName!
                      .toLowerCase()
                      .startsWith(value.toLowerCase()) ||
              element.address != null &&
                  element.address!
                      .toLowerCase()
                      .startsWith(value.toLowerCase()) ||
              element.message != null &&
                  element.message!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else if (originalData.isNotEmpty) {
      messagesToDisplay = originalData;
      messagesListController?.animateTo(0.0,
          curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
    } else {
      messagesToDisplay = [];
    }
    if (isFromRefresh) {
      Fluttertoast.showToast(
          msg: "Data refreshed successfully!", toastLength: Toast.LENGTH_LONG);
      isFromRefresh = false;
    }
    notifyListeners();
    _fetchTotalMonths();

  }

  static List<DateTime> extractMonthsInRange(DateTime from, DateTime to) {
    //0. save day of from date
    var daysInFromDate = from.day;
    List<DateTime> monthsInRange = [DateTime(from.year, from.month)];

    //1. get a list of months between 2 dates (without days)
    while (from.isBefore(DateTime(to.year, to.month - 1))) {
      var newFrom = DateTime(from.year, from.month + 1);
      monthsInRange.add(newFrom);
      from = newFrom;
    }

    //2. iterate months
    return monthsInRange.map((month) {
      var _lastDayOfMonth = lastDayOfMonth(month);
      //2.  if the day of the from date is < then the day of the last day of the month using the daysInFromDate
      if (daysInFromDate < _lastDayOfMonth.day) {
        return DateTime(month.year, month.month, daysInFromDate);
      }
      //3.  else save the last day of the month (means that the month has less days)
      return _lastDayOfMonth;
    }).toList();
  }

  /// The last day of a given month
  static DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? DateTime(month.year, month.month + 1, 1)
        : DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(Duration(days: 1));
  }

  String getTotalByMonth(DateTime dateTime) {
    var list = messagesToDisplay
        .where((element) =>
            element.date != null &&
            element.date!.month == dateTime.month &&
            element.date!.year == dateTime.year)
        .toList();
    var total = list.sumBy((n) => n.amount ?? 0);
    return total.toStringAsFixed(2);
  }

  String getTotal() {
    var total = messagesToDisplay.sumBy((n) => n.amount ?? 0);
    return total.toStringAsFixed(2);
  }
}

extension ListUtils<T> on List<T> {
  num sumBy(num Function(T element) f) {
    num sum = 0;
    for (var item in this) {
      sum += f(item);
    }
    return sum;
  }
}
