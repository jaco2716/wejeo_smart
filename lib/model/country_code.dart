import 'dart:convert';

import 'package:azlistview/azlistview.dart';

class CountryCode extends ISuspensionBean {
  String country;
  int code;
  String? tagIndex;

  CountryCode({
    required this.country,
    required this.code,
    this.tagIndex,
  });

  CountryCode.fromJson(Map<String, dynamic> json)
      : country = json['country'] as String,
        code = json['code'] as int;

  Map<String, dynamic> toJson() => {
        'country': country,
        'code': code,
      };

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  String toString() => '${json.encode(this)}"tag": "$tagIndex"';
}
