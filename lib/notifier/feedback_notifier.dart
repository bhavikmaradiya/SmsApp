import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';

class FeedbackNotifier extends ChangeNotifier {
  TextEditingController reviewFieldTextController = TextEditingController();

  onTextChange() {
    notifyListeners();
  }

  Future<void> uploadReview(BuildContext context) async {
    if (reviewFieldTextController.text.trim().isNotEmpty) {
      String udid = await FlutterUdid.udid;
      context.loaderOverlay.show();
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
      DatabaseReference reviewsRef = databaseRef.child("reviews").child(udid);
      String? key = reviewsRef.push().key;
      reviewsRef
          .child(key!)
          .set(reviewFieldTextController.text)
          .then((value) => {
                context.loaderOverlay.hide(),
                reviewFieldTextController.text = "",
                Fluttertoast.showToast(
                    msg: "Thank you for your feedback!",
                    toastLength: Toast.LENGTH_LONG),
                Navigator.pop(context)
              })
          .onError((error, stackTrace) => {context.loaderOverlay.hide()});
    }
  }
}
