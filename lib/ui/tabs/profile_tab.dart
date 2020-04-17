import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:onde_tem_saude_app/models/user_model.dart';
import 'package:onde_tem_saude_app/ui/general/login_page.dart';
import 'package:onde_tem_saude_app/ui/pages/user_page.dart';
import 'package:onde_tem_saude_app/ui/widgets/custom_drawer.dart';

class ProfileTab extends StatefulWidget {
  static const String routeName = '/Profile';

  ProfileTab();

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();
  }

  bool isLoggin;
  Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    isLoggin = UserModel.of(context).isLoggedIn();
    user = UserModel.of(context).userData;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (isLoggin)
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserPage(user: user)));
              else
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LoginPage()));
            },
            icon: Icon(
              isLoggin ? Icons.edit : Icons.person_add,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      drawer: CustomDrawer(ProfileTab.routeName),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: DiagonalPathClipperTwo(),
                  child: Container(
                    height: 60,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                buildHeader(width, height, context),
                buildHeaderData(height, width, context),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Text(
                "Dados: ",
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[850]),
              ),
            ),
            isLoggin ? buildPerfil() : Container()
          ],
        ),
      ),
    );
  }

  Widget buildPerfil() {
    bool hasPhone2 = user['phone2'] != null && user['phone2'] != "";
    String titlePhone1 = "Telefone: ";
    if (hasPhone2) titlePhone1 = "Telefone 1:";

    return Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildItensDados("Email: ", user['email']),
            buildItensDados(titlePhone1, user['phone1']),
            hasPhone2
                ? buildItensDados("Telefone 2: ", user['phone2'])
                : Container(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Endereço: ".toUpperCase(),
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[850])),
                Expanded(
                  child: Text(user['address'].toUpperCase(),
                      style:
                          TextStyle(fontSize: 18.0, color: Colors.grey[850])),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                FutureBuilder<DocumentSnapshot>(
                  future: Firestore.instance
                      .collection("cities")
                      .document(user['city'])
                      .collection("districts")
                      .document(user['district'])
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    else {
                      return buildItensDados(
                          "Bairro: ", "${snapshot.data["name"]}");
                    }
                  },
                ),
              ],
            ),
            FutureBuilder<DocumentSnapshot>(
              future: Firestore.instance
                  .collection("cities")
                  .document(user['city'])
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else {
                  return buildItensDados(
                      "CIDADE: ", "${snapshot.data["name"]}");
                }
              },
            ),
            buildItensDados("CEP: ", user['cep'] + " - Goiás - Brasil"),
          ],
        ));
  }

  Widget buildItensDados(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Text(title.toUpperCase(),
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[850])),
          Text(value.toUpperCase(),
              style: TextStyle(fontSize: 18.0, color: Colors.grey[850])),
        ],
      ),
    );
  }

  Widget buildHeader(double width, double height, BuildContext context) {
    return Positioned(
      child: Container(
        width: width,
        height: height * .18,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildHeaderData(double height, double width, BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM yyyy').format(now);
    String userName = "Olá";
    if (isLoggin && user["name"] != null)
      userName += " " + user["name"].split(" ")[0];

    return Positioned(
        top: (height * .13) / 2 - 45,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(
                      color: Theme.of(context).primaryColor, width: 3),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("images/logo_192.png"))),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  userName,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  ", bem vindo.",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 16),
                ),
              ],
            ),
            Text(
              "Hoje, " + formattedDate,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 13),
            ),
          ],
        ));
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
