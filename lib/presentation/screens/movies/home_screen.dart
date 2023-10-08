import 'package:flutter/material.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';

  final StatefulNavigationShell childView;

  const HomeScreen({Key? key, required this.childView}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: childView,
      bottomNavigationBar: CustomBottomNavigation(currentChild: childView,),
    );
  }
}

