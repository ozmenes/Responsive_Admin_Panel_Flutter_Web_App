import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_web_app/utils/components/chart.dart';
import 'package:responsive_admin_panel_web_app/utils/components/storage_info_card.dart';
import 'package:responsive_admin_panel_web_app/utils/shared/constants.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Storage Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Chart(),
          SizedBox(
            height: defaultPadding,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/Documents.svg",
            title: "Documents Files",
            amountOfFiles: "15.2Gb",
            numOfFiles: 1328,
          ),
          SizedBox(
            height: defaultPadding,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/media.svg",
            title: "Media Files",
            amountOfFiles: "15.3Gb",
            numOfFiles: 1328,
          ),
          SizedBox(
            height: defaultPadding,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/folder.svg",
            title: "Other Files",
            amountOfFiles: "1.8Gb",
            numOfFiles: 1328,
          ),
          SizedBox(
            height: defaultPadding,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/unknown.svg",
            title: "Unknown Files",
            amountOfFiles: "8.2Gb",
            numOfFiles: 140,
          ), //components
        ],
      ),
    );
  }
}
