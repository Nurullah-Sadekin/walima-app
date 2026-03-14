
class SingleStringModel {
  SingleStringModel({
    required this.name,
    this.isSelected = false
  });

  final String name;
  bool isSelected;

  SingleStringModel copyWith({
    String? name,
    bool? isSelected,
  }) {
    return SingleStringModel(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

List<SingleStringModel> dietDataListInserted = [
  SingleStringModel(name: 'Healthy'),
  SingleStringModel(name: 'Modern Balanced Diet'),
  SingleStringModel(name: 'Vegetarian'),
  SingleStringModel(name: 'Vegan'),
  SingleStringModel(name: 'Junk Food Lover'),
  SingleStringModel(name: 'Low Carb'),
  SingleStringModel(name: 'Low Fat'),
  SingleStringModel(name: 'Low Sodium'),
  SingleStringModel(name: 'Low Cholesterol'),
  SingleStringModel(name: 'Low Sugar'),
  SingleStringModel(name: 'Low Salt'),
  SingleStringModel(name: 'No Preferences'),
  SingleStringModel(name: 'Low Fat'),
  SingleStringModel(name: 'Low Sodium'),
  SingleStringModel(name: 'Low Cholesterol'),
  SingleStringModel(name: 'Low Sugar'),
  SingleStringModel(name: 'Low Salt'),
  SingleStringModel(name: 'No Preferences'),
];

List<SingleStringModel> incomeRangeListInserted = [
  SingleStringModel(name: 'Less than 10k'),
  SingleStringModel(name: '10k - 20k'),
  SingleStringModel(name: '20k - 50k'),
  SingleStringModel(name: '50k - 100k'),
  SingleStringModel(name: 'More than 100k'),
];

List<SingleStringModel> yourWorkListInserted = [
  SingleStringModel(name: 'Full-time'),
  SingleStringModel(name: 'Part-time'),
  SingleStringModel(name: 'Self-employed'),
  SingleStringModel(name: 'Student'),
  SingleStringModel(name: 'Unemployed'),
];

List<SingleStringModel> youWorkAsListInserted = [
  SingleStringModel(name: 'Engineer'),
  SingleStringModel(name: 'Doctor'),
  SingleStringModel(name: 'Teacher'),
  SingleStringModel(name: 'Business'),
  SingleStringModel(name: 'Other'),
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
  SingleStringModel(name: '0'),
  SingleStringModel(name: '1'),
  SingleStringModel(name: '2'),
  SingleStringModel(name: '3'),
  SingleStringModel(name: '4'),
  SingleStringModel(name: '5 or more'),
];

List<SingleStringModel> maritalStatusListDataInserted = [
  SingleStringModel(name: 'Open to All'),
  SingleStringModel(name: 'Never Married'),
  SingleStringModel(name: 'Divorced'),
  SingleStringModel(name: 'Widowed'),
  SingleStringModel(name: 'Separated'),
  SingleStringModel(name: 'Married'),
  SingleStringModel(name: 'Awaiting Divorce'),
  SingleStringModel(name: 'Annulled'),
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
