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
      create: (context) => LoaderBloc()..add(LoaderGetLocalDataEvent())..add(CheckPermissionEvent()),//ADDED BY MG:
      child: BlocListener<LoaderBloc, LoaderState>(
        listener: (context, state) {
           if(state is LoaderLocationSuccessState){ //ADDED: BY MG:
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
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).scaffoldBackgroundColor,
                resizeToAvoidBottomInset: false,
                body: Center(
                  child: (context.read<LoaderBloc>().locationApproved == null ||
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
                      : (context.read<LoaderBloc>().locationApproved == false)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.locationImage,
                                  width: size.width * 0.9,
                                  height: size.width * 0.9,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: size.width * 0.05),
                                SizedBox(
                                  width: size.width * 0.9,
                                  child: MyText(
                                    text:"Welcome TO 1111"
                                    //  AppLocalizations.of(context)!
                                    //     .welcomeToName
                                    //     .toString()
                                        .replaceAll('1111', AppConstants.title),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: size.width * 0.05),
                                SizedBox(
                                  width: size.width * 0.9,
                                  child: MyText(
                                    text: AppLocalizations.of(context)!.locationAccess,
                                        // .locationPermDesc,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: const Color(0xff847979),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                    maxLines: 5,
                                  ),
                                ),
                                SizedBox(height: size.width * 0.05),
                                SizedBox(
                                    width: size.width * 0.9,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Image.asset(
                                        //   AppImages.allowLocationIcon,
                                        //   width: size.width * 0.05,
                                        //   fit: BoxFit.contain,
                                        // ),
                                        SizedBox(width: size.width * 0.025),
                                        MyText(
                                          text: "Allow Location",
                                          // AppLocalizations.of(context)!
                                          //     .allowLocation,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: AppColors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                                SizedBox(height: size.width * 0.1),
                                CustomButton(
                                    buttonName:"Allow",
                                        // AppLocalizations.of(context)!.allow,
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
