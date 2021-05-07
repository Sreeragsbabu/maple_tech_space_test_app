import 'package:flutter/material.dart';
import 'package:maple_tech_test_app/models/city.dart';
import 'package:maple_tech_test_app/utils/constants.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'city_details_screen.dart';

class CitySelectScreen extends StatefulWidget {
  @override
  _CitySelectScreenState createState() => _CitySelectScreenState();
}

class _CitySelectScreenState extends State<CitySelectScreen> {
  static List<City> _cities = [
    City(id: 1, name: "Mississauga"),
    City(id: 2, name: "Brampton"),
    City(id: 3, name: "Scarborough"),
    City(id: 4, name: "Whitby"),
    City(id: 5, name: "Oakville"),
    City(id: 6, name: "Kitchener"),
    City(id: 7, name: "Toronto"),
  ];
  List<City> _selectedCities = [];
  String cityString = '';
  List<String> citiesList = [];
  final _items = _cities
      .map((animal) => MultiSelectItem<City>(animal, animal.name))
      .toList();
  bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 5),
            Text(
              "Click the below button to list out cities",
              style: TextStyle(color: primaryGreen, fontSize: 16.0),
            ),
            SizedBox(
              height: 22.0,
            ),
            MultiSelectBottomSheetField<City>(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              decoration: BoxDecoration(color: primaryGreen),
              buttonIcon: Icon(
                Icons.arrow_drop_down,
                color: white,
              ),
              selectedColor: primaryGreen,
              initialChildSize: 0.7,
              maxChildSize: 0.95,
              title: Text("Cities"),
              buttonText: Text(
                "Choose a city",
                style: TextStyle(color: white),
              ),
              items: _items,
              searchable: true,
              onConfirm: (values) {
                setState(() {
                  isSelect = false;
                  citiesList.clear();
                  cityString = '';
                  _selectedCities = values;
                  if (_selectedCities.length == 0) {
                    isSelect = false;
                  }
                  if (_selectedCities.length == 1) {
                    cityString = cityString + _selectedCities[0].name;
                    isSelect = true;
                  } else {
                    int a = 0;
                    for (int i = 0; i < _selectedCities.length; i++) {
                      if (a == 0) {
                        a = 1;
                        cityString = cityString + _selectedCities[i].name;
                        isSelect = true;
                      } else {
                        cityString =
                            cityString + ', ' + _selectedCities[i].name;
                        isSelect = true;
                      }
                    }
                  }

                  /* for(int i=0;i<_selectedCities.length;i++){
                    if(_selectedCities.length ==0){
                      isSelect = false;
                    }
                    if(_selectedCities.length == 1){
                      cityString = cityString + _selectedCities[i].name;
                      isSelect = true;
                    }
                    else{
                      cityString = cityString + _selectedCities[i].name +',';
                      isSelect = true;
                    }
                  }*/
                  //print(cityString);
                });
              },
              chipDisplay: MultiSelectChipDisplay(
                alignment: Alignment.center,
                //icon: Icon(Icons.check,color: Colors.white),
                chipColor: blue,
                textStyle: TextStyle(color: Colors.white),
              ),
            ),
            Spacer(),
            isSelect
                ? RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                    color: blue,
                    child: Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('selectedCities', cityString);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CityDetailsScreen(
                                    selectedCities: cityString,
                                  )));
                    })
                : Text('')
          ],
        ),
      ),
    ));
  }
}
