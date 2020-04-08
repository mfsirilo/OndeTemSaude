import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:onde_tem_saude_app/models/user_model.dart';
import 'package:onde_tem_saude_app/ui/tiles/place_tile.dart';
import 'package:onde_tem_saude_app/ui/tiles/place_tile2.dart';
import 'package:onde_tem_saude_app/ui/widgets/custom_drawer.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeTab extends StatefulWidget {
  static const String routeName = '/home';

  HomeTab();

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool showList = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Onde tem Saúde"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              showList ? Icons.grid_on : Icons.grid_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                showList = !showList;
              });
            },
          )
        ],
      ),
      drawer: CustomDrawer(HomeTab.routeName),
      backgroundColor: Colors.white,
      body: SafeArea(child:
          ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        return Stack(
          children: <Widget>[
            ClipPath(
              clipper: DiagonalPathClipperTwo(),
              child: Container(
                height: 130,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Column(
              children: <Widget>[
                model.isLoggedIn() && showList
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 4.0),
                            child: Text(
                              "UNIDADES DE SAÚDE PARA O SEU BAIRRO:",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FutureBuilder<DocumentSnapshot>(
                              future: Firestore.instance
                                  .collection("cities")
                                  .document(model.userData['city'])
                                  .collection("districts")
                                  .document(model.userData['district'])
                                  .get(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  );
                                else {
                                  return Text(
                                    "${snapshot.data["name"]}",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  );
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 20.0),
                            child: FutureBuilder<QuerySnapshot>(
                                future: Firestore.instance
                                    .collection("stores")
                                    .where("district",
                                        isEqualTo: model.userData['district'])
                                    .getDocuments(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                    );
                                  else if (snapshot.data.documents.length == 0)
                                    return Container(
                                      padding: EdgeInsets.only(
                                          top: 16.0, bottom: 32.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                              "NENHUMA UNIDADE DE SAÚDE ENCONTRADA...",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    );
                                  else if (snapshot.data.documents.length == 1)
                                    return PlaceTile(
                                        snapshot.data.documents[0]);
                                  else
                                    return Container(
                                      height: 220.0,
                                      child: Swiper(
                                        autoplay: true,
                                        autoplayDelay: 5000,
                                        duration: 2000,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return new PlaceTile(
                                              snapshot.data.documents[index]);
                                        },
                                        itemCount:
                                            snapshot.data.documents.length,
                                        pagination: new SwiperPagination(),
                                      ),
                                    );
                                }),
                          ),
                          Divider(
                            color: model.isLoggedIn()
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                        ],
                      )
                    : Container(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    "LISTA DE UNIDADES DE SAÚDE",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: model.isLoggedIn() && showList
                            ? Theme.of(context).primaryColor
                            : Colors.white),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FutureBuilder<QuerySnapshot>(
                      future: Firestore.instance
                          .collection("stores")
                          .getDocuments(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        else {
                          return ListView(
                            children: snapshot.data.documents
                                .map((doc) => PlaceTile2(doc))
                                .toList(),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      })),
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
