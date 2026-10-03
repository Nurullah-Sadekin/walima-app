// ignore_for_file: unused_element_parameter

abstract interface class ApiUiEnum {
  String get apiValue;
  String get label;
}

class EnumKeyPair<T extends ApiUiEnum> {
  const EnumKeyPair({
    required this.enumValue,
    required this.apiValue,
    required this.uiValue,
  });

  final T enumValue;
  final String apiValue;
  final String uiValue;
}

class EnumMapper {
  const EnumMapper._();

  static List<EnumKeyPair<T>> keyPairs<T extends ApiUiEnum>(
    Iterable<T> values,
  ) {
    return values
        .map(
          (value) => EnumKeyPair<T>(
            enumValue: value,
            apiValue: value.apiValue,
            uiValue: value.label,
          ),
        )
        .toList(growable: false);
  }

  static T? fromApiValue<T extends ApiUiEnum>(
    String? raw,
    Iterable<T> values, {
    Map<String, T>? aliases,
  }) {
    final normalized = _normalize(raw);
    if (normalized == null) return null;

    final aliasedValue = aliases?[normalized];
    if (aliasedValue != null) return aliasedValue;

    for (final value in values) {
      if (_normalize(value.apiValue) == normalized) {
        return value;
      }
    }

    return null;
  }

  static T? fromUiValue<T extends ApiUiEnum>(
    String? raw,
    Iterable<T> values, {
    Map<String, T>? aliases,
  }) {
    final normalized = _normalize(raw);
    if (normalized == null) return null;

    final aliasedValue = aliases?[normalized];
    if (aliasedValue != null) return aliasedValue;

    for (final value in values) {
      if (_normalize(value.label) == normalized) {
        return value;
      }
    }

    return null;
  }

  static String? toApiValue(ApiUiEnum? value) => value?.apiValue;

  static String? toUiValue(ApiUiEnum? value) => value?.label;

  static String labelFromValue(String raw) => _EnumLabelFormatter.humanize(raw);

  static String? _normalize(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;

    return trimmed.toLowerCase().replaceAll(RegExp(r'[\s-]+'), '_');
  }
}

extension ApiUiEnumIterableX<T extends ApiUiEnum> on Iterable<T> {
  List<EnumKeyPair<T>> get keyPairs => EnumMapper.keyPairs(this);

  T? byApiValue(String? raw, {Map<String, T>? aliases}) {
    return EnumMapper.fromApiValue(raw, this, aliases: aliases);
  }

  T? byUiValue(String? raw, {Map<String, T>? aliases}) {
    return EnumMapper.fromUiValue(raw, this, aliases: aliases);
  }
}

class _EnumLabelFormatter {
  static const Map<String, String> _specialTokens = <String, String>{
    'api': 'API',
    'otp': 'OTP',
    'ios': 'iOS',
    'imo': 'IMO',
    'phd': 'PhD',
    'bkash': 'bKash',
    'sslcommerz': 'SSLCommerz',
    'whatsapp': 'WhatsApp',
    'linkedin': 'LinkedIn',
  };

  static String humanize(String raw) {
    final normalized = raw.trim().replaceAll(RegExp(r'[_-]+'), ' ');
    if (normalized.isEmpty) return raw;

    return normalized
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map(_formatToken)
        .join(' ');
  }

  static String _formatToken(String token) {
    final special = _specialTokens[token.toLowerCase()];
    if (special != null) return special;

    if (RegExp(r'^[A-Z0-9+]+$').hasMatch(token)) return token;

    final lower = token.toLowerCase();
    return '${lower[0].toUpperCase()}${lower.substring(1)}';
  }
}

enum GlobalStatus {
  initial,
  loading,
  success,
  failure,
}

enum ConnectionRequestType implements ApiUiEnum {
  interest('interest'),
  connection('connection'),
  match('match');

