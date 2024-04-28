import 'package:flutter/material.dart';
import 'package:pookabu/shared/constant/assets.dart';

enum ToiletType {
  building,
  cafe;
}

enum ToiletFilter {
  time("time", '현재운영', Assets.alarm),
  gender("gender", '남녀분리', Assets.gender),
  password("password", '개방', Assets.closeKey),
  ;

  const ToiletFilter(this.key, this.text, this.icon);

  final String key;
  final String text;
  final String icon;
}

enum WeekKey {
  mon('mon', '월요일'),
  tue('tue', '화요일'),
  wed('wed', '수요일'),
  thu('thu', '목요일'),
  fri('fri', '금요일'),
  sat('sat', '토요일'),
  sun('sun', '일요일'),
  ;

  const WeekKey(this.key, this.ko);

  final String key;
  final String ko;
}

enum RatingScoreType {
  cleanliness('cleanliness', '청결도', '변기, 세면대 주변이 깨끗해요.', '🧹'),
  convenience('convenience', '편의성', '시설, 어메니티 등 사용하기 편리해요.', '🎛️'),
  management('management', '관리도', '항상 깔끔하게 정리되어있어요.', '🫧'),
  safety('safety', '안전성', '밤 늦게 사용해도 안전해요.', '🚨');

  const RatingScoreType(this.key, this.name, this.description, this.emoji);

  final String key;
  final String name;
  final String description;
  final String emoji;
}

enum EquipmentOrder { common, male, female }

enum EquipmentKey {
  urinal([
    ('urinal', "소변기"),
    ('child_urinal', "어린이용 소변기"),
    ('disable_urinal', "장애인용 소변기")
  ], '소변기', '💦'),
  seat([
    ('seat', "좌변기"),
    ('child_seat', "어린이용 좌변기"),
    ('disable_seat', "장애인용 좌변기")
  ], '좌변기', '🚽'),
  washbasin([('washbasin', "세면대")], '세면대', '🚰');

  const EquipmentKey(this.keys, this.name, this.emoji);

  final List<(String, String)> keys;
  final String name;
  final String emoji;
}

enum ConvenienceKey {
  power_room('powder_room', '파우더 룸', '🪞'),
  hand_dry('hand_dry', '핸드 드라이', '💨'),
  bell('bell', '비상벨', '🚨'),
  vending('vending', '편의 자판기', '🎛️'),
  diaper('diaper', '기저귀 교환대', '👶'),
  ;

  const ConvenienceKey(this.key, this.name, this.emoji);

  final String key;
  final String name;
  final String emoji;
}

enum AmenityKey {
  paper('paper', '화장실 휴지', '🧻'),
  soap('soap', '비누', '🧼'),
  towel('towel', '핸드 타올', '🧻');

  const AmenityKey(this.key, this.name, this.emoji);

  final String key;
  final String name;
  final String emoji;
}

enum Coord {
  wgs84('WGS84'),
  wcongnamul('WCONGNAMUL'),
  ;

  const Coord(this.key);

  final String key;
}

enum InputDataType {
  text,
  textMultiline,
  name,
  email,
  numberInt,
  numberDouble,
}

enum InputTimeDataType {
  date,
  time,
  dateAndTime,
}
