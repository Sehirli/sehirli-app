import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:sehirli/models/event.dart';
import 'package:sehirli/utils/database.dart';
import 'package:sehirli/widgets/event_page/comments_column.dart';
import 'package:sehirli/widgets/event_page/event_page_map.dart';
import 'package:sehirli/widgets/event_page/report_button.dart';

import '../../widgets/event_page/comment_button.dart';

class EventPage extends StatefulWidget {
  final Event event;

  const EventPage({super.key, required this.event});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  BannerAd? _bannerAd;
  late List comments;

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: Platform.isIOS
          ? "ca-app-pub-8378554191917930/8905703759"
          : "ca-app-pub-8378554191917930/9429513590",
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

  @override
  void initState() {
    super.initState();
    loadAd();
    comments = widget.event.comments;
  }

  @override
  Widget build(BuildContext context) {
    LatLng point = LatLng(widget.event.geoPoint.latitude, widget.event.geoPoint.longitude);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.event.title, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white, size: 30),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventPageMap(point: point),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat("dd.MM.yyyy HH:mm").format(widget.event.timestamp.toDate()),
                          style: const TextStyle(fontSize: 20),
                        ),
                        Row(
                          children: [
                            ReportButton(eventId: widget.event.id),
                            CommentButton(
                              eventId: widget.event.id,
                              comments: comments,
                              callback: () => setState(() {})
                            )
                          ],
                        )
                      ],
                    ),
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
                    const Divider(),
                    Text(widget.event.description, style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FutureBuilder(
                        future: Database().getComments(widget.event.id),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CupertinoActivityIndicator());
                          }

                          return CommentsColumn(
                            event: widget.event,
                            comments: snapshot.data,
                            callback: updateComments,
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateComments() async {
    comments = await Database().getComments(widget.event.id);
    setState(() {});
  }
}
