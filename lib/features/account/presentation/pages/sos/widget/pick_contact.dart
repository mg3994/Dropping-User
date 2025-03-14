import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../application/acc_bloc.dart';

class PickContact extends StatelessWidget {
  const PickContact({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<AccBloc, AccState>(
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Scaffold(
              body: Container(
                margin: EdgeInsets.all(8),
                // width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.width * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                                text: AppLocalizations.of(context)!.selectContact,
                                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: MyText(
                                  text: AppLocalizations.of(context)!.cancel,
                                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                          DottedLine( // ADDED: BY MG: Dotted line
                                dashLength: 2,
                                dashGapLength: 2,
                                dashRadius: 1,
                                lineThickness: 1,
                                dashColor: Theme.of(context).dividerColor,
                              ),
                        SizedBox(height: size.width * 0.03),
                        SizedBox(
                          height: size.height * 0.73,
                          child: RawScrollbar(
                            child: ListView.builder(
                              itemCount:
                                  context.read<AccBloc>().contactsList.length,
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 16),
                              itemBuilder: (context, index) {
                                final contact = context
                                    .read<AccBloc>()
                                    .contactsList
                                    .elementAt(index);
                                return Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor:
                                        Theme.of(context).primaryColorDark,
                                  ),
                                  child: RadioListTile(
                                    value: contact,
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    activeColor: Theme.of(context).primaryColorDark,
                                    groupValue:
                                        context.read<AccBloc>().selectedContact,
                                    onChanged: (value) {
                                      context.read<AccBloc>().selectedContact =
                                          contact;
                                      context.read<AccBloc>().add(AccUpdateEvent());
                                    },
                                    title: MyText(
                                      text: contact.name,
                                      maxLines: 2,
                                      textStyle:
                                          Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    subtitle:
                                        MyText(
                                      text: contact.number,
                                      maxLines: 1,
                                      textStyle:
                                          Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: size.width * 0.03),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                                                  margin: const EdgeInsets.symmetric(horizontal:10.0),

                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 0),
                        spreadRadius: 2,
                        blurRadius: 2,
                        color: Theme.of(context).shadowColor,
                      )
                    ]),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: size.width * 0.03),
                      CustomButton(
                        width: size.width,
                        buttonColor: Theme.of(context).primaryColor,
                        buttonName: AppLocalizations.of(context)!.confirm,
                        onTap: () {
                          context.read<AccBloc>().add(AddContactEvent(
                                name: context.read<AccBloc>().selectedContact.name,
                                number: context.read<AccBloc>().selectedContact.number,
                              ));
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(height: size.width * 0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}