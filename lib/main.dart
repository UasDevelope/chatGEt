import 'package:chat_gpt/helper/cache.dart';
import 'package:chat_gpt/helper/remote.dart';
import 'package:chat_gpt/resources/cache_keys.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Modules/home/home.dart';
import 'auth/loginPage.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DioHelper.init();
  await CacheHelper.init();
  // await
  // MobileAds.instance.initialize();
  final DateFormat dateFormat = DateFormat("yyyy-mm-dd");
  final today = int.parse(dateFormat.format(DateTime.now()).split("-").join());
  final cachedDate = await CacheHelper.getData(key: CacheKeys.todaysDate) ?? 0;
  if (today > cachedDate) {
    CacheHelper.removeData(CacheKeys.numberOfQestions);
    CacheHelper.removeData(CacheKeys.numberOfGeneration);
  }
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  String? stringValue;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  stringValue = prefs.getString('email');
  print(stringValue);
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner:false,
    home: stringValue != null ? Home() : LoginPage(),
  ));

}

class MyApp extends StatelessWidget {
  String? stringValue;
  void getsharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    stringValue = prefs.getString('email');
    print(stringValue);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Chat GPT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: stringValue == null ? Home() : LoginPage());
  }
}
