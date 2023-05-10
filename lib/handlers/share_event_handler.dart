import '../classes/court.dart';
import '../classes/event.dart';
import 'package:share_plus/share_plus.dart';

class ShareEventHandler {
  static shareEvent(Event event, Court court) async {
    String message =
        "Hey, come and join me for a game at ${court.name} in ${court.address.city}!";
    message += " Go to the app and join the event: hoopup://joinEvent?id=${event.id}"; // url does not work yet (try it on your phone) // we will need to add a deep link to the app
    Share.share(message, subject: "Let's play basketball!");
  }
}
