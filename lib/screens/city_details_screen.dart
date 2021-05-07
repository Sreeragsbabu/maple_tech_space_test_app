import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:maple_tech_test_app/models/city_details.dart';
import 'package:maple_tech_test_app/services/api_services.dart';
import 'package:maple_tech_test_app/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityDetailsScreen extends StatefulWidget {
  final String selectedCities;
  const CityDetailsScreen({Key key, this.selectedCities}) : super(key: key);

  @override
  _CityDetailsScreenState createState() => _CityDetailsScreenState();
}

class _CityDetailsScreenState extends State<CityDetailsScreen> {
  List<CityDetails> cityDetails;
  bool _loading = false;
  String images;
  List imgList = [];
  String cities = '';
  String expTime = '';
  final CarouselController _controller = CarouselController();
  @override
  void initState() {
    _loading = true;
    loadData();
    loadFromLocal();
  }

  Future<void> loadFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     expTime = prefs.getString('expireTime');
    cities = prefs.getString('selectedCities');
  }

  Future<void> loadData() async {
    ApiServices.getCityDetails(widget.selectedCities).then((details) {
      setState(() {
        cityDetails = details;
        print(cityDetails);
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: primaryGreen, //change your color here
        ),
        elevation: 0.0,
        backgroundColor: white,
        title: Row(
          children: [
            Flexible(
                child: Text(
              cities,
              style: TextStyle(fontSize: 14.0,color: primaryGreen),
            )),
            Icon(Icons.arrow_drop_down,color: primaryGreen,)
          ],
        ),
      ),
      body: _loading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  backgroundColor: primaryGreen,
                ),
                SizedBox(height: 12.0,),
                Text("loading....")],
            ))
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: ListView.builder(
                itemCount: cityDetails.length,
                itemBuilder: (context, index) {
                  images = cityDetails[index].images.images;
                  final split = images.split(',');
                  //print(split);
                  final Map<int, String> values = {
                    for (int i = 0; i < 3; i++)
                      i: split[i]
                  };
                  final value1 = values[0];
                  final value2 = values[1];
                  final value3 = values[2];

                  imgList = [
                    cityDetails[index].images.directory +
                        "Photo" +
                        cityDetails[index].images.mlNum +
                        "-" +
                        value1 +
                        ".jpeg",
                    cityDetails[index].images.directory +
                        "Photo" +
                        cityDetails[index].images.mlNum +
                        "-" +
                        value2 +
                        ".jpeg",
                    cityDetails[index].images.directory +
                        "Photo" +
                        cityDetails[index].images.mlNum +
                        "-" +
                        value3 +
                        ".jpeg"
                  ];
                  for(int i=0;i<3;i++){
                    //print(imgList[i]);
                    downloadFile(imgList[i], "${cityDetails[index].images.mlNum}-$i.jpeg");
                  }

                  return Column(
                    children: [
                      Stack(
                        children: [
                          CarouselSlider(
                            items: imgList.map((imageUrl) {
                              return Builder(builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(),
                                  child: FadeInImage.assetNetwork(
                                    placeholderCacheHeight: 20,
                                    fit: BoxFit.cover,
                                    placeholder: 'assets/images/spinner.gif',
                                    image: imageUrl,
                                  ),
                                );
                              });
                            }).toList(),
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                                viewportFraction: 1.0,
                                enlargeCenterPage: false,
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.height,
                                height: 200),
                            carouselController: _controller,
                          ),
                          Container(
                            height: 200.0,
                            width: double.infinity,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: white,
                                      ),
                                      onPressed: () {}),
                                  IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: white,
                                      ),
                                      onPressed: () {})
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        color: secondaryLightGrey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 12.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                cityDetails[index].addr ?? "",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 18.0,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(cityDetails[index].town ?? ""),
                                  Text(", "),
                                  Text(cityDetails[index].county ?? "")
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.local_offer_sharp,
                                    size: 18.0,
                                    color: secondaryGrey,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text('\$ '),
                                  Text(cityDetails[index].lpDol ?? "")
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.local_hotel_sharp,
                                    size: 18.0,
                                    color: secondaryGrey,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(cityDetails[index].br ?? ""),
                                  Text("+"+cityDetails[index].br_plus ??""),
                                  Text(" BEDROOMS ")
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.bathtub_outlined,
                                    size: 18.0,
                                    color: secondaryGrey,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(cityDetails[index].bathTot ?? ""),
                                  Text(" BATHROOMS")
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.sync_alt_sharp,
                                    size: 18.0,
                                    color: secondaryGrey,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text((cityDetails[index].sqft.isEmpty == true)
                                      ? "--"
                                      : cityDetails[index].sqft),
                                  Text(" SQFT")
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      )
                    ],
                  );
                },
              ),
            ),
    ));
  }

  downloadFile(String url, String fileName) async {
    try {
      Directory tempDir = await getApplicationDocumentsDirectory();
      String filePath = "${tempDir.path}/$fileName";
      //print(filePath);

      if(File(filePath).existsSync()){
        File(filePath).deleteSync();
      }
      Dio dio = new Dio();
      Response response = await dio.download(url, filePath,onReceiveProgress:(_c,_t){
      },);

    } on Exception catch (err, stackTrace) {
      print('error caught: $err');
      //Catcher.reportCheckedError(err, stackTrace);
    }
  }
}
