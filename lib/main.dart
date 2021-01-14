import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/detailedPage.dart';
import 'jsonWeather.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loading = false;
  int tagger = 1;
  String temp = "",
      description = "",
      main = "",
      feels_like = "",
      iconCode,
      placeName = "";

  String windSpeed, windDeg;
  String maxTemp, minTemp, pressure, humidity;
  String sunset, sunrise;

  @override
  void initState() {
    super.initState();
    print("Hello from init");
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    print("Hello from build");
    return Scaffold(
      body: Hero(
        tag: "image",
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("images/image$tagger.jpg"))),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !_loading
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.sort),
                                    splashColor: Colors.tealAccent,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SecondScreen(
                                                    currentTemp: temp,
                                                    feels_like: feels_like,
                                                    description: description,
                                                    placeName: placeName,
                                                    humidity: humidity,
                                                    maxTemp: maxTemp,
                                                    tagger: tagger,
                                                    minTemp: minTemp,
                                                    pressure: pressure,
                                                    iconId: iconCode,
                                                    sunrise: sunrise,
                                                    sunset: sunset,
                                                    windDeg: windDeg,
                                                    windSpeed: windSpeed,
                                                  )));
                                    },
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "$placeName",
                                    style: TextStyle(
                                        fontSize: 23,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.refresh),
                                    onPressed: _determinePosition,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: Divider(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "$main",
                                      style: TextStyle(
                                          fontSize: 23,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Image(
                                      filterQuality: FilterQuality.high,
                                      matchTextDirection: true,
                                      fit: BoxFit.contain,
                                      image: NetworkImage(
                                          "http://openweathermap.org/img/w/$iconCode.png"),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "$temp",
                                      style: TextStyle(
                                          fontSize: 50,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      "°",
                                      style: TextStyle(
                                          fontSize: 50,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w200),
                                    ),
                                    Text(
                                      "c",
                                      style: TextStyle(
                                          fontSize: 50,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$description",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            "$feels_like",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _determinePosition() async {
    setState(() {
      _loading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    var position = await Geolocator.getCurrentPosition();
    print(position.latitude);
    print(position.longitude);
    apiCall(position.latitude.toString(), position.longitude.toString());
    // apiCall("28.644800", "77.216721");
  }

  Future apiCall(String lat, String lon) async {
    try {
      var response = await http.get(
          "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=fe1dee988e7efe3e11a59d602a50ae1b&units=metric");
      final weather = Weather.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
        setState(() {
          //temp = weather.main.temp.toInt().toString();
          temp = weather.main.temp.toInt().toString();
          main = weather.weather.first.main;
          description = weather.weather.first.description;
          feels_like = "Feels like ${weather.main.feelsLike.toString()}°";
          iconCode = weather.weather.first.icon;
          placeName = weather.name;
          sunrise = convert(weather.sys.sunrise);
          sunset = convert(weather.sys.sunset);
          maxTemp = weather.main.tempMax.toString();
          minTemp = weather.main.tempMin.toString();
          pressure = "${weather.main.pressure.toString()} hPA";
          windDeg = weather.wind.deg.toString();
          windSpeed = "${weather.wind.speed.toString()} m/s";
          humidity = "${weather.main.humidity.toString()} %";
        });

        imageTagger(main);
      }
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        main = "Please try again";
        temp = "";
        description = "";
        feels_like = "";
        iconCode = "10d";
        _loading = false;
      });
    }
  }

  String convert(int utc) {
    final time = DateTime.fromMillisecondsSinceEpoch(utc * 1000, isUtc: true)
        .add(const Duration(hours: 5, minutes: 30));
    return "${time.hour.toString()}:${time.minute.toString()}";
  }

  void imageTagger(String main) {
    setState(() {
      if (main == "Clouds") tagger = 2;
      if (main == "Clear" ||
          main == "Mist" ||
          main == "Smoke" ||
          main == "Haze") tagger = 1;
      if (main == "Rain" || main == "Drizzle") tagger = 4;
      if (main == "Thunderstorm") tagger = 3;
    });
  }
}
