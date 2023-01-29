import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../Utils/hide_glow_behavior.dart';
import '../notifier/home_notifier.dart';
import 'components.dart';
import 'feedback_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeScreenNotifier(),
      child: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var provider = Provider.of<HomeScreenNotifier>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<HomeScreenNotifier>(builder: (context, state, child) {
      return Scaffold(
        drawer: Drawer(
          child: SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                    ), //BoxDecoration
                    child: const UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      accountName: Text(
                        "Flossinow",
                        style: TextStyle(fontSize: 18),
                      ),
                      accountEmail: null,
                      margin: EdgeInsets.zero,
                    ), //UserAccountDrawerHeader
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    horizontalTitleGap: 0,
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  /*ListTile(
                    leading: const Icon(Icons.upload),
                    horizontalTitleGap: 0,
                    title: const Text('Backup'),
                    onTap: () {
                      Navigator.pop(context);
                      if (!context.loaderOverlay.visible &&
                          state.originalData.isNotEmpty) {
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            builder: (dialogContext) {
                              return Wrap(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 20, left: 20, right: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 20,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Backup",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              InkWell(
                                                child: const Icon(Icons.close),
                                                onTap: () =>
                                                    Navigator.pop(context),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Text(
                                          "Are you sure you want to take backup, \nas it will update all messages ?",
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () =>
                                                    Navigator.pop(context),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 12,
                                                  ),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () =>
                                                    {state.uploadData(context)},
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 12,
                                                  ),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.85),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    "Yes, Update",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            });
                      }
                    },
                  ),*/
                  ListTile(
                    leading: const Icon(Icons.feedback),
                    horizontalTitleGap: 0,
                    title: const Text('Feedback'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackScreen()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    horizontalTitleGap: 0,
                    title: const Text('Privacy Policy'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackScreen()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: Text("Messages"),
          actions: [
            if (!state.isFromRefresh)
              Container(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                padding: const EdgeInsets.all(5),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      if (!context.loaderOverlay.visible) {
                        state.isFromRefresh = true;
                        state.fetchAllSms();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.refresh,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: LoaderOverlay(
          child: SafeArea(
            child: Container(
              height: size.height,
              width: size.width,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 0, left: 10, right: 10),
                    child: TextField(
                      controller: state.searchController,
                      style: const TextStyle(fontSize: 17),
                      onChanged: (value) {
                        state.searchText(value);
                      },
                      decoration: InputDecoration(
                          hintText: "Search here...",
                          hintStyle: TextStyle(fontSize: 17),
                          suffixIcon:
                              state.searchController.text.trim().isNotEmpty
                                  ? Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(30),
                                        onTap: () {
                                          state.searchController.clear();
                                          state.searchText("");
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : null),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  state.isLoading
                      ? const Expanded(
                          child: Center(
                            child: Text("Loading....",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        )
                      : !state.isLoading &&
                              state.isPermissionEnabled &&
                              state.messagesToDisplay.isNotEmpty
                          ? Expanded(
                              child: ScrollConfiguration(
                                behavior: HideGlowScrollBehavior(),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  controller: state.messagesListController,
                                  itemCount: state.messagesToDisplay.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (state.messagesToDisplay[index]
                                                        .date !=
                                                    null &&
                                                (index == 0 ||
                                                    state
                                                                .messagesToDisplay[
                                                                    index - 1]
                                                                .date !=
                                                            null &&
                                                        (state
                                                                    .messagesToDisplay[
                                                                        index -
                                                                            1]
                                                                    .date!
                                                                    .month !=
                                                                state
                                                                    .messagesToDisplay[
                                                                        index]
                                                                    .date!
                                                                    .month ||
                                                            state
                                                                    .messagesToDisplay[
                                                                        index -
                                                                            1]
                                                                    .date!
                                                                    .year !=
                                                                state
                                                                    .messagesToDisplay[
                                                                        index]
                                                                    .date!
                                                                    .year)))
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  state.messagesToDisplay[index]
                                                      .monthOfMessage!,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            if (state.messagesToDisplay[index]
                                                        .date !=
                                                    null &&
                                                state.messagesToDisplay[index]
                                                        .date!.year !=
                                                    DateTime.now().year &&
                                                (index == 0 ||
                                                    state
                                                                .messagesToDisplay[
                                                                    index - 1]
                                                                .date !=
                                                            null &&
                                                        state
                                                                .messagesToDisplay[
                                                                    index - 1]
                                                                .date!
                                                                .year !=
                                                            state
                                                                .messagesToDisplay[
                                                                    index]
                                                                .date!
                                                                .year))
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  state.messagesToDisplay[index]
                                                      .yearOfMessage!,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                          ],
                                        ),
                                        MessageItemWidget(
                                          state.messagesToDisplay[index],
                                          isExpanded: state
                                                  .searchController.text
                                                  .trim()
                                                  .isNotEmpty &&
                                              state.messagesToDisplay[index]
                                                      .message !=
                                                  null &&
                                              state.messagesToDisplay[index]
                                                  .message!
                                                  .toLowerCase()
                                                  .contains(state
                                                      .searchController.text
                                                      .toLowerCase()),
                                          query: state.searchController.text,
                                        ),
                                        if (state.messagesToDisplay[index].date !=
                                                null &&
                                            (index !=
                                                        state.messagesToDisplay
                                                                .length -
                                                            1 &&
                                                    state
                                                            .messagesToDisplay[
                                                                index + 1]
                                                            .date !=
                                                        null &&
                                                    (state
                                                                .messagesToDisplay[
                                                                    index + 1]
                                                                .date!
                                                                .month !=
                                                            state
                                                                .messagesToDisplay[
                                                                    index]
                                                                .date!
                                                                .month ||
                                                        state
                                                                .messagesToDisplay[
                                                                    index + 1]
                                                                .date!
                                                                .year !=
                                                            state
                                                                .messagesToDisplay[
                                                                    index]
                                                                .date!
                                                                .year) ||
                                                index ==
                                                    state.messagesToDisplay
                                                            .length -
                                                        1))
                                          Container(
                                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                            color: Theme.of(context).primaryColorLight,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Flexible(
                                                  flex: 1,
                                                  child: Text(
                                                    "Total of the month",
                                                    maxLines: 1,
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Text(
                                                    "AED ${state.getTotalByMonth(state.messagesToDisplay[index].date!)}",
                                                    maxLines: 1,
                                                    textAlign: TextAlign.end,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
                          : !state.isLoading && state.messagesToDisplay.isEmpty
                              ? Expanded(
                                  child: Center(
                                      child: InkWell(
                                    onTap: () {
                                      if (!state.isPermissionEnabled) {
                                        state.init();
                                      }
                                    },
                                    child: Text(
                                      state.searchController.text
                                              .trim()
                                              .isNotEmpty
                                          ? "No search result found!"
                                          : state.isPermissionEnabled
                                              ? "Currently, you don't have any message!"
                                              : "We don't have permission \nKindly enable by clicking here or from settings",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                                )
                              : Container(),
                  if (state.messagesToDisplay.isNotEmpty)
                    Container(
                      color: Theme.of(context).primaryColorLight,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Text(
                                "Total (${state.totalMonths})",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                "AED ${state.getTotal()}",
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
