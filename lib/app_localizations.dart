import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en'));

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const supportedLocales = [
    Locale('en'),
    Locale('ur'),
    Locale('ar'),
    Locale('es'),
  ];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'ur': 'Urdu',
    'ar': 'Arabic',
    'es': 'Spanish',
  };

  static String languageCodeFromName(String language) {
    return languageNames.entries
            .firstWhere(
              (entry) => entry.value.toLowerCase() == language.toLowerCase(),
              orElse: () => const MapEntry('en', 'English'),
            )
            .key;
  }

  static String languageNameFromCode(String code) {
    return languageNames[code] ?? 'English';
  }

  static Locale localeFromLanguageName(String language) {
    return localeFromLanguageCode(languageCodeFromName(language));
  }

  static Locale localeFromLanguageCode(String code) {
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == code,
      orElse: () => const Locale('en'),
    );
  }

  String translate(String key) {
    final translations = _translations[locale.languageCode] ?? _translations['en']!;
    return translations[key] ?? _translations['en']?[key] ?? key;
  }

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(localizations != null, 'AppLocalizations not found in context');
    return localizations!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

const Map<String, Map<String, String>> _translations = {
  'en': {
    'appDescription': 'Pakistan #1 Event Planning Marketplace',
    'eventsAffairsMenu': 'Events Affairs Menu',
    'home': 'Home',
    'venues': 'Venues',
    'vendors': 'Vendors',
    'blogs': 'Blogs',
    'contactUs': 'Contact Us',
    'location': 'Location',
    'open': 'Open',
    'contactAddress': 'Forman Christian College (A Chartered University)\nFerozepur Road, Lahore, Punjab, Pakistan',
    'getInTouch': 'Get In Touch',
    'callUs': 'Call Us',
    'emailUs': 'Email Us',
    'website': 'Website',
    'workingHours': 'Working Hours',
    'workingHoursValue': 'Mon – Sat: 9 AM – 6 PM',
    'about': 'About',
    'contactAboutDescription': 'Eventaffairs.pk is Pakistan\'s #1 Event Planning Portal and Mobile Application where you can find venues of your choice, the best wedding vendors, and much more with prices and reviews at the click of a button. Whether you are looking to hire Event Planners, top Photographers, Caterers or just need inspiration for your events — we have you covered.',
    'followUs': 'Follow Us',
    'contactFooterNote': '© 2025 EventAffairs.pk · Made with ❤️ in Pakistan',
    'settings': 'Settings',
    'support': 'Support',
    'language': 'Language',
    'defaultCity': 'Default City',
    'darkMode': 'Dark Mode',
    'notifications': 'Notifications',
    'personalInformation': 'Personal Information',
    'changePassword': 'Change Password',
    'myBookings': 'My Bookings',
    'savedVendors': 'Saved Vendors',
    'savedVendorsSubtitle': 'Hearts & bookmarks from listings',
    'savedBlogs': 'Saved Blogs',
    'articlesSavedForReading': 'Articles saved for reading',
    'myQuotes': 'My Quotes',
    'twoFactorAuth': 'Two-Factor Auth',
    'profileVisibility': 'Profile Visibility',
    'protectYourAccount': 'Protect your account',
    'public': 'Public',
    'dataPrivacy': 'Data & Privacy',
    'manageYourData': 'Manage your data',
    'privacySecurity': 'Privacy & Security',
    'helpFaq': 'Help & FAQ',
    'commonQuestions': 'Common questions',
    'contactSupport': 'Contact Support',
    'reportAnIssue': 'Report an issue',
    'switchAppAppearance': 'Switch app appearance',
    'notificationsSubtitle': 'Quotes, updates & offers',
    'rateApp': 'Rate the App',
    'termsPrivacy': 'Terms & Privacy Policy',
    'deleteAccount': 'Delete Account',
    'deleteAccountSubtitle': 'Permanently remove your data',
    'dangerZone': 'Danger Zone',
    'preferences': 'Preferences',
    'account': 'Account',
    'back': 'Back',
    'logout': 'Log Out',
    'cancel': 'Cancel',
    'edit': 'Edit',
    'selectDefaultCity': 'Select Default City',
    'selectLanguage': 'Select Language',
    'namePhoneEmail': 'Name, phone, email',
    'updateYourPassword': 'Update your password',
    'viewVendorBookings': 'Vendors you contacted',
    'pleaseSignInEditProfile': 'Please sign in to edit your profile.',
    'invalidEmailOrPassword': 'Invalid email or password. Please try again.',
    'noAccountFound': 'No account found with this email.',
    'incorrectPassword': 'Incorrect password. Please try again.',
    'invalidEmail': 'Please enter a valid email address.',
    'tooManyRequests': 'Too many attempts. Please try again later.',
    'networkFailed': 'No internet connection. Please check your network.',
    'somethingWentWrong': 'Something went wrong. Please try again.',
    'emailLabel': 'Email',
    'passwordLabel': 'Password',
    'login': 'Login',
    'createAccount': 'Create Account',
    'joinPlatform': 'Join Pakistan\'s #1 event platform',
    'welcomeBack': 'Welcome Back 👋',
    'signInManageEvents': 'Sign in to manage your events',
    'rememberMe': 'Remember me',
    'forgotPassword': 'Forgot Password?',
    'pleaseEnterYourEmail': 'Please enter your email',
    'enterValidEmail': 'Enter a valid email address',
    'pleaseEnterYourPassword': 'Please enter your password',
    'passwordAtLeast6': 'Password must be at least 6 characters',
    'fullName': 'Full Name',
    'emailAddress': 'Email Address',
    'phoneNumber': 'Phone Number',
    'confirmPassword': 'Confirm Password',
    'signUp': 'Sign Up',
    'enterAtLeast3Characters': 'Enter at least 3 characters',
    'enterYourEmail': 'Enter your email',
    'passwordTooWeak': 'Password is too weak. Use at least 6 characters.',
    'acceptTerms': 'Please accept the Terms & Conditions to continue.',
    'createAccountSuccess': 'Your couple account has been created! You can now login.',
    'pleaseEnterVendorInfo': 'Please enter a vendor name, category, or location.',
    'termsAndConditions': 'Terms & Conditions',
    'alreadyHaveAccount': 'Already have an account? ',
    'searchingVendors': 'Searching vendors…',
    'noVendorsMatchSearch': 'No vendors match your search. Opening the full vendor list.',
    'searchHint': 'Search vendors, category or city',
    'eventsAffairsTitle': 'Events Affairs',
    'footerDescription': 'Pakistan\'s #1 Event Planning Marketplace',
    'quickLinks': 'Quick Links',
    'contact': 'Contact',
    'phoneContact': '📞 +92 300 1234567',
    'emailContact': '📧 info@eventsaffairs.com',
    'footerCopyright': '© 2026 Events Affairs. All rights reserved.',
  },
  'ur': {
    'appDescription': 'پاکستان کا نمبر 1 ایونٹ پلاننگ مارکیٹ پلیس',
    'eventsAffairsMenu': 'ایونٹس افیئرز مینو',
    'home': 'ہوم',
    'venues': 'مقامات',
    'vendors': 'فروش',
    'blogs': 'بلاگز',
    'contactUs': 'ہم سے رابطہ کریں',
    'location': 'مقام',
    'open': 'کھولیں',
    'contactAddress': 'فارمن کرسچن کالج (اے چارٹرڈ یونیورسٹی)\nفیروزپور روڈ، لاہور، پنجاب، پاکستان',
    'getInTouch': 'رابطہ کریں',
    'callUs': 'ہمیں کال کریں',
    'emailUs': 'ای میل کریں',
    'website': 'ویب سائٹ',
    'workingHours': 'کاروباری اوقات',
    'workingHoursValue': 'پیر تا ہفتہ: صبح 9 تا شام 6',
    'about': 'ہمارے بارے میں',
    'contactAboutDescription': 'Eventaffairs.pk پاکستان کا نمبر 1 ایونٹ پلاننگ پورٹل اور موبائل ایپلیکیشن ہے جہاں آپ اپنی پسند کے مقامات، بہترین شادی کے فروش، اور قیمتوں اور جائزوں کے ساتھ بہت کچھ ایک کلک پر تلاش کرسکتے ہیں۔ چاہے آپ ایونٹ پلانرز، بہترین فوٹوگرافرز، کیٹررز تلاش کر رہے ہوں یا اپنے ایونٹس کے لئے تحریک درکار ہو — ہم آپ کے لئے موجود ہیں۔',
    'followUs': 'ہمیں فالو کریں',
    'contactFooterNote': '© 2025 EventAffairs.pk · محبت کے ساتھ پاکستان میں بنایا گیا',
    'settings': 'سیٹنگز',
    'support': 'سپورٹ',
    'language': 'زبان',
    'defaultCity': 'ڈیفالٹ شہر',
    'darkMode': 'ڈارک موڈ',
    'notifications': 'نوٹیفیکیشنز',
    'personalInformation': 'ذاتی معلومات',
    'changePassword': 'پاس ورڈ تبدیل کریں',
    'myBookings': 'میری بکنگ',
    'savedVendors': 'محفوظ فروش',
    'savedVendorsSubtitle': 'فہرستوں سے دل اور بُک مارک',
    'savedBlogs': 'محفوظ بلاگز',
    'articlesSavedForReading': 'پڑھنے کے لئے محفوظ مضامین',
    'myQuotes': 'میری کوٹس',
    'twoFactorAuth': 'دو مرحلہ وار تصدیق',
    'profileVisibility': 'پروفائل کی نمائش',
    'protectYourAccount': 'اپنے اکاؤنٹ کو محفوظ بنائیں',
    'public': 'عوامی',
    'dataPrivacy': 'ڈیٹا اور رازداری',
    'manageYourData': 'اپنا ڈیٹا منظم کریں',
    'privacySecurity': 'رازداری اور سکیورٹی',
    'helpFaq': 'مدد اور عمومی سوالات',
    'commonQuestions': 'عام سوالات',
    'contactSupport': 'سپورٹ سے رابطہ',
    'reportAnIssue': 'مسئلہ رپورٹ کریں',
    'switchAppAppearance': 'ایپ کا ظاہری حصہ تبدیل کریں',
    'notificationsSubtitle': 'کوٹس، اپ ڈیٹس اور پیشکشیں',
    'rateApp': 'ایپ کو درجہ دیں',
    'termsPrivacy': 'شرائط و ضوابط',
    'deleteAccount': 'اکاؤنٹ حذف کریں',
    'deleteAccountSubtitle': 'اپنا ڈیٹا مستقل طور پر حذف کریں',
    'dangerZone': 'خطرے کا زیلا',
    'preferences': 'ترجیحات',
    'account': 'کھاتہ',
    'back': 'پیچھے',
    'logout': 'لاگ آؤٹ',
    'cancel': 'منسوخ کریں',
    'edit': 'ترمیم کریں',
    'selectDefaultCity': 'ڈیفالٹ شہر منتخب کریں',
    'selectLanguage': 'زبان منتخب کریں',
    'namePhoneEmail': 'نام، فون، ای میل',
    'updateYourPassword': 'اپنا پاس ورڈ اپ ڈیٹ کریں',
    'viewVendorBookings': 'وہ فروش جن سے آپ نے رابطہ کیا',
    'pleaseSignInEditProfile': 'پروفائل میں ترمیم کرنے کے لیے سائن ان کریں۔',
    'invalidEmailOrPassword': 'غلط ای میل یا پاس ورڈ۔ دوبارہ کوشش کریں۔',
    'noAccountFound': 'اس ای میل کے ساتھ کوئی اکاؤنٹ نہیں ملا۔',
    'eventsAffairsTitle': 'ایونٹس افیئرز',
    'footerDescription': 'پاکستان کا نمبر 1 ایونٹ پلاننگ مارکیٹ پلیس',
    'quickLinks': 'فوری روابط',
    'contact': 'رابطہ',
    'phoneContact': '📞 +92 300 1234567',
    'emailContact': '📧 info@eventsaffairs.com',
    'footerCopyright': '© 2026 ایونٹس افیئرز۔ تمام حقوق محفوظ ہیں۔',
  },
  'ar': {
    'appDescription': 'باكستان السوق الأولى لتنظيم الفعاليات',
    'eventsAffairsMenu': 'قائمة شؤون الأحداث',
    'home': 'الرئيسية',
    'venues': 'المواقع',
    'vendors': 'الموردون',
    'blogs': 'المدونات',
    'contactUs': 'اتصل بنا',
    'location': 'الموقع',
    'open': 'افتح',
    'contactAddress': 'كلية فورمان المسيحية (جامعة معتمدة)\nطريق فيروزبور، لاهور، البنجاب، باكستان',
    'getInTouch': 'تواصل معنا',
    'callUs': 'اتصل بنا',
    'emailUs': 'راسلنا عبر البريد',
    'website': 'الموقع الإلكتروني',
    'workingHours': 'ساعات العمل',
    'workingHoursValue': 'الإثنين – السبت: 9 صباحًا – 6 مساءً',
    'about': 'حول',
    'contactAboutDescription': 'Eventaffairs.pk هو البوابة وتطبيق الهاتف المحمول الأول لتنظيم الفعاليات في باكستان حيث يمكنك العثور على الأماكن التي تختارها، أفضل موردي الأعراس، والمزيد مع الأسعار والتقييمات بنقرة زر. سواء كنت تبحث عن مخططي أحداث، أو مصورين محترفين، أو خدمات تموين أو مجرد تحتاج إلى إلهام لفعالياتك — فنحن هنا من أجلك.',
    'followUs': 'تابعنا',
    'contactFooterNote': '© 2025 EventAffairs.pk · صنع بحب في باكستان',
    'settings': 'الإعدادات',
    'support': 'الدعم',
    'language': 'اللغة',
    'defaultCity': 'المدينة الافتراضية',
    'darkMode': 'الوضع الداكن',
    'notifications': 'الإشعارات',
    'personalInformation': 'المعلومات الشخصية',
    'changePassword': 'تغيير كلمة المرور',
    'myBookings': 'حجوزاتي',
    'eventsAffairsTitle': 'شؤون الأحداث',
    'footerDescription': 'باكستان السوق الأولى لتنظيم الفعاليات',
    'quickLinks': 'روابط سريعة',
    'contact': 'اتصل',
    'phoneContact': '📞 +92 300 1234567',
    'emailContact': '📧 info@eventsaffairs.com',
    'footerCopyright': '© 2026 شؤون الأحداث. جميع الحقوق محفوظة.',
  },
  'es': {
    'appDescription': 'El principal mercado de planificación de eventos de Pakistán',
    'eventsAffairsMenu': 'Menú de Eventos',
    'home': 'Inicio',
    'venues': 'Lugares',
    'vendors': 'Vendedores',
    'blogs': 'Blogs',
    'contactUs': 'Contáctenos',
    'location': 'Ubicación',
    'open': 'Abrir',
    'contactAddress': 'Forman Christian College (Una universidad con estatuto)\nCarretera Ferozepur, Lahore, Punjab, Pakistán',
    'getInTouch': 'Contáctanos',
    'callUs': 'Llámanos',
    'emailUs': 'Envíanos un correo',
    'website': 'Sitio web',
    'workingHours': 'Horario',
    'workingHoursValue': 'Lun – Sáb: 9 AM – 6 PM',
    'about': 'Acerca de',
    'contactAboutDescription': 'Eventaffairs.pk es el portal y la aplicación móvil número 1 de Pakistán para la planificación de eventos donde puedes encontrar los lugares de tu elección, los mejores proveedores de bodas y mucho más con precios y reseñas con un solo clic. Ya sea que estés buscando planificadores de eventos, fotógrafos de primera, servicios de catering o solo necesites inspiración para tus eventos, estamos aquí para ayudarte.',
    'followUs': 'Síguenos',
    'contactFooterNote': '© 2025 EventAffairs.pk · Hecho con ❤️ en Pakistán',
    'settings': 'Configuración',
    'support': 'Soporte',
    'language': 'Idioma',
    'defaultCity': 'Ciudad predeterminada',
    'darkMode': 'Modo oscuro',
    'notifications': 'Notificaciones',
    'personalInformation': 'Información personal',
    'changePassword': 'Cambiar contraseña',
    'myBookings': 'Mis reservas',
    'eventsAffairsTitle': 'Events Affairs',
    'footerDescription': 'El principal mercado de planificación de eventos de Pakistán',
    'quickLinks': 'Enlaces rápidos',
    'contact': 'Contacto',
    'phoneContact': '📞 +92 300 1234567',
    'emailContact': '📧 info@eventsaffairs.com',
    'footerCopyright': '© 2026 Events Affairs. Todos los derechos reservados.',
  },
};
