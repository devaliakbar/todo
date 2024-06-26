import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String? imageUrl;
  const CachedImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    const Widget errorWidget = Icon(Icons.error);

    return (imageUrl ?? "").isEmpty
        ? errorWidget
        : CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => errorWidget,
          );
  }
}
