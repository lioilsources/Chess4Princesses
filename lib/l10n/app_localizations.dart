import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In cs, this message translates to:
  /// **'Šachové království'**
  String get appTitle;

  /// No description provided for @mapTitle.
  ///
  /// In cs, this message translates to:
  /// **'Království'**
  String get mapTitle;

  /// No description provided for @comingSoon.
  ///
  /// In cs, this message translates to:
  /// **'Brzy'**
  String get comingSoon;

  /// No description provided for @locked.
  ///
  /// In cs, this message translates to:
  /// **'Zamčeno'**
  String get locked;

  /// No description provided for @start.
  ///
  /// In cs, this message translates to:
  /// **'Hrát!'**
  String get start;

  /// No description provided for @again.
  ///
  /// In cs, this message translates to:
  /// **'Znovu'**
  String get again;

  /// No description provided for @next.
  ///
  /// In cs, this message translates to:
  /// **'Dál'**
  String get next;

  /// No description provided for @back.
  ///
  /// In cs, this message translates to:
  /// **'Zpět'**
  String get back;

  /// No description provided for @yes.
  ///
  /// In cs, this message translates to:
  /// **'Ano'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In cs, this message translates to:
  /// **'Ne'**
  String get no;

  /// No description provided for @wellDone.
  ///
  /// In cs, this message translates to:
  /// **'Výborně!'**
  String get wellDone;

  /// No description provided for @lessonDone.
  ///
  /// In cs, this message translates to:
  /// **'Lekce hotová!'**
  String get lessonDone;

  /// No description provided for @taskWon.
  ///
  /// In cs, this message translates to:
  /// **'Hurá!'**
  String get taskWon;

  /// No description provided for @tryAgain.
  ///
  /// In cs, this message translates to:
  /// **'Zkusíme to znovu!'**
  String get tryAgain;

  /// No description provided for @botWon.
  ///
  /// In cs, this message translates to:
  /// **'Robůtek vyhrál. Hrajeme znovu!'**
  String get botWon;

  /// No description provided for @promoted.
  ///
  /// In cs, this message translates to:
  /// **'Proměna v princeznu!'**
  String get promoted;

  /// No description provided for @lavaWarning.
  ///
  /// In cs, this message translates to:
  /// **'Au, láva!'**
  String get lavaWarning;

  /// No description provided for @tapTarget.
  ///
  /// In cs, this message translates to:
  /// **'Klepni na: {target}'**
  String tapTarget(String target);

  /// No description provided for @street.
  ///
  /// In cs, this message translates to:
  /// **'ulici {name}'**
  String street(String name);

  /// No description provided for @house.
  ///
  /// In cs, this message translates to:
  /// **'řadu {name}'**
  String house(String name);

  /// No description provided for @room.
  ///
  /// In cs, this message translates to:
  /// **'komnatu {name}'**
  String room(String name);

  /// No description provided for @dragHint.
  ///
  /// In cs, this message translates to:
  /// **'Přetáhni figurku na šachovnici'**
  String get dragHint;

  /// No description provided for @armies.
  ///
  /// In cs, this message translates to:
  /// **'Armády'**
  String get armies;

  /// No description provided for @myArmy.
  ///
  /// In cs, this message translates to:
  /// **'Moje armáda'**
  String get myArmy;

  /// No description provided for @rivalArmy.
  ///
  /// In cs, this message translates to:
  /// **'Soupeř'**
  String get rivalArmy;

  /// No description provided for @battleDemo.
  ///
  /// In cs, this message translates to:
  /// **'Zkušební bitva'**
  String get battleDemo;

  /// No description provided for @taskOf.
  ///
  /// In cs, this message translates to:
  /// **'Úkol {n} z {total}'**
  String taskOf(int n, int total);

  /// No description provided for @opponentThinking.
  ///
  /// In cs, this message translates to:
  /// **'Robůtek přemýšlí…'**
  String get opponentThinking;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
