import 'package:walima_llc/core/config/app_flavor.dart';

class AppUrls {
  static final String domain = AppConfig.instance.imageBaseUrl;
  static const String apiVersion = 'api/v1';
  static final String baseUrl = AppConfig.instance.apiBaseUrl;
  static final String login = '$baseUrl/auth/signin-with-password';
  static final String getMe = '$baseUrl/auth/me';
  static final String register = '$baseUrl/auth/register';
  static final String loginWithOTP = '$baseUrl/auth/signin-with-otp';
  static final String signUpWithOTP = '$baseUrl/auth/sign-up-with-otp';
  static final String verifyOTP = '$baseUrl/auth/verify-otp';
  static final String resendOTP = '$baseUrl/auth/resend-otp';
  static final String forgotPassword = '$baseUrl/auth/forgot-password';
  static final String setPasswordWithOTP =
      '$baseUrl/auth/set-password-with-otp';
  static final String createPassword = '$baseUrl/auth/create-password';
  static final String changePassword = '$baseUrl/auth/change-password';
  static final String getAccessToken = '$baseUrl/auth/refresh-token';
  static final String logout = '$baseUrl/auth/logout';
  static final String googleSignin = '$baseUrl/auth/google/signin';
  static final String appleSignin = '$baseUrl/auth/apple/signin';
  static final String signUpCreateUserProfile = '$baseUrl/users/onboarding';
  static final String checkUserNameAvailability =
      '$baseUrl/users/check-username';
  static final String checkEmailAvailability = '$baseUrl/users/check-email';
  static final String checkNumberAvailability = '$baseUrl/users/check-phone';
  static final String uploadMedia = '$baseUrl/media/upload';
  static final String getAllCountry = '$baseUrl/countries';
  static final String getCityByCountry = '$baseUrl/cities';
  static final String getPlans = '$baseUrl/plans';
  static final String updateHobbiesInterest =
      '$baseUrl/users/profile/interests';
  static final String updateFamily = '$baseUrl/users/profile/family';
  static final String updatePreferences = '$baseUrl/users/profile/preferences';

  // Engagement Endpoints
  static final String getRecentVisitors =
      '$baseUrl/engagement/recent-visitors'; //GET
  static final String getRecentlyViewed =
      '$baseUrl/engagement/recently-viewed'; //GET

  // User Profile Endpoints
  static final String getCompleteProfile = '$baseUrl/users/profile'; //GET
  static final String getProfileStrength =
      '$baseUrl/users/profile/strength'; //GET
  static final String getProfilePreview =
      '$baseUrl/users/profile/preview'; //GET
  static final String getBasicProfile = '$baseUrl/users/profile/basic'; //GET
  static final String getAppearanceProfile =
      '$baseUrl/users/profile/appearance'; //GET
  static final String getProfileLocations =
      '$baseUrl/users/profile/locations'; //GET
  static final String getEducationProfile =
      '$baseUrl/users/profile/education'; //GET
  static final String getProfessionProfile =
      '$baseUrl/users/profile/profession'; //GET
  static final String getFamilyProfile = '$baseUrl/users/profile/family'; //GET
  static final String getReligionProfile =
      '$baseUrl/users/profile/religion'; //GET
  static final String getLifestyleProfile =
      '$baseUrl/users/profile/lifestyle'; //GET
  static final String getProfilePreferences =
      '$baseUrl/users/profile/preferences'; //GET
  static final String getProfileContacts =
      '$baseUrl/users/profile/contacts'; //GET
  static final String getProfilePhotos =
      '$baseUrl/users/profile/photos'; //GET  // need to put after image upload
  static final String getProfilePhotoById =
      '$baseUrl/users/profile/photo/{photoId}'; //GET
  static final String getProfileInterests =
      '$baseUrl/users/profile/interests'; //GET
  static final String createProfile = '$baseUrl/users/profile'; //POST

  //Profile Update & Delete Endpoints
  static final String deleteAppearance =
      '$baseUrl/users/profile/appearance'; //DELETE
  static final String deleteFamily = '$baseUrl/users/profile/family'; //DELETE
  static final String deleteReligion =
      '$baseUrl/users/profile/religion'; //DELETE
  static final String deleteLifestyle =
      '$baseUrl/users/profile/lifestyle'; //DELETE
  static final String deletePreferences =
      '$baseUrl/users/profile/preferences'; //DELETE
  static final String deleteEducationEntry =
      '$baseUrl/users/profile/education/{educationId}'; //DELETE
  static final String deleteProfessionProfile =
      '$baseUrl/users/profile/profession/{professionId}'; //DELETE
  static final String deleteSpecificLocation =
      '$baseUrl/users/profile/locations/{locationId}'; //DELETE
  static final String deleteSpecificContact =
      '$baseUrl/users/profile/contacts/{contactId}'; //DELETE
  static final String deleteSpecificPhoto =
      '$baseUrl/users/profile/photos/{photoId}'; //DELETE
  static final String deleteSpecificInterest =
      '$baseUrl/users/profile/interests/{interestId}'; //DELETE

