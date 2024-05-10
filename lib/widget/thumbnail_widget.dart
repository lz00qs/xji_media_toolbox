import 'package:flutter/material.dart';

import '../footage.dart';

class ThumbnailWidget extends StatelessWidget {
  final Footage footage;
  final double width;
  final double height;
  final bool isSelected;
  final FocusNode focusNode;

  const ThumbnailWidget({
    super.key,
    required this.footage,
    required this.width,
    required this.height,
    required this.isSelected,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? Colors.grey : Colors.transparent,
      child: Focus(
        focusNode: focusNode,
        child: Flex(
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
                child: Text(footage.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? Colors.purple : Colors.black)),
              ),
            ]),
      ),
    );
  }
}
