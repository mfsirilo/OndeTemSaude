import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onde_tem_saude_app/models/user_model.dart';
import 'package:onde_tem_saude_app/routes/routes.dart';
import 'package:onde_tem_saude_app/ui/general/login_page.dart';
import 'package:onde_tem_saude_app/ui/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final String route;

  CustomDrawer(this.route);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(32.0, 16.0, 16.0, 8.0),
                height: 70.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: Text(
                        "",
                        style: TextStyle(
                            fontSize: 34.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]),
                      ),
                    ),
                    Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: ScopedModelDescendant<UserModel>(
                          builder: (context, child, model) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Olá," +
                                      (!model.isLoggedIn()
                                          ? ""
                                          : model.userData["name"]),
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700]),
                                ),
                                GestureDetector(
                                  child: Text(
                                    !model.isLoggedIn()
                                        ? "Entre ou cadastre-se..."
                                        : "Sair",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    if (!model.isLoggedIn()) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()));
                                    } else {
                                      model.signOut();
                                    }
                                  },
                                )
                              ],
                            );
                          },
                        ))
                  ],
                ),
              ),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              DrawerTile(Icons.assistant, "Início", MenuPages.home,
                  route == Routes.home, 22.0),
              //DrawerTile(FontAwesomeIcons.fileSignature, "Sobre",
              //    MenuPages.aboutUs, route == Routes.aboutUs, 22.0),
              DrawerTile(Icons.message, "Fale Conosco", MenuPages.contactUs,
                  route == Routes.contactUs, 25.0),
              Container(child: ScopedModelDescendant<UserModel>(
                  builder: (context, child, model) {
                return model.isLoggedIn()
                    ? DrawerTile(FontAwesomeIcons.addressCard, "Meu Perfil",
                        MenuPages.profile, route == Routes.profile, 22.0)
                    : Container();
              })),
            ],
          )
        ],
      ),
    );
  }
}