  static final String updateBasicProfile = '$baseUrl/users/profile/basic'; //PUT
  static final String updateAppearanceProfile =
      '$baseUrl/users/profile/appearance'; //PUT
  static final String updateProfileLocations =
      '$baseUrl/users/profile/locations'; //PUT
  static final String updateFamilyProfile =
      '$baseUrl/users/profile/family'; //PUT
  static final String updateReligionProfile =
      '$baseUrl/users/profile/religion'; //PUT
  static final String updateLifestyleProfile =
      '$baseUrl/users/profile/lifestyle'; //PUT
  static final String updateProfilePreferences =
      '$baseUrl/users/profile/preferences'; //PUT
  static final String updateProfileContacts =
      '$baseUrl/users/profile/contacts'; //PUT
  static final String updateProfilePhotos =
      '$baseUrl/users/profile/photos'; //PUT
  static final String updateProfileInterests =
      '$baseUrl/users/profile/interests'; //PUT
  static final String universalProfileUpdate =
      '$baseUrl/users/profile/update'; //PUT
  static final String updateEducationProfile =
      '$baseUrl/users/profile/educations'; //PUT
  static final String updateProfessionProfile =
      '$baseUrl/users/profile/professions'; //PUT

  //General User Endpoints

  static final String getCurrentUserInfo = '$baseUrl/users'; //GET
  static final String getLookups = '$baseUrl/lookups'; //GET
  static final String getUserDashboard = '$baseUrl/users/dashboard'; //GET
  static final String checkUsername = '$baseUrl/users/check-username'; //GET
  static final String checkEmail = '$baseUrl/users/check-email'; //GET
  static final String checkPhone = '$baseUrl/users/check-phone'; //GET
  static final String createUserOnboarding = '$baseUrl/users/onboarding'; //POST

  //Add-Ons & AI Services

  static final String purchaseAddOn = '$baseUrl/user/add-ons/purchase'; //POST
  static final String useAddOn = '$baseUrl/user/add-ons/use'; //POST

  static final String getAiModels = '$baseUrl/ai/models'; //GET
  static final String getAiProviders = '$baseUrl/ai/providers'; //GET
  static final String generateChatCompletion = '$baseUrl/ai/chat'; //POST
  static final String generateTextCompletion =
      '$baseUrl/ai/text-completion'; //POST
  static final String generateImage = '$baseUrl/ai/image'; //POST
  static final String createEmbedding = '$baseUrl/ai/embeddings'; //POST
  static final String moderateContent = '$baseUrl/ai/moderate'; //POST

  //Uploads (AWS S3)
  static final String getSignedUrl = '$baseUrl/uploads/signed-url'; //GET
  static final String uploadUserImage = '$baseUrl/uploads/usersphoto'; //POST
  static final String uploadPhotoIdFile =
      '$baseUrl/uploads/usersphotoid'; //POST
  static final String postPhotoFile = '$baseUrl/uploads/postphoto'; //POST

  //Biodata & Blogs
  static final String getBiodataProfile = '$baseUrl/biodata'; //GET
  static final String createOrUpdateBiodataDraft = '$baseUrl/biodata'; //POST
  static final String updateBiodata = '$baseUrl/biodata'; //PUT
  static final String getBioTemplates = '$baseUrl/public/bio-templates'; //GET
  static final String suggestBioTemplate =
      '$baseUrl/public/bio-templates/suggest'; //POST
  static final String getConnectMessageTemplates =
      '$baseUrl/public/connect-message-templates'; //GET

  static final String getAllBlogs = '$baseUrl/blogs'; //GET
  static final String getBlogBySlug = '$baseUrl/blogs/{slug}'; //GET
  static final String downloadBlogFile = '$baseUrl/blogs/{slug}/file'; //GET

  //Chat & Connections
  static final String getConnectableUsers = '$baseUrl/chat/conversations'; //GET
  static final String getUserConversations =
      '$baseUrl/chat/conversations'; //GET
  static final String getConversationMessages =
      '$baseUrl/chat/conversations/{conversationId}/messages'; //GET
  static final String getMessageById =
      '$baseUrl/chat/message/{messageId}'; //GET
  static final String sendMessage = '$baseUrl/chat/send-message'; //POST
  static final String markMessageDelivered =
      '$baseUrl/chat/message/{messageId}/mark-delivered'; //POST
  static final String markMessageRead =
      '$baseUrl/chat/message/{messageId}/mark-read'; //POST
  static final String markConversationRead =
      '$baseUrl/chat/conversation/{conversationId}/mark-read'; //POST

