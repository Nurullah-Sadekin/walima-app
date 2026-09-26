import 'package:walima_llc/core/global/enums/enums.dart';

class SingleStringModel {
  SingleStringModel({
    required this.name,
    this.value,
    this.isSelected = false,
  });

  final String name;
  final String? value;
  bool isSelected;

  SingleStringModel copyWith({
    String? name,
    String? value,
    bool? isSelected,
  }) {
    return SingleStringModel(
      name: name ?? this.name,
      value: value ?? this.value,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

List<SingleStringModel> dietDataListInserted = [
  ...RegistrationDiet.values
      .where((diet) => diet != RegistrationDiet.jainVegetarian)
      .map(
        (diet) => SingleStringModel(
          name: diet.label,
          value: diet.apiValue,
        ),
      ),
];

List<SingleStringModel> incomeRangeListInserted = [
  SingleStringModel(name: 'Less than 10k', value: 'less_than_10k'),
  SingleStringModel(name: '10k - 20k', value: '10k_20k'),
  SingleStringModel(name: '20k - 50k', value: '20k_50k'),
  SingleStringModel(name: '50k - 100k', value: '50k_100k'),
  SingleStringModel(name: 'More than 100k', value: 'more_than_100k'),
];

List<SingleStringModel> yourWorkListInserted = [
  SingleStringModel(name: 'Open to All', value: 'open_to_all'),
  SingleStringModel(
    name: 'Business / Self Employed',
    value: 'business_self_employed',
  ),
  SingleStringModel(name: 'Private Company', value: 'private_company'),
  SingleStringModel(
    name: 'Government / Public Sector',
    value: 'government_public_sector',
  ),
  SingleStringModel(
    name: 'Defense / Civil Service',
    value: 'defense_civil_service',
  ),
  SingleStringModel(name: 'Not Working', value: 'not_working'),
];

List<SingleStringModel> creativeItemListDataInserted = [
  SingleStringModel(name: 'Writing'),
  SingleStringModel(name: 'Cooking'),
  SingleStringModel(name: 'Singing'),
  SingleStringModel(name: 'Photography'),
  SingleStringModel(name: 'Playing instruments'),
  SingleStringModel(name: 'Painting'),
  SingleStringModel(name: 'DIY crafts'),
  SingleStringModel(name: 'Dancing'),
  SingleStringModel(name: 'Acting'),
  SingleStringModel(name: 'Poetry'),
  SingleStringModel(name: 'Gardening'),
  SingleStringModel(name: 'Blogging'),
  SingleStringModel(name: 'Content creation'),
  SingleStringModel(name: 'Designing'),
  SingleStringModel(name: 'Doodling'),
  SingleStringModel(name: 'Doodling'),
  SingleStringModel(name: 'Doodling'),
  SingleStringModel(name: 'Doodling'),
  SingleStringModel(name: 'Doodling'),
];

List<SingleStringModel> funItemListDataInserted = [
  SingleStringModel(name: 'Movies'),
  SingleStringModel(name: 'Music'),
  SingleStringModel(name: 'Travelling'),
  SingleStringModel(name: 'Reading'),
  SingleStringModel(name: 'Sports'),
  SingleStringModel(name: 'Social media'),
  SingleStringModel(name: 'Gaming'),
  SingleStringModel(name: 'Binge-watching'),
  SingleStringModel(name: 'Biking'),
  SingleStringModel(name: 'Clubbing'),
  SingleStringModel(name: 'Shopping'),
  SingleStringModel(name: 'Theater & Events'),
  SingleStringModel(name: 'Anime'),
  SingleStringModel(name: 'Stand ups'),
  SingleStringModel(name: 'Fashion & beauty'),
];

List<SingleStringModel> fitnessItemListDataInserted = [
  SingleStringModel(name: 'Running'),
  SingleStringModel(name: 'Cycling'),
  SingleStringModel(name: 'Yoga'),
  SingleStringModel(name: 'Walking'),
  SingleStringModel(name: 'Working out'),
  SingleStringModel(name: 'Trekking'),
  SingleStringModel(name: 'Aerobics/Zumba'),
];

List<SingleStringModel> otherInterestsItemListDataInserted = [
  SingleStringModel(name: 'Pets'),
  SingleStringModel(name: 'Foodie'),
  SingleStringModel(name: 'Vegan'),
  SingleStringModel(name: 'News & Politics'),
  SingleStringModel(name: 'Playing instruments'),
  SingleStringModel(name: 'Social service'),
  SingleStringModel(name: 'Entrepreneurship'),
  SingleStringModel(name: 'Home decor'),
  SingleStringModel(name: 'Investments'),
];

List<SingleStringModel> motherDetailsItemListDataInserted = [
  SingleStringModel(name: 'Housewife'),
  SingleStringModel(name: 'Working'),
  SingleStringModel(name: 'Government job'),
  SingleStringModel(name: 'Retired'),
  SingleStringModel(name: 'Teacher'),
  SingleStringModel(name: 'NGO worker'),
  SingleStringModel(name: 'Business'),
  SingleStringModel(name: 'Other'),
];

List<SingleStringModel> fatherDetailsItemListDataInserted = [
  SingleStringModel(name: 'Engineer'),
  SingleStringModel(name: 'Doctor'),
  SingleStringModel(name: 'Teacher'),
  SingleStringModel(name: 'Business'),
  SingleStringModel(name: 'Retired'),
  SingleStringModel(name: 'Government job'),
  SingleStringModel(name: 'Other'),
];

List<SingleStringModel> siblingCountListDataInserted = [
  SingleStringModel(name: 'None', value: '0'),
  SingleStringModel(name: '1'),
  SingleStringModel(name: '2'),
  SingleStringModel(name: '3'),
  SingleStringModel(name: '4'),
  SingleStringModel(name: '5'),
  SingleStringModel(name: '6'),
  SingleStringModel(name: '7'),
  SingleStringModel(name: '8'),
  SingleStringModel(name: '9'),
  SingleStringModel(name: '10+', value: '10'),
];

List<SingleStringModel> maritalStatusListDataInserted = [
  ...RegistrationMaritalStatus.values
      .where((status) => status != RegistrationMaritalStatus.married)
      .map(
        (status) => SingleStringModel(
          name: status.label,
          value: status.apiValue,
        ),
      ),
];

List<SingleStringModel> countryListDataInserted = [
  SingleStringModel(name: 'Bangladesh'),
  SingleStringModel(name: 'India'),
  SingleStringModel(name: 'Pakistan'),
  SingleStringModel(name: 'Nepal'),
  SingleStringModel(name: 'Sri Lanka'),
  SingleStringModel(name: 'Afghanistan'),
  SingleStringModel(name: 'Bhutan'),
  SingleStringModel(name: 'China'),
  SingleStringModel(name: 'Italy'),
  SingleStringModel(name: 'Spain'),
];

List<SingleStringModel> verificationTypeList = [
  SingleStringModel(name: 'Mobile'),
  SingleStringModel(name: 'Email'),
];

List<SingleStringModel> sortByListDataInserted = [
  SingleStringModel(name: 'Most Relevant'),
  SingleStringModel(name: 'Newest First'),
  SingleStringModel(name: 'Oldest First'),
];

List<SingleStringModel> filterListDataInserted = [
  SingleStringModel(name: 'All Requests'),
  SingleStringModel(name: 'Super Contacts'),
  SingleStringModel(name: 'Premium Members'),
  SingleStringModel(name: 'Member Online Now'),
  SingleStringModel(name: 'Phone Verified Members'),
  SingleStringModel(name: 'Members with Photo'),
  SingleStringModel(name: 'Filtered Out Members'),
];

List<SingleStringModel> ageListDataInserted = [
  SingleStringModel(name: '18'),
  SingleStringModel(name: '19'),
  SingleStringModel(name: '20'),
  SingleStringModel(name: '21'),
  SingleStringModel(name: '22'),
  SingleStringModel(name: '23'),
  SingleStringModel(name: '24'),
  SingleStringModel(name: '25'),
  SingleStringModel(name: '26'),
  SingleStringModel(name: '27'),
  SingleStringModel(name: '28'),
  SingleStringModel(name: '29'),
  SingleStringModel(name: '30'),
  SingleStringModel(name: '31'),
  SingleStringModel(name: '32'),
  SingleStringModel(name: '33'),
  SingleStringModel(name: '34'),
  SingleStringModel(name: '35'),
  SingleStringModel(name: '36'),
  SingleStringModel(name: '37'),
  SingleStringModel(name: '38'),
  SingleStringModel(name: '39'),
  SingleStringModel(name: '40'),
  SingleStringModel(name: '41'),
  SingleStringModel(name: '42'),
  SingleStringModel(name: '43'),
  SingleStringModel(name: '44'),
  SingleStringModel(name: '45'),
  SingleStringModel(name: '46'),
  SingleStringModel(name: '47'),
  SingleStringModel(name: '48'),
  SingleStringModel(name: '49'),
  SingleStringModel(name: '50'),
];

List<SingleStringModel> haveChildrenDataListInserted = [
  SingleStringModel(name: 'No', value: 'no'),
  SingleStringModel(name: 'Yes', value: 'yes'),
  SingleStringModel(
    name: 'Okay, If we\'re not staying together',
    value: 'okay_if_not_staying_together',
  ),
];
