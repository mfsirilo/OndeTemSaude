import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onde_tem_saude_app/models/user_model.dart';
import 'package:onde_tem_saude_app/routes/routes.dart';
import 'package:onde_tem_saude_app/ui/tabs/aboutus_tab.dart';
import 'package:onde_tem_saude_app/ui/tabs/service_view_tab.dart';
import 'package:onde_tem_saude_app/ui/views/login_view.dart';
import 'package:onde_tem_saude_app/ui/tabs/home_tab.dart';
import 'package:onde_tem_saude_app/ui/tiles/drawer_tile.dart';

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
                height: 90.0,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Olá, " +
                                (!UserModel.of(context).isLoggedIn()
                                    ? ""
                                    : UserModel.of(context).userData["name"]),
                            style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                          ),
                          GestureDetector(
                            child: Text(
                              !UserModel.of(context).isLoggedIn()
                                  ? "Entre ou cadastre-se..."
                                  : "Sair",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                            onTap: () {
                              if (!UserModel.of(context).isLoggedIn()) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                              } else {
                                UserModel.of(context).signOut();
                              }
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              DrawerTile(
                  Icons.home,
                  "Início",
                  UserModel.of(context).isLoggedIn()
                      ? HomeTab(
                          userDistrict:
                              UserModel.of(context).userData["district"],
                        )
                      : MenuPages.home,
                  route == Routes.home,
                  22.0),
              DrawerTile(
                  Icons.accessibility_new,
                  "Serviços",
                  UserModel.of(context).isLoggedIn()
                      ? ServiceViewTab(
                    userDistrict:
                    UserModel.of(context).userData["district"],
                  )
                      : MenuPages.service,
                  route == Routes.service,
                  22.0),
              DrawerTile(
                  Icons.local_hospital,
                  "Especialidades",
                  UserModel.of(context).isLoggedIn()
                      ? HomeTab(
                    userDistrict:
                    UserModel.of(context).userData["district"],
                  )
                      : MenuPages.home,
                  route == Routes.home,
                  22.0),

//              DrawerTile(FontAwesomeIcons.fileSignature, "Sobre",
//                  MenuPages.aboutUs, route == Routes.aboutUs, 22.0),
              /*Se não der tempo, desativar esse trecho > */
              UserModel.of(context).isLoggedIn()
                  ? DrawerTile(Icons.message, "Fale Conosco",
                      MenuPages.contactUs, route == Routes.contactUs, 25.0)
                  : Container(),
              /*Se não der tempo, desativar esse trecho < */

              UserModel.of(context).isLoggedIn()
                  ? DrawerTile(FontAwesomeIcons.addressCard, "Meu Perfil",
                      MenuPages.profile, route == Routes.profile, 22.0)
                  : Container(),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              DrawerTile(
                  Icons.contact_mail,
                  "Sobre",
                  UserModel.of(context).isLoggedIn()
                      ? AboutUsTab(
                    userDistrict:
                    UserModel.of(context).userData["district"],
                  )
                      : MenuPages.aboutUs,
                  route == Routes.aboutUs,
                  22.0),
            ],
          )
        ],
      ),
    );
  }
}
