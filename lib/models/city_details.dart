// To parse this JSON data, do
//
//     final cityDetails = cityDetailsFromJson(jsonString);

import 'dart:convert';

List<CityDetails> cityDetailsFromJson(String str) => List<CityDetails>.from(json.decode(str).map((x) => CityDetails.fromJson(x)));

String cityDetailsToJson(List<CityDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityDetails {
  CityDetails({
    this.id,
    this.addr,
    this.area,
    this.board,
    this.lpDol,
    this.br,
    this.br_plus,
    this.bathTot,
    this.country,
    this.county,
    this.municipality,
    this.town,
    this.sqft,
    this.images,
  });

  int id;
  String addr;
  String area;
  String board;
  String lpDol;
  String br;
  String br_plus;
  String bathTot;
  String country;
  String county;
  String municipality;
  String town;
  String sqft;
  Images images;

  factory CityDetails.fromJson(Map<String, dynamic> json) => CityDetails(
    id: json["id"] ?? '',
    addr: json["addr"] ?? '',
    area: json["area"] ?? '',
    board: json["board"] ?? '',
    lpDol: json["lp_dol"] ?? '',
    br: json["br"] ?? '',
    br_plus: json["br_plus"] ?? '',
    bathTot: json["bath_tot"] ?? '',
    country: json["country"] ?? '',
    county: json["county"] ?? '',
    municipality: json["municipality"] ?? '',
    town: json["town"] ?? '',
    sqft: json["sqft"] ?? '--',
    images: Images.fromJson(json["images"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "addr": addr,
    "area": area,
    "board": board,
    "lp_dol": lpDol,
    "br": br,
    "br_plus": br_plus,
    "bath_tot": bathTot,
    "country": country,
    "county": county,
    "municipality": municipality,
    "town": town,
    "sqft": sqft,
    "images": images.toJson(),
  };
}



class Images {
  Images({
    this.id,
    this.mlNum,
    this.directory,
    this.images,
  });

  int id;
  String mlNum;
  String directory;
  String images;

  factory Images.fromJson(Map<String, dynamic> json) => Images(
    id: json["id"],
    mlNum: json["ml_num"],
    directory: json["directory"],
    images: json["images"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ml_num": mlNum,
    "directory": directory,
    "images": images,
  };
}
