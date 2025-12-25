import 'package:cashio/core/widgets/custom_home_app_bar.dart';
import 'package:cashio/core/widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: CustomNavBar(),
      appBar: CustomAppBar(scaffoldKey: scaffoldKey),
      body: Center(child: Text('Goals Page')),
    );
  }
}
