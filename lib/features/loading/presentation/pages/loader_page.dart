import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restart_tagxi/core/utils/custom_button.dart' show CustomButton;
import 'package:restart_tagxi/core/utils/custom_text.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import '../../../../common/common.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../landing/presentation/page/landing_page.dart';
import '../../../../app/localization.dart';
import '../../../language/presentation/page/choose_language_page.dart';
import '../../application/loader_bloc.dart';
import 'package:dotted_line/dotted_line.dart'; // Add this package // ADDED: BY MG: Dotted line

class LoaderPage extends StatefulWidget {
  static const String routeName = '/loaderPage';

  const LoaderPage({super.key});

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => LoaderBloc()
        ..add(
            CheckPermissionEvent()), //ADDED BY MG: ..add(LoaderGetLocalDataEvent())
      child: BlocListener<LoaderBloc, LoaderState>(
        listener: (context, state) {
          if (state is LoaderLocationSuccessState) {
            //ADDED: BY MG:
            context.read<LoaderBloc>().add(LoaderGetLocalDataEvent());
          } else if(state is LoaderUpdateState){
            context.read<LoaderBloc>().add(LoaderGetLocalDataEvent());

          }
          if (state is LoaderSuccessState) {
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) {
                Future.delayed(const Duration(seconds: 2), () {
                  if (state.selectedLanguage.isNotEmpty) {
                    if (!context.mounted) return;
                    context.read<LocalizationBloc>().add(
                        LocalizationInitialEvent(
                            isDark:
                                Theme.of(context).brightness == Brightness.dark,
                            locale: Locale(state.selectedLanguage)));
                    if (!state.loginStatus) {
                      if (!state.landingStatus) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, LandingPage.routeName, (route) => false);
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                            context, AuthPage.routeName, (route) => false);
                      }
                    } else {
                      context.read<LoaderBloc>().add(UpdateUserLocationEvent());
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomePage.routeName, (route) => false);
                    }
                  } else {
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      ChooseLanguagePage.routeName,
                      (route) => false,
                      arguments: ChooseLanguageArguments(
                          isInitialLanguageChange: true),
                    );
                  }
                });
              },
            );
          }
        },
        // child: BlocBuilder<LoaderBloc, LoaderState>(
        //   builder: (context, state) {
        //     return PopScope(
        //     canPop: false,
        //     child :Scaffold(
        //       backgroundColor: Theme.of(context).primaryColor,
        //       resizeToAvoidBottomInset: false,
        //       body: Center(
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Image.asset(
        //               AppImages.loader,
        //               width: size.width * 0.51,
        //               height: size.height * 0.51,
        //             )
        //           ],
        //         ),
        //       ),
        //     ));
        //   },
        // ),
        child: BlocBuilder<LoaderBloc, LoaderState>(
          builder: (context, state) {
            return PopScope(
              canPop: false,
              child: Scaffold(
                backgroundColor:
                    (context.read<LoaderBloc>().locationApproved == null ||
                            context.read<LoaderBloc>().locationApproved == true)
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Theme.of(context).scaffoldBackgroundColor,
                resizeToAvoidBottomInset: false,
                body: Center(
                  child: (context.read<LoaderBloc>().locationApproved == false ||
                          context.read<LoaderBloc>().locationApproved == true)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.loader,
                              width: size.width * 0.51,
                              height: size.height * 0.51,
                            )
                          ],
                        )
                      : (context.read<LoaderBloc>().locationApproved == null)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.locationImage,
                                  width: size.width * 0.9,
                                  height: size.width * 0.9,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: size.width * 0.02),
                                SizedBox(
                                  width: size.width * 0.9,
                                  child: Column(
                                    spacing: 4,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MyText(
                                        text: AppLocalizations.of(context)!
                                            .welcomeToName
                                            .toString()
                                            .replaceAll(
                                                '1111', AppConstants.title),
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                      DottedLine(
                                        // ADDED: BY MG: Dotted line
                                        dashLength: 2,
                                        dashGapLength: 2,
                                        dashRadius: 1,
                                        lineThickness: 1,
                                        dashColor:
                                            Theme.of(context).dividerColor,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: size.width * 0.05),
                                SizedBox(
                                  width: size.width * 0.9,
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .locationPermDesc,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: const Color(0xff847979),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(height: size.width * 0.05),
                                SizedBox(
                                    width: size.width * 0.9,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          AppImages.allowLocationIcon,
                                          width: size.width * 0.05,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(width: size.width * 0.025),
                                        MyText(
                                          text: AppLocalizations.of(context)!
                                              .allowLocation,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: AppColors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                                SizedBox(height: size.width * 0.1),
                                CustomButton(
                                    borderRadius: 2,
                                    buttonName:
                                        AppLocalizations.of(context)!.allow,
                                    onTap: () async {
                                      await Permission.location.request();
                                      await Permission.locationAlways
                                          .request()
                                          .whenComplete(
                                        () async {
                                          context
                                              .read<LoaderBloc>()
                                              .add(LoaderGetLocalDataEvent());
                                        },
                                      );
                                    })
                              ],
                            )
                          : Container(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
