import 'package:flutter/material.dart';


class SettingItem extends StatelessWidget {

  final String title;

  final String? subtitle;

  final Widget? trailing;

  final VoidCallback? onTap;

  const SettingItem({

    super.key,

    required this.title,

    this.subtitle,

    this.trailing,

    this.onTap,

  });

  @override
  Widget build(
    BuildContext context
  ) {

    return ListTile(

      title: Text(title),

      subtitle: subtitle != null ? Text(subtitle!) : null,

      trailing: trailing,

      onTap: onTap,

    );

  }

}
