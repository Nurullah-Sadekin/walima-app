import 'package:flutter_boilerplate/features/home/data/model/response/recent_visitors_response.dart';

class HomeRepository {
  // get recent visitors
  //curl --location 'https://dev.walima.app/api/v1/engagement/recent-visitors?page=1&size=10&responseFormat=short' \
  // --header 'Accept: application/json' \
  // --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjMWZhYjc4Ny0yYjk0LTRlNWItYjBlOS01MTFkYmRjMzA0NTkiLCJ1c2VySWQiOiJjMWZhYjc4Ny0yYjk0LTRlNWItYjBlOS01MTFkYmRjMzA0NTkiLCJlbWFpbCI6InB1cnVzaEBnbWFpbC5jb20iLCJwaG9uZU51bWJlciI6bnVsbCwidXNlclJlZmVyZW5jZSI6IldMRDVEQjJPVEJRN0NPIiwidmVyaWZpY2F0aW9uVHlwZSI6ImVtYWlsIiwidHlwZSI6InVzZXIiLCJpYXQiOjE3NzUwNjI0MDMsImV4cCI6MTc3NTE0ODgwM30.RMtIjTyPH-oKqW_r6EjQvY28bJA1a3kSOnCsdTcgtnc' \
  // --header 'Cookie: walima_locale=en'
   
  Future<RecentVisitorsResponse?> getRecentVisitors() async {
    return null;
    
  }
}