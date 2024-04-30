import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../footage.dart';

class ThumbnailWidget extends StatelessWidget {
  final Footage footage;
  final double width;
  final double height;

  const ThumbnailWidget({
    super.key,
    required this.footage,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: footage.thumbFile != null
                ? Image.file(
                    footage.thumbFile!,
                    // width: width,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    'assets/images/resource_not_found.jpeg',
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: width,
            child: Text(
              footage.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ]);
  }
}
