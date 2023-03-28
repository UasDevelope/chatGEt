import 'dart:developer';
import 'dart:io';
import 'package:chat_gpt/API/api.dart';
import 'package:chat_gpt/API/export_conversation.dart';
import 'package:chat_gpt/API/image.dart';
import 'package:chat_gpt/Modules/image_gen/img_gen.dart';
import 'package:chat_gpt/Modules/my%20conversation/my_con.dart';
import 'package:chat_gpt/Modules/prompts/prompt.dart';
import 'package:chat_gpt/resources/cache_keys.dart';
import 'package:chat_gpt/resources/colors.dart';
import 'package:chat_gpt/resources/style.dart';
import 'package:chat_gpt/utils/drawer_item.dart';
import 'package:chat_gpt/chat/chat.dart';
import 'package:chat_gpt/chat/bubble.dart';
import 'package:chat_gpt/helper/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../ads/ad_helper.dart';
import '../../ads/banner.dart';
import '../../ads/intetialads.dart';
import '../../ads/q_ad.dart';
import '../../const/robot_icons.dart';
import '../../resources/images.dart';
import '../../utils/components.dart';
import '../subscription/subs.dart';
import 'package:badges/badges.dart' as badges;

class Home extends StatefulWidget {
  String? prompt;
  String? act;
  Home({this.prompt, this.act});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId:Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : "ca-app-pub-3940256099942544/1033173712",
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
  final TextEditingController _controller = TextEditingController();
  late final ScrollController _scrollController;
  final GlobalKey<FormState> _form = GlobalKey();
  final OpenAiAPI openAiAPI = OpenAiAPI();

  List<ChatInput> chat = [];
  final ImageAPI _imageAPI = ImageAPI();
  List<bool> animated = [];
  bool isEnabled = true;
  Map<int, String> chatText = {};
  int tempIndex = 0;
  int myconversation=0;
  int saveconverstion=0;
  int clearconversation=0;
  int Awesomeprompt=0;
  int chatIndex = 0;
  int setting =0;
  int awesomeprompt=0;
  int imagegeneration=0;
  int subscription=0;
  String fileName = '';
  String allPrompt = '';
  List<String> chats = [];
  final DateFormat dateFormat = DateFormat("yyyy-mm-dd");
  int reminatodatindex =
      CacheHelper.getData(key: CacheKeys.remainquestion) ?? 5;
  int todayQuestionIndex =
      CacheHelper.getData(key: CacheKeys.numberOfQestions) ?? 0;
  bool isVoiceEnabled = false;
  @override
  void initState() {
    // _createInterstitialAd();
    setState(() {});
    getchats();
    _scrollController = ScrollController();
    // IntetialAds();
    setting++;
    super.initState();
  }

  void getchats() async {
    chats = await CacheHelper.getStrings('names') ?? [];
    final today =
    int.parse(dateFormat.format(DateTime.now()).split("-").join());
    CacheHelper.saveData(key: CacheKeys.todaysDate, value: today);
  }

