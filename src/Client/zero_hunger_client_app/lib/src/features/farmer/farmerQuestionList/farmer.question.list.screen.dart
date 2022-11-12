import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zero_hunger_client_app/src/features/farmer/farmerQuestionList/farmer.question.list.dart';
import 'package:zero_hunger_client_app/src/features/farmer/update.question.screen.dart';
import 'package:zero_hunger_client_app/src/features/farmer/view.answer.screen.dart';
import 'package:zero_hunger_client_app/src/features/ui_view/farmer.question.list.view.dart';
import 'package:zero_hunger_client_app/src/features/zero_hunger_theme.dart';
import 'package:zero_hunger_client_app/src/models/question/basic.question.model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';

class FarmerQuestionListScreen extends StatefulWidget {
  const FarmerQuestionListScreen({Key? key, this.animationController})
      : super(key: key);
  final AnimationController? animationController;

  @override
  State<FarmerQuestionListScreen> createState() =>
      _FarmerQuestionListScreenState();
}

class _FarmerQuestionListScreenState extends State<FarmerQuestionListScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  late bool loading;

  List<Widget> listViews = <Widget>[];
  List<BasicQuestionModel> questionList = <BasicQuestionModel>[];
  Map<String, String> token = {};
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  void initState() {
    loading = true;
    getAllQuestionByFarmer();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    configureWidgetListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  void configureWidgetListData() {
    const int count = 5;

    listViews.add(
      FarmerQuestionListView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    listViews.add(FarmerQuestionList(this.questionList, this.viewAnwser,
        this.updateQuestion, this.deleteQuestion));
  }

  Future<void> getAllQuestionByFarmer() async {
    final storage = new FlutterSecureStorage();
    final String? authToken = await storage.read(key: 'token');
    try {
      print('object');
      final response = await http
          .get(Uri.parse('http://localhost:4000/api/question'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': "Bearer $authToken",
      });

      final responseJson = jsonDecode(response.body);
      print(response.body);

      for (Map<String, dynamic> item in responseJson) {
        this.questionList.add(BasicQuestionModel.fromJson(item));
      }

      setState(() {
        loading = false;
      });

      // setState(() {
      //   this.questionList = this.questionList;
      // });
      // configureWidgetListData();
    } catch (e) {
      print(e);
    }
    // final response = await http
    //     .get(Uri.parse('http://10.0.2.2:4000/api/question'), headers: {
    //   'Content-Type': 'application/json; charset=UTF-8',
    //   'authorization': "Bearer $authToken",
    // });

    // final responseJson = jsonDecode(response.body);

    // for (Map<String, dynamic> item in responseJson) {
    //   this.questionList.add(BasicQuestionModel.fromJson(item));
    // }

    // setState(() {
    //   this.questionList = this.questionList;
    // });
  }

  void deleteQuestion(String id) {
    showAlertDialog(context, id);
  }

  showAlertDialog(BuildContext context, String id) {
    // set up the buttons
    Widget processResult = FlatButton(
      child: Text("Delete"),
      onPressed: () {
        processQuestionDelete(id);
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text(
          "Are you sure you want to delete this question? This action cannot be undone."),
      actions: [
        processResult,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void viewAnwser(BasicQuestionModel question) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewAnswerScreen(
                animationController: widget.animationController,
                basicQuestionModel: question,
              )),
    );
  }

  Future<void> processQuestionDelete(String id) async {
    print(id);
    final storage = new FlutterSecureStorage();
    final String? authToken = await storage.read(key: 'token');

    final response = await http.delete(
        Uri.parse('http://localhost:4000/api/question/' + id),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': "Bearer $authToken",
        });

    final httpContextResponse = jsonDecode(response.body);

    if (httpContextResponse['isSuccess'] == true) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: httpContextResponse["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) {
          return FarmerQuestionListScreen(
              animationController: widget.animationController);
        },
      ));
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: httpContextResponse["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> updateQuestion(BasicQuestionModel question) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateQuestionScreen(
                animationController: widget.animationController,
                basicQuestionModel: question,
              )),
    );
  }

  void GetQuestionData() {}
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ZeroHungerAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            loading == true
                ? SpinKitRotatingCircle(
                    color: Colors.white,
                    size: 50.0,
                  )
                : getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();

              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    DateTime UTCDateAsync = DateTime.now();
    String nowDate = DateFormat('yyyy-MM-dd').format(UTCDateAsync);
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: ZeroHungerAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: ZeroHungerAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Welcome',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: ZeroHungerAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: ZeroHungerAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    color: ZeroHungerAppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: ZeroHungerAppTheme.grey,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    nowDate,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: ZeroHungerAppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      letterSpacing: -0.2,
                                      color: ZeroHungerAppTheme.darkerText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: ZeroHungerAppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
