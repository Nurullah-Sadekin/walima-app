class UpdateInterestsRequestBody {
  final List<String> creativePursuits;
  final List<String> outdoorActivities;
  final List<String> fitnessAndSports;
  final List<String> mediaAndLearning;
  final List<String> foodAndCuisine;
  final List<String> travelAndLeisure;

  UpdateInterestsRequestBody({
    required this.creativePursuits,
    required this.outdoorActivities,
    required this.fitnessAndSports,
    required this.mediaAndLearning,
    required this.foodAndCuisine,
    required this.travelAndLeisure,
  });

  Map<String, dynamic> toJson() {
    return {
      'creativePursuits': creativePursuits,
      'outdoorActivities': outdoorActivities,
      'fitnessAndSports': fitnessAndSports,
      'mediaAndLearning': mediaAndLearning,
      'foodAndCuisine': foodAndCuisine,
      'travelAndLeisure': travelAndLeisure,
    };
  }
}
