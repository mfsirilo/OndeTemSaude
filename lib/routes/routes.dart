import 'package:flutter/cupertino.dart';
import 'package:onde_tem_saude_app/ui/tabs/aboutus_tab.dart';
import 'package:onde_tem_saude_app/ui/tabs/contactus_tab.dart';
import 'package:onde_tem_saude_app/ui/tabs/home_tab.dart';
import 'package:onde_tem_saude_app/ui/tabs/profile_tab.dart';

class Routes {
  static const String home = HomeTab.routeName;
  static const String contactUs = ContactUsTab.routeName;
  static const String aboutUs = AboutUsTab.routeName;
  static const String profile = ProfileTab.routeName;
}

class MenuPages {
  static Widget home = HomeTab();
  static Widget contactUs = ContactUsTab();
  static Widget aboutUs = AboutUsTab();
  static Widget profile = ProfileTab();
}
