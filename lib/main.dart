import 'package:flutter/material.dart';
import 'package:onde_tem_saude_app/models/user_model.dart';
import 'package:onde_tem_saude_app/routes/routes.dart';
import 'package:onde_tem_saude_app/ui/tabs/home_tab.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        child:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          return MaterialApp(
            title: 'Onde tem Saúde',
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.green,
            ),
            debugShowCheckedModeBanner: false,
            home: model.isLoggedIn()
                ? HomeTab(
                    userDistrict: model.userData["district"],
                  )
                : HomeTab(),
            routes: {
              Routes.home: (context) => MenuPages.home,
              Routes.contactUs: (context) => MenuPages.contactUs,
              Routes.aboutUs: (context) => MenuPages.aboutUs,
            },
          );
        }));
  }
}
