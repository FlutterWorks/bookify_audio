// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookifyAds extends StatelessWidget {
  const BookifyAds({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        const String playStoreUrl =
            'https://play.google.com/store/apps/details?id=com.kbeauty.bangladesh&hl=en_US';

        final Uri playStoreAppUrl = Uri.parse(playStoreUrl);
        final Uri webUrl = Uri.parse(playStoreUrl);

        if (await canLaunch(playStoreAppUrl.toString())) {
          await launch(playStoreAppUrl.toString());
        } else {
          await launch(webUrl.toString());
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.grey[800],
        ),
        height: 60,
        width: MediaQuery.of(context).size.width * 1,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  Image.network(
                    "https://i.postimg.cc/vB37vkP1/gora.jpg",
                    height: 50,
                  ),
                  const SizedBox(width: 15),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rosa Cosmatic Shop",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Cosmatic , Female Cosmatic",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 40,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: Text("Install"),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
