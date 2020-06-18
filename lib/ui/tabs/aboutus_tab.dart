import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_app/ui/widgets/custom_drawer.dart';

class AboutUsTab extends StatefulWidget {
  static const String routeName = '/aboutUs';
  final String userDistrict;
  
  AboutUsTab({this.userDistrict});

  @override
  _AboutUsTabState createState() => _AboutUsTabState(userDistrict);
}

class _AboutUsTabState extends State<AboutUsTab> {
  final String userDistrict;
  _AboutUsTabState(this.userDistrict);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawer(AboutUsTab.routeName),
        appBar: AppBar(
          title: Text("Sobre o aplicativo"),
          centerTitle: true,
          elevation: 0,
        ),

        body: Stack(
            children: <Widget>[
              Column(
                  children: <Widget>[
                    Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                              top: 10.0,
                        ),
                        child: Row(
                          children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                      height: 55.0,
                                      child: Image.asset(
                                        "assets/images/logo.png",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                             ),
                          ],
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        right: 12.0,
                        top: 10.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 150,
                            child: Text(
                              "ONDE TEM SAÚDE",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        right: 12.0,
                        top: 10.0,
                      ),
                      child: Row(
                            children: <Widget>[
                            Container(
                                width: 380,
                                child: Text(
                                  "A ferramenta pretende promover acesso facilitado às informações pertinentes aos locais de atendimento por especialidade ao munícipe, evitando desgastes sociais e prejuízos financeiros, diminuindo assim o tempo de resposta ao cidadão, garantindo uma informação mais concisa e assertiva."
                                  ,
                                ),
                            ),
                          ],
                      ),
                    ),
                  ],
              ),
            ],
        ),
    );
  }
}
class BodyWidget extends StatelessWidget {
  final Color color;

  BodyWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      color: color,
      alignment: Alignment.center,
    );
  }
}
