import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'package:sehirli/models/event_type.dart';
import 'package:sehirli/utils/database.dart';
import 'package:sehirli/widgets/add_page/event_type_selector.dart';
import 'package:sehirli/widgets/add_page/location_selector.dart';
import 'package:sehirli/widgets/add_page/photo_selector.dart';
import 'package:sehirli/widgets/custom_button.dart';
import 'package:sehirli/widgets/custom_textfield.dart';
import 'package:sehirli/models/event.dart';
import 'package:sehirli/utils/image_selector.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final Database db = Database();
  final ImageSelector imageSelector = ImageSelector();
  final storageRef = FirebaseStorage.instance.ref();

  final eventTypeSelectorKey = GlobalKey<EventTypeSelectorState>();

  String address = "";
  bool addressSelected = false;
  GeoPoint? geoPoint;
  BannerAd? _bannerAd;
  List<XFile> imagesList = [];
  late String id;

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: Platform.isIOS
          ? "ca-app-pub-8378554191917930/9097275444"
          : "ca-app-pub-8378554191917930/5306699087",
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, err) {
          debugPrint("BannerAd failed to load: $err");
          ad.dispose();
        },
      )
    )..load();
  }

  void generateId() {
    id = const Uuid().v1();
  }

  @override
  void initState() {
    super.initState();

    loadAd();
    generateId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Ekle", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white, size: 30),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 10),
                  const Text("Başlık", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
                  CustomTextField(
                    controller: titleController,
                    hintText: "Neler oluyor?",
                    maxLength: 30,
                  ),
                  const Text("Açıklama", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
                  CustomTextField(
                      controller: descriptionController,
                      hintText: "Biraz daha detay verebilir misin?",
                      maxLines: null
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();

                        Get.to(() => LocationSelector(
                          onPicked: (pickedData) {
                            Navigator.pop(context);

                            setState(() {
                              addressSelected = true;
                              address = pickedData.address;
                              geoPoint = GeoPoint(
                                pickedData.latLong.latitude,
                                pickedData.latLong.longitude
                              );
                            });
                          }
                        ));
                      },
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      text: "Konum Seç",
                    )
                  ),
                  Text(addressSelected ? address : "Herhangi bir konum seçili değil!"),
                  const SizedBox(height: 10),
                  EventTypeSelector(key: eventTypeSelectorKey),
                  const SizedBox(height: 10),
                  PhotoSelector(onPressed: onPhotoSelectorPressed),
                  const SizedBox(height: 5),
                  buildImagesView(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: SizedBox(
                      height: _bannerAd!.size.height.toDouble(),
                      width: _bannerAd!.size.width.toDouble(),
                      child: AdWidget(
                        ad: _bannerAd!
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: addButtonPressed,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              text: "Ekle",
            ),
          ),
        ),
      ),
    );
  }

  // FUNCTIONS

  void onPhotoSelectorPressed() async {
    HapticFeedback.lightImpact();

    try {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Container(
              color: Colors.black.withOpacity(.5),
              child: const Center(child: CircularProgressIndicator())
            );
          },
        );
      }

      List<XFile>? images = await imageSelector.pickMultiple();

      if (images.length > 5) {
        if (context.mounted) {
          Navigator.pop(context);
        }

        Get.snackbar(
          "Hata!",
          "Maksimum 5 tane fotoğraf yükleyebilirsin!",
          colorText: Colors.white,
          icon: const Icon(Icons.warning_amber, color: Colors.red),
          shouldIconPulse: false
        );
        return;
      }

      if (images.isNotEmpty) {
        imagesList = [];
        imagesList.addAll(images);

        if (context.mounted) {
          Navigator.pop(context);
        }

        Get.snackbar(
          "Başarılı!",
          "${images.length} tane fotoğraf yüklendi!",
          colorText: Colors.white,
          icon: const Icon(Icons.verified_outlined, color: Colors.green),
          shouldIconPulse: false
        );

        setState(() {});
      } else {
        if (context.mounted) {
          Navigator.pop(context);
        }

        return;
      }
    } catch (exception) {
      Get.snackbar(
        "Hata!",
        "Fotoğraf(lar) yüklenemedi!",
        colorText: Colors.white,
        icon: const Icon(Icons.warning_amber, color: Colors.red),
        shouldIconPulse: false
      );

      debugPrint(exception.toString());

      Navigator.pop(context);
    }
  }

  void uploadImages(String eventId) async {
    if (imagesList.isNotEmpty) {
      for (var image in imagesList) {
        Reference imageRef = storageRef.child("/events/$eventId/${image.name}");
        await imageRef.putFile(File(image.path));
      }
    } else {
      return;
    }
  }

  void addButtonPressed() async {
    HapticFeedback.lightImpact();

    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar(
        "Hata!",
        "Lütfen bir boş bir alan bırakma!",
        colorText: Colors.white,
        icon: const Icon(Icons.warning_amber, color: Colors.red),
        shouldIconPulse: false
      );
    } else if (geoPoint == null) {
      Get.snackbar(
        "Hata!",
        "Lütfen bir konum seç!",
        colorText: Colors.white,
        icon: const Icon(Icons.warning_amber, color: Colors.red),
        shouldIconPulse: false
      );
    } else {
      try {
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Container(
                color: Colors.black.withOpacity(.5),
                child: const Center(child: CircularProgressIndicator())
              );
            },
          );
        }

        await db.addEvent(Event(
          id: id,
          title: titleController.text,
          description: descriptionController.text,
          addedBy: FirebaseAuth.instance.currentUser!.phoneNumber!,
          eventType: eventTypeSelectorKey.currentState!.eventType?.event ?? EventType.other.event,
          timestamp: Timestamp.now(),
          geoPoint: geoPoint!,
          comments: []
        ));

        uploadImages(id);

        Get.snackbar(
          "Başarılı!",
          "Olay eklendi. Raporun için teşekkür ederiz.",
          colorText: Colors.white,
          icon: const Icon(Icons.verified_outlined, color: Colors.green),
          shouldIconPulse: false
        );

        if (context.mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } catch (_) {
        Get.snackbar(
          "Hata!",
          "Bir hata oluştu! Lütfen daha sonra tekrar dene.",
          colorText: Colors.white,
          icon: const Icon(Icons.warning_amber, color: Colors.red),
          shouldIconPulse: false
        );

        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  Widget buildImagesView() {
    if (imagesList.isEmpty) {
      return const Text("Seçili fotoğraf yok!");
    } else {
      return SizedBox(
        height: 150,
        child: ListView.builder(
          itemCount: imagesList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Image.file(File(imagesList[index].path)),
            );
          }
        ),
      );
    }
  }
}
