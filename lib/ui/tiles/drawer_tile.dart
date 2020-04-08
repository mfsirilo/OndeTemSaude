import 'package:flutter/material.dart';
import 'package:onde_tem_saude_app/ui/transitions/fade_route.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget tab;
  final bool isActive;
  final double iconSize;

  DrawerTile(this.icon, this.text, this.tab, this.isActive, this.iconSize);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          Navigator.pushReplacement(context, FadeRoute(page: tab));
        },
        child: Container(
          padding: EdgeInsets.only(left: 20.0),
          height: 50.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: iconSize,
                color: isActive
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: isActive
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
