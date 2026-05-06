part of 'profile_section_edit_screen.dart';

extension _ProfileSectionEditLookupDynamicPart
    on _ProfileSectionEditScreenState {
  Future<void> _loadLookupsForSection() async {
    final futures = <Future<void>>[];

    switch (widget.section) {
      case ProfileEditSection.basicDetails:
        futures.add(_loadBasicDetailsLookups());
        break;
      case ProfileEditSection.preferenceBasicInfo:
        futures.add(_loadPreferenceBasicInfoLookups());
        break;
      case ProfileEditSection.preferenceLocationDetails:
        futures.add(_loadPreferenceLocationLookups());
        break;
      case ProfileEditSection.preferenceEducationCareer:
        futures.add(_loadPreferenceEducationCareerLookups());
        break;
      case ProfileEditSection.preferenceOtherDetails:
        futures.add(_loadPreferenceOtherDetailLookups());
        break;
      case ProfileEditSection.educationCareer:
        futures.add(_loadEducationLevelLookup());
        futures.add(_loadProfessionAndIncomeLookup());
        break;
      case ProfileEditSection.familyDetails:
        futures.add(_loadFamilyLookups());
        break;
      case ProfileEditSection.location:
        futures.add(_loadLocationLookups());
        break;
      case ProfileEditSection.hobbiesInterests:
        futures.add(_loadHobbyLookups());
        break;
      default:
        break;
    }

    if (futures.isEmpty) {
      return;
    }

    _setLookupLoading(true);
    try {
      await Future.wait(futures);
    } catch (_) {
      // Silent fallback: dropdowns will show whatever data was loaded successfully.
    } finally {
      if (mounted) {
        _setLookupLoading(false);
      }
    }
  }

  Future<void> _loadBasicDetailsLookups() async {
    final tasks = <Future<void>>[];

    if (_healthInfoOptions.isEmpty) {
      tasks.add(() async {
        final options = await _domainRepository.getLookups(
          LookupCategory.healthInformation,
        );
        if (!mounted) return;
        _healthInfoOptions = options;
      }());
    }

    if (_motherTongueOptions.isEmpty || _languageOptions.isEmpty) {
      tasks.add(() async {
        final options = await _domainRepository.getLookupsBySlug(
          'mother-tongue',
        );
        if (!mounted) return;
        if (_motherTongueOptions.isEmpty) {
          _motherTongueOptions = options;
        }
        if (_languageOptions.isEmpty) {
          _languageOptions = options
              .map(
                (option) => SingleStringModel(
                  name: option.label,
                  value: option.key,
                ),
              )
              .toList(growable: false);
        }
      }());
    }

    if (tasks.isEmpty) return;
    await Future.wait(tasks);
  }

  Future<void> _loadEducationLevelLookup() async {
    if (_educationLevelOptions.isNotEmpty) return;
    _educationLevelOptions = await _domainRepository.getLookups(
      LookupCategory.educationLevels,
    );
    if (_educationLevelOptions.isEmpty) {
      _educationLevelOptions = EducationLevel.values
          .map((e) => LookupOption(key: e.apiValue, label: e.label))
          .toList(growable: false);
    }
    if (!mounted) return;
  }

  Future<void> _loadProfessionAndIncomeLookup() async {
    if (_professionOptions.isNotEmpty && _incomeRangeOptions.isNotEmpty) return;
    final results = await Future.wait<List<LookupOption>>([
      _domainRepository.getLookups(LookupCategory.professions),
      _domainRepository.getLookups(LookupCategory.incomeRange),
    ]);
    if (!mounted) return;
    _professionOptions = results[0];
    _incomeRangeOptions = results[1];
  }

  Future<void> _loadFamilyLookups() async {
    if (_didLoadFamilyLookups) return;
    _didLoadFamilyLookups = true;

    _familyTypeOptions = await _loadLookupByPrioritySlugs(
      slugs: const <String>[
        'family-type',
        'familyType',
        'family_type',
      ],
      fallback: _enumValuesToLookupOptions(FamilyType.values),
    );

    _familyValuesOptions = await _loadLookupByPrioritySlugs(
      slugs: const <String>[
        'family-values',
        'familyValues',
        'family_values',
      ],
      fallback: _enumValuesToLookupOptions(FamilyValues.values),
    );

    _marriageTimelineOptions = await _loadLookupByPrioritySlugs(
      slugs: const <String>[
        'marriage-timeline',
        'marriageTimeline',
        'marriage_time_line',
      ],
      fallback: const <LookupOption>[],
    );
  }

  Future<void> _loadLocationLookups() async {
    await _syncCountryOptions(reset: _countryDropdownItems.isEmpty);
    final selectedCountry = _countryController.text.trim();
    if (selectedCountry.isNotEmpty) {
      await _syncCityOptionsForCountry(selectedCountry, reset: true);
    }
  }

  Future<void> _loadPreferenceBasicInfoLookups() async {
    await _loadBasicDetailsLookups();
    if (_prefReligionController.text.trim().isNotEmpty) {
      await _loadCommunityOptionsForReligion(_prefReligionController.text);
    }
  }

  Future<void> _loadPreferenceLocationLookups() async {
    await _syncCountryOptions(reset: _countryDropdownItems.isEmpty);
    final selectedCountry = _prefCountryController.text.trim();
    if (selectedCountry.isNotEmpty) {
      await _syncCityOptionsForCountry(
        selectedCountry,
        reset: true,
        usePreferenceSelection: true,
      );
    }
  }

  Future<void> _loadPreferenceEducationCareerLookups() async {
    await _loadEducationLevelLookup();
    await _loadProfessionAndIncomeLookup();

    _prefEducationOptions = _educationLevelOptions
        .map(
          (option) => SingleStringModel(
            name: option.label,
            value: option.key,
          ),
        )
        .toList(growable: false);

    _prefWorkingAsOptions = _professionOptions
        .map(
          (option) => SingleStringModel(
            name: option.label,
            value: option.key,
          ),
        )
        .toList(growable: false);
  }

  Future<void> _loadPreferenceOtherDetailLookups() async {
    // Preference chips already come from local enums/static data.
  }

  Future<void> _loadHobbyLookups() async {
    final results = await Future.wait<List<LookupOption>>([
      _domainRepository.getLookups(LookupCategory.creativePursuits),
      _domainRepository.getLookups(LookupCategory.outdoorActivities),
      _domainRepository.getLookups(LookupCategory.fitnessAndSports),
      _domainRepository.getLookups(LookupCategory.mediaAndLearning),
      _domainRepository.getLookups(LookupCategory.foodAndCuisine),
      _domainRepository.getLookups(LookupCategory.travelAndLeisure),
    ]);
    if (!mounted) return;

    final creative = _lookupToSingleStrings(results[0]);
    final fun = _lookupToSingleStrings(results[1]);
    final fitness = _lookupToSingleStrings(results[2]);
    final other = <SingleStringModel>[
      ..._lookupToSingleStrings(results[3]),
      ..._lookupToSingleStrings(results[4]),
      ..._lookupToSingleStrings(results[5]),
    ];

    if (creative.isNotEmpty) _creativeOptions = creative;
    if (fun.isNotEmpty) _funOptions = fun;
    if (fitness.isNotEmpty) _fitnessOptions = fitness;
    if (other.isNotEmpty) _otherOptions = other;
  }

  List<SingleStringModel> _lookupToSingleStrings(List<LookupOption> options) {
    return options
        .map(
          (option) => SingleStringModel(
            name: option.label,
            value: option.key,
          ),
        )
        .toList(growable: false);
  }

  Future<List<LookupOption>> _loadLookupByPrioritySlugs({
    required List<String> slugs,
    required List<LookupOption> fallback,
  }) async {
    for (final slug in slugs) {
      try {
        final options = await _domainRepository.getLookupsBySlug(slug);
        if (options.isNotEmpty) {
          return options;
        }
      } catch (_) {
        // Try next slug and fall back if none works.
      }
    }

    return fallback;
  }

  List<LookupOption> _enumValuesToLookupOptions<T extends ApiUiEnum>(
    Iterable<T> values,
  ) {
    return values
        .map(
          (value) => LookupOption(
            key: value.apiValue,
            label: value.label,
          ),
        )
        .toList(growable: false);
  }

  Future<void> _loadCommunityOptionsForReligion(String? religionInput) async {
    final religionKey = _resolveLookupKey(
      _ProfileSectionEditScreenState._religionOptions,
      religionInput,
    );
    if (religionKey == null) {
      if (!mounted) return;
      setState(() {
        _communityOptions = <LookupOption>[];
      });
      return;
    }

    _setLookupLoading(true);
    try {
      final options = await _domainRepository.getLookupsBySlug(religionKey);
      if (!mounted) return;
      _communityOptions = options;
    } catch (_) {
      if (!mounted) return;
      _communityOptions = <LookupOption>[];
    } finally {
      if (mounted) {
        _setLookupLoading(false);
      }
    }
  }

  Future<void> _syncPreferredCommunitySelection(String? rawCommunity) async {
    await _loadCommunityOptionsForReligion(_prefReligionController.text);
    if (!mounted) return;

    final normalized = rawCommunity?.trim();
    if (normalized == null || normalized.isEmpty) {
      return;
    }

    final match = _findLookupOption(_communityOptions, normalized);
    if (match == null) {
      setState(() {
        _selectedApiValues.remove('prefCommunity');
      });
      return;
    }

    setState(() {
      _prefCommunityController.text = match.label;
      _selectedApiValues['prefCommunity'] = match.key;
    });
  }
}

