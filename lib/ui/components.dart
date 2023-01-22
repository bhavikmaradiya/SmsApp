import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../model/sms_model.dart';

class MessageItemWidget extends StatefulWidget {
  SmsModel smsMessage;
  String query = "";
  var isExpanded = false;

  MessageItemWidget(this.smsMessage, {this.isExpanded = false, this.query = ""});

  @override
  State<MessageItemWidget> createState() => _MessageItemWidgetState();
}

class _MessageItemWidgetState extends State<MessageItemWidget> {
  var formattedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical:3, horizontal: 10),
      color: Colors.grey.shade300,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              widget.isExpanded = !widget.isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.smsMessage.address != null && widget.smsMessage.address!.trim().isNotEmpty ? (widget.smsMessage.contact?.fullName ?? widget.smsMessage.address!) : "Unknown",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Text(
                      widget.smsMessage.formattedDate ?? "",
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Text(
                      "AED ${widget.smsMessage.amount!.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 17),
                    ),
                    const Spacer(),
                    InkWell(
                      child: Text("Click to show"),
                      onTap: () {
                        setState(() {
                          widget.isExpanded = !widget.isExpanded;
                        });
                      },
                    )
                  ],
                ),
                if (widget.isExpanded)
                  const SizedBox(
                    height: 7,
                  ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  color: Colors.white,
                  height: widget.isExpanded ? 100 : 0,
                  padding: const EdgeInsets.all(7),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SubstringHighlight(
                      text: widget.smsMessage.message ?? "",
                      term: widget.query,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      textStyle:
                          const TextStyle(fontSize: 15, color: Colors.black),
                      textStyleHighlight: TextStyle(
                        // highlight style
                        color: Colors.yellow.shade800,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
