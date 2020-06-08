import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_app/ui/tiles/place_tile2.dart';
import 'package:onde_tem_saude_app/ui/widgets/custom_drawer.dart';
import 'package:onde_tem_saude_app/ui/widgets/loading_widget.dart';
import 'package:onde_tem_saude_app/ui/widgets/no_record_widget.dart';

class ServiceViewTab extends StatefulWidget {
  static const String routeName = '/Servicehome';
  final String userDistrict;

  ServiceViewTab({this.userDistrict});

  @override
  _ServiceTab createState() => _ServiceTab(userDistrict);
}

class _ServiceTab extends State<ServiceViewTab> {
  bool selectedUserDistrict = true;
  bool showList = false;
  bool showListAll = true;
  bool showListAllButton = true;
  String selectedCity = "0EvkbABbbt4sk1rQOkT1";
  final String userDistrict;
  String selectedDistrict, selectedSpecialty, selectedService;

  _ServiceTab(this.userDistrict);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedUserDistrict) selectedDistrict = widget.userDistrict;
    if (selectedDistrict != null) showListAll = false;

    return Scaffold(
      appBar: AppBar(
        title: Text("Área de Serviços"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      drawer: CustomDrawer(ServiceViewTab.routeName),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
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
                      width: 100,
                      child: Text(
                        "Bairros:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("cities")
                            .document(selectedCity)
                            .collection("districts").orderBy("name", descending:false)
                            .where("active", isEqualTo: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return const Text("Carregando...");
                          else {
                            List<DropdownMenuItem> currencyItems = [];
                            for (int i = 0;
                                i < snapshot.data.documents.length;
                                i++) {
                              DocumentSnapshot snap =
                                  snapshot.data.documents[i];
                              currencyItems.add(
                                DropdownMenuItem(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Text(
                                      snap["name"],
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  value: "${snap.documentID}",
                                ),
                              );
                            }
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 6.0, right: 6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    DropdownButton(
                                      items: currencyItems,
                                      onChanged: (currencyValue) {
                                        setState(() {
                                          showListAllButton = false;
                                          showListAll = false;
                                          selectedDistrict = currencyValue;
                                          selectedUserDistrict = false;
                                        });
                                      },
                                      value: selectedDistrict,
                                      isExpanded: true,
                                      hint: Text(
                                        "  selecione...",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }),
                    selectedDistrict != null
                        ? IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                selectedDistrict = null;
                                selectedUserDistrict = false;
                              });
                            },
                          )
                        : Container()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        "Serviços:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(

                        stream: Firestore.instance
                            .collection("services").orderBy("name", descending:false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return const Text("Carregando...");
                          else {
                            List<DropdownMenuItem> currencyItems = [];
                            for (int i = 0;
                                i < snapshot.data.documents.length;
                                i++) {
                              DocumentSnapshot snap =
                                  snapshot.data.documents[i];
                              currencyItems.add(
                                DropdownMenuItem(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Text(
                                      snap["name"],
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  value: "${snap.documentID}",
                                ),
                              );
                            }
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 6.0, right: 6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    DropdownButton(
                                      items: currencyItems,
                                      onChanged: (currencyValue) {
                                        setState(() {
                                          showListAllButton = false;
                                          showListAll = false;
                                          selectedService = currencyValue;
                                        });
                                      },
                                      value: selectedService,
                                      isExpanded: true,
                                      hint: Text(
                                        "  selecione...",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }),
                    selectedService != null
                        ? IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                selectedService = null;
                              });
                            },
                          )
                        : Container()
                  ],
                ),
              ),
