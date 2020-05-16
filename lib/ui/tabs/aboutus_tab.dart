import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:onde_tem_saude_app/ui/widgets/custom_drawer.dart';

class AboutUsTab extends StatefulWidget {
  static const String routeName = '/aboutUs';

  @override
  _AboutUsTabState createState() => _AboutUsTabState();
}

class _AboutUsTabState extends State<AboutUsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawer(AboutUsTab.routeName),
        appBar: AppBar(
          title: Text("Onde tem Saúde"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                height: 55,
              ),
            ),
            Divider(),
            SizedBox(
              height: 155.0,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
            SizedBox(height: 450.0),
            Container(),
          ],
        ));
  }
}
