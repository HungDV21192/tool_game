// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

class CasesBaseModel {
  CasesBaseModel({
    required this.id,
    required this.message,
    required this.global,
    required this.countries,
    required this.date,
  });

  final String id;
  final String message;
  final GlobalBase global;
  final List<BaseCountry> countries;
  final DateTime date;

  factory CasesBaseModel.fromRawJson(String str) =>
      CasesBaseModel.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory CasesBaseModel.fromJson(Map<String, dynamic> json) => CasesBaseModel(
    id: json["ID"] as String,
    message: json["Message"] as String,
    global: GlobalBase.fromJson(json["Global"] as Map<String, dynamic>),
    countries: List<BaseCountry>.from((json["Countries"] as Iterable).map(
          (x) => BaseCountry.fromJson(x as Map<String, dynamic>),
    )),
    date: DateTime.parse(json["Date"] as String),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Message": message,
    "Global": global.toJson(),
    "Countries": List<dynamic>.from(countries.map((x) => x.toJson())),
    "Date": date.toIso8601String(),
  };
}

class BaseCountry {
  BaseCountry({
    required this.id,
    required this.country,
    required this.countryCode,
    required this.slug,
    required this.newConfirmed,
    required this.totalConfirmed,
    required this.newDeaths,
    required this.totalDeaths,
    required this.newRecovered,
    required this.totalRecovered,
    required this.date,
    required this.premium,
  });

  final String id;
  final String country;
  final String countryCode;
  final String slug;
  final int newConfirmed;
  final int totalConfirmed;
  final int newDeaths;
  final int totalDeaths;
  final int newRecovered;
  final int totalRecovered;
  final DateTime date;
  final Premium premium;

  factory BaseCountry.fromRawJson(String str) =>
      BaseCountry.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory BaseCountry.fromJson(Map<String, dynamic> json) => BaseCountry(
    id: json["ID"] as String,
    country: json["Country"] as String,
    countryCode: json["CountryCode"] as String,
    slug: json["Slug"] as String,
    newConfirmed: json["NewConfirmed"] as int,
    totalConfirmed: json["TotalConfirmed"] as int,
    newDeaths: json["NewDeaths"] as int,
    totalDeaths: json["TotalDeaths"] as int,
    newRecovered: json["NewRecovered"] as int,
    totalRecovered: json["TotalRecovered"] as int,
    date: DateTime.parse(json["Date"] as String),
    premium: Premium.fromJson(json["Premium"] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Country": country,
    "CountryCode": countryCode,
    "Slug": slug,
    "NewConfirmed": newConfirmed,
    "TotalConfirmed": totalConfirmed,
    "NewDeaths": newDeaths,
    "TotalDeaths": totalDeaths,
    "NewRecovered": newRecovered,
    "TotalRecovered": totalRecovered,
    "Date": date.toIso8601String(),
    "Premium": premium.toJson(),
  };
}

class Premium {
  Premium();

  factory Premium.fromRawJson(String str) =>
      Premium.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory Premium.fromJson(Map<String, dynamic> json) => Premium();

  Map<String, dynamic> toJson() => {};
}

class GlobalBase {
  GlobalBase({
    required this.newConfirmed,
    required this.totalConfirmed,
    required this.newDeaths,
    required this.totalDeaths,
    required this.newRecovered,
    required this.totalRecovered,
    required this.date,
  });

  final int newConfirmed;
  final int totalConfirmed;
  final int newDeaths;
  final int totalDeaths;
  final int newRecovered;
  final int totalRecovered;
  final DateTime date;

  factory GlobalBase.fromRawJson(String str) =>
      GlobalBase.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory GlobalBase.fromJson(Map<String, dynamic> json) => GlobalBase(
    newConfirmed: json["NewConfirmed"] as int,
    totalConfirmed: json["TotalConfirmed"] as int,
    newDeaths: json["NewDeaths"] as int,
    totalDeaths: json["TotalDeaths"] as int,
    newRecovered: json["NewRecovered"] as int,
    totalRecovered: json["TotalRecovered"] as int,
    date: DateTime.parse(json["Date"] as String),
  );

  Map<String, dynamic> toJson() => {
    "NewConfirmed": newConfirmed,
    "TotalConfirmed": totalConfirmed,
    "NewDeaths": newDeaths,
    "TotalDeaths": totalDeaths,
    "NewRecovered": newRecovered,
    "TotalRecovered": totalRecovered,
    "Date": date.toIso8601String(),
  };
}