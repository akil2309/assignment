import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SecondScreen extends StatelessWidget {
  String windSpeed, windDeg;
  String maxTemp, minTemp, pressure, humidity;
  String feels_like, sunset, sunrise;
  String placeName, currentTemp, description, iconId;
  int tagger;
  SecondScreen({
    @required this.windSpeed,
    @required this.windDeg,
    @required this.maxTemp,
    @required this.minTemp,
    @required this.tagger,
    @required this.pressure,
    @required this.humidity,
    @required this.iconId,
    @required this.description,
    @required this.feels_like,
    @required this.sunset,
    @required this.sunrise,
    @required this.placeName,
    @required this.currentTemp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
              tag: "image",
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  width: double.infinity,
                  height: 370,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                    color: Colors.white,
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black26, BlendMode.softLight),
                        image: AssetImage("images/image$tagger.jpg"),
                        fit: BoxFit.cover),
                  ),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, top: 15.0),
                              child: IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.arrow_back_ios_rounded),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              filterQuality: FilterQuality.high,
                              matchTextDirection: true,
                              fit: BoxFit.contain,
                              image: NetworkImage(
                                  "http://openweathermap.org/img/w/$iconId.png"),
                            ),
                            Text(
                              "Today",
                              style: TextStyle(
                                  fontSize: 30,
                                  letterSpacing: 2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$currentTemp°",
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      letterSpacing: 2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  "$placeName",
                                  style: TextStyle(
                                      fontSize: 15,
                                      letterSpacing: 2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "$description",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sunrise $sunrise | $feels_like | Sunset $sunset",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Wind",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Speed: $windSpeed",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "Deg    : $windDeg°",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Deatiled Weather",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Max temp: $maxTemp°",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "Min temp : $minTemp°",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "Pressure  : $pressure",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "Humidity  : $humidity",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
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
