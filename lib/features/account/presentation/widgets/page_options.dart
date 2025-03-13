// ignore_for_file: deprecated_member_use

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:restart_tagxi/common/app_constants.dart';
import 'package:restart_tagxi/core/utils/custom_navigation_icon.dart';

import '../../../../core/utils/custom_text.dart';

// Account Page Navigation Widget
class PageOptions extends StatelessWidget {
  final String optionName;
  final Function()? onTap;
  final Color? color;
  final Icon? icon;
  final Widget? child;

  const PageOptions({
    super.key,
    required this.optionName,
    this.onTap,
    this.color,
    this.icon,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (onTap != null) {
                onTap!();
              }
            });
          },
          highlightColor: Theme.of(context).disabledColor.withOpacity(0.1),
          splashColor: Theme.of(context).disabledColor.withOpacity(0.2),
          hoverColor: Theme.of(context).disabledColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4, top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if(icon != null) ...[NavigationIconWidget(icon: icon!,)],
                      MyText(
                        text: optionName,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                                color: Theme.of(context).disabledColor,
                                fontWeight: FontWeight.bold,
                                fontSize: AppConstants().subHeaderSize),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: child,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Theme.of(context).disabledColor,
                ),
              ],
            ),
          ),
        ),
        DottedLine( // ADDED: BY MG: Dotted line
                         dashLength: 2,
                          dashGapLength: 2,
                          dashRadius: 1,
                          lineThickness: 1,
                          dashColor: Theme.of(context).dividerColor,
                        ),
      ],
    );
  }
}
