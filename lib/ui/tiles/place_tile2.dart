import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_app/ui/pages/place_page.dart';

class PlaceTile2 extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const PlaceTile2(this.snapshot);

  @override
  Widget build(BuildContext context) {
    if (snapshot == null || snapshot.data["title"] == null)
      return Container();
    else
      return InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PlacePage(snapshot)));
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      snapshot.data["title"].toString().toUpperCase(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0, bottom: 2.0),
                          child: Text(
                            snapshot.data["address"],
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            FutureBuilder<DocumentSnapshot>(
                              future: Firestore.instance
                                  .collection("cities")
                                  .document(snapshot.data['city'])
                                  .collection("districts")
                                  .document(snapshot.data['district'])
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
                                    "${snapshot.data["name"]}, ".toUpperCase(),
                                  );
                                }
                              },
                            ),
                            FutureBuilder<DocumentSnapshot>(
                              future: Firestore.instance
                                  .collection("cities")
                                  .document(snapshot.data['city'])
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
                                    "${snapshot.data["name"]}, GOIÁS - BRASIL"
                                        .toUpperCase(),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
