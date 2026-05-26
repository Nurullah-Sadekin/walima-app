import 'package:flutter/widgets.dart';

extension LocalizedTextX on String {
  String localized(BuildContext context) {
    return AppTextTranslator.translate(context, this);
  }
}

class AppTextTranslator {
  AppTextTranslator._();

  static String translate(BuildContext context, String text) {
    final normalized = text.trim();
    if (normalized.isEmpty) return text;

    final languageCode = Localizations.localeOf(context).languageCode;
    final translations = _translations[normalized];
    if (translations == null) return text;

    return translations[languageCode] ?? text;
  }

  static const Map<String, Map<String, String>> _translations = {
    'English': {
      'bn': 'ইংরেজি',
      'ar': 'الإنجليزية',
    },
    'Bangla': {
      'bn': 'বাংলা',
      'ar': 'البنغالية',
    },
    'Arabic': {
      'bn': 'আরবি',
      'ar': 'العربية',
    },
    'Language': {
      'bn': 'ভাষা',
      'ar': 'اللغة',
    },
    'Select Languages': {
      'bn': 'ভাষা নির্বাচন করুন',
      'ar': 'اختر اللغات',
    },
    'MATCH · MEET · MARRY': {
      'bn': 'ম্যাচ · দেখা · বিয়ে',
      'ar': 'توافق · لقاء · زواج',
    },
    'Continue': {
      'bn': 'চালিয়ে যান',
      'ar': 'متابعة',
    },
    'Continue with Phone': {
      'bn': 'ফোন দিয়ে চালিয়ে যান',
      'ar': 'المتابعة برقم الهاتف',
    },
    'Continue with Email': {
      'bn': 'ইমেইল দিয়ে চালিয়ে যান',
      'ar': 'المتابعة بالبريد الإلكتروني',
    },
    'Continue with Apple': {
      'bn': 'Apple দিয়ে চালিয়ে যান',
      'ar': 'المتابعة باستخدام Apple',
    },
    'Continue with Google': {
      'bn': 'Google দিয়ে চালিয়ে যান',
      'ar': 'المتابعة باستخدام Google',
    },
    'Continue with OTP': {
      'bn': 'OTP দিয়ে চালিয়ে যান',
      'ar': 'المتابعة برمز التحقق',
    },
    'Continue & Submit': {
      'bn': 'চালিয়ে যান ও জমা দিন',
      'ar': 'متابعة وإرسال',
    },
    'Save & Continue': {
      'bn': 'সংরক্ষণ করে চালিয়ে যান',
      'ar': 'حفظ ومتابعة',
    },
    'Save Changes': {
      'bn': 'পরিবর্তন সংরক্ষণ করুন',
      'ar': 'حفظ التغييرات',
    },
    'Cancel': {
      'bn': 'বাতিল',
      'ar': 'إلغاء',
    },
    'Done': {
      'bn': 'সম্পন্ন',
      'ar': 'تم',
    },
    'Complete': {
      'bn': 'সম্পূর্ণ করুন',
      'ar': 'أكمل',
    },
    'Back': {
      'bn': 'পেছনে',
      'ar': 'رجوع',
    },
    'Go to Home': {
      'bn': 'হোমে যান',
      'ar': 'اذهب إلى الرئيسية',
    },
    'No internet connection': {
      'bn': 'ইন্টারনেট সংযোগ নেই',
      'ar': 'لا يوجد اتصال بالإنترنت',
    },
    'Back online': {
      'bn': 'আবার অনলাইনে',
      'ar': 'تمت استعادة الاتصال',
    },
    'Unable to open': {
      'bn': 'খোলা যাচ্ছে না',
      'ar': 'تعذر فتح',
    },
    'Next': {
      'bn': 'পরবর্তী',
      'ar': 'التالي',
    },
    'Apply': {
      'bn': 'প্রয়োগ করুন',
      'ar': 'تطبيق',
    },
    'Retry': {
      'bn': 'আবার চেষ্টা করুন',
      'ar': 'إعادة المحاولة',
    },
    'Refresh': {
      'bn': 'রিফ্রেশ',
      'ar': 'تحديث',
    },
    'unread': {
      'bn': 'অপঠিত',
      'ar': 'غير مقروء',
    },
    'Mark all as read': {
      'bn': 'সব পঠিত হিসেবে চিহ্নিত করুন',
      'ar': 'تحديد الكل كمقروء',
    },
    'Try again': {
      'bn': 'আবার চেষ্টা করুন',
      'ar': 'حاول مرة أخرى',
    },
    'Error': {
      'bn': 'ত্রুটি',
      'ar': 'خطأ',
    },
    'Success': {
      'bn': 'সফল',
      'ar': 'نجاح',
    },
    'Exit App': {
      'bn': 'অ্যাপ বন্ধ করুন',
      'ar': 'الخروج من التطبيق',
    },
    'Are you sure you want to exit the app?': {
      'bn': 'আপনি কি নিশ্চিত যে অ্যাপ বন্ধ করতে চান?',
      'ar': 'هل أنت متأكد أنك تريد الخروج من التطبيق؟',
    },
    'Exit': {
      'bn': 'বন্ধ করুন',
      'ar': 'خروج',
    },
    'Optional': {
      'bn': 'ঐচ্ছিক',
      'ar': 'اختياري',
    },
    '(optional)': {
      'bn': '(ঐচ্ছিক)',
      'ar': '(اختياري)',
    },
    'Settings': {
      'bn': 'সেটিংস',
      'ar': 'الإعدادات',
    },
    'Use light theme': {
      'bn': 'লাইট থিম ব্যবহার করুন',
      'ar': 'استخدم الوضع الفاتح',
    },
    'Use dark theme': {
      'bn': 'ডার্ক থিম ব্যবহার করুন',
      'ar': 'استخدم الوضع الداكن',
    },
    'System': {
      'bn': 'সিস্টেম',
      'ar': 'النظام',
    },
    'Use system theme': {
      'bn': 'সিস্টেম থিম ব্যবহার করুন',
      'ar': 'استخدم سمة النظام',
    },
    'Version': {
      'bn': 'ভার্সন',
      'ar': 'الإصدار',
    },
    'Build Number': {
      'bn': 'বিল্ড নম্বর',
      'ar': 'رقم البناء',
    },
    'Home': {
      'bn': 'হোম',
      'ar': 'الرئيسية',
    },
    'Profile': {
      'bn': 'প্রোফাইল',
      'ar': 'الملف الشخصي',
    },
    'Edit Profile': {
      'bn': 'প্রোফাইল সম্পাদনা',
      'ar': 'تعديل الملف الشخصي',
    },
    'Payment': {
      'bn': 'পেমেন্ট',
      'ar': 'الدفع',
    },
    'Logout': {
      'bn': 'লগআউট',
      'ar': 'تسجيل الخروج',
    },
    'Log Out': {
      'bn': 'লগ আউট',
      'ar': 'تسجيل الخروج',
    },
    'Matches': {
      'bn': 'ম্যাচেস',
      'ar': 'التطابقات',
    },
    'Inbox': {
      'bn': 'ইনবক্স',
      'ar': 'الوارد',
    },
    'Premium': {
      'bn': 'প্রিমিয়াম',
      'ar': 'المميز',
    },
    'ACCOUNT': {
      'bn': 'অ্যাকাউন্ট',
      'ar': 'الحساب',
    },
    'find your matches': {
      'bn': 'আপনার ম্যাচ খুঁজুন',
      'ar': 'ابحث عن مطابقاتك',
    },
    'options and controls': {
      'bn': 'অপশন ও নিয়ন্ত্রণ',
      'ar': 'الخيارات والتحكم',
    },
    'general': {
      'bn': 'সাধারণ',
      'ar': 'عام',
    },
    'View & Edit Your profile': {
      'bn': 'আপনার প্রোফাইল দেখুন ও সম্পাদনা করুন',
      'ar': 'عرض وتعديل ملفك الشخصي',
    },
    'Download & Share profile': {
      'bn': 'প্রোফাইল ডাউনলোড ও শেয়ার করুন',
      'ar': 'تنزيل ومشاركة الملف الشخصي',
    },
    'Partner Preferences': {
      'bn': 'পছন্দের জীবনসঙ্গী',
      'ar': 'تفضيلات الشريك',
    },
    'Contacts Filters': {
      'bn': 'যোগাযোগ ফিল্টার',
      'ar': 'فلاتر التواصل',
    },
    'Account Settings': {
      'bn': 'অ্যাকাউন্ট সেটিংস',
      'ar': 'إعدادات الحساب',
    },
    'Privacy Policy': {
      'bn': 'গোপনীয়তা নীতি',
      'ar': 'سياسة الخصوصية',
    },
    'Safety': {
      'bn': 'নিরাপত্তা',
      'ar': 'الأمان',
    },
    'Rate The App': {
      'bn': 'অ্যাপটি রেট দিন',
      'ar': 'قيّم التطبيق',
    },
    'Terms & Conditions': {
      'bn': 'শর্তাবলী',
      'ar': 'الشروط والأحكام',
    },
    'Copyright© walima.com': {
      'bn': 'কপিরাইট© walima.com',
      'ar': 'حقوق النشر© walima.com',
    },
    'Help & Support': {
      'bn': 'সহায়তা ও সাপোর্ট',
      'ar': 'المساعدة والدعم',
    },
    'Be Safe Online': {
      'bn': 'অনলাইনে নিরাপদ থাকুন',
      'ar': 'كن آمنا على الإنترنت',
    },
    'Need Help?': {
      'bn': 'সহায়তা দরকার?',
      'ar': 'هل تحتاج إلى مساعدة؟',
    },
    "We're here to help you on your journey to finding the right match.": {
      'bn': 'সঠিক জীবনসঙ্গী খুঁজে পাওয়ার যাত্রায় আমরা আপনার পাশে আছি।',
      'ar': 'نحن هنا لمساعدتك في رحلتك للعثور على الشريك المناسب.',
    },
    'Terms & Privacy': {
      'bn': 'শর্তাবলি ও গোপনীয়তা',
      'ar': 'الشروط والخصوصية',
    },
    'Contact Support': {
      'bn': 'সাপোর্টে যোগাযোগ করুন',
      'ar': 'التواصل مع الدعم',
    },
    'About Walima': {
      'bn': 'Walima সম্পর্কে',
      'ar': 'حول وليمة',
    },
    'Profile Created by': {
      'bn': 'প্রোফাইল তৈরি করেছেন',
      'ar': 'تم إنشاء الملف بواسطة',
    },
    "Don't have an account?": {
      'bn': 'অ্যাকাউন্ট নেই?',
      'ar': 'ليس لديك حساب؟',
    },
    'Create now': {
      'bn': 'এখন তৈরি করুন',
      'ar': 'أنشئ الآن',
    },
    'By continuing you agree to our': {
      'bn': 'চালিয়ে গেলে আপনি সম্মত হচ্ছেন আমাদের',
      'ar': 'بالمتابعة فإنك توافق على',
    },
    'Terms': {
      'bn': 'শর্তাবলি',
      'ar': 'الشروط',
    },
    ' and ': {
      'bn': ' এবং ',
      'ar': ' و ',
    },
    'Privacy policy': {
      'bn': 'গোপনীয়তা নীতি',
      'ar': 'سياسة الخصوصية',
    },
    'Partner Preferences: Other Details': {
      'bn': 'সঙ্গী পছন্দ: অন্যান্য বিবরণ',
      'ar': 'تفضيلات الشريك: تفاصيل أخرى',
    },
    'Partner Preferences: Basic Info': {
      'bn': 'সঙ্গী পছন্দ: মৌলিক তথ্য',
      'ar': 'تفضيلات الشريك: معلومات أساسية',
    },
    'Partner Preferences: Location Details': {
      'bn': 'সঙ্গী পছন্দ: অবস্থান বিবরণ',
      'ar': 'تفضيلات الشريك: تفاصيل الموقع',
    },
    'Partner Preferences: Education & Career': {
      'bn': 'সঙ্গী পছন্দ: শিক্ষা ও পেশা',
      'ar': 'تفضيلات الشريك: التعليم والمهنة',
    },
    'Basic Info': {
      'bn': 'মৌলিক তথ্য',
      'ar': 'معلومات أساسية',
    },
    'Location Details': {
      'bn': 'অবস্থানের বিবরণ',
      'ar': 'تفاصيل الموقع',
    },
    'Countries': {
      'bn': 'দেশসমূহ',
      'ar': 'الدول',
    },
    'States': {
      'bn': 'রাজ্যসমূহ',
      'ar': 'الولايات',
    },
    'Cities': {
      'bn': 'শহরসমূহ',
      'ar': 'المدن',
    },
    'Self': {
      'bn': 'নিজে',
      'ar': 'نفسه',
    },
    'Parent': {
      'bn': 'অভিভাবক',
      'ar': 'الوالد/الوالدة',
    },
    'Sibling': {
      'bn': 'ভাই/বোন',
      'ar': 'الأخ/الأخت',
    },
    'Relative': {
      'bn': 'আত্মীয়',
      'ar': 'قريب',
    },
    'Friend': {
      'bn': 'বন্ধু',
      'ar': 'صديق',
    },
    'Other': {
      'bn': 'অন্যান্য',
      'ar': 'أخرى',
    },
    'Halal Only': {
      'bn': 'শুধু হালাল',
      'ar': 'حلال فقط',
    },
    'Vegetarian': {
      'bn': 'শাকাহারী',
      'ar': 'نباتي',
    },
    'Occasionally Non-Veg': {
      'bn': 'মাঝেমধ্যে আমিষ',
      'ar': 'غير نباتي أحيانًا',
    },
    'Occasionally Non Veg': {
      'bn': 'মাঝেমধ্যে আমিষ',
      'ar': 'غير نباتي أحيانًا',
    },
    'Jain Vegetarian': {
      'bn': 'জৈন শাকাহারী',
      'ar': 'نباتي جايني',
    },
    'Non-Vegetarian': {
      'bn': 'আমিষাশী',
      'ar': 'غير نباتي',
    },
    'Non Vegetarian': {
      'bn': 'আমিষাশী',
      'ar': 'غير نباتي',
    },
    'Vegan': {
      'bn': 'ভেগান',
      'ar': 'نباتي صرف',
    },
    'Other Details': {
      'bn': 'অন্যান্য বিবরণ',
      'ar': 'تفاصيل أخرى',
    },
    'Not Specified': {
      'bn': 'নির্দিষ্ট নয়',
      'ar': 'غير محدد',
    },
    'Unknown User': {
      'bn': 'অজানা ব্যবহারকারী',
      'ar': 'مستخدم غير معروف',
    },
    'Status': {
      'bn': 'স্ট্যাটাস',
      'ar': 'الحالة',
    },
    'ID': {
      'bn': 'আইডি',
      'ar': 'المعرف',
    },
    'Blood Group': {
      'bn': 'রক্তের গ্রুপ',
      'ar': 'فصيلة الدم',
    },
    'Health Information': {
      'bn': 'স্বাস্থ্য তথ্য',
      'ar': 'معلومات صحية',
    },
    'Disability': {
      'bn': 'প্রতিবন্ধকতা',
      'ar': 'إعاقة',
    },
    'None': {
      'bn': 'কোনটি নয়',
      'ar': 'لا يوجد',
    },
    'Preview Profile': {
      'bn': 'প্রোফাইল প্রিভিউ',
      'ar': 'معاينة الملف الشخصي',
    },
    'Connect': {
      'bn': 'যুক্ত হোন',
      'ar': 'تواصل',
    },
    'Connect Now': {
      'bn': 'এখনই কানেক্ট',
      'ar': 'تواصل الآن',
    },
    'Contact': {
      'bn': 'যোগাযোগ',
      'ar': 'اتصال',
    },
    'Received': {
      'bn': 'প্রাপ্ত',
      'ar': 'المستلمة',
    },
    'Accepted': {
      'bn': 'গৃহীত',
      'ar': 'المقبولة',
    },
    'Sent': {
      'bn': 'পাঠানো',
      'ar': 'المرسلة',
    },
    'More': {
      'bn': 'আরও',
      'ar': 'المزيد',
    },
    'No Pending Requests!': {
      'bn': 'কোনো মুলতবি অনুরোধ নেই!',
      'ar': 'لا توجد طلبات معلقة!',
    },
    'Take the next step view your accepted matches for better connections': {
      'bn': 'পরবর্তী ধাপ নিন—ভালো সংযোগের জন্য আপনার গৃহীত ম্যাচগুলো দেখুন।',
      'ar': 'اتخذ الخطوة التالية واعرض المطابقات المقبولة لتواصل أفضل.',
    },
    'Explore Accepted Matches': {
      'bn': 'গৃহীত ম্যাচগুলো দেখুন',
      'ar': 'استكشف المطابقات المقبولة',
    },
    'Error Loading Requests': {
      'bn': 'অনুরোধ লোড করতে সমস্যা',
      'ar': 'خطأ في تحميل الطلبات',
    },
    'Unable to load your connection requests': {
      'bn': 'আপনার কানেকশন অনুরোধগুলো লোড করা যাচ্ছে না',
      'ar': 'تعذر تحميل طلبات التواصل الخاصة بك',
    },
    'Location: Undefine': {
      'bn': 'অবস্থান: অনির্ধারিত',
      'ar': 'الموقع: غير محدد',
    },
    'Chat': {
      'bn': 'চ্যাট',
      'ar': 'الدردشة',
    },
    'All': {
      'bn': 'সব',
      'ar': 'الكل',
    },
    'Unread': {
      'bn': 'অপঠিত',
      'ar': 'غير مقروء',
    },
    'Calls': {
      'bn': 'কল',
      'ar': 'مكالمات',
    },
    'No conversations yet': {
      'bn': 'এখনও কোনো কথোপকথন নেই',
      'ar': 'لا توجد محادثات بعد',
    },
    'Upgrade to Premium': {
      'bn': 'প্রিমিয়ামে আপগ্রেড করুন',
      'ar': 'الترقية إلى بريميوم',
    },
    'You Have Questions?': {
      'bn': 'কোনো প্রশ্ন আছে?',
      'ar': 'هل لديك أسئلة؟',
    },
    'Still Need Help?': {
      'bn': 'আরও সহায়তা দরকার?',
      'ar': 'هل ما زلت بحاجة للمساعدة؟',
    },
    'Unlimited': {
      'bn': 'আনলিমিটেড',
      'ar': 'غير محدود',
    },
    'up to': {
      'bn': 'সর্বোচ্চ',
      'ar': 'حتى',
    },
    'month': {
      'bn': 'মাস',
      'ar': 'شهر',
    },
    'Feature': {
      'bn': 'ফিচার',
      'ar': 'ميزة',
    },
    'Welcome Back!': {
      'bn': 'আবার স্বাগতম!',
      'ar': 'مرحبا بعودتك!',
    },
    'Please': {
      'bn': 'অনুগ্রহ করে',
      'ar': 'يرجى',
    },
    'Login': {
      'bn': 'লগইন করুন',
      'ar': 'تسجيل الدخول',
    },
    'Sign Up Free': {
      'bn': 'ফ্রি সাইন আপ করুন',
      'ar': 'سجل مجانا',
    },
    'Use the same Email or Mobile No. That you used to create your profile on Walima.':
        {
      'bn':
          'Walima-তে প্রোফাইল তৈরি করতে যে ইমেইল বা মোবাইল নম্বর ব্যবহার করেছেন সেটি ব্যবহার করুন।',
      'ar':
          'استخدم نفس البريد الإلكتروني أو رقم الجوال الذي استخدمته لإنشاء ملفك في وليمة.',
    },
    'OR LOGIN WITH OTP': {
      'bn': 'অথবা OTP দিয়ে লগইন করুন',
      'ar': 'أو سجل الدخول برمز التحقق',
    },
    'Mobile No. / Email ID': {
      'bn': 'মোবাইল নম্বর / ইমেইল',
      'ar': 'رقم الجوال / البريد الإلكتروني',
    },
    'Enter mobile or email': {
      'bn': 'মোবাইল বা ইমেইল লিখুন',
      'ar': 'أدخل رقم الجوال أو البريد الإلكتروني',
    },
    'Email address': {
      'bn': 'ইমেইল ঠিকানা',
      'ar': 'البريد الإلكتروني',
    },
    'Email Address': {
      'bn': 'ইমেইল ঠিকানা',
      'ar': 'البريد الإلكتروني',
    },
    'Email': {
      'bn': 'ইমেইল',
      'ar': 'البريد الإلكتروني',
    },
    'Phone': {
      'bn': 'ফোন',
      'ar': 'الهاتف',
    },
    'Login with': {
      'bn': 'লগইন করুন',
      'ar': 'تسجيل الدخول باستخدام',
    },
    'Enter your registered email and password': {
      'bn': 'আপনার নিবন্ধিত ইমেইল ও পাসওয়ার্ড লিখুন',
      'ar': 'أدخل بريدك الإلكتروني المسجل وكلمة المرور',
    },
    'Enter your registered email to get an OTP': {
      'bn': 'OTP পেতে আপনার নিবন্ধিত ইমেইল লিখুন',
      'ar': 'أدخل بريدك الإلكتروني المسجل للحصول على رمز التحقق',
    },
    'Enter your registered mobile number and password': {
      'bn': 'আপনার নিবন্ধিত মোবাইল নম্বর ও পাসওয়ার্ড লিখুন',
      'ar': 'أدخل رقم جوالك المسجل وكلمة المرور',
    },
    'Enter your registered mobile number to get an OTP': {
      'bn': 'OTP পেতে আপনার নিবন্ধিত মোবাইল নম্বর লিখুন',
      'ar': 'أدخل رقم جوالك المسجل للحصول على رمز التحقق',
    },
    'Keep me logged in': {
      'bn': 'আমাকে লগইন অবস্থায় রাখুন',
      'ar': 'إبقائي مسجلا',
    },
    'Forgot password?': {
      'bn': 'পাসওয়ার্ড ভুলে গেছেন?',
      'ar': 'هل نسيت كلمة المرور؟',
    },
    'Log In': {
      'bn': 'লগইন',
      'ar': 'تسجيل الدخول',
    },
    'OR CONTINUE WITH': {
      'bn': 'অথবা চালিয়ে যান',
      'ar': 'أو تابع باستخدام',
    },
    'Password': {
      'bn': 'পাসওয়ার্ড',
      'ar': 'كلمة المرور',
    },
    'Enter your password': {
      'bn': 'আপনার পাসওয়ার্ড লিখুন',
      'ar': 'أدخل كلمة المرور',
    },
    'Create Password': {
      'bn': 'পাসওয়ার্ড তৈরি করুন',
      'ar': 'إنشاء كلمة مرور',
    },
    'Confirm Password': {
      'bn': 'পাসওয়ার্ড নিশ্চিত করুন',
      'ar': 'تأكيد كلمة المرور',
    },
    'Write here': {
      'bn': 'এখানে লিখুন',
      'ar': 'اكتب هنا',
    },
    'Select': {
      'bn': 'নির্বাচন করুন',
      'ar': 'اختر',
    },
    'Select Date': {
      'bn': 'তারিখ নির্বাচন করুন',
      'ar': 'اختر التاريخ',
    },
    'Search country': {
      'bn': 'দেশ খুঁজুন',
      'ar': 'ابحث عن بلد',
    },
    'No items available': {
      'bn': 'কোনো আইটেম নেই',
      'ar': 'لا توجد عناصر متاحة',
    },
    'Enter Profile ID': {
      'bn': 'প্রোফাইল আইডি লিখুন',
      'ar': 'أدخل معرف الملف الشخصي',
    },
    'Personalize Your Search': {
      'bn': 'আপনার সার্চ ব্যক্তিগত করুন',
      'ar': 'خصص بحثك',
    },
    'From': {
      'bn': 'থেকে',
      'ar': 'من',
    },
    'Age From': {
      'bn': 'বয়স শুরু',
      'ar': 'العمر من',
    },
    'Have Children': {
      'bn': 'সন্তান আছে',
      'ar': 'لديه أطفال',
    },
    'Country Grew Up In': {
      'bn': 'যে দেশে বড় হয়েছেন',
      'ar': 'بلد النشأة',
    },
    'Photo Setting': {
      'bn': 'ছবির সেটিং',
      'ar': 'إعدادات الصور',
    },
    'Education & Profession Details': {
      'bn': 'শিক্ষা ও পেশার বিবরণ',
      'ar': 'تفاصيل التعليم والمهنة',
    },
    'Qualification': {
      'bn': 'যোগ্যতা',
      'ar': 'المؤهل',
    },
    'Life Style': {
      'bn': 'জীবনধারা',
      'ar': 'نمط الحياة',
    },
    'Diet': {
      'bn': 'খাদ্যাভ্যাস',
      'ar': 'النظام الغذائي',
    },
    'Other Details Style': {
      'bn': 'অন্যান্য বিবরণ',
      'ar': 'تفاصيل أخرى',
    },
    'Profile Managed By': {
      'bn': 'প্রোফাইল পরিচালনা করেন',
      'ar': 'يدير الملف',
    },
    'Search Now': {
      'bn': 'এখন খুঁজুন',
      'ar': 'ابحث الآن',
    },
    'Phone Number': {
      'bn': 'ফোন নম্বর',
      'ar': 'رقم الهاتف',
    },
    'Mobile No.': {
      'bn': 'মোবাইল নম্বর',
      'ar': 'رقم الجوال',
    },
    'Personal Information': {
      'bn': 'ব্যক্তিগত তথ্য',
      'ar': 'المعلومات الشخصية',
    },
    'Tell us about yourself': {
      'bn': 'নিজের সম্পর্কে বলুন',
      'ar': 'أخبرنا عن نفسك',
    },
    'Your Name': {
      'bn': 'আপনার নাম',
      'ar': 'اسمك',
    },
    'First Name': {
      'bn': 'নামের প্রথম অংশ',
      'ar': 'الاسم الأول',
    },
    'Last Name': {
      'bn': 'নামের শেষ অংশ',
      'ar': 'اسم العائلة',
    },
    'Date of Birth': {
      'bn': 'জন্ম তারিখ',
      'ar': 'تاريخ الميلاد',
    },
    'Contact Details': {
      'bn': 'যোগাযোগের তথ্য',
      'ar': 'بيانات التواصل',
    },
    "We'll use these to verify and secure your account": {
      'bn': 'আপনার অ্যাকাউন্ট যাচাই ও সুরক্ষিত করতে এগুলো ব্যবহার করা হবে',
      'ar': 'سنستخدم هذه البيانات للتحقق من حسابك وتأمينه',
    },
    'Religion & Location': {
      'bn': 'ধর্ম ও অবস্থান',
      'ar': 'الدين والموقع',
    },
    'Tell us about your faith and where you live': {
      'bn': 'আপনার ধর্মবিশ্বাস ও কোথায় থাকেন তা বলুন',
      'ar': 'أخبرنا عن إيمانك ومكان إقامتك',
    },
    'Your Religion': {
      'bn': 'আপনার ধর্ম',
      'ar': 'دينك',
    },
    'Community': {
      'bn': 'কমিউনিটি',
      'ar': 'المجتمع',
    },
    'Living In': {
      'bn': 'যেখানে থাকেন',
      'ar': 'تقيم في',
    },
    'City': {
      'bn': 'শহর',
      'ar': 'المدينة',
    },
    'Personal Details': {
      'bn': 'ব্যক্তিগত বিবরণ',
      'ar': 'التفاصيل الشخصية',
    },
    'Tell us a bit more about yourself': {
      'bn': 'নিজের সম্পর্কে আরও কিছু বলুন',
      'ar': 'أخبرنا المزيد عن نفسك',
    },
    'Marital Status': {
      'bn': 'বৈবাহিক অবস্থা',
      'ar': 'الحالة الاجتماعية',
    },
    'Height': {
      'bn': 'উচ্চতা',
      'ar': 'الطول',
    },
    'Marriage Intention': {
      'bn': 'বিয়ের উদ্দেশ্য',
      'ar': 'نية الزواج',
    },
    'Tell us a bit more about plan': {
      'bn': 'আপনার পরিকল্পনা সম্পর্কে আরও বলুন',
      'ar': 'أخبرنا المزيد عن خطتك',
    },
    'Work Details': {
      'bn': 'কর্মজীবনের তথ্য',
      'ar': 'تفاصيل العمل',
    },
    'Tell us about your career & income': {
      'bn': 'আপনার ক্যারিয়ার ও আয়ের তথ্য দিন',
      'ar': 'أخبرنا عن عملك ودخلك',
    },
    'Work Sector': {
      'bn': 'কর্মক্ষেত্র',
      'ar': 'قطاع العمل',
    },
    'Your Profession': {
      'bn': 'আপনার পেশা',
      'ar': 'مهنتك',
    },
    'Company / Organisation': {
      'bn': 'কোম্পানি / প্রতিষ্ঠান',
      'ar': 'الشركة / المؤسسة',
    },
    'About Yourself': {
      'bn': 'নিজের সম্পর্কে',
      'ar': 'عن نفسك',
    },
    'Almost done!\n A well-written bio helps you get 3x more profile views': {
      'bn':
          'প্রায় শেষ!\nভালোভাবে লেখা বায়ো প্রোফাইল ভিউ ৩ গুণ বাড়াতে সাহায্য করে',
      'ar':
          'اقتربنا من النهاية!\nالسيرة المكتوبة جيدا تساعدك على الحصول على مشاهدات أكثر بثلاث مرات',
    },
    'Show Templates': {
      'bn': 'টেমপ্লেট দেখুন',
      'ar': 'عرض القوالب',
    },
    'Auto Suggest': {
      'bn': 'স্বয়ংক্রিয় পরামর্শ',
      'ar': 'اقتراح تلقائي',
    },
    'Family Details': {
      'bn': 'পারিবারিক তথ্য',
      'ar': 'تفاصيل العائلة',
    },
    'This is optional - you can add later': {
      'bn': 'এটি ঐচ্ছিক - পরে যোগ করতে পারবেন',
      'ar': 'هذا اختياري ويمكنك إضافته لاحقا',
    },
    "Mother's Details": {
      'bn': 'মায়ের তথ্য',
      'ar': 'تفاصيل الأم',
    },
    "Father's Details": {
      'bn': 'বাবার তথ্য',
      'ar': 'تفاصيل الأب',
    },
    'No. of Sisters': {
      'bn': 'বোনের সংখ্যা',
      'ar': 'عدد الأخوات',
    },
    'No. of Brothers': {
      'bn': 'ভাইয়ের সংখ্যা',
      'ar': 'عدد الإخوة',
    },
    "Family's Financial Status": {
      'bn': 'পরিবারের আর্থিক অবস্থা',
      'ar': 'الوضع المالي للعائلة',
    },
    'Helps find compatible matches': {
      'bn': 'উপযুক্ত ম্যাচ খুঁজতে সাহায্য করে',
      'ar': 'يساعد في العثور على توافق أفضل',
    },
    'Residency Information': {
      'bn': 'বাসস্থানের তথ্য',
      'ar': 'معلومات الإقامة',
    },
    'Where do you currently live?': {
      'bn': 'আপনি বর্তমানে কোথায় থাকেন?',
      'ar': 'أين تقيم حاليا؟',
    },
    'Residency Status': {
      'bn': 'বাসিন্দার অবস্থা',
      'ar': 'حالة الإقامة',
    },
    'Add Hobbies & Interests': {
      'bn': 'শখ ও আগ্রহ যোগ করুন',
      'ar': 'أضف الهوايات والاهتمامات',
    },
    'Creative': {
      'bn': 'সৃজনশীল',
      'ar': 'إبداعي',
    },
    'Fun': {
      'bn': 'বিনোদন',
      'ar': 'ترفيه',
    },
    'Fitness': {
      'bn': 'ফিটনেস',
      'ar': 'اللياقة',
    },
    'Media & Learning': {
      'bn': 'মিডিয়া ও শেখা',
      'ar': 'الإعلام والتعلم',
    },
    'Food & Cuisine': {
      'bn': 'খাবার ও রান্না',
      'ar': 'الطعام والمطبخ',
    },
    'Travel & Leisure': {
      'bn': 'ভ্রমণ ও অবসর',
      'ar': 'السفر والترفيه',
    },
    'Helps us suggest more compatible matches': {
      'bn': 'আরও উপযুক্ত ম্যাচ সাজেস্ট করতে সাহায্য করে',
      'ar': 'يساعدنا على اقتراح توافق أفضل',
    },
    'Photo Guidelines': {
      'bn': 'ছবির নির্দেশিকা',
      'ar': 'إرشادات الصور',
    },
    'Download Bio-data': {
      'bn': 'বায়ো-ডাটা ডাউনলোড করুন',
      'ar': 'تنزيل السيرة الذاتية',
    },
    'Save PDF': {
      'bn': 'PDF সংরক্ষণ করুন',
      'ar': 'حفظ PDF',
    },
    'Share': {
      'bn': 'শেয়ার',
      'ar': 'مشاركة',
    },
    'Replace File': {
      'bn': 'ফাইল পরিবর্তন করুন',
      'ar': 'استبدال الملف',
    },
    'Passport': {
      'bn': 'পাসপোর্ট',
      'ar': 'جواز السفر',
    },
    'Driving License': {
      'bn': 'ড্রাইভিং লাইসেন্স',
      'ar': 'رخصة القيادة',
    },
    'Voter ID': {
      'bn': 'ভোটার আইডি',
      'ar': 'بطاقة الناخب',
    },
    'Uploading...': {
      'bn': 'আপলোড হচ্ছে...',
      'ar': 'جارٍ الرفع...',
    },
    'Permission denied. Please allow photo library access and try again.': {
      'bn':
          'অনুমতি দেওয়া হয়নি। অনুগ্রহ করে ফটো লাইব্রেরি অ্যাক্সেস দিন এবং আবার চেষ্টা করুন।',
      'ar': 'تم رفض الإذن. اسمح بالوصول إلى مكتبة الصور وحاول مرة أخرى.',
    },
    'Unable to pick the document right now. Please try again.': {
      'bn': 'এখন ডকুমেন্ট নির্বাচন করা যাচ্ছে না। আবার চেষ্টা করুন।',
      'ar': 'تعذر اختيار المستند الآن. حاول مرة أخرى.',
    },
    'Please upload a document first.': {
      'bn': 'প্রথমে একটি ডকুমেন্ট আপলোড করুন।',
      'ar': 'يرجى رفع مستند أولا.',
    },
    'Something went wrong while uploading the document.': {
      'bn': 'ডকুমেন্ট আপলোড করার সময় কিছু ভুল হয়েছে।',
      'ar': 'حدث خطأ أثناء رفع المستند.',
    },
    'Know More': {
      'bn': 'আরও জানুন',
      'ar': 'اعرف المزيد',
    },
    'Use Camera': {
      'bn': 'ক্যামেরা ব্যবহার করুন',
      'ar': 'استخدم الكاميرا',
    },
    'Crop Image': {
      'bn': 'ছবি ক্রপ করুন',
      'ar': 'اقتصاص الصورة',
    },
    'No messages yet': {
      'bn': 'এখনও কোনো বার্তা নেই',
      'ar': 'لا توجد رسائل بعد',
    },
    'Block': {
      'bn': 'ব্লক',
      'ar': 'حظر',
    },
    'Are you sure?': {
      'bn': 'আপনি কি নিশ্চিত?',
      'ar': 'هل أنت متأكد؟',
    },
    'Blocked members cannot view your profile or contact you on walima.com.': {
      'bn':
          'ব্লক করা সদস্যরা আপনার প্রোফাইল দেখতে বা walima.com-এ যোগাযোগ করতে পারবে না।',
      'ar':
          'الأعضاء المحظورون لا يمكنهم عرض ملفك أو التواصل معك على walima.com.',
    },
    'Type a message': {
      'bn': 'বার্তা লিখুন',
      'ar': 'اكتب رسالة',
    },
    'Profile Preview': {
      'bn': 'প্রোফাইল প্রিভিউ',
      'ar': 'معاينة الملف الشخصي',
    },
    'Basic Details': {
      'bn': 'প্রাথমিক তথ্য',
      'ar': 'التفاصيل الأساسية',
    },
    'About': {
      'bn': 'সম্পর্কে',
      'ar': 'حول',
    },
    'Profile Photos': {
      'bn': 'প্রোফাইল ছবি',
      'ar': 'صور الملف الشخصي',
    },
    'Lifestyle': {
      'bn': 'জীবনধারা',
      'ar': 'نمط الحياة',
    },
    'Background': {
      'bn': 'পটভূমি',
      'ar': 'الخلفية',
    },
    'Family': {
      'bn': 'পরিবার',
      'ar': 'العائلة',
    },
    'Education & Career': {
      'bn': 'শিক্ষা ও ক্যারিয়ার',
      'ar': 'التعليم والعمل',
    },
    'Interests & Hobbies': {
      'bn': 'আগ্রহ ও শখ',
      'ar': 'الاهتمامات والهوايات',
    },
    'Hobbies and Interests': {
      'bn': 'শখ ও আগ্রহ',
      'ar': 'الهوايات والاهتمامات',
    },
    'Appearance': {
      'bn': 'চেহারা',
      'ar': 'المظهر',
    },
    'Preferences': {
      'bn': 'পছন্দসমূহ',
      'ar': 'التفضيلات',
    },
    'Basic Profile': {
      'bn': 'মৌলিক প্রোফাইল',
      'ar': 'الملف الأساسي',
    },
    'Location': {
      'bn': 'অবস্থান',
      'ar': 'الموقع',
    },
    'Education': {
      'bn': 'শিক্ষা',
      'ar': 'التعليم',
    },
    'Profession': {
      'bn': 'পেশা',
      'ar': 'المهنة',
    },
    'No matches found': {
      'bn': 'কোনো ম্যাচ পাওয়া যায়নি',
      'ar': 'لم يتم العثور على مطابقات',
    },
    'User information unavailable.': {
      'bn': 'ব্যবহারকারীর তথ্য পাওয়া যায়নি।',
      'ar': 'معلومات المستخدم غير متاحة.',
    },
    'User information unavailable. Cannot initiate contact.': {
      'bn': 'ব্যবহারকারীর তথ্য পাওয়া যায়নি। যোগাযোগ শুরু করা যাচ্ছে না।',
      'ar': 'معلومات المستخدم غير متاحة. لا يمكن بدء التواصل.',
    },
    'User id not found': {
      'bn': 'ইউজার আইডি পাওয়া যায়নি',
      'ar': 'معرف المستخدم غير موجود',
    },
    'You can select up to \$hobbiesSelectionMax hobbies.': {
      'bn': 'আপনি সর্বোচ্চ \$hobbiesSelectionMax টি শখ নির্বাচন করতে পারবেন।',
      'ar': 'يمكنك اختيار ما يصل إلى \$hobbiesSelectionMax هوايات.',
    },
    'Load more': {
      'bn': 'আরও দেখুন',
      'ar': 'تحميل المزيد',
    },
    'Whatsapp link is not configured yet': {
      'bn': 'হোয়াটসঅ্যাপ লিংক এখনো কনফিগার করা হয়নি',
      'ar': 'رابط واتساب غير مهيأ بعد',
    },
    'Sending...': {
      'bn': 'পাঠানো হচ্ছে...',
      'ar': 'جارٍ الإرسال...',
    },
    'Send': {
      'bn': 'পাঠান',
      'ar': 'إرسال',
    },
    'Your message has been sent.': {
      'bn': 'আপনার বার্তাটি পাঠানো হয়েছে।',
      'ar': 'تم إرسال رسالتك.',
    },
    'Please fill in subject and message.': {
      'bn': 'অনুগ্রহ করে বিষয় এবং বার্তা লিখুন।',
      'ar': 'يرجى ملء الموضوع والرسالة.',
    },
    'Email (optional)': {
      'bn': 'ইমেইল (ঐচ্ছিক)',
      'ar': 'البريد الإلكتروني (اختياري)',
    },
    'Phone (optional)': {
      'bn': 'ফোন (ঐচ্ছিক)',
      'ar': 'الهاتف (اختياري)',
    },
    'Subject': {
      'bn': 'বিষয়',
      'ar': 'الموضوع',
    },
    'Message': {
      'bn': 'বার্তা',
      'ar': 'الرسالة',
    },
    'AI Support': {
      'bn': 'এআই সাপোর্ট',
      'ar': 'دعم الذكاء الاصطناعي',
    },
    'Live Support Bot': {
      'bn': 'লাইভ সাপোর্ট বট',
      'ar': 'روبوت الدعم المباشر',
    },
    'active': {
      'bn': 'সক্রিয়',
      'ar': 'نشط',
    },
    'inactive': {
      'bn': 'নিষ্ক্রিয়',
      'ar': 'غير نشط',
    },
    'Chat with Walima support': {
      'bn': 'Walima সাপোর্টের সাথে চ্যাট করুন',
      'ar': 'تحدث مع دعم وليمة',
    },
    'Ask about account issues, payments, verification, or match-related support.':
        {
      'bn':
          'অ্যাকাউন্ট সমস্যা, পেমেন্ট, ভেরিফিকেশন বা ম্যাচ-সম্পর্কিত সাপোর্ট সম্পর্কে জিজ্ঞাসা করুন।',
      'ar':
          'اسأل عن مشكلات الحساب أو المدفوعات أو التحقق أو الدعم المتعلق بالمطابقات.',
    },
    'Talk to a human': {
      'bn': 'মানুষের সাথে কথা বলুন',
      'ar': 'تحدث مع موظف',
    },
    'Start with a short description of your issue': {
      'bn': 'আপনার সমস্যার সংক্ষিপ্ত বর্ণনা দিয়ে শুরু করুন',
      'ar': 'ابدأ بوصف قصير لمشكلتك',
    },
    'Examples: "Why did my payment fail?", "What is my verification status?", or "I need help with a match conversation."':
        {
      'bn':
          'উদাহরণ: "আমার পেমেন্ট কেন ব্যর্থ হলো?", "আমার ভেরিফিকেশন স্ট্যাটাস কী?", অথবা "ম্যাচ কথোপকথনে সাহায্য দরকার।"',
      'ar':
          'أمثلة: "لماذا فشل الدفع؟" أو "ما حالة التحقق؟" أو "أحتاج مساعدة في محادثة مع مطابقة."',
    },
    'Type your question here...': {
      'bn': 'এখানে আপনার প্রশ্ন লিখুন...',
      'ar': 'اكتب سؤالك هنا...',
    },
    'Use Shift+Enter for a new line. Your chat is stored with a ticket reference when human support is needed.':
        {
      'bn':
          'নতুন লাইনের জন্য Shift+Enter ব্যবহার করুন। মানুষের সাপোর্ট দরকার হলে আপনার চ্যাট একটি টিকিট রেফারেন্সসহ সংরক্ষণ করা হয়।',
      'ar':
          'استخدم Shift+Enter لسطر جديد. يتم حفظ محادثتك مع مرجع تذكرة عند الحاجة لدعم بشري.',
    },
    'Send message': {
      'bn': 'মেসেজ পাঠান',
      'ar': 'إرسال رسالة',
    },
    'Support status': {
      'bn': 'সাপোর্ট স্ট্যাটাস',
      'ar': 'حالة الدعم',
    },
    'Recent ticket activity and direct contact options.': {
      'bn': 'সাম্প্রতিক টিকিট কার্যক্রম এবং সরাসরি যোগাযোগের অপশন।',
      'ar': 'نشاط التذاكر الأخير وخيارات الاتصال المباشر.',
    },
    'No ticket created in this session yet. The bot can open one when needed.':
        {
      'bn':
          'এই সেশনে এখনো কোনো টিকিট তৈরি হয়নি। প্রয়োজন হলে বট একটি টিকিট খুলতে পারে।',
      'ar':
          'لم يتم إنشاء تذكرة في هذه الجلسة بعد. يمكن للروبوت فتح واحدة عند الحاجة.',
    },
    'Ticket reference: \$ticketReference': {
      'bn': 'টিকিট রেফারেন্স: \$ticketReference',
      'ar': 'مرجع التذكرة: \$ticketReference',
    },
    'My support tickets': {
      'bn': 'আমার সাপোর্ট টিকিটসমূহ',
      'ar': 'تذاكر الدعم الخاصة بي',
    },
    'Your latest requests, escalations, and ticket references.': {
      'bn': 'আপনার সর্বশেষ অনুরোধ, এস্কেলেশন এবং টিকিট রেফারেন্স।',
      'ar': 'أحدث طلباتك وتصعيداتك ومراجع التذاكر.',
    },
    'No support tickets yet.': {
      'bn': 'এখনো কোনো সাপোর্ট টিকিট নেই।',
      'ar': 'لا توجد تذاكر دعم بعد.',
    },
    'Get fast, account-aware support for plans, payments, verification, and match issues. Escalate to a human whenever you need.':
        {
      'bn':
          'প্ল্যান, পেমেন্ট, ভেরিফিকেশন এবং ম্যাচ সমস্যার জন্য দ্রুত, অ্যাকাউন্ট-সচেতন সাপোর্ট পান। প্রয়োজন হলে যেকোনো সময় মানুষকে যুক্ত করুন।',
      'ar':
          'احصل على دعم سريع ومدرك للحساب للخطط والمدفوعات والتحقق ومشكلات المطابقات. صعّد إلى دعم بشري متى احتجت.',
    },
    'Open email app': {
      'bn': 'ইমেইল অ্যাপ খুলুন',
      'ar': 'فتح تطبيق البريد',
    },
    'AI is thinking...': {
      'bn': 'এআই ভাবছে...',
      'ar': 'الذكاء الاصطناعي يفكر...',
    },
    'Send Connection': {
      'bn': 'কানেকশন পাঠান',
      'ar': 'إرسال طلب تواصل',
    },
    'Select Matches': {
      'bn': 'ম্যাচ নির্বাচন করুন',
      'ar': 'اختر المطابقات',
    },
    'Connection Sent': {
      'bn': 'কানেকশন পাঠানো হয়েছে',
      'ar': 'تم إرسال طلب التواصل',
    },
    'Connection Failed': {
      'bn': 'কানেকশন ব্যর্থ হয়েছে',
      'ar': 'فشل إرسال طلب التواصل',
    },
    'Contact Now': {
      'bn': 'এখন যোগাযোগ করুন',
      'ar': 'تواصل الآن',
    },
    'View on Accept': {
      'bn': 'স্বীকার করলে দেখুন',
      'ar': 'يظهر عند القبول',
    },
    'Photo Request': {
      'bn': 'ছবির অনুরোধ',
      'ar': 'طلب صورة',
    },
    'Walima Chat': {
      'bn': 'Walima চ্যাট',
      'ar': 'دردشة وليمة',
    },
    'Phone Call': {
      'bn': 'ফোন কল',
      'ar': 'مكالمة هاتفية',
    },
    'Whatsapp': {
      'bn': 'হোয়াটসঅ্যাপ',
      'ar': 'واتساب',
    },
    'Edit': {
      'bn': 'সম্পাদনা',
      'ar': 'تعديل',
    },
    'Set': {
      'bn': 'সেট করুন',
      'ar': 'تعيين',
    },
    'Skip': {
      'bn': 'এড়িয়ে যান',
      'ar': 'تخطي',
    },
    'Search': {
      'bn': 'খুঁজুন',
      'ar': 'بحث',
    },
    'to': {
      'bn': 'থেকে',
      'ar': 'إلى',
    },
    'Years': {
      'bn': 'বছর',
      'ar': 'سنة',
    },
    'Your Username': {
      'bn': 'আপনার ইউজারনেম',
      'ar': 'اسم المستخدم',
    },
    'Order Summary': {
      'bn': 'অর্ডার সারাংশ',
      'ar': 'ملخص الطلب',
    },
    'Credit (unused days)': {
      'bn': 'ক্রেডিট (অব্যবহৃত দিন)',
      'ar': 'رصيد (الأيام غير المستخدمة)',
    },
    'Discount': {
      'bn': 'ছাড়',
      'ar': 'خصم',
    },
    'Promote My Profile': {
      'bn': 'আমার প্রোফাইল প্রচার করুন',
      'ar': 'روّج لملفي الشخصي',
    },
    'ADD-ONS': {
      'bn': 'অ্যাড-অন',
      'ar': 'إضافات',
    },
    'Contribute to Walima.com': {
      'bn': 'Walima.com-এ অবদান রাখুন',
      'ar': 'ساهم في Walima.com',
    },
    'Total Amount': {
      'bn': 'মোট পরিমাণ',
      'ar': 'المبلغ الإجمالي',
    },
    'Continue to Pay': {
      'bn': 'পেমেন্টে যান',
      'ar': 'المتابعة للدفع',
    },
    'Proceed To Pay': {
      'bn': 'পেমেন্ট করুন',
      'ar': 'المتابعة إلى الدفع',
    },
    'Safety First': {
      'bn': 'নিরাপত্তা আগে',
      'ar': 'السلامة أولا',
    },
    'Take Your Time': {
      'bn': 'সময় নিন',
      'ar': 'خذ وقتك',
    },
    'Get to know someone well before taking the conversation offline.': {
      'bn': 'কথোপকথন অফলাইনে নেওয়ার আগে মানুষটিকে ভালোভাবে জানুন।',
      'ar': 'تعرّف إلى الشخص جيدا قبل نقل المحادثة خارج التطبيق.',
    },
    'Stay Alert': {
      'bn': 'সতর্ক থাকুন',
      'ar': 'ابق متنبها',
    },
    'Watch out for quick commitments or money requests. Keep your financial details private.':
        {
      'bn':
          'দ্রুত প্রতিশ্রুতি বা টাকা চাওয়ার বিষয়ে সতর্ক থাকুন। আপনার আর্থিক তথ্য গোপন রাখুন।',
      'ar':
          'انتبه للالتزامات السريعة أو طلبات المال. حافظ على سرية بياناتك المالية.',
    },
    'Report': {
      'bn': 'রিপোর্ট করুন',
      'ar': 'إبلاغ',
    },
    'Report the profile if you encounter offensive messages or anything suspicious.':
        {
      'bn': 'আপত্তিকর বার্তা বা সন্দেহজনক কিছু দেখলে প্রোফাইলটি রিপোর্ট করুন।',
      'ar': 'أبلغ عن الملف إذا واجهت رسائل مسيئة أو أي شيء مريب.',
    },
    'Get More Safety Tips': {
      'bn': 'আরও নিরাপত্তা টিপস দেখুন',
      'ar': 'احصل على المزيد من نصائح السلامة',
    },
    'Matched': {
      'bn': 'ম্যাচ হয়েছে',
      'ar': 'متطابق',
    },
    'Preferences Analysis': {
      'bn': 'পছন্দ বিশ্লেষণ',
      'ar': 'تحليل التفضيلات',
    },
    'Seeking a genuine connection': {
      'bn': 'একটি আন্তরিক সম্পর্ক খুঁজছেন',
      'ar': 'البحث عن علاقة حقيقية',
    },
    'No comparison criteria available.': {
      'bn': 'কোনো তুলনা মানদণ্ড নেই।',
      'ar': 'لا توجد معايير مقارنة متاحة.',
    },
    'Compatibility level not available.': {
      'bn': 'সামঞ্জস্যতার স্তর পাওয়া যায়নি।',
      'ar': 'مستوى التوافق غير متاح.',
    },
    'Account Setting': {
      'bn': 'অ্যাকাউন্ট সেটিং',
      'ar': 'إعدادات الحساب',
    },
    'Name And Email Update': {
      'bn': 'নাম ও ইমেইল আপডেট',
      'ar': 'تحديث الاسم والبريد الإلكتروني',
    },
    'My Contact Settings': {
      'bn': 'আমার যোগাযোগ সেটিংস',
      'ar': 'إعدادات التواصل الخاصة بي',
    },
    'Premium Membership': {
      'bn': 'প্রিমিয়াম সদস্যতা',
      'ar': 'العضوية المميزة',
    },
    'Email/SMS Alerts': {
      'bn': 'ইমেইল/SMS অ্যালার্ট',
      'ar': 'تنبيهات البريد/SMS',
    },
    'Messages': {
      'bn': 'বার্তা',
      'ar': 'الرسائل',
    },
    'Manage Messages': {
      'bn': 'বার্তা পরিচালনা',
      'ar': 'إدارة الرسائل',
    },
    'Change Password': {
      'bn': 'পাসওয়ার্ড পরিবর্তন',
      'ar': 'تغيير كلمة المرور',
    },
    'Set Password': {
      'bn': 'পাসওয়ার্ড সেট করুন',
      'ar': 'تعيين كلمة المرور',
    },
    'Privacy Options': {
      'bn': 'গোপনীয়তা অপশন',
      'ar': 'خيارات الخصوصية',
    },
    'Privacy Settings': {
      'bn': 'গোপনীয়তা সেটিংস',
      'ar': 'إعدادات الخصوصية',
    },
    'Hide/Delete Profile': {
      'bn': 'প্রোফাইল লুকান/মুছুন',
      'ar': 'إخفاء/حذف الملف الشخصي',
    },
    'Auto-renew my Plan': {
      'bn': 'আমার প্ল্যান অটো-রিনিউ করুন',
      'ar': 'تجديد خطتي تلقائيا',
    },
    'What is auto-renewal?': {
      'bn': 'অটো-রিনিউ কী?',
      'ar': 'ما هو التجديد التلقائي؟',
    },
    'Current Plan:': {
      'bn': 'বর্তমান প্ল্যান:',
      'ar': 'الخطة الحالية:',
    },
    'Hide Profile': {
      'bn': 'প্রোফাইল লুকান',
      'ar': 'إخفاء الملف الشخصي',
    },
    'Hiding your profile makes you invisible and disables messages and invitations':
        {
      'bn': 'প্রোফাইল লুকালে আপনি অদৃশ্য থাকবেন এবং বার্তা ও আমন্ত্রণ বন্ধ হবে',
      'ar': 'إخفاء ملفك يجعلك غير مرئي ويعطل الرسائل والدعوات',
    },
    'Visibility Preferences': {
      'bn': 'দৃশ্যমানতার পছন্দ',
      'ar': 'تفضيلات الظهور',
    },
    'Manage how others discover and connect with you': {
      'bn': 'অন্যরা কীভাবে আপনাকে খুঁজে পাবে ও যোগাযোগ করবে তা নিয়ন্ত্রণ করুন',
      'ar': 'تحكم في كيفية اكتشاف الآخرين لك والتواصل معك',
    },
    'Shortlist Alerts': {
      'bn': 'শর্টলিস্ট অ্যালার্ট',
      'ar': 'تنبيهات القائمة المختصرة',
    },
    'Notify me when someone shortlists my profile': {
      'bn': 'কেউ আমার প্রোফাইল শর্টলিস্ট করলে জানান',
      'ar': 'أخبرني عندما يضيف شخص ملفي إلى القائمة المختصرة',
    },
    'Premium Calls': {
      'bn': 'প্রিমিয়াম কল',
      'ar': 'مكالمات مميزة',
    },
    'Allow premium members to call me directly': {
      'bn': 'প্রিমিয়াম সদস্যদের আমাকে সরাসরি কল করতে দিন',
      'ar': 'السماح للأعضاء المميزين بالاتصال بي مباشرة',
    },
    'Delete Profile': {
      'bn': 'প্রোফাইল মুছুন',
      'ar': 'حذف الملف الشخصي',
    },
    "You'll permanently lose all profile data, matches, and memberships": {
      'bn': 'আপনি স্থায়ীভাবে সব প্রোফাইল ডেটা, ম্যাচ ও সদস্যতা হারাবেন',
      'ar': 'ستفقد جميع بيانات الملف والتطابقات والعضويات نهائيا',
    },
    'Primary': {
      'bn': 'প্রাথমিক',
      'ar': 'أساسي',
    },
    'Contact Display Status': {
      'bn': 'যোগাযোগ প্রদর্শনের অবস্থা',
      'ar': 'حالة عرض بيانات التواصل',
    },
    'No privacy settings available': {
      'bn': 'কোনো গোপনীয়তা সেটিংস নেই',
      'ar': 'لا توجد إعدادات خصوصية متاحة',
    },
    'Display Name': {
      'bn': 'প্রদর্শিত নাম',
      'ar': 'اسم العرض',
    },
    'Show Full Name': {
      'bn': 'পূর্ণ নাম দেখান',
      'ar': 'إظهار الاسم الكامل',
    },
    'Hide First Name': {
      'bn': 'নামের প্রথম অংশ লুকান',
      'ar': 'إخفاء الاسم الأول',
    },
    'Hide Last Name': {
      'bn': 'নামের শেষ অংশ লুকান',
      'ar': 'إخفاء اسم العائلة',
    },
    'Hide Full Name': {
      'bn': 'পূর্ণ নাম লুকান',
      'ar': 'إخفاء الاسم الكامل',
    },
    'Customize the message sent to members.': {
      'bn': 'সদস্যদের পাঠানো বার্তাটি কাস্টমাইজ করুন।',
      'ar': 'خصص الرسالة المرسلة إلى الأعضاء.',
    },
    'Premium Visitors Email': {
      'bn': 'প্রিমিয়াম ভিজিটর ইমেইল',
      'ar': 'بريد زوار العضوية المميزة',
    },
    'Contact Filter': {
      'bn': 'যোগাযোগ ফিল্টার',
      'ar': 'فلتر التواصل',
    },
    'Age Range': {
      'bn': 'বয়স সীমা',
      'ar': 'نطاق العمر',
    },
    'Height Range': {
      'bn': 'উচ্চতার সীমা',
      'ar': 'نطاق الطول',
    },
    'Marital Status Preference': {
      'bn': 'বৈবাহিক অবস্থার পছন্দ',
      'ar': 'تفضيل الحالة الاجتماعية',
    },
    'Education Preference': {
      'bn': 'শিক্ষাগত পছন্দ',
      'ar': 'تفضيل التعليم',
    },
    'Religion Preference': {
      'bn': 'ধর্মের পছন্দ',
      'ar': 'تفضيل الديانة',
    },
    'Preferred Location': {
      'bn': 'পছন্দের স্থান',
      'ar': 'الموقع المفضل',
    },
    'Enter Education Preference': {
      'bn': 'শিক্ষাগত পছন্দ লিখুন',
      'ar': 'أدخل تفضيل التعليم',
    },
    'Enter Religion Preference': {
      'bn': 'ধর্মের পছন্দ লিখুন',
      'ar': 'أدخل تفضيل الديانة',
    },
    'Open To All': {
      'bn': 'সবার জন্য উন্মুক্ত',
      'ar': 'مفتوح للجميع',
    },
    'Never Married': {
      'bn': 'অবিবাহিত',
      'ar': 'لم يسبق له الزواج',
    },
    'Married': {
      'bn': 'বিবাহিত',
      'ar': 'متزوج',
    },
    'Divorced': {
      'bn': 'তালাকপ্রাপ্ত',
      'ar': 'مطلق',
    },
    'Widowed': {
      'bn': 'বিধবা/বিপত্নীক',
      'ar': 'أرمل',
    },
    'Separated': {
      'bn': 'আলাদা',
      'ar': 'منفصل',
    },
    'Awaiting Divorce': {
      'bn': 'তালাক প্রক্রিয়াধীন',
      'ar': 'بانتظار الطلاق',
    },
    'Annulled': {
      'bn': 'বিবাহ বাতিল',
      'ar': 'فسخ الزواج',
    },
    'Partner Expectations': {
      'bn': 'সঙ্গীর প্রত্যাশা',
      'ar': 'توقعات الشريك',
    },
    'Diet Preference': {
      'bn': 'খাদ্যাভ্যাসের পছন্দ',
      'ar': 'تفضيل النظام الغذائي',
    },
    'Smoking': {
      'bn': 'ধূমপান',
      'ar': 'التدخين',
    },
    'Drinking': {
      'bn': 'মদ্যপান',
      'ar': 'شرب الكحول',
    },
    'expectation': {
      'bn': 'প্রত্যাশা',
      'ar': 'التوقع',
    },
    'Write what you expect from your partner': {
      'bn': 'আপনি আপনার সঙ্গীর কাছ থেকে কী প্রত্যাশা করেন লিখুন',
      'ar': 'اكتب ما تتوقعه من شريكك',
    },
    'Religion': {
      'bn': 'ধর্ম',
      'ar': 'الدين',
    },
    'Mother Tongue': {
      'bn': 'মাতৃভাষা',
      'ar': 'اللغة الأم',
    },
    'Country Living In': {
      'bn': 'যে দেশে থাকেন',
      'ar': 'بلد الإقامة',
    },
    'Select Country': {
      'bn': 'দেশ নির্বাচন করুন',
      'ar': 'اختر الدولة',
    },
    'Working With': {
      'bn': 'যেখানে কাজ করেন',
      'ar': 'جهة العمل',
    },
    'Annual Income': {
      'bn': 'বার্ষিক আয়',
      'ar': 'الدخل السنوي',
    },
    'Select Annual Income': {
      'bn': 'বার্ষিক আয় নির্বাচন করুন',
      'ar': 'اختر الدخل السنوي',
    },
    'No cities available for the selected country.': {
      'bn': 'নির্বাচিত দেশের জন্য কোনো শহর পাওয়া যায়নি।',
      'ar': 'لا توجد مدن متاحة للدولة المحددة.',
    },
    'Select religion first to load community options.': {
      'bn': 'কমিউনিটি অপশন লোড করতে আগে ধর্ম নির্বাচন করুন।',
      'ar': 'اختر الدين أولا لتحميل خيارات المجتمع.',
    },
    'Search community': {
      'bn': 'কমিউনিটি খুঁজুন',
      'ar': 'ابحث عن المجتمع',
    },
    'Search mother tongue': {
      'bn': 'মাতৃভাষা খুঁজুন',
      'ar': 'ابحث عن اللغة الأم',
    },
    'No matching items found': {
      'bn': 'মিল পাওয়া যায়নি',
      'ar': 'لم يتم العثور على عناصر مطابقة',
    },
    'Select a 2-year minimum age range': {
      'bn': 'কমপক্ষে ২ বছরের বয়স সীমা নির্বাচন করুন',
      'ar': 'اختر نطاق عمر لا يقل عن سنتين',
    },
    'Select a 4-inch minimum height range': {
      'bn': 'কমপক্ষে ৪ ইঞ্চি উচ্চতার সীমা নির্বাচন করুন',
      'ar': 'اختر نطاق طول لا يقل عن 4 بوصات',
    },
    'Help Center': {
      'bn': 'হেল্প সেন্টার',
      'ar': 'مركز المساعدة',
    },
    'My Walima': {
      'bn': 'আমার Walima',
      'ar': 'وليمتي',
    },
    'Profiles Found': {
      'bn': 'টি প্রোফাইল পাওয়া গেছে',
      'ar': 'ملفات شخصية تم العثور عليها',
    },
    'Fetching premium matches': {
      'bn': 'প্রিমিয়াম ম্যাচ লোড হচ্ছে',
      'ar': 'جارٍ جلب المطابقات المميزة',
    },
    'Premium Matches': {
      'bn': 'প্রিমিয়াম ম্যাচ',
      'ar': 'المطابقات المميزة',
    },
    'View All': {
      'bn': 'সব দেখুন',
      'ar': 'عرض الكل',
    },
    'No premium matches available yet.': {
      'bn': 'এখনও কোনো প্রিমিয়াম ম্যাচ নেই।',
      'ar': 'لا توجد مطابقات مميزة متاحة بعد.',
    },
    'recent visitors': {
      'bn': 'সাম্প্রতিক ভিজিটর',
      'ar': 'الزوار الجدد',
    },
    'premium matches': {
      'bn': 'প্রিমিয়াম ম্যাচ',
      'ar': 'المطابقات المميزة',
    },
    'Upgrade Your Plan': {
      'bn': 'আপনার প্ল্যান আপগ্রেড করুন',
      'ar': 'قم بترقية خطتك',
    },
    'See': {
      'bn': 'দেখুন',
      'ar': 'شاهد',
    },
    'more': {
      'bn': 'আরও',
      'ar': 'المزيد',
    },
    'Upgrade Now': {
      'bn': 'এখনই আপগ্রেড করুন',
      'ar': 'قم بالترقية الآن',
    },
    'Walima Member': {
      'bn': 'Walima সদস্য',
      'ar': 'عضو وليمة',
    },
    'Undefine': {
      'bn': 'অজানা',
      'ar': 'غير محدد',
    },
    'Yr': {
      'bn': 'বছর',
      'ar': 'سنة',
    },
    'Unknown': {
      'bn': 'অজানা',
      'ar': 'غير معروف',
    },
    'Online': {
      'bn': 'অনলাইন',
      'ar': 'متصل',
    },
    'Offline': {
      'bn': 'অফলাইন',
      'ar': 'غير متصل',
    },
    'Loading recent visitors': {
      'bn': 'সাম্প্রতিক ভিজিটর লোড হচ্ছে',
      'ar': 'جارٍ تحميل الزوار الجدد',
    },
    'Recent Visitors': {
      'bn': 'সাম্প্রতিক ভিজিটর',
      'ar': 'الزوار الجدد',
    },
    'No recent visitors yet.': {
      'bn': 'এখনও কোনো সাম্প্রতিক ভিজিটর নেই।',
      'ar': 'لا يوجد زوار جدد بعد.',
    },
    'Follow Us on': {
      'bn': 'আমাদের অনুসরণ করুন',
      'ar': 'تابعنا على',
    },
    'Stay inspired follow us on social media': {
      'bn': 'অনুপ্রাণিত থাকুন, সোশ্যাল মিডিয়ায় আমাদের ফলো করুন',
      'ar': 'ابق ملهمًا وتابعنا على وسائل التواصل الاجتماعي',
    },
    'Instagram': {
      'bn': 'ইনস্টাগ্রাম',
      'ar': 'إنستغرام',
    },
    'Facebook': {
      'bn': 'ফেসবুক',
      'ar': 'فيسبوك',
    },
    'X': {
      'bn': 'এক্স',
      'ar': 'إكس',
    },
    'API Not Responding': {
      'bn': 'API সাড়া দিচ্ছে না',
      'ar': 'واجهة API لا تستجيب',
    },
    'OK': {
      'bn': 'ঠিক আছে',
      'ar': 'حسنًا',
    },
    'Remind': {
      'bn': 'রিমাইন্ড',
      'ar': 'تذكير',
    },
    'Educational Background': {
      'bn': 'শিক্ষাগত পটভূমি',
      'ar': 'الخلفية التعليمية',
    },
    'Share your qualifications': {
      'bn': 'আপনার যোগ্যতা শেয়ার করুন',
      'ar': 'شارك مؤهلاتك',
    },
    'Select Highest Qualification': {
      'bn': 'সর্বোচ্চ যোগ্যতা নির্বাচন করুন',
      'ar': 'اختر أعلى مؤهل',
    },
    'Verify & Log In': {
      'bn': 'যাচাই করুন ও লগইন করুন',
      'ar': 'تحقق وسجل الدخول',
    },
    'Upgrade Plan': {
      'bn': 'প্ল্যান আপগ্রেড',
      'ar': 'ترقية الخطة',
    },
    'Error Loading Sent Requests': {
      'bn': 'পাঠানো রিকোয়েস্ট লোড করতে ত্রুটি',
      'ar': 'خطأ في تحميل الطلبات المرسلة',
    },
    'Unable to load your sent connection requests': {
      'bn': 'আপনার পাঠানো কানেকশন রিকোয়েস্ট লোড করা যায়নি',
      'ar': 'تعذر تحميل طلبات التواصل المرسلة',
    },
    'No Sent Requests': {
      'bn': 'কোনো পাঠানো রিকোয়েস্ট নেই',
      'ar': 'لا توجد طلبات مرسلة',
    },
    'Your sent connection requests will appear here': {
      'bn': 'আপনার পাঠানো কানেকশন রিকোয়েস্ট এখানে দেখাবে',
      'ar': 'ستظهر طلبات التواصل المرسلة هنا',
    },
    'Filter My Sent Requests': {
      'bn': 'আমার পাঠানো রিকোয়েস্ট ফিল্টার করুন',
      'ar': 'تصفية طلباتي المرسلة',
    },
    'No Views on Your Contact!': {
      'bn': 'আপনার কন্টাক্টে কোনো ভিউ নেই!',
      'ar': 'لا توجد مشاهدات على جهة اتصالك!',
    },
    'Take the next step, check out more profiles to find your perfect match!': {
      'bn':
          'পরবর্তী ধাপ নিন, আরও প্রোফাইল দেখুন এবং আপনার উপযুক্ত ম্যাচ খুঁজুন!',
      'ar':
          'اتخذ الخطوة التالية، واستعرض المزيد من الملفات للعثور على التطابق المناسب!',
    },
    'View My Matches': {
      'bn': 'আমার ম্যাচ দেখুন',
      'ar': 'عرض تطابقاتي',
    },
    'Join Walima Now': {
      'bn': 'এখনই Walima-তে যোগ দিন',
      'ar': 'انضم إلى وليمة الآن',
    },
    "Let's set up your account, while we fund Matches for you!": {
      'bn':
          'চলুন আপনার অ্যাকাউন্ট সেটআপ করি, আর আমরা আপনার জন্য ম্যাচ ফান্ড করি!',
      'ar': 'لنقم بإعداد حسابك بينما نوفر لك المطابقات!',
    },
    'Send OTP': {
      'bn': 'OTP পাঠান',
      'ar': 'إرسال رمز التحقق',
    },
    'Used': {
      'bn': 'ব্যবহৃত',
      'ar': 'المستخدم',
    },
    'Limit': {
      'bn': 'সীমা',
      'ar': 'الحد',
    },
    'Remaining': {
      'bn': 'অবশিষ্ট',
      'ar': 'المتبقي',
    },
    'Extend Plan': {
      'bn': 'প্ল্যান বাড়ান',
      'ar': 'تمديد الخطة',
    },
    'Partner Location Preference': {
      'bn': 'সঙ্গীর লোকেশন পছন্দ',
      'ar': 'تفضيل موقع الشريك',
    },
    'Select Preferable Country Living In': {
      'bn': 'পছন্দের বসবাসের দেশ নির্বাচন করুন',
      'ar': 'اختر بلد الإقامة المفضل',
    },
    "Partner's Work & Income": {
      'bn': 'সঙ্গীর কাজ ও আয়',
      'ar': 'عمل ودخل الشريك',
    },
    'What career does your ideal prefer have': {
      'bn': 'আপনার পছন্দের সঙ্গীর কী ধরনের ক্যারিয়ার হওয়া উচিত',
      'ar': 'ما المسار المهني الذي تفضله في الشريك المثالي',
    },
    'Select Profession': {
      'bn': 'পেশা নির্বাচন করুন',
      'ar': 'اختر المهنة',
    },
    "Partner's Education": {
      'bn': 'সঙ্গীর শিক্ষা',
      'ar': 'تعليم الشريك',
    },
    'What qualifications do you prefer': {
      'bn': 'আপনি কী ধরনের যোগ্যতা পছন্দ করেন',
      'ar': 'ما المؤهلات التي تفضلها',
    },
    'Preference Religion': {
      'bn': 'পছন্দের ধর্ম',
      'ar': 'تفضيل الدين',
    },
    'Select Religion': {
      'bn': 'ধর্ম নির্বাচন করুন',
      'ar': 'اختر الدين',
    },
    'Select Community': {
      'bn': 'কমিউনিটি নির্বাচন করুন',
      'ar': 'اختر المجتمع',
    },
    'Select Mother Tongue': {
      'bn': 'মাতৃভাষা নির্বাচন করুন',
      'ar': 'اختر اللغة الأم',
    },
    'Education Qualification': {
      'bn': 'শিক্ষাগত যোগ্যতা',
      'ar': 'المؤهل التعليمي',
    },
    'Working As': {
      'bn': 'কর্মক্ষেত্র',
      'ar': 'العمل كـ',
    },
    'Preference Details': {
      'bn': 'পছন্দের বিবরণ',
      'ar': 'تفاصيل التفضيلات',
    },
    'Choose your preferred age, height, and marital status for recommended matches.':
        {
      'bn':
          'রেকমেন্ডেড ম্যাচের জন্য আপনার পছন্দের বয়স, উচ্চতা ও বৈবাহিক অবস্থা নির্বাচন করুন।',
      'ar': 'اختر العمر والطول والحالة الاجتماعية المفضلة للمطابقات المقترحة.',
    },
    'Call Her': {
      'bn': 'তাকে কল করুন',
      'ar': 'اتصل بها',
    },
    'View Plan': {
      'bn': 'প্ল্যান দেখুন',
      'ar': 'عرض الخطة',
    },
    'Call': {
      'bn': 'কল',
      'ar': 'اتصال',
    },
    'Send Message': {
      'bn': 'বার্তা পাঠান',
      'ar': 'إرسال رسالة',
    },
    'No Selection': {
      'bn': 'কোনো নির্বাচন নেই',
      'ar': 'لا يوجد اختيار',
    },
    'To': {
      'bn': 'পর্যন্ত',
      'ar': 'إلى',
    },
    'Age To': {
      'bn': 'বয়স শেষ',
      'ar': 'العمر إلى',
    },
    'Height From': {
      'bn': 'উচ্চতা শুরু',
      'ar': 'الطول من',
    },
    'Height To': {
      'bn': 'উচ্চতা শেষ',
      'ar': 'الطول إلى',
    },
    'Include Filtered Profiles': {
      'bn': 'ফিল্টার করা প্রোফাইলও অন্তর্ভুক্ত করুন',
      'ar': 'تضمين الملفات التي قامت بتصفيتي',
    },
    'Include profiles that filtered me out as well.': {
      'bn': 'যারা আমাকে ফিল্টার করেছে তাদের প্রোফাইলও অন্তর্ভুক্ত করুন।',
      'ar': 'قم أيضًا بتضمين الملفات التي قامت بتصفيتي.',
    },
    'Include Viewed Profiles': {
      'bn': 'দেখা প্রোফাইল অন্তর্ভুক্ত করুন',
      'ar': 'تضمين الملفات التي تمت مشاهدتها',
    },
    'Include profiles that i have already viewed': {
      'bn': 'যে প্রোফাইলগুলো আমি আগে দেখেছি সেগুলো অন্তর্ভুক্ত করুন',
      'ar': 'تضمين الملفات التي شاهدتها مسبقًا',
    },
    'Show Matches': {
      'bn': 'ম্যাচ দেখান',
      'ar': 'عرض التطابقات',
    },
    'More Matches': {
      'bn': 'আরও ম্যাচ',
      'ar': 'المزيد من التطابقات',
    },
    'Profiles Matching Your Preferences': {
      'bn': 'আপনার পছন্দের সাথে মেলে এমন প্রোফাইল',
      'ar': 'ملفات تطابق تفضيلاتك',
    },
    'State Living In': {
      'bn': 'যে রাজ্যে থাকেন',
      'ar': 'الولاية المقيم بها',
    },
    'Eating Habits': {
      'bn': 'খাদ্যাভ্যাস',
      'ar': 'عادات الأكل',
    },
  };
}
