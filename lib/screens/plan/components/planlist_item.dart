import 'package:flutter/material.dart';

class PlanListItem extends StatelessWidget {
  final String name;
  const PlanListItem({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
    );
  }
}