  static final String deleteConnection = '$baseUrl/connections/{id}'; //DELETE
  static final String getConnections = '$baseUrl/connections'; //GET
  static final String getRequestedConnections =
      '$baseUrl/connections/requested'; //GET
  static final String getAcceptedConnections =
      '$baseUrl/connections/accepted'; //GET
  static final String getSentConnections = '$baseUrl/connections/sent'; //GET
  static final String getBlockedConnections =
      '$baseUrl/connections/blocked'; //GET
  static final String getDeletedConnections =
      '$baseUrl/connections/deleted'; //GET
  static final String getConnectionById = '$baseUrl/connections/{id}'; //GET
  static final String getConnectionStats = '$baseUrl/connections/stats'; //GET
  static final String viewContact = '$baseUrl/connections/view-contact/'; //GET
  static String performConnectionAction(String id) =>
      '$baseUrl/connections/$id'; //PATCH
  static final String createConnection = '$baseUrl/connections'; //POST
  static final String bulkSendConnectionRequests =
      '$baseUrl/connections/bulk-send'; //POST
  static final String sendReminder = '$baseUrl/connections/{id}/remind'; //POST
  static final String updateConnection = '$baseUrl/connections/{id}'; //PATCH
  //

  // --- Matches & Compatibility ---
  static final String getMatches = '$baseUrl/matches'; //GET
  static final String getPublicMatches = '$baseUrl/matches/public'; //GET
  static final String getMatchesStats = '$baseUrl/matches/stats'; //GET
  static final String getTopMatches = '$baseUrl/matches/top-matches'; //GET
  static final String getHomepageTopMatches =
      '$baseUrl/matches/homepage/top'; //GET
  static final String getAiPoweredHomepageTopMatches =
      '$baseUrl/matches/homepage/top/ai-powered'; //GET
  static final String getCompatibilityResult =
      '$baseUrl/matches/compatibility/{userId}'; //GET
  static final String getMatchPreview =
      '$baseUrl/matches/preview/{userId}'; //GET
  static final String getMatchCompare =
      '$baseUrl/matches/compare/{userId}'; //GET
  static final String getMatchFilterSchema =
      '$baseUrl/matches/filters/schema'; //GET
  static final String getMatchFilterDefaults =
      '$baseUrl/matches/filters/defaults'; //GET

  // --- Plans & Subscriptions ---
  static final String getActivePlan = '$baseUrl/plans/active-plan'; //GET
  static final String getAvailablePlans =
      '$baseUrl/plans/available-plans'; //GET
  static final String getSubscriptionHistory =
      '$baseUrl/plans/subscription-history'; //GET
  static final String cancelSubscription =
      '$baseUrl/plans/cancel-subscription'; //POST
  static final String purchasePlan = '$baseUrl/plans/purchase'; //POST
  static final String paymentsUpgradeQuote =
      '$baseUrl/payments/upgrade-quote'; //POST
  static final String paymentsInitiate = '$baseUrl/payments/initiate'; //POST
  static final String paymentsInitiateUpgrade =
      '$baseUrl/payments/initiate-upgrade'; //POST
  static final String paymentsSslCommerzWebhook =
      '$baseUrl/payments/webhook/sslcommerz'; //POST
  static final String paymentsSslCommerzCallback =
      '$baseUrl/payments/callback/sslcommerz'; //GET
  static final String paymentsSubscription =
      '$baseUrl/payments/subscription'; //GET

  // --- Activities & Interactions ---
  static final String getProfileVisitors = '$baseUrl/activities/visitors'; //GET

  // --- Settings ---
  static final String contactFilters =
      '$baseUrl/settings/contact-filters'; //GET,PUT
  static final String getShortlistedUsers =
      '$baseUrl/engagement/shortlists'; //GET
  static String addToShortlist(String userId) =>
      '$baseUrl/engagement/shortlists/$userId'; //POST
  static String removeFromShortlist(String userId) =>
      '$baseUrl/engagement/shortlists/$userId'; //DELETE
  static String getShortlistStatus(String userId) =>
      '$baseUrl/engagement/shortlists/$userId/status'; //GET
  static final String getBlockedUsers = '$baseUrl/interactions/blocks'; //GET
  static final String getReports = '$baseUrl/interactions/reports'; //GET
  static final String blockUser = '$baseUrl/interactions/block'; //POST
  static final String reportUser = '$baseUrl/interactions/report'; //POST
  static final String unblockUser = '$baseUrl/interactions/unblock'; //POST