extension _ProfileSectionEditLookupDynamicStrengthMetaPart
    on _ProfileSectionEditScreenState {
  bool get _isStrengthDrivenMode => widget.strengthFields.isNotEmpty;

  String get _screenTitle {
    final customTitle = widget.strengthSectionLabel?.trim();
    if (customTitle != null && customTitle.isNotEmpty) {
      return 'Complete $customTitle';
    }
    return widget.section.title;
  }

  List<ProfileStrengthField> get _effectiveStrengthFields {
    if (!_isStrengthDrivenMode) {
      return const <ProfileStrengthField>[];
    }
    return _strengthFieldsUseCase.resolveEffectiveFields(widget.strengthFields);
  }

  Future<void> _initializeStrengthFieldMeta(CompleteProfile? profile) async {
    if (!_isStrengthDrivenMode || _didInitStrengthFieldMeta) {
      return;
    }
    _didInitStrengthFieldMeta = true;

    final knownKeys = _knownFieldKeysForSection(widget.section);
    for (final field in _effectiveStrengthFields) {
      final key = field.key!.trim();
      final normalized = _fieldKeyUseCase.normalize(key);

      if (!knownKeys.contains(normalized)) {
        final controller = TextEditingController();
        controller.text = _profileValueUseCase.resolveValueByNormalizedKey(
          profile,
          _fieldKeyUseCase.normalize(key),
          _fieldKeyUseCase.normalize,
        );
        _dynamicFieldControllers[key] = controller;
      }

      final options = await _loadLookupOptionsForStrengthField(key);
      _dynamicFieldLookupOptions[key] = options;
      if (options.isNotEmpty && _dynamicFieldControllers.containsKey(key)) {
        final controller = _dynamicFieldControllers[key]!;
        final currentValue = controller.text.trim();
        final match = _findLookupOption(options, currentValue);
        if (match != null) {
          _dynamicFieldSelectedApiValues[key] = match.key;
          controller.text = match.label;
        }
      }
    }
  }
}
