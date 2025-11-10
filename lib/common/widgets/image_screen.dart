import 'dart:io';
import 'package:ashil_school/Utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({
    super.key,
    required this.image,
     this.name="",
    this.isedit = false,
  });

  final File image;
  final String name;
  final bool isedit;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: const TextStyle(color: Colors.white)),
        backgroundColor: KColors.primary,
        actions: isedit
            ? [
                IconButton(
                  onPressed: () {
                    // إجراء تعديل
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    // إجراء مشاركة
                  },
                  icon: const Icon(Icons.share, color: Colors.white),
                ),
              ]
            : [],
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // السماح بتحريك الصورة
          scaleEnabled: true, // السماح بالتكبير والتصغير
          minScale: 1.0, // الحد الأدنى للتصغير
          maxScale: 5.0, // الحد الأقصى للتكبير
          child: Container(
            width: screenSize.width,
            height: screenSize.height,
            alignment: Alignment.center,
            child: Image.file(
              image,
              fit: BoxFit.cover, // عرض الصورة بحيث تملأ الشاشة
            ),
          ),
        ),
      ),
    );
  }
}
