import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/enums/enums.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:walima_llc/features/profile/data/model/response/contacts.dart';
import 'package:walima_llc/features/profile/data/repository/profile_repository.dart';

class ContactInformationScreen extends ConsumerStatefulWidget {
  const ContactInformationScreen({super.key});

  @override
  ConsumerState<ContactInformationScreen> createState() =>
      _ContactInformationScreenState();
}

class _ContactInformationScreenState
    extends ConsumerState<ContactInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  ContactType _contactType = ContactType.phone;
  Contacts? _existingContact;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = ref.read(profileProvider);
      if (provider.profile == null) await provider.getProfile(context);
      if (!mounted) return;
      final contacts = provider.profile?.contacts;
      _existingContact =
          contacts == null || contacts.isEmpty ? null : contacts.first;
      final existingType = _existingContact?.contactType?.trim().toLowerCase();
      _contactType = ContactType.values.firstWhere(
        (type) => type.apiValue == existingType,
        orElse: () => ContactType.phone,
      );
      _valueController.text = _existingContact?.contactValue ?? '';
      setState(() {});
    });
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final profile = ref.read(profileProvider).profile;
    final existingContacts = profile?.contacts ?? const <Contacts>[];
    final edited = <String, dynamic>{
      if (_existingContact?.id != null) 'id': _existingContact!.id,
      'contactType': _contactType.apiValue,
      'contactValue': _valueController.text.trim(),
      'contactOwner': _existingContact?.contactOwner ?? 'self',
      'contactOwnerType': _existingContact?.contactOwnerType ?? 'user',
      'isVerified': _existingContact?.isVerified ?? false,
      'isPrimary': _existingContact?.isPrimary ?? existingContacts.isEmpty,
      'isPublic': _existingContact?.isPublic ?? false,
    };
    final payload = <Map<String, dynamic>>[
      edited,
      for (final contact in existingContacts.skip(1)) contact.toJson(),
    ];

    final response = await ProfileRepository.updateProfileContacts(payload);
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (!response.isSuccess) {
      await DialogUtils.showErrorDialog(
        context: context,
        message: response.message ?? 'Failed to update contact information.',
      );
      return;
    }

    await ref.read(profileProvider).getProfile(context);
    if (!mounted) return;
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomBackAppBar(
              title: Text('Contact Information'.localized(context)),
              backIconBackground: AppColors.transparent,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<ContactType>(
                        key: ValueKey<ContactType>(_contactType),
                        initialValue: _contactType,
                        decoration: InputDecoration(
                          labelText: 'Contact Type'.localized(context),
                          border: const OutlineInputBorder(),
                        ),
                        items: ContactType.values
                            .map(
                              (type) => DropdownMenuItem<ContactType>(
                                value: type,
                                child: Text(type.label.localized(context)),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _contactType = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _valueController,
                        keyboardType: _contactType == ContactType.email
                            ? TextInputType.emailAddress
                            : TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Contact Value'.localized(context),
                          hintText: _contactType == ContactType.email
                              ? 'name@example.com'
                              : '+880...',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'This field is required'.localized(context)
                                : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isSaving ? null : _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isSaving
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Text('Save Changes'.localized(context)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
