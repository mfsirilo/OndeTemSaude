import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_app/ui/widgets/loading_widget.dart';
import 'package:onde_tem_saude_app/ui/widgets/network_image.dart';
import 'package:onde_tem_saude_app/ui/widgets/no_record_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PlacePage extends StatefulWidget {
  final DocumentSnapshot place;

  PlacePage(this.place);

  @override
  _PlacePageState createState() => _PlacePageState(place);
}

class _PlacePageState extends State<PlacePage> {
  final DocumentSnapshot place;
  _PlacePageState(this.place);

  bool hasService = true;
  bool hasDistrict = true;
  bool hasSpecialty = true;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: <Widget>[
              !place["images"].isEmpty
                  ? Container(
                      height: 400,
                      width: double.infinity,
                      child: AspectRatio(
                        aspectRatio: 0.9,
                        child: Carousel(
                          images: place["images"].map((url) {
                            return PNetworkImage(
                              url,
                              fit: BoxFit.cover,
                            );
                          }).toList(),
                          dotSize: 4.0,
                          dotSpacing: 15.0,
                          dotBgColor: Colors.transparent,
                          dotColor: primaryColor,
                          autoplay: true,
                        ),
                      ),
                    )
                  : Container(),
              Container(
                margin: !place["images"].isEmpty
                    ? EdgeInsets.fromLTRB(16.0, 370.0, 16.0, 16.0)
                    : EdgeInsets.fromLTRB(16.0, 85.0, 16.0, 16.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      place["title"].toUpperCase(),
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                      maxLines: 3,
                    ),
                    !place["description"].isEmpty
                        ? SizedBox(
                            height: 8.0,
                          )
                        : Container(),
                    !place["description"].isEmpty
                        ? Text(
                            place["description"],
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 8.0,
                    ),
                    Divider(),
                    !place["address"].isEmpty
                        ? SizedBox(
                            height: 8.0,
                          )
                        : Container(),
                    !place["address"].isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("ENDEREÇO: ",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Expanded(
                                  child: Text(
                                    place['address'].toUpperCase(),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      children: <Widget>[
                        !place["district"].isEmpty
                            ? Text("BAIRRO: ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ))
                            : Container(),
                        !place["district"].isEmpty
                            ? FutureBuilder<DocumentSnapshot>(
                                future: Firestore.instance
                                    .collection("cities")
                                    .document(place['city'])
                                    .collection("districts")
                                    .document(place['district'])
                                    .get(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  else {
                                    return Text(
                                      "${snapshot.data["name"]}",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    );
                                  }
                                },
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      children: <Widget>[
                        !place["city"].isEmpty
                            ? Text("CIDADE: ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ))
                            : Container(),
                        !place["city"].isEmpty
                            ? FutureBuilder<DocumentSnapshot>(
                                future: Firestore.instance
                                    .collection("cities")
                                    .document(place['city'])
                                    .get(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  else {
                                    return Text(
                                      "${snapshot.data["name"]}",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    );
                                  }
                                },
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            !place["cep"].isEmpty
                                ? Text("CEP: " + place['cep'] + " - ",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ))
                                : Container(),
                            Text("GOIÁS - BRASIL",
                                style: TextStyle(fontSize: 16.0)),
                          ],
                        ),
                        MaterialButton(
                          padding: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.blue,
                          ),
                          color: Colors.white,
                          textColor: Colors.black,
                          minWidth: 0,
                          height: 40,
                          onPressed: () {
                            String url = "";
                            if (place["latitude"] == 0 ||
                                place["longitude"] == 0)
                              url =
                                  "https://www.google.com/maps/search/?api=1&query=${place["address"]}, Rio Verde, Goiás, Brasil";
                            else
                              url =
                                  "https://www.google.com/maps/search/?api=1&query=${place["latitude"]},"
                                  "${place["longitude"]}";

                            launch(url);
                          },
                        ),
                      ],
                    ),
                    Text("TELEFONE(S): ",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        )),
                    !place["phone1"].isEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                place["phone1"],
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              MaterialButton(
                                padding: const EdgeInsets.all(8.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.blue,
                                ),
                                color: Colors.white,
                                textColor: Colors.black,
                                minWidth: 0,
                                height: 40,
                                onPressed: () {
                                  launch("tel:${place["phone1"]}");
                                },
                              ),
                            ],
                          )
                        : Container(),
                    !place["phone2"].isEmpty
                        ? SizedBox(
                            height: 8.0,
                          )
                        : Container(),
                    !place["phone2"].isEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                place["phone2"],
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              MaterialButton(
                                padding: const EdgeInsets.all(8.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.blue,
                                ),
                                color: Colors.white,
                                textColor: Colors.black,
                                minWidth: 0,
                                height: 40,
                                onPressed: () {
                                  launch("tel:${place["phone2"]}");
                                },
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(
                      height: 8.0,
                    ),
                    hasSpecialty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Divider(),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text("ESPECIALIDADES: ",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                              FutureBuilder<QuerySnapshot>(
                                  future: place.reference
                                      .collection("specialties")
                                      .getDocuments(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return LoadingWidget();
                                    else if (snapshot.data.documents.length ==
                                        0) {
                                      hasSpecialty = false;
                                      return NoRecordWidget();
                                    } else {
                                      List<String> list = snapshot
                                          .data.documents
                                          .map((DocumentSnapshot docSnapshot) {
                                        return docSnapshot.data["uid"]
                                            .toString();
                                      }).toList();

                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: listItemsToWidget(
                                              list, "specialties"),
                                        ),
                                      );
                                    }
                                  })
                            ],
                          )
                        : Container(),
                    SizedBox(
                      height: 8.0,
                    ),
                    hasService
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Divider(),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text("SERVIÇOS: ",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                              FutureBuilder<QuerySnapshot>(
                                  future: place.reference
                                      .collection("services")
                                      .getDocuments(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return LoadingWidget();
                                    else if (snapshot.data.documents.length ==
                                        0) {
                                      hasService = false;
                                      return NoRecordWidget();
                                    } else {
                                      List<String> list = snapshot
                                          .data.documents
                                          .map((DocumentSnapshot docSnapshot) {
                                        return docSnapshot.data["uid"]
                                            .toString();
                                      }).toList();

                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: listItemsToWidget(
                                              list, "services"),
                                        ),
                                      );
                                    }
                                  })
                            ],
                          )
                        : Container(),
                    hasDistrict
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Divider(),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text("BAIRROS ATENDIDOS: ",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                              FutureBuilder<QuerySnapshot>(
                                  future: place.reference
                                      .collection("districts")
                                      .getDocuments(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return LoadingWidget();
                                    else if (snapshot.data.documents.length ==
                                        0) {
                                      hasDistrict = false;
                                      return NoRecordWidget();
                                    } else {
                                      List<String> list = snapshot
                                          .data.documents
                                          .map((DocumentSnapshot docSnapshot) {
                                        return docSnapshot.data["uid"]
                                            .toString();
                                      }).toList();

                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: listItemsToWidgetDistrict(
                                              list, "districts"),
                                        ),
                                      );
                                    }
                                  }),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    MaterialButton(
                      padding: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).primaryColor,
                      ),
                      color: Colors.white,
                      textColor: Colors.black,
                      minWidth: 0,
                      height: 40,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> listItemsToWidget(List<String> listItems, String collection) {
    List<Widget> listWidget = [];
    listItems
        .forEach((element) => listWidget.add(FutureBuilder<DocumentSnapshot>(
              future: Firestore.instance
                  .collection(collection)
                  .document(element)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      snapshot.data["name"],
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  );
                }
              },
            )));

    return listWidget;
  }

  List<Widget> listItemsToWidgetDistrict(
      List<String> listItems, String collection) {
    List<Widget> listWidget = [];
    listItems
        .forEach((element) => listWidget.add(FutureBuilder<DocumentSnapshot>(
              future: Firestore.instance
                  .collection("cities")
                  .document(widget.place.data["city"])
                  .collection(collection)
                  .document(element)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      snapshot.data["name"],
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  );
                }
              },
            )));

    return listWidget;
  }
}
