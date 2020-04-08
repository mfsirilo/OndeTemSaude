import 'package:flutter/material.dart';
import 'package:onde_tem_saude_app/models/user_model.dart';
import 'package:onde_tem_saude_app/routes/routes.dart';
import 'package:scoped_model/scoped_model.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        child: MaterialApp(
          title: 'Onde tem Saúde',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.green,
          ),
          debugShowCheckedModeBanner: false,
          home: MenuPages.home,
          routes: {
            Routes.home: (context) => MenuPages.home,
            Routes.contactUs: (context) => MenuPages.contactUs,
            Routes.aboutUs: (context) => MenuPages.aboutUs,
          },
        ));
  }
}
