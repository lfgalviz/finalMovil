import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/crew.dart';
import 'package:provider/provider.dart';

import 'crew_title.dart';

class CrewList extends StatefulWidget {
  @override
  _CrewListState createState() => _CrewListState();
}

class _CrewListState extends State<CrewList> {
  @override
  Widget build(BuildContext context) {

    final crews = Provider.of<List<CrewMember>>(context);

    return ListView.builder(
      itemCount: crews.length,
      itemBuilder: (context, index) {
        return CrewTitle(crew: crews[index]);
      },
    );
  }
}