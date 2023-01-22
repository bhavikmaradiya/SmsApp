import 'dart:math';

import 'package:intl/intl.dart';
import 'package:sms_advanced/contact.dart';
import 'package:sms_advanced/sms_advanced.dart';

class SmsModel {
  String? id;
  String? formattedDate;
  String? monthOfMessage, yearOfMessage;
  DateTime? date;
  String? message;
  String? sender;
  String? address;
  double? amount;
  Contact? contact;


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmsModel &&
          runtimeType == other.runtimeType &&
          formattedDate == other.formattedDate &&
          monthOfMessage == other.monthOfMessage &&
          yearOfMessage == other.yearOfMessage &&
          date == other.date &&
          message == other.message &&
          sender == other.sender &&
          address == other.address &&
          amount == other.amount &&
          contact == other.contact;


  SmsModel(SmsMessage smsMessage) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    this.id = "${String.fromCharCodes(Iterable.generate(
    4
    , (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))))}${smsMessage.sender??""}";
    final amountRegex = RegExp(r'\d+(\.\d+)', multiLine: true);
    this.message = smsMessage.body;
    if(this.message != null && amountRegex.hasMatch(this.message!)){
      var amount = amountRegex.allMatches(this.message!).first.group(0)?.trim();
      this.amount = amount != null ? double.parse(amount): 0;
    }else {
      this.amount = 0;
    }
    this.sender = smsMessage.sender;
    this.address = smsMessage.address;

    this.date = smsMessage.dateSent;
    this.formattedDate = smsMessage.dateSent != null
        ? DateFormat("dd/MM/yyyy").format(smsMessage.dateSent!)
        : null;
    this.monthOfMessage = smsMessage.dateSent != null
        ? DateFormat("MMMM").format(smsMessage.dateSent!)
        : null;
    this.yearOfMessage = smsMessage.dateSent != null
        ? DateFormat("yyyy").format(smsMessage.dateSent!)
        : null;
  }

  Map toJson() => {
    "formattedDate": formattedDate,
    "monthOfMessage": monthOfMessage,
    "yearOfMessage": yearOfMessage,
    "date": date.toString(),
    "message": message,
    "sender": sender,
    "address": address,
    "amount": amount,
    "contact": contact?.fullName,
  };

}
