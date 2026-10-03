import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/constants/app_texts.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/utils/date_time_utils.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:walima_llc/features/notification/data/notification_response.dart';
import 'package:walima_llc/features/notification/presentation/providers/notificaiton_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  late NotificationProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(notiProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getDetailList();
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(notiProvider);
    return TransparentLoading(
      isLoading:
          provider.loaderState == NotificationScreenStates.transparentLoading,
      child: Scaffold(
        body: GradientBackground(
          child: Column(
            children: [
              CustomBackAppBar(
                title: Text(
                  'Notifications',
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: TextSize.font18(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: provider.screenStates == NotificationScreenStates.loading
                    ? const Loading()
                    : _body(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    if (provider.errorMessage != null && provider.notifications.isEmpty) {
      return _errorState();
    }

    if (provider.notifications.isEmpty) {
      return _emptyState();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // _actionBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => provider.getAllNotification(isRefresh: true),
              color: AppColors.primary,
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification.metrics.pixels >=
                      scrollNotification.metrics.maxScrollExtent - 120) {
                    provider.loadMoreNotifications();
                  }
                  return false;
                },
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: provider.notifications.length +
                      (provider.isLoadingMore ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index >= provider.notifications.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final item = provider.notifications[index];
                    return _notificationCard(item);
                  },
                ),
              ),
            ),
          ),
          Text(
            provider.pagination?.page == provider.pagination?.totalPages
                ? 'No more'
                : 'Swipe down for more',
            style: const TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _actionBar() {
    final unreadCount =
        provider.notifications.where((item) => item.isRead != true).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$unreadCount ${'unread'.localized(context)}',
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: TextSize.font12(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          InkWell(
            onTap: unreadCount == 0
                ? null
                : () {
                    provider.markAllNotificationsAsRead();
                  },
            child: Text(
              'Mark all as read'.localized(context),
              style: TextStyle(
                color: AppColors.primary,
                fontSize: TextSize.font12(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationCard(NotificationItem item) {
    final senderName = item.sender?.displayName?.trim();
    final displayName =
        (senderName?.isNotEmpty ?? false) ? senderName! : 'Walima';
    final title = (item.title?.trim().isNotEmpty ?? false)
        ? item.title!.trim()
        : displayName;
    final message = item.message?.trim() ?? '';
    final isRead = item.isRead == true;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: isRead
          ? null
          : () {
              final id = item.id?.trim();
              if (id == null || id.isEmpty) return;
              provider.markSingleNotificationAsRead(id);
            },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _avatar(item),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textPrimaryLight,
                          fontSize: TextSize.font14(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontSize: TextSize.font12(context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateTimeUtils.formatDate(item.createdAtDateTime),
                        style: TextStyle(
                          color: AppColors.hintTextColor,
                          fontSize: TextSize.font10(context),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    // if (!isRead)
                    //   Text(
                    //     'Mark read',
                    //     style: TextStyle(
                    //       color: AppColors.primary,
                    //       fontSize: TextSize.font10(context),
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(NotificationItem item) {
    final avatarUrl = item.sender?.profilePhoto?.url?.trim();
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 23,
        backgroundColor: AppColors.greyLight,
        backgroundImage: NetworkImage(avatarUrl),
      );
    }
    return Container(
        width: 46,
        height: 46,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: AppColors.greyLight,
          shape: BoxShape.circle,
        ),
        child: const ShowImage(
          imagePath: AppImages.notificationSvgIcon,
          color: AppColors.textSecondaryLight,
        ));
  }

  Widget _emptyState() {
    return RefreshIndicator(
      onRefresh: () => provider.getAllNotification(isRefresh: true),
      color: AppColors.primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Text(
                AppTexts.noNotifications,
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              provider.errorMessage ?? AppTexts.error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => provider.getAllNotification(isRefresh: true),
              child: const Text(AppTexts.retry),
            ),
          ],
        ),
      ),
    );
  }
}
