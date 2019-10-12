import 'package:flutter/material.dart';
import '../main.dart';
import 'dart:async';
import 'lostform.dart';
import 'dart:convert';
import 'loginpage.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'foundForm.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

const kGoogleApiKey = "AIzaSyBRMxmWyTA2yeYIA6kh6aUWIKBPR6Xm8mw";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class _MainPageState extends State<MainPage> {
  var username;
  bool isLoading = false;
  List foundRecords = [];
  List lostRecords = [];

  

  Completer<GoogleMapController> _controller = Completer();
  static final MarkerId markerId = MarkerId("ChIJg-0KkVVYqDsRnQo3zeVdh4A");
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();

  List<Marker> markers = <Marker>[];

  final Marker marker = Marker( 
    markerId: markerId,
    position: LatLng(37.42796133580664, -122.085749655962),
    onTap: () {
    },
  );
  CameraPosition latlon(double la,double lo){
    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(la, lo),
      zoom: 14.4746,
    );
    return _kGooglePlex;
  }

  
  double _lat;
  double _lon;

  var useremail;
  @override
  void initState() {
    super.initState();
    getFounderRecord();
    getLoserRecord();
    setState(() {
      SharedPreferences.getInstance().then((prefs) {
        
        print("main page shared prefs");
        username = prefs.getString('name');
        print(username);
        useremail = prefs.getString('email');
        print(useremail);
     
    });
    });
    
  }

  Future<Null> refresh1() async {
    setState(() {
      isLoading = true;
      foundRecords.clear();
      getFounderRecord();
      isLoading = false;
    });
  }

  void call() async{
    await getFounderRecord();
    await getLoserRecord();
  }

  Future<Null> refresh2() async {
    setState(() {
      lostRecords.clear();
      getLoserRecord();
    });
  }

  Future<Null> refresh() async {
    setState(() {
      isLoading = true;
    });
    await refresh1();
    await refresh2();
    setState(() {
      isLoading = false;
    });
  }

  getFounderRecord() async {
    print("Enter found record");
    var prefs = await SharedPreferences.getInstance();
    http.get(
      host + 'foundhome/',
      headers: {'Authorization': 'Token ${prefs.getString('token')}'},
    ).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          foundRecords = jsonDecode(response.body);
          SharedPreferences.getInstance().then((prefs) {
            prefs.setString('found', jsonEncode(foundRecords));
          });
        });
      }
      print(foundRecords);
    });
  }

  getLoserRecord() async {
    print("Enter lost record");
    setState(() {
      isLoading = true;
    });
    var prefs = await SharedPreferences.getInstance();
    http.get(
      host + 'losthome/',
      headers: {'Authorization': 'Token ${prefs.getString('token')}'},
    ).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          lostRecords = jsonDecode(response.body);
          isLoading = false;
          SharedPreferences.getInstance().then((prefs) {
            prefs.setString('lost', jsonEncode(lostRecords));
          });
          print(lostRecords);
        });
      }
    });
  }

  void logout() async {
    print("entered logout");
    setState(() {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('token', '');
        print(prefs.getString('token'));

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget lostCard() {
      return lostRecords.length != 0
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.2, 0.4,0.7,0.9],
                                    colors: [
                                      Colors.blue[200],
                                      Colors.blue[300],
                                      Colors.blue[500],
                                      Colors.blue[600]
                                    ],
                ),
              ),
              child: ListView(
                  //shrinkWrap: true,
                  children: lostRecords
                      .map((item) => Container(
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 30.0),
                            margin: EdgeInsets.only(
                                top: 3.0, right: 5.0, left: 5.0),
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    
                              color: Color.fromRGBO(255,255,255, 0.3),
                              elevation: 40.0,
                              child: InkWell(
                                onTap: () {
                                  print(item);
                                  print(item['founder_imageurl']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 8.0, left: 8.0, right: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Your missing child is found.",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: Image.network(
                                                Uri(
                                                        scheme: "http",
                                                        host: path,
                                                        port: int.parse(port),
                                                        path:
                                                            item["founder_img"])
                                                    .toString(),
                                                scale: 2.0,
                                              ),
                                              margin: EdgeInsets.all(10.0),
                                            ),
                                            Container(
                                              child: Image.network(
                                                Uri(
                                                        scheme: "http",
                                                        host: path,
                                                        port: int.parse(port),
                                                        path: item["loser_img"])
                                                    .toString(),
                                                scale: 1.8,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 10.0, left: 8.0),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                              "Founder Name : " +
                                                  item['founder_name'],
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
    
                                                  fontFamily: 'OpenSans',fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 10.0, left: 8.0),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                              "Location : " +
                                                  item['founder_location'],
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,fontFamily: 'OpenSans',fontWeight: FontWeight.bold)),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Center(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: RaisedButton.icon(
                                              onPressed: () {
                                                launch(
                                                    "tel:${item['founder_num']}");
                                              },
                                              icon: Icon(Icons.call),
                                              label: Text(
                                                item['founder_num'],
                                                style:
                                                    TextStyle(fontSize: 20.0),
                                              ),
                                              color: Colors.greenAccent[400],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 20.0),
                                          height: 200,
                                          child: GoogleMap(
                                            mapType: MapType.normal,
                                            initialCameraPosition: latlon(double.parse(item['latitude']),double.parse(item['longitude'] )),
                                            onMapCreated: (GoogleMapController controller) {
                                              _controller.complete(controller);
                                            },
                                            markers: Set<Marker>.of(markers)
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          ))
                      .toList()),
            )
          : Container();
    }

    Widget foundCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.2, 0.4,0.7,0.9],
                                    colors: [
                                      Colors.blue[200],
                                      Colors.blue[300],
                                      Colors.blue[500],
                                      Colors.blue[600]
                                    ],
        ),
      ),
      child: ListView(
          children: foundRecords.map((item) => Container(
            padding:EdgeInsets.only(left: 10.0, right: 10.0, top: 30.0),
            margin: EdgeInsets.only(top: 3.0, right: 5.0, left: 5.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              color: Color.fromRGBO(255,255,255, 0.3),
                elevation: 40.0,
                child: InkWell(
                  onTap: () {
                    print(item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            top: 8.0, left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Thankyou for finding the child",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 23.0,
                                          fontFamily: 'OpenSans'
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Image.network(Uri(scheme: "http",host: path,port:int.parse(port),path: item["founder_img"]).toString(),
                                      scale: 1.8,),
                                      margin: EdgeInsets.all(10.0),
                                    ),
                                    Container(
                                      child: Image.network(Uri(scheme: "http",host: path,port: int.parse(port),path: item["loser_img"]).toString(),
                                      scale: 1.8,),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 8.0),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      "Loser Name : " + item['loser_name'],
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white, fontFamily: 'OpenSans',fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 8.0),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      "Location : " + item['loser_location'],
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold
                                          )),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: RaisedButton.icon(
                                      onPressed: () {
                                        launch("tel:${item['loser_num']}");
                                      },
                                      icon: Icon(Icons.call),
                                      label: Text(
                                        item['loser_num'],
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      color: Colors.greenAccent[400],
                                    ),
                                  ),
                                ),
                                 Container(
                                          padding: EdgeInsets.symmetric(vertical: 20.0),
                                          height: 200,
                                          child: GoogleMap(
                                            mapType: MapType.normal,
                                            initialCameraPosition: latlon(double.parse(item['latitude']),double.parse(item['longitude'] )),
                                            onMapCreated: (GoogleMapController controller) {
                                              _controller.complete(controller);
                                            },
                                            markers: Set<Marker>.of(markers)
                                          ),
                                        )
                              ]),
                        ),
                      ),
                    ),
                  ))
              .toList()),
    );
  }

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: new Scaffold(
          body: TabBarView(
            children: [
              new Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.deepPurpleAccent[200],
                  title: Text("Lost But Found"),
                  centerTitle: true,
                  actions: <Widget>[
                    Container(
                      padding:EdgeInsets.symmetric(horizontal: 10.0),
                      child: IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: call,
                        
                        ),)
                  ],
                ),
                drawer: Drawer(
                  child: ListView(
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        accountName:
                            Text(username == null ? 'User Name' : username),
                        accountEmail:
                            Text(useremail == null ? 'User Email' : useremail),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).platform == TargetPlatform.iOS
                                  ? Colors.blue
                                  : Colors.white,
                          child: Text(
                            username == null ? 'A' : username[0],
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: logout,
                        title: Text("Logout"),
                        trailing: Icon(Icons.exit_to_app),
                      ),
                    ],
                  ),
                ),
                body: SafeArea(
                    child: RefreshIndicator(
                        onRefresh: refresh1,
                        child: lostRecords.length != 0
                            ? lostCard()
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.2, 0.4,0.7,0.9],
                                    colors: [
                                      Colors.blue[200],
                                      Colors.blue[300],
                                      Colors.blue[500],
                                      Colors.blue[600]
                                    ],
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Card(
                                  margin: EdgeInsets.only(
                                      top: 0, left: 30, right: 30.0),
                                  elevation: 10,
                                  child: Container(
                                    padding: new EdgeInsets.all(32.0),
                                    child: Text(
                                      "No Records found yet!, We are trying on it",
                                      style: TextStyle(
                                          color: Colors.deepPurpleAccent[400]),
                                    ),
                                  ),
                                ),
                              ))
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.deepPurpleAccent[400],
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LostFormPage()));
                  },
                  child: Icon(Icons.add),
                ),
              ),
              new Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.deepPurpleAccent[200],

                  title: Text("Lost But Found"),
                  centerTitle: true,
                  actions: <Widget>[
                    Container(
                      padding:EdgeInsets.symmetric(horizontal: 10.0),
                      child: IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: call,
                        
                        ),)
                  ],
                ),
                drawer: Drawer(
                  child: ListView(
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        accountName:
                            Text(username == null ? 'User Name' : username),
                        accountEmail:
                            Text(useremail == null ? 'User Email' : useremail),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).platform == TargetPlatform.iOS
                                  ? Colors.blue
                                  : Colors.white,
                          child: Text(
                            username == null ? 'A' : username[0],
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: logout,
                        title: Text("Logout"),
                        trailing: Icon(Icons.exit_to_app),
                      ),
                    ],
                  ),
                ),
                body: SafeArea(
                    child: RefreshIndicator(
                        onRefresh: refresh2,
                        child: foundRecords.length != 0
                            ? foundCard()
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.2, 0.4,0.7,0.9],
                                    colors: [
                                      Colors.blue[200],
                                      Colors.blue[300],
                                      Colors.blue[500],
                                      Colors.blue[600]
                                    ],
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Card(
                                  margin: EdgeInsets.only(
                                      top: 0, left: 30, right: 30.0),
                                  elevation: 10,
                                  child: Container(
                                    padding: new EdgeInsets.all(32.0),
                                    child: Text(
                                      "No Records found yet!, We are trying on it",
                                      style: TextStyle(
                                          color: Colors.deepPurpleAccent[200]),
                                    ),
                                  ),
                                ),
                              ))
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.deepPurpleAccent[400],
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => FoundFormPage()));
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(icon: new Icon(Icons.location_searching), text: "Lost"),
              Tab(icon: new Icon(Icons.child_care), text: "Found"),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.red,
          ),
          backgroundColor: Colors.deepPurpleAccent[200],
        ),
      ),
    );
  }
}
