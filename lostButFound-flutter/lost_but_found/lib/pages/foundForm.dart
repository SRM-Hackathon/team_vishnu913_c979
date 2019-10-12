import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'mainPage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

const kGoogleApiKey = "AIzaSyBRMxmWyTA2yeYIA6kh6aUWIKBPR6Xm8mw";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
bool _autoValidate = false;
bool isLoading = false;

DateTime _selectedDate;
String _foundChildName;

String _foundChildDes;
String _foundChildDateTime;
String _latitiude;
String _longitude;
String _location;
File image;
var token='';
class FoundFormPage extends StatefulWidget {
  @override
  _FoundFormPageState createState() => _FoundFormPageState();
}

class _FoundFormPageState extends State<FoundFormPage> {
  @override
  void initState(){
    super.initState();
    SharedPreferences.getInstance().then((prefs){
      setState(() {
        token=prefs.getString('token');
      });
    });
  }
  Completer<GoogleMapController> _controller = Completer();
  static final MarkerId markerId = MarkerId("ChIJg-0KkVVYqDsRnQo3zeVdh4A");
  List<Marker> markers = <Marker>[];
postFound() async{
  setState(() {
      isLoading = true;
    });
  var dio = Dio();
  String base64Image = base64Encode(image.readAsBytesSync());
  print(image.path);
  print(_foundChildName);
  print(_foundChildDes);
  FormData data= new FormData.fromMap(
    {
      'latitude':_latitiude,
      'longitude':_longitude,
      'description':_foundChildDes,
      'name':_foundChildName,
      'location':_location,
      'date':_foundChildDateTime,
      'image':base64Image,
      'file': await MultipartFile.fromFile(image.path,filename: 'testing.jpg')
    }
  );
  dio.options.headers={"Authorization":"Token "+token};
  dio.post(host+"found/",data:data);
  Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => MainPage()));
  setState(() {
    isLoading = false;
  });
}
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  picker() async {
    print('Picker is called');
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
//    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      
      setState(() {
        image = img;
      });
    }
  }

  final Marker marker = Marker(
    markerId: markerId,
    position: LatLng(37.42796133580664, -122.085749655962),
    onTap: () {
    },
  );
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    Widget _lostNameField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Name',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans'),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
              alignment: Alignment.centerLeft,
              height: 60.0,
              child: TextFormField(
                keyboardType: TextInputType.text,
                validator: (String arg) {
                  if (arg.length < 2) {
                    return 'Name cannot be empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (String val) {
                  print(val);
                  setState(() {
                    print(val);
                    _foundChildName = val;
                  });
                  
                },
                style: TextStyle(
                  color: Colors.grey,
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.people,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter your Name',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    )),
              ))
        ],
      );
    }

    void _presentDatePicker() {
      showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2019),
              lastDate: DateTime.now())
          .then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        _selectedDate = pickedDate;
        _foundChildDateTime = _selectedDate.toString();
      });
    }

    Widget _lostDesField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Description',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 60.0,
            child: TextFormField(
              keyboardType: TextInputType.text,
              validator: (String arg) {
                if (arg.length < 2) {
                  return 'Description cannot be empty';
                } else {
                  return null;
                }
              },
              onChanged: (String val) {
                setState(() {
                  _foundChildDes = val;
                });
                
              },
              style: TextStyle(
                color: Colors.grey,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.description,
                  color: Colors.grey,
                ),
                hintText: 'Enter the description',
                hintStyle: TextStyle(
                  color: Colors.grey,
                )
              ),
            )
          )
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        top:true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding:EdgeInsets.symmetric(horizontal:20.0),
                child: Text("Add the location...",style:TextStyle( 
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  fontFamily: 'OpenSans'
                ))
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Card(
                  elevation: 5,
                    child: Container(
                    height: 500,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: Set<Marker>.of(markers)
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: RaisedButton(
                  onPressed: () async {
                    Prediction p = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: kGoogleApiKey,
                      mode: Mode.overlay, // Mode.fullscreen
                      language: "en",
                    );
                    setState(() {
                      markers.clear();
                      displayPrediction(p);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(Icons.search)),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text("Search for you location"))
                        ],
                      )
                    )
                  )
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Card(
                    child: Container(
                      padding:EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Form(
                            key: _formKey3,
                            autovalidate: _autoValidate,
                            child: Column(

                              children: <Widget>[
                                Container(
                                  padding:EdgeInsets.all(10.0),
                                  child: _lostNameField()),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: _lostDesField()),
                                Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: _presentDatePicker,
                                          child: Row(
                                            children: <Widget>[
                                              IconButton(
                                                color: Colors.grey,
                                                icon:
                                                    Icon(Icons.calendar_today),
                                                onPressed: _presentDatePicker,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                                  child: Text("Select date")),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text(_selectedDate == null
                                              ? 'No Date Chosen'
                                              : DateFormat.yMd()
                                                  .format(_selectedDate)),
                                        )
                                      ],
                                    ),
                                  ),
                                Container(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: picker,
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              color: Colors.grey,
                                              icon: Icon(Icons.camera_alt),
                                              onPressed: picker,
                                            ),
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0),
                                                child:
                                                    Text("Upload the image")),
                                          ],
                                        ),
                                      ),
                                      image == null
                                          ? Container(
                                              width: 40.0,
                                              height: 40.0,
                                              child: Icon(Icons.person))
                                          : Container(
                                              padding:
                                                  EdgeInsets.only(right: 10.0),
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.file(image))
                                    ],
                                  ))
                              ],
                            )
                          )
                  ],
                ),
                    ),
              )),
              Container(
                padding: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
                child: isLoading ? Center(child: CircularProgressIndicator()) : RaisedButton(
                  onPressed: postFound,
                  child: Container(
                    width:double.infinity,
                    child: Text("Submit",textAlign: TextAlign.center)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToTheLake(double la, double lo, String pla) async {
    _latitiude = la.toString();
    _longitude = lo.toString();
    _location = pla;
    print("la:" + la.toString());
    print("lo:" + lo.toString());
    final CameraPosition tempLocation = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(la, lo),
      zoom: 14.4746,
    );
    print("Entered");
    print("Enter successfull");
    final GoogleMapController controller = await _controller.future;
    print(tempLocation);
    // print(_kLake);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(tempLocation));
    print("Exited");
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      var templat = detail.result.geometry.location.lat;
      var templng = detail.result.geometry.location.lng;
      var loac = detail.result.name;
      print(placeId);
      print(templat);
      print(templng);

      await _goToTheLake(templat, templng, loac);

      await setState(() {
        print("Entered setstate");
        markers.add(Marker(
            markerId: MarkerId(placeId),
            position: LatLng(templat, templng),
            onTap: () {}));
        print("markers:" + markers.toString());
      });
      var address = await Geocoder.local.findAddressesFromQuery(p.description);
    }
  }
}
