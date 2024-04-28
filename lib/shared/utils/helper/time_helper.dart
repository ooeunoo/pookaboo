import 'package:intl/intl.dart';
import 'package:pookabu/shared/utils/logging/log.dart';

Map<String, String> getCurrentDayAndTime() {
  DateTime now = DateTime.now();

  String day = DateFormat('E').format(now).toLowerCase().toString();

  String time = DateFormat('HH:mm:ss').format(now).toString();

  return {'day': day, 'time': time};
}

bool isCurrentlyOpen(String currentTime, String? openTime, String? closeTime) {
  try {
    if (isValidTimeFormat(openTime) && isValidTimeFormat(closeTime)) {
      DateTime openDateTime = DateTime.parse('2022-01-01 $openTime');
      DateTime closeDateTime = DateTime.parse('2022-01-01 $closeTime');
      DateTime currentDateTime = DateTime.parse('2022-01-01 $currentTime');

      if (currentDateTime.compareTo(openDateTime) >= 0 &&
          currentDateTime.compareTo(closeDateTime) <= 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    log.e(e);
    return false;
  }
}

bool isValidTimeFormat(String? time) {
  if (time == null || time == "") return false;

  RegExp regex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$');

  return regex.hasMatch(time);
}

String formatTime(String? time) {
  if (!isValidTimeFormat(time)) return '-';
  List<String> parts = time!.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);

  String suffix = hours < 12 ? '오전' : '오후';

  if (hours > 12) {
    hours -= 12;
  } else if (hours == 0) {
    hours = 12;
  }

  return '$suffix $hours:${minutes.toString().padLeft(2, '0')}시';
}

int convertSecondsToMinutes(int seconds) {
  return (seconds / 60).floor();
}

String parseAndFormatDateTime(DateTime dateTime) {
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  return formattedDate;
}

final timestamp = DateTime.now().millisecondsSinceEpoch;
