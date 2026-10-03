// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'وليمة';

  @override
  String get helloWorld => 'مرحبا بالعالم!';

  @override
  String get welcome => 'مرحبا';

  @override
  String get home => 'الرئيسية';

  @override
  String get settings => 'الإعدادات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'تسجيل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get update => 'تحديث';

  @override
  String get confirm => 'تأكيد';

  @override
  String get submit => 'إرسال';

  @override
  String get close => 'إغلاق';

  @override
  String get done => 'تم';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get skip => 'تخطي';

  @override
  String get finish => 'إنهاء';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get refresh => 'تحديث';

  @override
  String get ok => 'موافق';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get loading => 'جار التحميل...';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get error => 'حدث خطأ';

  @override
  String get success => 'نجاح';

  @override
  String get networkError => 'خطأ في الشبكة. تحقق من اتصالك.';

  @override
  String get serverError => 'خطأ في الخادم. حاول مرة أخرى لاحقا.';

  @override
  String get unknownError => 'حدث خطأ غير معروف';

  @override
  String get sessionExpired => 'انتهت جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get unauthorized => 'وصول غير مصرح';

  @override
  String get notFound => 'لم يتم العثور على المورد';

  @override
  String get invalidInput => 'إدخال غير صالح';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get passwordTooShort => 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get invalidPhoneNumber => 'يرجى إدخال رقم هاتف صالح';

  @override
  String get noResults => 'لم يتم العثور على نتائج';

  @override
  String get emptyList => 'القائمة فارغة';

  @override
  String get confirmDelete => 'هل أنت متأكد أنك تريد الحذف؟';

  @override
  String get confirmLogout => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get theme => 'المظهر';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get bangla => 'البنغالية';

  @override
  String get arabic => 'العربية';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get changeTheme => 'تغيير المظهر';

  @override
  String get about => 'حول';

  @override
  String get completeYourProfile => 'أكمل ملفك الشخصي';

  @override
  String profileCompletionPercentage(Object percentage) {
    return 'ملفك الشخصي مكتمل بنسبة $percentage%';
  }

  @override
  String get seeMore => 'عرض المزيد';

  @override
  String get seeLess => 'عرض أقل';

  @override
  String completeSectionTitle(Object sectionLabel) {
    return 'أكمل $sectionLabel';
  }

  @override
  String get profileSection => 'قسم الملف الشخصي';

  @override
  String fieldsLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حقول متبقية',
      one: 'حقل واحد متبقٍ',
      zero: 'لا توجد حقول متبقية',
    );
    return '$_temp0';
  }

  @override
  String get profileStrengthTitle => 'اكتمال الملف الشخصي';

  @override
  String get profileStrengthCompleted => 'مكتمل';

  @override
  String get profileStrengthTips => 'نصائح للتحسين';

  @override
  String get profileStrengthUnavailable =>
      'بيانات اكتمال الملف الشخصي غير متاحة الآن.';

  @override
  String get profileStrengthRefreshFailed => 'تعذر تحديث اكتمال الملف الشخصي.';

  @override
  String get profileStrengthCompletedStatus => 'مكتمل';

  @override
  String get profileStrengthIncompleteStatus => 'غير مكتمل';

  @override
  String profileStrengthSemantics(Object percentage) {
    return 'اكتمال الملف الشخصي $percentage بالمائة.';
  }

  @override
  String profileStrengthSectionSemantics(
    Object sectionLabel,
    Object percentage,
    Object status,
  ) {
    return '$sectionLabel، $percentage بالمائة، $status.';
  }

  @override
  String get profileStrengthPreferences => 'تفضيلات شريك الحياة';

  @override
  String get profileStrengthBasicProfile => 'الملف الشخصي الأساسي';

  @override
  String get profileStrengthPhotos => 'صور الملف الشخصي';

  @override
  String get profileStrengthFamily => 'تفاصيل العائلة';

  @override
  String get profileStrengthEducation => 'التعليم';

  @override
  String get profileStrengthProfession => 'المهنة';

  @override
  String get profileStrengthAppearance => 'المظهر';

  @override
  String get profileStrengthReligion => 'الدين';

  @override
  String get profileStrengthLifestyle => 'نمط الحياة';

  @override
  String get profileStrengthLocation => 'الموقع';

  @override
  String get profileStrengthInterests => 'الاهتمامات والهوايات';

  @override
  String get profileStrengthContact => 'معلومات الاتصال';

  @override
  String get profileStrengthTipPreferences =>
      'أكمل تفضيلات شريك الحياة لتحسين جودة المطابقات';

  @override
  String get profileStrengthTipBasic =>
      'أكمل تفاصيل ملفك الأساسية لمساعدة الآخرين على معرفتك بشكل أفضل';

  @override
  String get profileStrengthTipPhotos => 'أضف صورة ملفك الشخصي لتحسين ظهورك';

  @override
  String get profileStrengthTipFamily =>
      'تساعد إضافة تفاصيل العائلة على بناء الثقة مع المطابقات المحتملة';

  @override
  String get profileStrengthTipEducation =>
      'شارك خلفيتك التعليمية للعثور على مطابقات متوافقة';

  @override
  String get profileStrengthTipProfession =>
      'تؤدي إضافة تفاصيل مهنتك إلى تحسين صلة المطابقات';

  @override
  String get profileStrengthTipAppearance =>
      'أكمل تفاصيل مظهرك لتحسين دقة المطابقة';

  @override
  String get profileStrengthTipReligion =>
      'حدد خلفيتك الدينية للعثور على مطابقات متوافقة';

  @override
  String get profileStrengthTipLifestyle =>
      'شارك خيارات نمط حياتك للعثور على مطابقات متشابهة';

  @override
  String get profileStrengthTipLocation => 'أضف موقعك للعثور على مطابقات قريبة';

  @override
  String get profileStrengthTipInterests =>
      'شارك اهتماماتك وهواياتك للعثور على نقاط مشتركة';

  @override
  String get profileStrengthTipContact =>
      'أضف معلومات الاتصال حتى تتمكن المطابقات من الوصول إليك';
}
