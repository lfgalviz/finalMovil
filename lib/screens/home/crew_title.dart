import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/crew.dart';

class CrewTitle extends StatelessWidget {

  final CrewMember crew;
  CrewTitle({this.crew});


  @override
  Widget build(BuildContext context) {

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
            ),
            title: Text('Add List'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("You want to add your friend list to your list's"),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.assignment_turned_in),
                label: Text('Add'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown,
            backgroundImage: NetworkImage(crew.url),
          ),
          title: Text(crew.name),
          subtitle: Text('Last Name: ${crew.lastname},  Phone number: ${crew.phone}'),
          trailing: Icon(Icons.add_circle),
          isThreeLine: true,
          onTap: ()=>{
            _showMyDialog()
          },
        ),
      ),
    );

  
  }

  
}