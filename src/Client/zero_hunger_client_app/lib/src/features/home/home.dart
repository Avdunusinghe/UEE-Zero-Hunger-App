import 'package:flutter/material.dart';
import 'package:zero_hunger_client_app/src/common_widgets/bottom_navigation_view/bottom_bar_view.dart';
import 'package:zero_hunger_client_app/src/features/authentication/authentication.screen.dart';
import 'package:zero_hunger_client_app/src/features/farmer/farmer_dashboard.dart';
import 'package:zero_hunger_client_app/src/features/zero_hunger_theme.dart';
import 'package:zero_hunger_client_app/src/models/tabIcon_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppModuleScreen extends StatefulWidget {
  @override
  _AppModuleScreenState createState() => _AppModuleScreenState();
}

class _AppModuleScreenState extends State<AppModuleScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final int number = 0;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  String? authToken = null;
  String? role = null;
  Widget tabBody = Container(
    color: ZeroHungerAppTheme.background,
  );

  @override
  void initState() {
    getMasterData();
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = AuthenticationScreen(animationController: animationController);

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ZeroHungerAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  this.authToken != null ? bottomBar() : Container()
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  void getMasterData() async {
    final storage = new FlutterSecureStorage();

    this.authToken = await storage.read(key: 'token');
    this.role = await storage.read(key: 'role');
    print(role);
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0 || index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      FarmerDashboard(animationController: animationController);
                });
              });
            } else if (index == 1 || index == 3) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      FarmerDashboard(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
