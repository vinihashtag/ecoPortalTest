import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/custom_cache_manager.dart';

class CustomImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Widget? customPlaceHolder;
  final int? sizeLocalImage;

  const CustomImageWidget({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
    this.customPlaceHolder,
    this.sizeLocalImage,
  });

  @override
  Widget build(BuildContext context) {
    // * PlaceHolder default
    final Widget placeHolderDefault = customPlaceHolder ??
        Container(
          color: Colors.grey.shade100,
          alignment: Alignment.center,
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                size: 45,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Invalid image',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );

    if (imageUrl.trim().isEmpty) return placeHolderDefault;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      cacheManager: CustomCacheManager.instance,
      errorWidget: (_, child, __) => placeHolderDefault,
      placeholder: (_, __) => Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4),
        child: const CupertinoActivityIndicator(),
      ),
    );
  }
}
