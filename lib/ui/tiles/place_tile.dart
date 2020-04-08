import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_app/ui/pages/place_page.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const PlaceTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PlacePage(snapshot)));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 80.0,
              child: snapshot.data["image"] != null
                  ? Image.network(
                      snapshot.data["image"],
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
            Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    snapshot.data["title"],
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                  Text(
                    snapshot.data["address"],
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text("Ver no Mapa"),
                  textColor: Colors.blue,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    launch(
                        "https://www.google.com/maps/search/?api=1&query=${snapshot.data["latitude"]},"
                        "${snapshot.data["longitude"]}");
                  },
                ),
                FlatButton(
                  child: Text("Ligar"),
                  textColor: Colors.blue,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    launch("tel:${snapshot.data["phone1"]}");
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