  // --- Public Profiles & Search ---
  static final String getPublicProfile =
      '$baseUrl/public/profile/{userId}'; //GET
  static final String getPublicProfilePhotos =
      '$baseUrl/public/profile/{userId}/photos'; //GET
  static final String searchUsers = '$baseUrl/public/search'; //POST

  // --- Notifications ---
  static final String getNotifications = '$baseUrl/notifications'; //GET
  static final String getUnreadNotificationCount =
      '$baseUrl/notifications/unread-count'; //GET
  static final String bulkReadNotifications =
      '$baseUrl/notifications/bulk-read'; //PATCH
  static final String markNotificationAsRead =
      '$baseUrl/notifications/{id}/read'; //PATCH
  static final String markAllNotificationsAsRead =
      '$baseUrl/notifications/read-all'; //POST
  static final String registerDeviceToken =
      '$baseUrl/notifications/device-tokens/register'; //PATCH
  static final String deleteNotification =
      '$baseUrl/notifications/{id}'; //DELETE

  // --- Settings & Add-Ons ---
  static final String getNotificationSettings =
      '$baseUrl/settings/notifications'; //GET
  static final String getPrivacySettings = '$baseUrl/settings/privacy'; //GET
  static final String updateNotificationSettings =
      '$baseUrl/settings/notifications'; //PUT
  static final String updatePrivacySettings = '$baseUrl/settings/privacy'; //PUT
  static final String submitFeedback = '$baseUrl/settings/feedback'; //POST
  static final String contactSupport = '$baseUrl/settings/support'; //POST
  // Plans
  static final String getAllPlans = '$baseUrl/plans'; //POST

  // --- AI Support Bot ---
  static final String supportBotConversations =
      '$baseUrl/support-bot/conversations'; //GET, POST
  static final String supportBotConversationById =
      '$baseUrl/support-bot/conversations/{conversationId}'; //GET
  static final String supportBotMessages =
      '$baseUrl/support-bot/conversations/{conversationId}'; //GET (paged messages)
  static final String supportBotSendMessage =
      '$baseUrl/support-bot/conversations/{conversationId}/messages'; //POST
  static final String supportBotConfirm =
      '$baseUrl/support-bot/conversations/{conversationId}/confirm'; //POST
  static final String supportBotEscalate =
      '$baseUrl/support-bot/conversations/{conversationId}/escalate'; //POST
  static final String supportBotTickets = '$baseUrl/support-bot/tickets'; //GET
  static final String supportBotTicketById =
      '$baseUrl/support-bot/tickets/{ticketId}'; //GET, DELETE
  static final String supportBotTicketMessages =
      '$baseUrl/support-bot/tickets/{ticketId}/messages'; //POST

  static final String getPlanById = '$baseUrl/plans/{planId}'; //GET

  // --- Identity Verification (Didit KYC) ---
  // Flutter talks only to the Walima backend; the backend owns the Didit API key.
  static final String verificationSession =
      '$baseUrl/verification/session'; //POST, DELETE
  static final String verificationStatus = '$baseUrl/verification/status'; //GET
  static final String verificationSessions =
      '$baseUrl/verification/sessions'; //GET

  //------  Account Settings ------
  static final String updateNameAndEmail = '$baseUrl/settings/account'; //GET
  static final String contactSettings = '$baseUrl/settings/contact'; //GET, PUT
  static final String contactPhone =
      '$baseUrl/settings/contact/phone'; //POST (add + send OTP)
  static final String contactPhoneVerify =
      '$baseUrl/settings/contact/phone/verify'; //POST
  static final String contactPhoneOtp =
      '$baseUrl/settings/contact/phone/otp'; //POST (resend OTP)
  static final String contactEntryPrimary =
      '$baseUrl/settings/contact/entry/primary'; //PUT
  static final String premiumSettings = '$baseUrl/settings/premium'; //GET, PUT
  static final String messagesSettings = '$baseUrl/settings/messages'; //GET

  // ---- External Links ----
  static final String helpCenterUrl = '${domain}en/account/help-desk';
  static final String beSafeOnlineUrl = '${domain}en/be-safe-online';
  static final String privacyPolicyUrl = '${domain}en/privacy';
  static final String safetyUrl = '${domain}en/safety';
  static final String termsUrl = '${domain}en/terms';
  static const String facebookUrl = 'https://www.facebook.com/WalimaApp';
  static const String instagramUrl = 'https://www.instagram.com/walima.app';
  static const String xUrl = 'https://x.com/WalimaApp';
}
