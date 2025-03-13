import 'package:flutter/material.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';

class EditOptions extends StatelessWidget {
  final String text;
  final String header;
  final Function()? onTap;
  final Icon? icon;

  const EditOptions(
      {super.key,
      required this.text,
      required this.header,
      required this.onTap,
      this.icon});

  @override
  Widget build(BuildContext context) {
    final bool showEditIcon = header == AppLocalizations.of(context)!.name ||
        header == AppLocalizations.of(context)!.gender ||
        header == AppLocalizations.of(context)!.emailAddress;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: header,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 4,),
              Container(
             
                width: double.infinity, // Ensures full width
                height: 40,
                                                          
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            // Theme.of(context)
                                            //     .scaffoldBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .disabledColor
                                                  .withOpacity(0.5),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context)
                                                    .shadowColor
                                                    .withOpacity(0.1),
                                                blurRadius: 15,
                                                offset: const Offset(0, 1),
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 12,),
                  
                    
                    MyText(
                      text: text,
                      textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).disabledColor, fontSize: 16),
                    ),
                    Spacer(),
                    (showEditIcon)
                  ? Align(

                    child: InkWell(
                        onTap: onTap,
                        highlightColor:
                            Theme.of(context).disabledColor.withOpacity(0.1),
                        splashColor:
                            Theme.of(context).disabledColor.withOpacity(0.2),
                        hoverColor:
                            Theme.of(context).disabledColor.withOpacity(0.05),
                        child: Icon(
                          Icons.edit,
                          size: 15,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                  )
                  : const SizedBox()
                  ],
                ),
              ),
              
            ],
          ),
        ),
        // const SizedBox(
        //   height: 5,
        // ),
        // const Divider(
        //   height: 1,
        //   color: Color(0xFFD9D9D9),
        // ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
