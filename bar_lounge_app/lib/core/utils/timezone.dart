import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezoneUtil {
  static const String localTimezone = 'America/Santo_Domingo';
  
  static void initialize() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(localTimezone));
  }
  
  static DateTime getLocalNow() {
    return tz.TZDateTime.now(tz.local);
  }
}
