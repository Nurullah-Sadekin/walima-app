class AppUrls {
  static const String domain = 'https://dev.walima.app/';
  static const String apiVersion = 'api/v1';
  static const String baseUrl = '$domain$apiVersion';
  static const String login = '$baseUrl/auth/signin-with-password';
  static const String getMe = '$baseUrl/auth/me';
  static const String register = '$baseUrl/auth/register';
  // static const String signinWithPassword = '$baseUrl/auth/signin-with-password';
  static const String loginWithOTP = '$baseUrl/auth/signin-with-otp';
  static const String signUpWithOTP = '$baseUrl/auth/sign-up-with-otp';
  static const String verifyOTP = '$baseUrl/auth/verify-otp';
  static const String resendOTP = '$baseUrl/auth/resend-otp';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String setPasswordWithOTP =
      '$baseUrl/auth/set-password-with-otp';
  static const String createPassword = '$baseUrl/auth/create-password';
  static const String changePassword = '$baseUrl/auth/change-password';
  static const String getAccessToken = '$baseUrl/auth/refresh-token';
  static const String logout = '$baseUrl/auth/logout';
  static const String googleSignin = '$baseUrl/auth/google/signin';
  static const String signUpCreateUserProfile = '$baseUrl/users/onboarding';
  static const String checkUserNameAvailability =
      '$baseUrl/users/check-username';
  static const String checkEmailAvailability = '$baseUrl/users/check-email';
  static const String checkNumberAvailability = '$baseUrl/users/check-phone';
  static const String uploadMedia = '$baseUrl/media/upload';
  static const String getAllCountry = '$baseUrl/countries';
  static const String getCityByCountry = '$baseUrl/cities';
  static const String getPlans = '$baseUrl/plans';
  static const String updateHobbiesInterest =
      '$baseUrl/users/profile/interests';
  static const String updateFamily = '$baseUrl/users/profile/family';
  static const String updatePreferences = '$baseUrl/users/profile/preferences';

  // Engagement Endpoints
  static const String getRecentVisitors =
      '$baseUrl/engagement/recent-visitors'; //GET

  // User Profile Endpoints
  static const String getCompleteProfile = '$baseUrl/users/profile'; //GET
  static const String getProfileStrength =
      '$baseUrl/users/profile/strength'; //GET
  static const String getProfilePreview =
      '$baseUrl/users/profile/preview'; //GET
  static const String getBasicProfile = '$baseUrl/users/profile/basic'; //GET
  static const String getAppearanceProfile =
      '$baseUrl/users/profile/appearance'; //GET
  static const String getProfileLocations =
      '$baseUrl/users/profile/locations'; //GET
  static const String getEducationProfile =
      '$baseUrl/users/profile/education'; //GET
  static const String getProfessionProfile =
      '$baseUrl/users/profile/profession'; //GET
  static const String getFamilyProfile = '$baseUrl/users/profile/family'; //GET
  static const String getReligionProfile =
      '$baseUrl/users/profile/religion'; //GET
  static const String getLifestyleProfile =
      '$baseUrl/users/profile/lifestyle'; //GET
  static const String getProfilePreferences =
      '$baseUrl/users/profile/preferences'; //GET
  static const String getProfileContacts =
      '$baseUrl/users/profile/contacts'; //GET
  static const String getProfilePhotos =
      '$baseUrl/users/profile/photos'; //GET  // need to put after image upload
  static const String getProfilePhotoById =
      '$baseUrl/users/profile/photo/{photoId}'; //GET
  static const String getProfileInterests =
      '$baseUrl/users/profile/interests'; //GET
  static const String createProfile = '$baseUrl/users/profile'; //POST

  //Profile Update & Delete Endpoints
  static const String deleteAppearance =
      '$baseUrl/users/profile/appearance'; //DELETE
  static const String deleteFamily = '$baseUrl/users/profile/family'; //DELETE
  static const String deleteReligion =
      '$baseUrl/users/profile/religion'; //DELETE
  static const String deleteLifestyle =
      '$baseUrl/users/profile/lifestyle'; //DELETE
  static const String deletePreferences =
      '$baseUrl/users/profile/preferences'; //DELETE
  static const String deleteEducationEntry =
      '$baseUrl/users/profile/education/{educationId}'; //DELETE
  static const String deleteProfessionProfile =
      '$baseUrl/users/profile/profession/{professionId}'; //DELETE
  static const String deleteSpecificLocation =
      '$baseUrl/users/profile/locations/{locationId}'; //DELETE
  static const String deleteSpecificContact =
      '$baseUrl/users/profile/contacts/{contactId}'; //DELETE
  static const String deleteSpecificPhoto =
      '$baseUrl/users/profile/photos/{photoId}'; //DELETE
  static const String deleteSpecificInterest =
      '$baseUrl/users/profile/interests/{interestId}'; //DELETE

  static const String updateBasicProfile = '$baseUrl/users/profile/basic'; //PUT
  static const String updateAppearanceProfile =
      '$baseUrl/users/profile/appearance'; //PUT
  static const String updateProfileLocations =
      '$baseUrl/users/profile/locations'; //PUT
  static const String updateFamilyProfile =
      '$baseUrl/users/profile/family'; //PUT
  static const String updateReligionProfile =
      '$baseUrl/users/profile/religion'; //PUT
  static const String updateLifestyleProfile =
      '$baseUrl/users/profile/lifestyle'; //PUT
  static const String updateProfilePreferences =
      '$baseUrl/users/profile/preferences'; //PUT
  static const String updateProfileContacts =
      '$baseUrl/users/profile/contacts'; //PUT
  static const String updateProfilePhotos =
      '$baseUrl/users/profile/photos'; //PUT
  static const String updateProfileInterests =
      '$baseUrl/users/profile/interests'; //PUT
  static const String universalProfileUpdate =
      '$baseUrl/users/profile/update'; //PUT
  static const String updateEducationProfile =
      '$baseUrl/users/profile/educations'; //PUT
  static const String updateProfessionProfile =
      '$baseUrl/users/profile/professions'; //PUT

  //General User Endpoints

  static const String getCurrentUserInfo = '$baseUrl/users'; //GET
  static const String getLookups = '$baseUrl/lookups'; //GET
  static const String getUserDashboard = '$baseUrl/users/dashboard'; //GET
  static const String checkUsername = '$baseUrl/users/check-username'; //GET
  static const String checkEmail = '$baseUrl/users/check-email'; //GET
  static const String checkPhone = '$baseUrl/users/check-phone'; //GET
  static const String createUserOnboarding = '$baseUrl/users/onboarding'; //POST

  //Add-Ons & AI Services

  static const String purchaseAddOn = '$baseUrl/user/add-ons/purchase'; //POST
  static const String useAddOn = '$baseUrl/user/add-ons/use'; //POST

  static const String getAiModels = '$baseUrl/ai/models'; //GET
  static const String getAiProviders = '$baseUrl/ai/providers'; //GET
  static const String generateChatCompletion = '$baseUrl/ai/chat'; //POST
  static const String generateTextCompletion =
      '$baseUrl/ai/text-completion'; //POST
  static const String generateImage = '$baseUrl/ai/image'; //POST
  static const String createEmbedding = '$baseUrl/ai/embeddings'; //POST
  static const String moderateContent = '$baseUrl/ai/moderate'; //POST

  //Uploads (AWS S3)
  static const String getSignedUrl = '$baseUrl/uploads/signed-url'; //GET
  static const String uploadUserImage = '$baseUrl/uploads/usersphoto'; //POST
  static const String uploadPhotoIdFile =
      '$baseUrl/uploads/usersphotoid'; //POST
  static const String postPhotoFile = '$baseUrl/uploads/postphoto'; //POST

  //Biodata & Blogs
  static const String getBiodataProfile = '$baseUrl/biodata'; //GET
  static const String createOrUpdateBiodataDraft = '$baseUrl/biodata'; //POST
  static const String updateBiodata = '$baseUrl/biodata'; //PUT

  static const String getAllBlogs = '$baseUrl/blogs'; //GET
  static const String getBlogBySlug = '$baseUrl/blogs/{slug}'; //GET
  static const String downloadBlogFile = '$baseUrl/blogs/{slug}/file'; //GET

  //Chat & Connections
  static const String getConnectableUsers =
      '$baseUrl/chat/connectable-users'; //GET
  static const String getUserConversations =
      '$baseUrl/chat/conversations'; //GET
  static const String getConversationMessages =
      '$baseUrl/chat/conversations/{conversationId}/messages'; //GET
  static const String getMessageById =
      '$baseUrl/chat/message/{messageId}'; //GET
  static const String sendMessage = '$baseUrl/chat/send-message'; //POST
  static const String markMessageDelivered =
      '$baseUrl/chat/message/{messageId}/mark-delivered'; //POST
  static const String markMessageRead =
      '$baseUrl/chat/message/{messageId}/mark-read'; //POST
  static const String markConversationRead =
      '$baseUrl/chat/conversation/{conversationId}/mark-read'; //POST

  static const String deleteConnection = '$baseUrl/connections/{id}'; //DELETE
  static const String getConnections = '$baseUrl/connections'; //GET
  static const String getRequestedConnections =
      '$baseUrl/connections/requested'; //GET
  static const String getAcceptedConnections =
      '$baseUrl/connections/accepted'; //GET
  static const String getSentConnections = '$baseUrl/connections/sent'; //GET
  static const String getBlockedConnections =
      '$baseUrl/connections/blocked'; //GET
  static const String getDeletedConnections =
      '$baseUrl/connections/deleted'; //GET
  static const String getConnectionById = '$baseUrl/connections/{id}'; //GET
  static const String getConnectionStats = '$baseUrl/connections/stats'; //GET
  static const String viewContact = '$baseUrl/connections/view-contact/'; //GET
  static String performConnectionAction(String id) =>
      '$baseUrl/connections/$id/action'; //PATCH
  static const String createConnection = '$baseUrl/connections'; //POST
  static const String bulkSendConnectionRequests =
      '$baseUrl/connections/bulk-send'; //POST
  static const String sendReminder = '$baseUrl/connections/{id}/remind'; //POST
  static const String updateConnection = '$baseUrl/connections/{id}'; //PUT
  //

  // --- Matches & Compatibility ---
  static const String getMatches = '$baseUrl/matches'; //GET
  static const String getPublicMatches = '$baseUrl/matches/public'; //GET
  static const String getMatchesStats = '$baseUrl/matches/stats'; //GET
  static const String getTopMatches = '$baseUrl/matches/top-matches'; //GET
  static const String getHomepageTopMatches =
      '$baseUrl/matches/homepage/top'; //GET
  static const String getCompatibilityResult =
      '$baseUrl/matches/compatibility/{userId}'; //GET

  // --- Plans & Subscriptions ---
  static const String getActivePlan = '$baseUrl/plans/active-plan'; //GET
  static const String getAvailablePlans =
      '$baseUrl/plans/available-plans'; //GET
  static const String getSubscriptionHistory =
      '$baseUrl/plans/subscription-history'; //GET
  static const String cancelSubscription =
      '$baseUrl/plans/cancel-subscription'; //POST
  static const String purchasePlan = '$baseUrl/plans/purchase'; //POST
  static const String paymentsUpgradeQuote =
      '$baseUrl/payments/upgrade-quote'; //POST
  static const String paymentsInitiate = '$baseUrl/payments/initiate'; //POST
  static const String paymentsInitiateUpgrade =
      '$baseUrl/payments/initiate-upgrade'; //POST
  static const String paymentsSslCommerzWebhook =
      '$baseUrl/payments/webhook/sslcommerz'; //POST
  static const String paymentsSslCommerzCallback =
      '$baseUrl/payments/callback/sslcommerz'; //GET
  static const String paymentsSubscription =
      '$baseUrl/payments/subscription'; //GET

  // --- Activities & Interactions ---
  static const String getProfileVisitors = '$baseUrl/activities/visitors'; //GET

  // --- Settings ---
  static const String contactFilters =
      '$baseUrl/settings/contact-filters'; //GET,PUT
  static const String getShortlistedUsers =
      '$baseUrl/activities/shortlist'; //GET
  static const String addToShortlist = '$baseUrl/activities/shortlist'; //POST
  static const String removeFromShortlist =
      '$baseUrl/activities/shortlist/{userId}'; //DELETE
  static const String getBlockedUsers = '$baseUrl/interactions/blocks'; //GET
  static const String getReports = '$baseUrl/interactions/reports'; //GET
  static const String blockUser = '$baseUrl/interactions/block'; //POST
  static const String reportUser = '$baseUrl/interactions/report'; //POST
  static const String unblockUser = '$baseUrl/interactions/unblock'; //POST

  // --- Public Profiles & Search ---
  static const String getPublicProfile =
      '$baseUrl/public/profile/{userId}'; //GET
  static const String getPublicProfilePhotos =
      '$baseUrl/public/profile/{userId}/photos'; //GET
  static const String searchUsers = '$baseUrl/public/search'; //POST

  // --- Notifications ---
  static const String getNotifications = '$baseUrl/notifications'; //GET
  static const String getUnreadNotificationCount =
      '$baseUrl/notifications/unread-count'; //GET
  static const String bulkReadNotifications =
      '$baseUrl/notifications/bulk-read'; //PATCH
  static const String markNotificationAsRead =
      '$baseUrl/notifications/{id}/read'; //PATCH
  static const String markAllNotificationsAsRead =
      '$baseUrl/notifications/read-all'; //POST
  static const String registerDeviceToken =
      '$baseUrl/notifications/device-tokens/register'; //PATCH
  static const String deleteNotification =
      '$baseUrl/notifications/{id}'; //DELETE

  // --- Settings & Add-Ons ---
  static const String getNotificationSettings =
      '$baseUrl/settings/notifications'; //GET
  static const String getPrivacySettings = '$baseUrl/settings/privacy'; //GET
  static const String updateNotificationSettings =
      '$baseUrl/settings/notifications'; //PUT
  static const String updatePrivacySettings = '$baseUrl/settings/privacy'; //PUT
  static const String submitFeedback = '$baseUrl/settings/feedback'; //POST
  static const String contactSupport = '$baseUrl/settings/support'; //POST
  // Plans
  static const String getAllPlans = '$baseUrl/plans'; //POST

  static const String getPlanById = '$baseUrl/plans/{planId}'; //GET


  //------  Account Settings ------
  static const String updateNameAndEmail = '$baseUrl/settings/account'; //GET
  static const String contactSettings = '$baseUrl/settings/contact'; //GET, PUT
  static const String premiumSettings = '$baseUrl/settings/premium'; //GET, PUT
  static const String messagesSettings = '$baseUrl/settings/messages'; //GET


  // ---- External Links ----
  static const String helpCenterUrl = 'https://dev.walima.app/en/account/help-desk';
  static const String beSafeOnlineUrl = 'https://dev.walima.app/en/be-safe-online';
  static const String privacyPolicyUrl = 'https://dev.walima.app/en/privacy';
  static const String safetyUrl = 'https://dev.walima.app/en/safety';
  static const String termsUrl = 'https://dev.walima.app/en/terms';
  static const String facebookUrl = 'https://www.facebook.com/WalimaApp';
  static const String instagramUrl = 'https://www.instagram.com/walima.app';
  static const String xUrl = 'https://x.com/WalimaApp';
}