  const ConnectionRequestType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum RegistrationMaritalStatus implements ApiUiEnum {
  openToAll('open_to_all'),
  neverMarried('never_married'),
  married('married'),
  divorced('divorced'),
  widowed('widowed'),
  separated('separated'),
  awaitingDivorce('awaiting_divorce'),
  annulled('annulled');

  const RegistrationMaritalStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum RegistrationDiet implements ApiUiEnum {
  halalOnly('halal_only', 'Halal Only'),
  vegetarian('vegetarian'),
  occasionallyNonVeg('occasionally_non_veg', 'Occasionally Non-Veg'),
  jainVegetarian('jain_vegetarian', 'Jain Vegetarian'),
  nonVegetarian('non_vegetarian', 'Non-Vegetarian'),
  vegan('vegan');

  const RegistrationDiet(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum RegistrationFamilyEconomicCondition implements ApiUiEnum {
  eliteClass('elite_class'),
  upperClass('upper_class'),
  middleClass('middle_class'),
  lowerMiddleClass('lower_middle_class');

  const RegistrationFamilyEconomicCondition(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum RegistrationProfileManagedBy implements ApiUiEnum {
  self('self'),
  parent('parent'),
  sibling('sibling'),
  relative('relative'),
  friend('friend'),
  other('other');

  const RegistrationProfileManagedBy(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum MessageType implements ApiUiEnum {
  text('text'),
  image('image'),
  file('file'),
  video('video'),
  audio('audio');

  const MessageType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ChatMessageType implements ApiUiEnum {
  text('text'),
  image('image'),
  video('video'),
  audio('audio'),
  document('document');

  const ChatMessageType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum PhotoVisibilityDecision implements ApiUiEnum {
  visible('visible'),
  requestRequired('request_required'),
  premiumRequired('premium_required'),
  connectRequired('connect_required'),
  hidden('hidden');

  const PhotoVisibilityDecision(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ConversationStatus implements ApiUiEnum {
  active('active'),
  archived('archived'),
  blocked('blocked');

  const ConversationStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ConversationType implements ApiUiEnum {
  direct('direct'),
  group('group');

  const ConversationType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ConnectionAction implements ApiUiEnum {
  respond('respond'),
  cancel('cancel'),
  block('block'),
  update('update');

  const ConnectionAction(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ConnectionRequestStatus implements ApiUiEnum {
  pending('pending'),
  accepted('accept', 'Accepted'),
  rejected('reject', 'Rejected'),
  cancelled('cancel', 'Cancelled'),
  blocked('block', 'Blocked');

  const ConnectionRequestStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ServerConnectionRequestType implements ApiUiEnum {
  interest('interest'),
  connection('connection'),
  match('match');

  const ServerConnectionRequestType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum EngagementType implements ApiUiEnum {
  recentVisitors('recent_visitors'),
  recentlyViewed('recently_viewed'),
  mutualViews('mutual_views');

  const EngagementType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum EngagementResponseFormat implements ApiUiEnum {
  full('full'),
  short('short');

  const EngagementResponseFormat(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum EventStatus implements ApiUiEnum {
  upcoming('upcoming'),
  ongoing('ongoing'),
  completed('completed');

  const EventStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum DisplayNameFormat implements ApiUiEnum {
  hideFirstName('hide_first_name'),
  hideLastName('hide_last_name'),
  hideEmailAddress('hide_email_address'),
  hideFullName('hide_full_name'),
  showFullName('show_full_name');

  const DisplayNameFormat(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ProfilePhotoVisibility implements ApiUiEnum {
  visibleToAll('visible_to_all'),
  visibleToPremiumAndLiked('visible_to_premium_and_liked'),
  visibleOnConnect('visible_on_connect'),
  visibleToLikedOnly('visible_to_liked_only');

  const ProfilePhotoVisibility(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum AlbumPhotoVisibility implements ApiUiEnum {
  visibleToAll('visible_to_all'),
  visibleToPremiumAndLiked('visible_to_premium_and_liked'),
  visibleOnConnect('visible_on_connect'),
  visibleToLikedOnly('visible_to_liked_only');

  const AlbumPhotoVisibility(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum PhoneVisibility implements ApiUiEnum {
  onlyPremiumMembers('only_premium_members'),
  onlyPremiumMembersILike('only_premium_members_i_like'),
  noOne('no_one'),
  allMatches('all_matches');

  const PhoneVisibility(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum EmailVisibility implements ApiUiEnum {
  visibleToAllPremiumMembers('visible_to_all_premium_members'),
  visibleToPremiumAndWishToConnect('visible_to_premium_and_wish_to_connect'),
  hideEmailAddress('hide_email_address'),
  visibleToAllMatches('visible_to_all_matches');

  const EmailVisibility(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum DobDisplay implements ApiUiEnum {
  monthAndYearOnly('month_and_year_only'),
  fullDob('full_dob', 'Full DOB');

  const DobDisplay(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum IncomeVisibility implements ApiUiEnum {
  visibleToAll('visible_to_all'),
  hidden('hidden');

  const IncomeVisibility(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ProfilePrivacy implements ApiUiEnum {
  visibleToAllVisitors('visible_to_all_visitors'),
  visibleToRegisteredMembers('visible_to_registered_members');

  const ProfilePrivacy(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum HideDuration implements ApiUiEnum {
  oneWeek('1_week', '1 Week'),
  twoWeeks('2_weeks', '2 Weeks'),
  oneMonth('1_month', '1 Month'),
  untilITurnOn('until_i_turn_on', 'Until I Turn On');

  const HideDuration(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum DeleteReason implements ApiUiEnum {
  takingABreak('taking_a_break'),
  unsatisfactoryExperience('unsatisfactory_experience'),
  reasonNotMentioned('reason_not_mentioned');

  const DeleteReason(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum BloodGroup implements ApiUiEnum {
  aPositive('A+', 'A+'),
  aNegative('A-', 'A-'),
  bPositive('B+', 'B+'),
  bNegative('B-', 'B-'),
  abPositive('AB+', 'AB+'),
  abNegative('AB-', 'AB-'),
  oPositive('O+', 'O+'),
  oNegative('O-', 'O-'),
  unknown('unknown');

  const BloodGroup(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum Complexion implements ApiUiEnum {
  veryFair('very_fair'),
  fair('fair'),
  wheatish('wheatish'),
  wheatishBrown('wheatish_brown'),
  dark('dark');

  const Complexion(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum BodyType implements ApiUiEnum {
  slim('slim'),
  average('average'),
  athletic('athletic'),
  heavy('heavy');

  const BodyType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum HealthCondition implements ApiUiEnum {
  normal('normal'),
  anyIllness('any_illness'),
  disability('disability'),
  specialRequirement('special_requirement');

  const HealthCondition(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ContactType implements ApiUiEnum {
  phone('phone'),
  email('email'),
  whatsapp('whatsapp'),
  telegram('telegram'),
  skype('skype'),
  viber('viber'),
  imo('imo', 'IMO'),
  facebook('facebook'),
  instagram('instagram'),
  linkedin('linkedin', 'LinkedIn'),
  others('others');

  const ContactType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ContactOwner implements ApiUiEnum {
  self('self'),
  parent('parent'),
  sibling('sibling'),
  relative('relative'),
  friend('friend'),
  others('others');

  const ContactOwner(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum EducationLevel implements ApiUiEnum {
  noFormalEducation('no_formal_education'),
  primary('primary'),
  secondary('secondary'),
  higherSecondary('higher_secondary'),
  diploma('diploma'),
  bachelor('bachelor'),
  masters('masters', 'Masters'),
  phd('phd', 'PhD'),
  doctorate('doctorate'),
  professionalDegree('professional_degree'),
  vocationalTraining('vocational_training'),
  certificate('certificate'),
  others('others');

  const EducationLevel(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum FamilyType implements ApiUiEnum {
  nuclear('nuclear'),
  joint('joint'),
  others('others');

  const FamilyType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum FamilyValues implements ApiUiEnum {
  traditional('traditional'),
  moderate('moderate'),
  liberal('liberal');

  const FamilyValues(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum FamilyEconomicCondition implements ApiUiEnum {
  eliteClass('elite_class'),
  upperClass('upper_class'),
  middleClass('middle_class'),
  lowerMiddleClass('lower_middle_class');

  const FamilyEconomicCondition(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum FamilyMaritalStatus implements ApiUiEnum {
  single('single'),
  married('married'),
  divorced('divorced'),
  widowed('widowed');

  const FamilyMaritalStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum DietType implements ApiUiEnum {
  vegetarian('vegetarian'),
  nonVegetarian('non_vegetarian', 'Non-Vegetarian'),
  halalOnly('halal_only', 'Halal Only'),
  vegan('vegan'),
  jainVegetarian('jain_vegetarian', 'Jain Vegetarian'),
  occasionallyNonVeg('occasionally_non_veg', 'Occasionally Non-Veg');

  const DietType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum DrinkingHabits implements ApiUiEnum {
  never('never'),
  occasionally('occasionally'),
  socially('socially'),
  regularly('regularly'),
  preferNotToSay('prefer_not_to_say');

  const DrinkingHabits(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum SmokingHabits implements ApiUiEnum {
  never('never'),
  occasionally('occasionally'),
  socially('socially'),
  regularly('regularly'),
  preferNotToSay('prefer_not_to_say');

  const SmokingHabits(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum FoodHabits implements ApiUiEnum {
  vegetarian('vegetarian'),
  nonVegetarian('non_vegetarian', 'Non-Vegetarian'),
  halalOnly('halal_only', 'Halal Only');

  const FoodHabits(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ExerciseHabits implements ApiUiEnum {
  daily('daily'),
  weekly34Times('weekly_3_4_times', 'Weekly 3-4 Times'),
  weekly12Times('weekly_1_2_times', 'Weekly 1-2 Times'),
  occasionally('occasionally'),
  notInterested('not_interested'),
  yogaOrMeditation('yoga_or_meditation'),
  preferNotToSay('prefer_not_to_say');

  const ExerciseHabits(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ResidencyStatus implements ApiUiEnum {
  citizen('citizen'),
  permanentResident('permanent_resident'),
  workPermit('work_permit'),
  studentVisa('student_visa'),
  temporaryVisa('temporary_visa'),
  visitor('visitor');

  const ResidencyStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum LocationType implements ApiUiEnum {
  present('present'),
  permanent('permanent');

  const LocationType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum PhotoCategory implements ApiUiEnum {
  profile('profile'),
  gallery('gallery'),
  document('document');

  const PhotoCategory(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum PhotoVisibility implements ApiUiEnum {
  public('public'),
  connectionsOnly('connections_only'),
  premiumOnly('premium_only'),
  private('private');

  const PhotoVisibility(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum PhotoApprovalStatus implements ApiUiEnum {
  pending('pending'),
  approved('approved'),
  rejected('rejected');

  const PhotoApprovalStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum SpouseWorkStudyPreference implements ApiUiEnum {
  yes('yes'),
  no('no'),
  withConditions('with_conditions');

  const SpouseWorkStudyPreference(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum PostMarriageLivingPreference implements ApiUiEnum {
  withFamily('with_family'),
  individual('individual'),
  abroad('abroad');

  const PostMarriageLivingPreference(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum HeightUnit implements ApiUiEnum {
  cm('cm', 'CM'),
  inch('inch');

  const HeightUnit(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum WorkingAsPreference implements ApiUiEnum {
  openToAll('open_to_all'),
  businessSelfEmployed('business_self_employed'),
  privateCompany('private_company'),
  governmentPublicSector('government_public_sector'),
  defenseCivilService('defense_civil_service'),
  notWorking('not_working');

  const WorkingAsPreference(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

/// Mirrors the web `Religion` enum (`walima-frontend/src/enums/index.ts`) exactly —
/// same values, same order. Religion is never fetched from the API; only the
/// dependent community list is (`GET /lookups?categorySlug={apiValue}`).
enum Religion implements ApiUiEnum {
  openToAll('open_to_all'),
  islam('islam'),
  hinduism('hinduism'),
  christianity('christianity'),
  buddhism('buddhism'),
  others('others');

  const Religion(this.apiValue, [this._label]);

  /// Religions with no community lookup — web hides the community field for
  /// these rather than issuing a request that always comes back empty.
  static const Set<String> valuesWithoutCommunity = <String>{
    'open_to_all',
    'others',
  };

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);

  bool get hasCommunityOptions => !valuesWithoutCommunity.contains(apiValue);
}

enum ReligiousBackground implements ApiUiEnum {
  veryReligious('very_religious'),
  religious('religious'),
  somewhatReligious('somewhat_religious'),
  notReligious('not_religious'),
  spiritualNotReligious('spiritual_not_religious');

  const ReligiousBackground(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum SubscriptionStatus implements ApiUiEnum {
  active('active'),
  cancelled('cancelled'),
  expired('expired'),
  paused('paused'),
  pending('pending');

  const SubscriptionStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum TransactionStatus implements ApiUiEnum {
  pending('pending'),
  success('success'),
  failed('failed'),
  cancelled('cancelled'),
  refunded('refunded');

  const TransactionStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ActivityType implements ApiUiEnum {
  login('login'),
  loginFailed('login_failed'),
  logout('logout'),
  tokenRefresh('token_refresh'),
  passwordChange('password_change'),
  passwordReset('password_reset'),
  accountLocked('account_locked'),
  accountUnlocked('account_unlocked'),
  profileUpdate('profile_update'),
  settingsChange('settings_change'),
  otpVerified('otp_verified', 'OTP Verified'),
  googleOauth('google_oauth', 'Google OAuth');

  const ActivityType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum LoginMethod implements ApiUiEnum {
  emailPassword('email_password'),
  phonePassword('phone_password'),
  emailOtp('email_otp', 'Email OTP'),
  phoneOtp('phone_otp', 'Phone OTP'),
  googleOauth('google_oauth', 'Google OAuth'),
  tokenRefresh('token_refresh');

  const LoginMethod(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ContactDisplayStatusOption implements ApiUiEnum {
  onlyPremiumMembers('only_premium_members'),
  onlyPremiumMembersILike('only_premium_members_i_like'),
  noOne('no_one'),
  allMatches('all_matches');

  const ContactDisplayStatusOption(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum Gender implements ApiUiEnum {
  male('male'),
  female('female'),
  other('other');

  const Gender(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ProfileMaritalStatus implements ApiUiEnum {
  openToAll('open_to_all'),
  neverMarried('never_married'),
  married('married'),
  divorced('divorced'),
  widowed('widowed'),
  separated('separated'),
  awaitingDivorce('awaiting_divorce'),
  annulled('annulled');

  const ProfileMaritalStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ProfileManagedBy implements ApiUiEnum {
  self('self'),
  parent('parent'),
  sibling('sibling'),
  relative('relative'),
  friend('friend'),
  other('other');

  const ProfileManagedBy(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum AuthVerificationType implements ApiUiEnum {
  email('email'),
  phone('phone'),
  google('google');

  const AuthVerificationType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum OTPResendPurpose implements ApiUiEnum {
  signin('signin'),
  signup('signup'),
  biodataVerification('biodata_verification'),
  passwordReset('password_reset'),
  passwordCreate('password_create'),
  deleteAccount('delete_account');

  const OTPResendPurpose(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum OTPVerificationPurpose implements ApiUiEnum {
  signin('signin'),
  signup('signup'),
  biodataVerification('biodata_verification'),
  passwordReset('password_reset'),
  passwordCreate('password_create'),
  deleteAccount('delete_account');

  const OTPVerificationPurpose(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum UserRole implements ApiUiEnum {
  user('user'),
  agent('agent'),
  admin('admin'),
  superAdmin('super_admin');

  const UserRole(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum UserStatus implements ApiUiEnum {
  active('active'),
  inactive('inactive'),
  suspended('suspended');

  const UserStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum UserGender implements ApiUiEnum {
  male('male'),
  female('female');

  const UserGender(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ViewGalleryPhotoStatus implements ApiUiEnum {
  pending('pending'),
  accepted('accepted'),
  rejected('rejected');

  const ViewGalleryPhotoStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ViewProfilePhotoStatus implements ApiUiEnum {
  pending('pending'),
  accepted('accepted'),
  rejected('rejected');

  const ViewProfilePhotoStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum AddOnType implements ApiUiEnum {
  boost('boost'),
  pack('pack');

  const AddOnType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum AdminNotificationType implements ApiUiEnum {
  userVerification('user_verification'),
  photoApproval('photo_approval'),
  photoRejection('photo_rejection'),
  userReport('user_report'),
  userSuspension('user_suspension'),
  system('system');

  const AdminNotificationType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum AdminNotificationPriority implements ApiUiEnum {
  low('low'),
  medium('medium'),
  high('high'),
  urgent('urgent');

  const AdminNotificationPriority(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum AdminNotificationStatus implements ApiUiEnum {
  unread('unread'),
  read('read'),
  resolved('resolved');

  const AdminNotificationStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum BlogStatus implements ApiUiEnum {
  draft('draft'),
  published('published'),
  archived('archived');

  const BlogStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum MessageStatus implements ApiUiEnum {
  sent('sent'),
  delivered('delivered'),
  read('read');

  const MessageStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ParticipantRole implements ApiUiEnum {
  member('member'),
  admin('admin');

  const ParticipantRole(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum FeatureResetPeriod implements ApiUiEnum {
  daily('daily'),
  weekly('weekly'),
  monthly('monthly'),
  quarterly('quarterly'),
  never('never');

  const FeatureResetPeriod(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum FeatureValueType implements ApiUiEnum {
  counter('counter'),
  boolean('boolean'),
  tier('tier');

  const FeatureValueType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum NotificationType implements ApiUiEnum {
  message('message'),
  match('match'),
  connection('connection'),
  system('system'),
  reminder('reminder');

  const NotificationType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum NotificationStatus implements ApiUiEnum {
  pending('pending'),
  sent('sent'),
  read('read'),
  failed('failed');

  const NotificationStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum BillingCycle implements ApiUiEnum {
  monthly('monthly'),
  quarterly('quarterly'),
  halfYearly('half_yearly'),
  yearly('yearly'),
  lifetime('lifetime');

  const BillingCycle(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum PlanStatus implements ApiUiEnum {
  active('active'),
  inactive('inactive');

  const PlanStatus(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ProfileMatchLabel implements ApiUiEnum {
  excellent('excellent'),
  veryGood('very_good'),
  good('good');

  const ProfileMatchLabel(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum SettingValueType implements ApiUiEnum {
  string('string'),
  number('number'),
  boolean('boolean'),
  json('json', 'JSON');

  const SettingValueType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum SettingCategory implements ApiUiEnum {
  general('general'),
  matching('matching'),
  featureFlag('feature_flag'),
  threshold('threshold'),
  notification('notification'),
  payment('payment'),
  system('system');

  const SettingCategory(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum DevicePlatform implements ApiUiEnum {
  android('android'),
  ios('ios', 'iOS'),
  web('web'),
  unknown('unknown');

  const DevicePlatform(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum HaveChildrenOption implements ApiUiEnum {
  no('no'),
  yes('yes'),
  okayIfNotStayingTogether('okay_if_not_staying_together');

  const HaveChildrenOption(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum PhotoVisibilityFilter implements ApiUiEnum {
  visibleToAll('visible_to_all'),
  privatePhoto('private_photo');

  const PhotoVisibilityFilter(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ExcludeProfilesOption implements ApiUiEnum {
  profilesThatFilteredMe('profiles_that_filtered_me'),
  viewedProfiles('viewed_profiles');

  const ExcludeProfilesOption(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum MatchFilterTypeServer implements ApiUiEnum {
  openToAll('open_to_all'),
  twoWayMatches('two_way_matches');

  const MatchFilterTypeServer(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum RecentlyJoinedFilter implements ApiUiEnum {
  mostRelevant('most_relevant'),
  openToAll('open_to_all'),
  visibleToAll('visible_to_all'),
  protectedPhoto('protected_photo');

  const RecentlyJoinedFilter(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ActiveMembersFilter implements ApiUiEnum {
  onlineNow('online_now'),
  activeWithin24h('active_within_24h', 'Active Within 24H'),
  activeWithinWeek('active_within_week');

  const ActiveMembersFilter(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum InboxConnectionFilter implements ApiUiEnum {
  mostRelevant('most_relevant'),
  newestFirst('newest_first'),
  oldestFirst('oldest_first'),
  allRequests('all_requests'),
  premiumMembers('premium_members'),
  phoneVerifiedMembers('phone_verified_members', 'Phone Verified Members');

  const InboxConnectionFilter(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum MatchSortByServer implements ApiUiEnum {
  relevance('relevance'),
  newest('newest'),
  lastActive('last_active'),
  ageAsc('age_asc'),
  ageDesc('age_desc');

  const MatchSortByServer(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum MatchType implements ApiUiEnum {
  newMatch('new', 'New'),
  today('today'),
  onboarding('onboarding'),
  myMatches('my_matches'),
  nearMe('near_me'),
  twoWay('two_way'),
  recommendations('recommendations'),
  suggestedMembers('suggested_members'),
  premiumMatches('premium_matches'),
  peopleWhoMayLikeMe('people_who_may_like_me');

  const MatchType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ResponseFormat implements ApiUiEnum {
  full('full'),
  short('short');

  const ResponseFormat(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum NotificationFilter implements ApiUiEnum {
  allActivities('all_activities'),
  unreadOnly('unread_only'),
  mostRecent('most_recent');

  const NotificationFilter(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum PaymentGatewayKey implements ApiUiEnum {
  stripe('stripe'),
  bkash('bkash', 'bKash'),
  nagad('nagad'),
  sslcommerz('sslcommerz', 'SSLCommerz');

  const PaymentGatewayKey(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum DowngradeStrategy implements ApiUiEnum {
  preserveUsage('preserve_usage'),
  resetUsage('reset_usage'),
  capUsage('cap_usage');

  const DowngradeStrategy(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum EducationType implements ApiUiEnum {
  primary('primary'),
  secondary('secondary'),
  higherSecondary('higher_secondary'),
  diploma('diploma'),
  bachelor('bachelor'),
  master('master'),
  doctorate('doctorate'),
  vocational('vocational'),
  professionalCertificate('professional_certificate');

  const EducationType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum EducationStream implements ApiUiEnum {
  science('science'),
  commerce('commerce'),
  arts('arts'),
  engineering('engineering'),
  medical('medical'),
  law('law'),
  business('business'),
  technology('technology');

  const EducationStream(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ReligiousValues implements ApiUiEnum {
  veryReligious('very_religious'),
  moderatelyReligious('moderately_religious'),
  liberal('liberal');

  const ReligiousValues(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum ReligiousLanguagesKnown implements ApiUiEnum {
  arabic('arabic'),
  urdu('urdu'),
  persian('persian');

  const ReligiousLanguagesKnown(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum PilgrimageType implements ApiUiEnum {
  hajj('hajj'),
  umrah('umrah');

  const PilgrimageType(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum Sects implements ApiUiEnum {
  sunni('sunni'),
  shia('shia'),
  others('others');

  const Sects(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum Namaaz implements ApiUiEnum {
  fiveTimes('five_times'),
  sometimes('sometimes'),
  rarely('rarely'),
  never('never');

  const Namaaz(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum Fasting implements ApiUiEnum {
  yes('yes'),
  no('no'),
  sometimes('sometimes');

  const Fasting(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum Zakaat implements ApiUiEnum {
  yes('yes'),
  no('no'),
  planningTo('planning_to');

  const Zakaat(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum HttpMethod implements ApiUiEnum {
  post('POST', 'POST'),
  get('GET', 'GET'),
  put('PUT', 'PUT'),
  delete('DELETE', 'DELETE');

  const HttpMethod(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}

enum LookupCategory implements ApiUiEnum {
  educationLevels('education-levels'),
  qualificationLevel('qualification-level'),
  religiousPractice('religious-practice'),
  walimaIntroductionTimeline('walima-introduction-timeline'),
  marriageTimeline('marriage-timeline'),
  workSector('work-sector'),
  professions('profession'),
  incomeRange('income-range'),
  creativePursuits('creative-pursuits'),
  outdoorActivities('outdoor-activities'),
  fitnessAndSports('fitness-and-sports'),
  mediaAndLearning('media-and-learning'),
  foodAndCuisine('food-and-cuisine'),
  travelAndLeisure('travel-and-leisure'),
  healthInformation('health-condition');

  const LookupCategory(this.apiValue, [this._label]);

  @override
  final String apiValue;
  final String? _label;

  @override
  String get label => _label ?? EnumMapper.labelFromValue(apiValue);
}
