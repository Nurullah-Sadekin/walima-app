/// Centralized app text constants
/// Access common texts throughout the app using AppTexts
class AppTexts {
  AppTexts._(); // Private constructor to prevent instantiation

  // App Info
  static const String appName = 'Flutter Boilerplate';
  static const String appVersion = '1.0.0';

  // Common Actions
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String add = 'Add';
  static const String update = 'Update';
  static const String confirm = 'Confirm';
  static const String submit = 'Submit';
  static const String close = 'Close';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String skip = 'Skip';
  static const String finish = 'Finish';
  static const String retry = 'Retry';
  static const String refresh = 'Refresh';
  static const String ok = 'OK';
  static const String yes = 'Yes';
  static const String no = 'No';

  // Common Labels
  static const String email = 'Email';
  static const String password = 'Password';
  static const String username = 'Username';
  static const String phone = 'Phone';
  static const String address = 'Address';
  static const String name = 'Name';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String sort = 'Sort';
  static const String settings = 'Settings';
  static const String profile = 'Profile';
  static const String help = 'Help';
  static const String about = 'About';
  static const String logout = 'Logout';
  static const String login = 'Login';
  static const String register = 'Register';
  static const String forgotPassword = 'Forgot Password';

  // Messages
  static const String loading = 'Loading...';
  static const String noData = 'No data available';
  static const String error = 'An error occurred';
  static const String success = 'Success';
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'Unknown error occurred';
  static const String sessionExpired = 'Your session has expired. Please login again.';
  static const String unauthorized = 'Unauthorized access';
  static const String notFound = 'Resource not found';
  static const String invalidInput = 'Invalid input';
  static const String requiredField = 'This field is required';

  // Validation Messages
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordTooShort = 'Password must be at least 8 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String invalidPhoneNumber = 'Please enter a valid phone number';

  // Empty States
  static const String noResults = 'No results found';
  static const String emptyList = 'The list is empty';
  static const String noNotifications = 'No notifications';
  static const String noMessages = 'No messages';

  // Confirmation Messages
  static const String confirmDelete = 'Are you sure you want to delete?';
  static const String confirmLogout = 'Are you sure you want to logout?';
  static const String confirmCancel = 'Are you sure you want to cancel?';

  // Theme
  static const String darkMode = 'Dark Mode';
  static const String lightMode = 'Light Mode';
  static const String theme = 'Theme';
  static const String language = 'Language';

  // Time
  static const String today = 'Today';
  static const String yesterday = 'Yesterday';
  static const String tomorrow = 'Tomorrow';

  // API Endpoints (Base paths)
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = 'v1';
}
