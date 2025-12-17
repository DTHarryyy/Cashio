import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:cashio/features/home/presentation/widget/custom_home_app_bar.dart';
import 'package:cashio/features/home/presentation/widget/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int index = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(child: ListView(children: [Text('drawer')])),
      appBar: CustomHomeAppBar(scaffoldKey: _scaffoldKey),
      body: Center(
        child: profile.when(
          data: (user) => Text(user.username ?? 'a'),
          // TODO: Handle this error correctly
          error: (e, _) => Text(e.toString()),
          loading: () => Text('Loading...'),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: index,
        ontap: (value) {
          setState(() => index = value);
        },
      ),
    );
  }
}