  @override
  Widget build(BuildContext context) {
    reminatodatindex;
    todayQuestionIndex;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        getchats();
      });
      if (tempIndex == 0) {
        // QestionAd.loadSaveAd();
        _showInterstitialAd();
        log("Done");
        tempIndex++;
      }
    });
    return Scaffold(
      backgroundColor:AppColors.solfColor,
      appBar: AppBar(
        backgroundColor:AppColors.hardColor,
        // title: const BoxAd(),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
                onTap: () async {
                  setting++;
                if(setting%3==0){
                  _showInterstitialAd();

                }else{

                }
                  settingsbottomSheet();
                  print("object");
                  // QestionAd.loadSaveAd();
                },
                child: Icon(Icons.settings,color:Colors.black,)),
          )
        ],
        title: InkWell(
          onTap: () {
            // QestionAd.loadSaveAd();
            showalertbox();
            // showalertbox();
          },
          child: Container(
            margin: EdgeInsets.only(right: 10),
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:AppColors.solfColor,
                border: Border.all(width: 0.2, color: AppColors.hardColor)),
            // width: MediaQuery.of(context).size.width ,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "remaining messages",
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                ),
                badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                      shape: badges.BadgeShape.circle,
                      badgeColor: Colors.white,
                      elevation: 10),
                  onTap: () {
                    // showalertbox();
                  },
                  badgeAnimation: badges.BadgeAnimation.rotation(
                      colorChangeAnimationCurve: Curves.easeInBack,
                      animationDuration: Duration(seconds: 1),
                      colorChangeAnimationDuration: Duration(seconds: 1),
                      disappearanceFadeAnimationDuration: Duration(seconds: 1),
                      curve: Curves.decelerate,
                      loopAnimation: true,
                      toAnimate: true),
                  badgeContent: Text("${reminatodatindex}"),
                  child: Image.asset(
                    "assets/images/prize.png",
                    height: 25,
                    filterQuality: FilterQuality.high,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
        elevation: 10,
      ),
      body: SafeArea(
        child: chat.isNotEmpty
            ? Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 120,
              child: ListView.separated(
                  shrinkWrap: true,
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    chatIndex = index;

                    if (index == chat.length) {
                      if (chat.length >= 2) {
                        // _scrollController.jumpTo(
                        //   _scrollController.position.maxScrollExtent,
                        // );
                      }
                      return const SizedBox(
                        height: 15,
                      );
                    }
                    if (!chatText.containsKey(index)) {
                      chatText
                          .addEntries({index: chat[index].text}.entries);

                      // print(chatText);
                    }
                    return InkWell(
                      onLongPress: () {
                        Clipboard.setData(
                            ClipboardData(text: chat[index].text));
                        Fluttertoast.showToast(msg: "Copied");
                      },
                      onTap: () {
                        chat[index].isDone = false;
                      },
                      child: BubbleSpecialThree(
                        text: chat[index].type == ChatType.user
                            ? chat[index].text.trim()
                            : chat[index].text.trim(),
                        color: chat[index].type == ChatType.user
                            ? const Color(0xff0d8266)
                            : const Color(0xff3c3d49),
                        tail: true,
                        delivered: true,
                        isTextAnimating:
                        chat[index].type == ChatType.bot &&
                            chat[index].isDone,
                        isSender: chat[index].type == ChatType.user
                            ? true
                            : false,
                        seen: true,
                        textStyle: const TextStyle(
                            color: Colors.white, fontSize: 16),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemCount: chat.length + 1),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                  onPressed: () {
                    _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent + 10,
                        duration: const Duration(seconds: 2),
                        curve: Curves.fastLinearToSlowEaseIn);
                  },
                  icon: const Icon(
                    Icons.arrow_downward,
                    color: Colors.black,
                  )),
            )
          ],
        )
            : Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Icon(
                  Icons.thunderstorm,
                  size: 50,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Capabilities",
                  style: TextStyle(color: Colors.black, fontSize: 19),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color:AppColors.hardColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Text(
                    'Allows user to provide follow-up corrections',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color:AppColors.hardColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Text(
                    'Trained to decline inappropriate requests',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Icon(
                  Icons.wb_sunny_outlined,
                  size: 50,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Examples",
                  style: TextStyle(color: Colors.black, fontSize: 19),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    _controller.text =
                    'Explain quantum computing in simple terms';
                  },
                  child: Container(
                    width: 250,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color:AppColors.hardColor,

                        borderRadius: BorderRadius.circular(12)),
                    child: const Text(
                      'Explain quantum computing in simple terms',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    _controller.text = widget.prompt == null
                        ? 'Got any creative ideas for a 10 year old’s birthday?'
                        : widget.prompt.toString();

                    // widget.prompt!.isEmpty?
                    // _controller.text =
                    //     'Got any creative ideas for a 10 year old’s birthday?':widget.prompt;
                  },
                  child: Container(
                    width: 250,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color:AppColors.hardColor,

                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      widget.prompt == null
                          ? 'Got any creative ideas for a 10 year old’s birthday?'
                          : widget.prompt.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Unofficial",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Form(
        key: _form,
        child: Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: TextFormField(
                    enabled: isEnabled,
                    minLines: 1,
                    maxLines: 4,
                    controller: _controller,
                    style:GoogleFonts.poppins(fontWeight:FontWeight.w500,fontSize:14,color:Colors.black),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Must not be empty';
                      }
                      return null;
                    },

                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor:AppColors.cayanColor,
                        filled: true,
                        suffix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isEnabled)
                              const SpinKitThreeBounce(
                                color:Colors.black,
                                size: 20,
                              ),
                            if (isEnabled)
                              // InkWell(
                              //   onTap: () async {
                              //     final res = await _imageAPI
                              //         .getImage(ImageSource.gallery);
                              //     setState(() {
                              //       _controller.text = res;
                              //     });
                              //   },
                              //   child: const Icon(Icons.camera_alt_outlined,
                              //       color: Colors.white),
                              // ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (isEnabled)
                              InkWell(
                                onTap: () => send(),
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.green,
                                ),
                              ),
                          ],
                        ),
                        hintStyle: GoogleFonts.poppins(fontWeight:FontWeight.w500,color:Colors.black,fontSize:14),
                        hintText: "Ask Here !",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor:AppColors.hardColor,
        child: DrawerHeader(
          child: Column(
            children: [
              DrawerItem(
                icona: Icons.messenger_sharp,
                text: "My Conversation",
                onPressed: () {
                  C.pop(context);
                  myconversation++;
                  if(myconversation%2==0){
                    _showInterstitialAd();
                  }
                  C.navTo(context, MyConversations(chats: chats));
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              DrawerItem(
                icona: Icons.save_alt,
                text: "Save Conversation",
                onPressed: () async {
                  saveconverstion++;
                  if(saveconverstion%2==0){
                    _showInterstitialAd();
                  }
                  final chatPdf = await PdfConversationExport.exportChat(chat);
                  setState(() {
                    log(chatPdf.path);
                  });
                  PdfConversationExport.openPdfFile(chatPdf);
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              DrawerItem(
                icona: Icons.delete,
                text: "Clear Conversation",
                onPressed: () async {
                  clearconversation++;
                  if(clearconversation%5==0){
                    _showInterstitialAd();
                  }
                  setState(() {
                    chat.clear();
                    chatText.clear();
                    animated.clear();
                  });
                  if (isVoiceEnabled) {
                    OpenAiAPI.tts("Stopped");
                  }
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                height: 10.0,
              ),

              DrawerItem(
                icona: Icons.auto_awesome,
                text: "Awsome Prompt",
                onPressed: () async {
                  awesomeprompt++;
                  if(awesomeprompt%2==0){
                    _showInterstitialAd();
                  }
                  C.pop(context);
                  C.navTo(context, const AwsomePrompt());
                },
              ),
              DrawerItem(
                icona: Icons.image_search,
                text: "Image Generator",
                onPressed: () async {
                  imagegeneration++;
                  if(imagegeneration%5==0){
                    _showInterstitialAd();
                  }
                  C.pop(context);
                  C.navTo(context, const ImgGen());
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              DrawerItem(
                icona: Icons.subscriptions,
                text: "Subscriptions",
                onPressed: () async {
                  subscription++;
                  if(subscription%2==0){
                    _showInterstitialAd();
                  }
                  C.pop(context);
                  C.navToDown(context, const Subscription());
                },
              ),
              DrawerItem(
                icona: Icons.settings,
                text: "Settings",
                onPressed: () async {
                  setting++;
                  if(setting%2==0){
                    // _showInterstitialAd();
                  }
                  C.pop(context);
                  settingsbottomSheet();
                },
              ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.star,
              //     color: Colors.white,
              //   ),
              //   title: const Text(
              //     'Rate The app',
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   onTap: () {
              //     launchUrl(
              //         Uri.parse(
              //             "https://play.google.com/store/apps/details?id=com.amaa.chatgpt"),
              //         mode: LaunchMode.externalApplication);
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void send() async {
    if (todayQuestionIndex < 5) {
      if (_form.currentState!.validate()) {
        allPrompt = "";
        chat.add(ChatInput(
          text: _controller.text,
          type: ChatType.user,
        ));
        chatText.forEach((key, value) {
          allPrompt += "${widget.prompt} \n\n $value";
        });

        setState(() {
          isEnabled = false;
        });
        final String botResponse = await openAiAPI
            .generateResponse("$allPrompt \n\n ${_controller.text}");

        if (isVoiceEnabled) {
          OpenAiAPI.tts(botResponse);
        }
        chat.add(
            ChatInput(text: botResponse, type: ChatType.bot, isDone: true));
        setState(() {
          isEnabled = true;
        });

        _controller.clear();
        if (openAiAPI.totalTokens > 150) {
         _showInterstitialAd();
          tempIndex = 0;
        }
        setState(() {
          if (chat.length > 2) {
            if (chat[chatIndex].type == ChatType.bot) {
              chat[chatIndex - 2].isDone = false;
            }
          }
        });

        todayQuestionIndex++;
        if(todayQuestionIndex%8==0){
          _showInterstitialAd();
        }
        reminatodatindex--;
        CacheHelper.saveData(
            key: CacheKeys.numberOfQestions, value: todayQuestionIndex);
        CacheHelper.saveData(
            key: CacheKeys.remainquestion, value: reminatodatindex);
      }
    } else {
      showalertbox();
    }
  }

  void showalertbox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [InkWell(
              onTap:(){
                // QestionAd.loadSaveAd();
                Get.back();
              },
              child:Icon(Icons.cancel,color:Colors.black,),
            )],
          ),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: AppColors.cayanColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Get messages",
                style: GoogleFonts.inter(
                    fontSize:25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "You've run out of chat . Let's watch one video ad to earn 6 more messages",
                style: GoogleFonts.poppins(
                  fontSize:20,
                  fontWeight: FontWeight.w500,
                  color:AppColors.solfColor,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          actions: <Widget>[
            InkWell(
                onTap: () {
                  Get.to(Subscription());
                },
                child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.150,
                    decoration: BoxDecoration(
                      color: AppColors.hardColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.hardColor,
                          // blurRadius: 15.0, // soften the shadow
                          spreadRadius: 4.0, //extend the shadow
                          offset: Offset(
                            0.0,
                            2.0, // Move to bottom 5 Vertically
                          ),
                        )
                      ],
                      gradient: LinearGradient(colors: [
                        AppColors.solfColor,
                        AppColors.solfColor,
                      ]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Get Unlimited Chat",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontStyle: FontStyle.italic),
                      ),
                    ))),
            SizedBox(
              height: 40,
            ),
            InkWell(
                onTap: () async {
                  _showInterstitialAd();

                  todayQuestionIndex = 0;
                  reminatodatindex = 5;
                  CacheHelper.saveData(
                      key: CacheKeys.numberOfQestions, value: 0);
                  CacheHelper.saveData(key: CacheKeys.remainquestion, value: 5);
                  Get.back();
                },
                child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.150,
                    decoration: BoxDecoration(
                      color: AppColors.hardColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.hardColor,
                          // blurRadius: 15.0, // soften the shadow
                          spreadRadius: 4.0, //extend the shadow
                          offset: Offset(
                            0.0,
                            2.0, // Move to bottom 5 Vertically
                          ),
                        )
                      ],
                      gradient: LinearGradient(colors: [
                        AppColors.solfColor,
                        AppColors.solfColor,
                      ]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Watch Ads",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ))),
            SizedBox(
              height: 40,
            ),
          ],
        );
      },
    );
  }

  settingsbottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.hardColor,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: SettingsList(
            physics: const NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
            // platform: DevicePlatform.iOS,
            lightTheme: const SettingsThemeData(
                titleTextColor: Colors.white,
                settingsListBackground: AppColors.hardColor,
                settingsSectionBackground: AppColors.solfColor
            ),
            sections: [

              SettingsSection(
                title: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          C.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios)),
                    Text(
                      'Settings'.toUpperCase(),
                      style: GoogleFonts.poppins(fontWeight:FontWeight.w700,color:Colors.black)
                    ),
                  ],
                ),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(
                      Icons.subscriptions_outlined,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Plan',
                      style: AppStyle.normal(),
                    ),
                    value: Text(
                      'Free 5 Questions',
                      style: AppStyle.normal(),
                    ),
                    onPressed: (context) {
                      C.pop(context);
                      C.navToDown(context, const Subscription());
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(
                      Icons.language,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Language',
                      style: AppStyle.normal(),
                    ),
                    value: Text(
                      'English',
                      style: AppStyle.normal(),
                    ),
                    onPressed: (context) {
                      C.toast(msg: "Multi-Language Soon");
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(
                      Icons.delete_outline_outlined,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Clear Conversation',
                      style: AppStyle.normal(),
                    ),
                    // value: const Text('English'),
                    onPressed: (context) {
                      chat.clear();
                      allPrompt = '';
                      chats.clear();
                      chatText.clear();
                      animated.clear();
                      C.pop(context);
                    },
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) {
                      isVoiceEnabled = value;

                      C.pop(context);
                    },
                    initialValue: isVoiceEnabled,
                    leading: const Icon(
                      Robot.robot,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Bot Voice',
                      style: AppStyle.normal(),
                    ),
                  ),
                ],
              ),
              SettingsSection(
                tiles: [
                  SettingsTile.navigation(
                    leading: const Icon(Icons.lock_open, color: Colors.black),
                    title: Text(
                      'Privacy Policy',
                      style: AppStyle.normal(),
                    ),
                    onPressed: (context) async {
                      final url = Uri.parse(
                          "https://sites.google.com/view/censorai/%D8%A7%D9%84%D8%B5%D9%81%D8%AD%D8%A9-%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9");
                      if (!await launchUrl(
                        url,
                      )) {
                        throw Exception('Could not launch $url');
                      }
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(
                      Icons.help_outline,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Help',
                      style: AppStyle.normal(),
                    ),
                    onPressed: (context) async {
                      final url = Uri.parse(
                          "https://sites.google.com/view/censorai/%D8%A7%D9%84%D8%B5%D9%81%D8%AD%D8%A9-%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9");
                      if (!await launchUrl(
                        url,
                      )) {
                        throw Exception('Could not launch $url');
                      }
                    },
                  ),
                ],
                title: Text(
                  'Support'.toUpperCase(),
                                style:GoogleFonts.poppins(fontWeight:FontWeight.w400,fontSize:20,color:Colors.black,letterSpacing:2),

                ),
              ),
              SettingsSection(
                tiles: [
                  SettingsTile.navigation(
                    leading: const Icon(
                      Icons.info_outline,
                      color: Colors.black,
                    ),
                    title: Text(
                      'About us',
                      style: AppStyle.normal(),
                    ),
                    onPressed: (context) async {
                      final url = Uri.parse(
                          "https://sites.google.com/view/censorai/%D8%A7%D9%84%D8%B5%D9%81%D8%AD%D8%A9-%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9");
                      if (!await launchUrl(
                        url,
                      )) {
                        throw Exception('Could not launch $url');
                      }
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(
                      Icons.star_border,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Rate Us',
                      style: AppStyle.normal(),
                    ),
                    onPressed: (context) async {
                      if (Platform.isAndroid) {
                        final url = Uri.parse(
                            "https://play.google.com/store/apps/details?id=com.chat.botAi");
                        if (!await launchUrl(url,
                            mode: LaunchMode.externalApplication)) {
                          throw Exception('Could not launch $url');
                        }
                      } else {
                        final url = Uri.parse(
                            "https://apps.apple.com/us/app/telegram-messenger/id686449807");
                        if (!await launchUrl(url,
                            mode: LaunchMode.externalApplication)) {
                          throw Exception('Could not launch $url');
                        }
                      }
                    },
                  ),
                ],
                title: Text(
                  'about'.toUpperCase(),
                  style:GoogleFonts.poppins(fontWeight:FontWeight.w400,fontSize:20,color:Colors.black,letterSpacing:2),
                ),
              ),

            ],
          ),
        );
      },
    );
  }
}