//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                child: Row(
//                  children: <Widget>[
//                    Container(
//                      width: 100,
//                      child: Text(
//                        "Serviços:",
//                        style: TextStyle(fontWeight: FontWeight.bold),
//                      ),
//                    ),
//                    StreamBuilder<QuerySnapshot>(
//                        stream: Firestore.instance
//                            .collection("services").orderBy("name",descending: false)
//                            .snapshots(),
//                        builder: (context, snapshot) {
//                          if (!snapshot.hasData)
//                            return const Text("Carregando...");
//                          else {
//                            List<DropdownMenuItem> currencyItems = [];
//                            for (int i = 0;
//                                i < snapshot.data.documents.length;
//                                i++) {
//                              DocumentSnapshot snap =
//                                  snapshot.data.documents[i];
//                              currencyItems.add(
//                                DropdownMenuItem(
//                                  child: Padding(
//                                    padding:
//                                        EdgeInsets.only(left: 8.0, right: 8.0),
//                                    child: Text(
//                                      snap["name"],
//                                      style: TextStyle(
//                                          color:
//                                              Theme.of(context).primaryColor),
//                                    ),
//                                  ),
//                                  value: "${snap.documentID}",
//                                ),
//                              );
//                            }
//                            return Expanded(
//                              child: Padding(
//                                padding: const EdgeInsets.only(
//                                    left: 6.0, right: 6.0),
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  mainAxisAlignment:
//                                      MainAxisAlignment.spaceBetween,
//                                  children: <Widget>[
//                                    DropdownButton(
//                                      items: currencyItems,
//                                      onChanged: (currencyValue) {
//                                        setState(() {
//                                          showListAllButton = false;
//                                          showListAll = false;
//                                          selectedService = currencyValue;
//                                        });
//                                      },
//                                      value: selectedService,
//                                      isExpanded: true,
//                                      hint: Text(
//                                        "  selecione...",
//                                        style: TextStyle(
//                                            color:
//                                                Theme.of(context).primaryColor),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                            );
//                          }
//                        }),
//                    selectedService != null
//                        ? IconButton(
//                            icon: Icon(Icons.close),
//                            onPressed: () {
//                              setState(() {
//                                selectedService = null;
//                              });
//                            },
//                          )
//                        : Container()
//                  ],
//                ),
//              ),
              Divider(),
              showListAll ||
                      (selectedDistrict == null &&
                          selectedSpecialty == null &&
                          selectedService == null)
                  ? Expanded(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            child: Text(
                              "TODAS AS UNIDADES DE SAÚDE",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          SizedBox(
                            height: 55.0,
                            child: Image.asset(
                              "assets/images/logo.png",
                              fit: BoxFit.contain,
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
                                    return LoadingWidget();
                                  else if (snapshot.data.documents.length == 0)
                                    return NoRecordWidget();
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
                    )
                  : selectedDistrict != null
                      ? Expanded(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                child: Text(
                                  "LISTA DE UNIDADES DE SAÚDE ENCONTRADAS",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                              SizedBox(
                                height: 55.0,
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              selectedService == null
                                  ? Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: FutureBuilder<QuerySnapshot>(
                                          future: Firestore.instance
                                              .collection("store_district")
                                              .where("district",
                                                  isEqualTo: selectedDistrict)
                                              .getDocuments(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return LoadingWidget();
                                            else if (snapshot
                                                    .data.documents.length ==
                                                0)
                                              return NoRecordWidget();
                                            else {
                                              return ListView(
                                                  children: snapshot
                                                      .data.documents
                                                      .map((doc) => FutureBuilder<
                                                              DocumentSnapshot>(
                                                          future: Firestore
                                                              .instance
                                                              .collection(
                                                                  "stores")
                                                              .document(
                                                                  doc.data[
                                                                      "store"])
                                                              .get(),
                                                          builder:
                                                              (context, snap) {
                                                            if (!snap.hasData)
                                                              return LoadingWidget();
                                                            else {
                                                              if (snap.data
                                                                      .data ==
                                                                  null)
                                                                return Container();
                                                              else
                                                                return PlaceTile2(
                                                                    snap.data);
                                                            }
                                                          }))
                                                      .toList());
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: FutureBuilder<QuerySnapshot>(
                                          future: Firestore.instance
                                              .collection("store_district")
                                              .where("district",
                                                  isEqualTo: selectedDistrict)
                                              .getDocuments(),
                                          builder: (context, snapshot) {
                                            List<String> storesID = [];

                                            for (DocumentSnapshot doc
                                                in snapshot.data.documents) {
                                              storesID.add(doc.data["store"]);
                                            }
                                            if (storesID.isEmpty)
                                              return NoRecordWidget();

                                            return FutureBuilder<QuerySnapshot>(
                                                future: Firestore.instance
                                                    .collection(
                                                        "store_service")
                                                    .where("services",
                                                        isEqualTo:
                                                            selectedService)
                                                    .where("store",
                                                        whereIn: storesID)
                                                    .getDocuments(),
                                                builder: (context, snap) {
                                                  if (!snap.hasData)
                                                    return LoadingWidget();
                                                  else if (snap.data.documents
                                                          .length ==
                                                      0)
                                                    return NoRecordWidget();
                                                  else {
                                                    return ListView(
                                                        children: snap
                                                            .data.documents
                                                            .map((doc) => FutureBuilder<
                                                                    DocumentSnapshot>(
                                                                future: Firestore
                                                                    .instance
                                                                    .collection(
                                                                        "stores")
                                                                    .document(doc
                                                                            .data[
                                                                        "store"])
                                                                    .get(),
                                                                builder: (context,
                                                                    snapStore) {
                                                                  if (!snapStore
                                                                      .hasData)
                                                                    return LoadingWidget();
                                                                  else {
                                                                    if (snapStore
                                                                            .data
                                                                            .data ==
                                                                        null)
                                                                      return Container();
                                                                    else
                                                                      return PlaceTile2(
                                                                          snapStore
                                                                              .data);
                                                                  }
                                                                }))
                                                            .toList());
                                                  }
                                                });
                                          },
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                child: Text(
                                  "LISTA DE UNIDADES DE SAÚDE ENCONTRADAS",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                              Container(
                                child: Image.network(
                                    'http://www.riofer.com.br/assinaturas/logo_72.png'),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: FutureBuilder<QuerySnapshot>(
                                    future: Firestore.instance
                                        .collection("store_service")
                                        .where("service",
                                            isEqualTo: selectedService)
                                        .getDocuments(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData)
                                        return LoadingWidget();
                                      else if (snapshot.data.documents.length ==
                                          0)
                                        return NoRecordWidget();
                                      else {
                                        return ListView(
                                            children: snapshot.data.documents
                                                .map((doc) => FutureBuilder<
                                                        DocumentSnapshot>(
                                                    future: Firestore.instance
                                                        .collection("stores")
                                                        .document(
                                                            doc.data["store"])
                                                        .get(),
                                                    builder: (context, snap) {
                                                      if (!snap.hasData)
                                                        return LoadingWidget();
                                                      else {
                                                        if (snap.data.data ==
                                                            null)
                                                          return Container();
                                                        else
                                                          return PlaceTile2(
                                                              snap.data);
                                                      }
                                                    }))
                                                .toList());
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
            ],
          ),
        ],
      )),
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
