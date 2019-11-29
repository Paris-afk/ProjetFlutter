import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Form Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

//globalkey
//email, password variable
//form
//textformfield
//submit

class Todo {
  final String title;
  final String description;


  Todo(this.title, this.description);
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Things:'
                    ),
                    //validator: (input) => !input.contains('@') ? 'Not a valid Email' : null,
                    onSaved: (input) => _email = input,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'City:'
                    ),

                    //validator: (input) => input.length < 8 ? 'You need at least 8 characters' : null,
                    onSaved: (input) => _password = input,
                   // obscureText: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: _submit,
                          child: Text('Go'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }



  void _submit(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      print(_email);
      print(_password);
    }
    Navigator.push(
      context,
      //MaterialPageRoute(builder: (context) => SecondRoute(_email , _password)),
      MaterialPageRoute(builder: (context) => ThirdRoute(_email, _password)),
    );
  }

}
class SecondRoute extends StatelessWidget {
  String thing , city;
  SecondRoute(_email , _password){
    thing= _email;
    city = _password;
  }

 // Todo t = new Todo();
  String paris = "paris";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            print(city);
            print(thing);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }

  void _submit() {
    print("Paris Lopez");
  }
}





class Places{
  final String name ;
  final String address;
  final double lat ;
  final double lng ;
  final String city ;
  final String state ;
  final String country;

  Places(this.address, this.city , this.country , this.lat , this.lng , this.name , this.state);
}






class ThirdRoute extends StatelessWidget {
  String thing , city;
  ThirdRoute(_email , _password){
    thing= _email;
    city = _password;
  }

Future<List<Places>> _getPlaces() async{
  var data = await http.get("https://api.foursquare.com/v2/venues/search?client_id=U01ZTHJ1Y10MTKDX120LXSUWG2PPKYN5SJ3DVPVIHSCESPZS&client_secret=DTIY5LWEEE02HVLJBCSNKQTA3E3KKI3JRHX1FUDUAS0V1LJS&near=${city}&query=${thing}&v=20190811");
var jsonData = json.decode(data.body);
List<Places> places = [];
for(var u in jsonData['response']['venues']){
  Places place = Places(u['name'],u['location']['address'],u['categories'][0]['icon']['prefix']+'88'+'.png',u['location']['labeledLatLngs'][0]['lat'],u['location']['labeledLatLngs'][0]['lng'],u["name"],u["name"]);
  places.add(place);
  //print(u['location']['address']);
 // print(u['categories'][0]['icon']['prefix']+'88'+'.png');
  print(u['location']['labeledLatLngs'][0]['lat']);
}
print(places.length);
return places;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tirth Screen"),
      ),
      body: Center(
        child: FutureBuilder(

          future: _getPlaces(),
          builder: (BuildContext context , AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Container(
                child: Center(
                child: Text("Loading"),
                ),
              );
            }else if(snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  if(snapshot.data[index].city == null ||snapshot.data[index].country == null ){

                    return ListTile(
                        onTap: () => launch('https://www.google.fr/maps/@${snapshot.data[index].lat},${snapshot.data[index].lng},20z'),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://ss3.4sqi.net/img/categories_v2/food/middleeastern_88.png"
                        ),
                      ),
                      title: Text(snapshot.data[index].name),
                      subtitle:Text("il n'ya pas un address specifique") ,


                    );
                  }else {
                    return ListTile(
                        onTap: () => launch('https://www.google.fr/maps/@${snapshot.data[index].lat},${snapshot.data[index].lng},20z'),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data[index].country
                        ),
                      ),
                      title: Text(snapshot.data[index].name),

                      subtitle: Text(snapshot.data[index].city),

                    );
                  }
                },

              );
            }else{
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index].name),

                    subtitle:Text(snapshot.data[index].city) ,
                  );
                },
              );
            }

          },

        ),

      ),
    );
  }

  void _submit() {
    print("Paris Lopez");
  }
}



