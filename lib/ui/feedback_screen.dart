import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flossinow/notifier/feedback_notifier.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedbackNotifier(),
      child: _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FeedbackNotifier>(builder: (context, state, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Feedback"),
        ),
        body: LoaderOverlay(
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: TextField(
                      minLines: 5,
                      maxLines: 5,
                      controller: state.reviewFieldTextController,
                      onChanged: (value) => state.onTextChange(),
                      decoration: InputDecoration(
                          hintText: "Give us your valuable review..",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.7,
                                strokeAlign: StrokeAlign.outside,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.7,
                              strokeAlign: StrokeAlign.outside,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                                strokeAlign: StrokeAlign.outside,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(5))),
                    ),
                  ),
                  InkWell(
                    onTap: () => state.uploadReview(context),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: state.reviewFieldTextController.text.trim().isNotEmpty ? Theme.of(context).primaryColor.withOpacity(0.85) : Colors.grey
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Text(
                        "Submit Review",
                        style: TextStyle(
                          color: state.reviewFieldTextController.text.trim().isNotEmpty ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
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
    });
  }
}
