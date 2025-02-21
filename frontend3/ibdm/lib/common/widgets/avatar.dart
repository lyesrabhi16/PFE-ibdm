import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.user,
    this.size,
    this.fit,
    this.backgroundColor,
  });
  final User user;
  final Size? size;
  final BoxFit? fit;
  final Color? backgroundColor;

  Size get _size => size ?? Size(AppSizes.xl * 2, AppSizes.xl * 5);
  BoxFit get _fit => fit ?? BoxFit.cover;
  Color get _backgroundColor =>
      backgroundColor ?? AppColors.getRoleColorWithRoleValue(user.role);
  Widget get _placeHolderAvatar => ShadAvatar(
        Icons.person_sharp,
        size: _size,
        fit: _fit,
        backgroundColor: _backgroundColor,
      );
  @override
  Widget build(BuildContext context) {
    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: user.avatarUrl!,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => _placeHolderAvatar,
        imageBuilder: (context, imageProvider) => Center(
          child: Container(
            clipBehavior: Clip.antiAlias,
            height: _size.width * 2,
            width: _size.width * 2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: _fit,
              ),
              border: Border.all(
                color: _backgroundColor,
                width: 3,
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    return _placeHolderAvatar;
  }
}
