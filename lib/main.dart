import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_gpt/helper/cache.dart';
import 'package:chat_gpt/helper/remote.dart';
import 'package:chat_gpt/resources/cache_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Modules/home/Home_intro.dart';
import 'Modules/home/home.dart';
import 'auth/loginPage.dart';
AndroidNotificationChannel channel =AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
StreamController<String?>.broadcast();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // await setupFlutterNotifications();
  // showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
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
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  var androidInit = const AndroidInitializationSettings('@mipmap/ic_launcher');

  var initSettings = InitializationSettings(android: androidInit);
  try {
    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (payload) async {
          try {
            if (payload.payload != null && payload.payload!.isNotEmpty) {
              print(payload.payload.toString());
              Map<String, dynamic> data = jsonDecode(payload.payload!);
              if (data['click_action'] == "linker_click") {
                // Get.to(ChatScreen(
                // chatRoomId: data['chatroomid'], recieverId: data['reciverid']));
              } else if (data['click_action'] == 'offer_click') {
                // Get.to(ViewOffers(
                //    reqId: data['reqId'],
                //  ));
              } else if (data['click_action'] == 'new_order_click') {
                //  Get.to(const ActiveOrders());
              } else if (data['click_action'] == 'complete_order_click') {
                // Get.to(const ActiveOrders());
              }
            } else {}
          } catch (e) {
            print(e);
          }
          return;
        });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("on message");
      print(message.notification!.title);

      _showNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');

      _showNotification(message);
    });
  } catch (e) {
    print(e.toString());
  }
  String? stringValue;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  stringValue = prefs.getString('email');
  print(stringValue);
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner:false,
    home: stringValue != null ? Homepage():LoginPage(),
  ));

}
Future<void> _showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails('linker', 'linker',
      channelDescription: 'linker App',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');

  NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
      message.notification!.body, notificationDetails,
      payload: jsonEncode(message.data));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _isAndroidPermissionGranted();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();

    requestPermission();
    // TODO: implement initState
    super.initState();
  }
  String? stringValue;
  String? mtoken;
  bool _notificationsEnabled = false;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
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

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled() ??
          false;

      setState(() {
        _notificationsEnabled = granted;
      });
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestPermission();
      setState(() {
        _notificationsEnabled = granted ?? false;
      });
    }
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                // Navigator.of(context, rootNavigator: true).pop();
                // await Navigator.of(context).push(
                //   MaterialPageRoute<void>(
                //     builder: (BuildContext context) => const AllMessages(),
                //   ),
                // );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      //   await Navigator.of(context).push(MaterialPageRoute<void>(
      //     builder: (BuildContext context) => const AllMessages(),
      //   ));
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Authorized");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("Provisional Authorized");
    } else {
      print("Not auth");
    }
  }
  FirebaseAuth auth = FirebaseAuth.instance;

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        mtoken = value;
      });
      saveToken(value!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(auth.currentUser!.uid)
        .update({"ntoken": token});
  }
}
