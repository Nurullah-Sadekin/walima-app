// ignore_for_file: invalid_use_of_protected_member

part of 'profile_section_edit_screen.dart';

extension _ProfileSectionEditLocationPickerActionsPart
    on _ProfileSectionEditScreenState {
  Future<void> _openGrewUpInCountryPicker() async {
    await _syncCountryOptions(reset: _countryDropdownItems.isEmpty);
    if (!mounted) return;

    final selectedCountry = await showPaginatedSearchPickerSheet(
      context: context,
      title: 'Select Grew Up In',
      searchHintText: 'Search country',
      items: _countryDropdownItems,
      isInitialLoading: _isCountryLoading && _countryDropdownItems.isEmpty,
      isLoadingMore: _isCountryLoadingMore,
      hasMoreItems: _hasMoreCountries,
      initialQuery: _countrySearchQuery,
      emptyStateText: 'No countries found',
      onSearchChanged: _setCountrySearchQuery,
      onLoadMore: _loadMoreCountries,
    );

    if (!mounted || selectedCountry == null || selectedCountry.trim().isEmpty) {
      return;
    }

    setState(() {
      _grewUpInController.text = selectedCountry.trim();
      _selectedApiValues['grewUpIn'] = selectedCountry.trim();
    });
  }

  Future<void> _openCurrentCountryPicker() async {
    await _syncCountryOptions(reset: _countryDropdownItems.isEmpty);
    if (!mounted) return;

    final selectedCountry = await showPaginatedSearchPickerSheet(
      context: context,
      title: 'Select Current Country',
      searchHintText: 'Search country',
      items: _countryDropdownItems,
      isInitialLoading: _isCountryLoading && _countryDropdownItems.isEmpty,
      isLoadingMore: _isCountryLoadingMore,
      hasMoreItems: _hasMoreCountries,
      initialQuery: _countrySearchQuery,
      emptyStateText: 'No countries found',
      onSearchChanged: _setCountrySearchQuery,
      onLoadMore: _loadMoreCountries,
    );

    if (!mounted || selectedCountry == null || selectedCountry.trim().isEmpty) {
      return;
    }

    final normalizedCountry = selectedCountry.trim();
    final previousCountry = _countryController.text.trim();

    setState(() {
      _countryController.text = normalizedCountry;
      if (previousCountry.toLowerCase() != normalizedCountry.toLowerCase()) {
        _cityController.clear();
        _citySearchQuery = '';
      }
    });

    await _syncCityOptionsForCountry(normalizedCountry, reset: true);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openCurrentCityPicker() async {
    final selectedCountry = _countryController.text.trim();
    if (selectedCountry.isEmpty) {
      return;
    }

    await _syncCityOptionsForCountry(
      selectedCountry,
      reset: _cityDropdownItems.isEmpty ||
          _selectedCityCountry?.toLowerCase() != selectedCountry.toLowerCase(),
    );
    if (!mounted) return;

    final selectedCity = await showPaginatedSearchPickerSheet(
      context: context,
      title: 'Select Current City',
      searchHintText: 'Search city',
      items: _cityDropdownItems,
      isInitialLoading: _isCityLoading && _cityDropdownItems.isEmpty,
      isLoadingMore: _isCityLoadingMore,
      hasMoreItems: _hasMoreCities,
      initialQuery: _citySearchQuery,
      emptyStateText: 'No cities found',
      onSearchChanged: _setCitySearchQuery,
      onLoadMore: _loadMoreCities,
    );

    if (!mounted || selectedCity == null || selectedCity.trim().isEmpty) {
      return;
    }

    setState(() {
      _cityController.text = selectedCity.trim();
    });
  }

  Future<void> _openCurrentGrewUpCountryPicker() async {
    await _syncCountryOptions(reset: _countryDropdownItems.isEmpty);
    if (!mounted) return;

    final selectedCountry = await showPaginatedSearchPickerSheet(
      context: context,
      title: 'Select Grew Up In',
      searchHintText: 'Search country',
      items: _countryDropdownItems,
      isInitialLoading: _isCountryLoading && _countryDropdownItems.isEmpty,
      isLoadingMore: _isCountryLoadingMore,
      hasMoreItems: _hasMoreCountries,
      initialQuery: _countrySearchQuery,
      emptyStateText: 'No countries found',
      onSearchChanged: _setCountrySearchQuery,
      onLoadMore: _loadMoreCountries,
    );

    if (!mounted || selectedCountry == null || selectedCountry.trim().isEmpty) {
      return;
    }

    setState(() {
      _grewUpController.text = selectedCountry.trim();
    });
  }

  Future<void> _openPreferredCountryPicker() async {
    await _syncCountryOptions(reset: _countryDropdownItems.isEmpty);
    if (!mounted) return;

    final selectedCountry = await showPaginatedSearchPickerSheet(
      context: context,
      title: 'Select Preferable Country Living In',
      searchHintText: 'Search country',
      items: _countryDropdownItems,
      isInitialLoading: _isCountryLoading && _countryDropdownItems.isEmpty,
      isLoadingMore: _isCountryLoadingMore,
      hasMoreItems: _hasMoreCountries,
      initialQuery: _countrySearchQuery,
      emptyStateText: 'No countries found',
      onSearchChanged: _setCountrySearchQuery,
      onLoadMore: _loadMoreCountries,
    );

    if (!mounted || selectedCountry == null || selectedCountry.trim().isEmpty) {
      return;
    }

    final normalizedCountry = selectedCountry.trim();
    final previousCountry = _prefCountryController.text.trim();

    setState(() {
      _prefCountryController.text = normalizedCountry;
      if (previousCountry.toLowerCase() != normalizedCountry.toLowerCase()) {
        _preferredCitySelections.clear();
        _prefCityController.clear();
        _prefStateController.clear();
        _citySearchQuery = '';
      }
    });

    await _syncCityOptionsForCountry(
      normalizedCountry,
      reset: true,
      usePreferenceSelection: true,
    );
  }

  Future<void> _openLanguagesPicker() async {
    if (_languageOptions.isEmpty) {
      _setLookupLoading(true);
      try {
        await _loadBasicDetailsLookups();
      } finally {
        if (mounted) {
          _setLookupLoading(false);
        }
      }
    }

    if (!mounted || _languageOptions.isEmpty) return;

    final draftOptions = _languageOptions
        .map((item) => item.copyWith(isSelected: item.isSelected))
        .toList(growable: false);

    final selectedOptions = await showModalBottomSheet<List<SingleStringModel>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        final maxHeight = MediaQuery.of(context).size.height * 0.5;
        return SafeArea(
          child: SizedBox(
            height: maxHeight,
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Select Languages'.localized(context),
                              style: TextStyle(
                                color: AppColors.textPrimaryLight,
                                fontSize: TextSize.font18(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'.localized(context)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(draftOptions.length, (
                              index,
                            ) {
                              final item = draftOptions[index];
                              return SelectionCard(
                                buttonStyle: item.isSelected
                                    ? SelectionStyle.selectedCheckbox
                                    : SelectionStyle.unSelectedCheckbox,
                                onTap: () {
                                  setModalState(() {
                                    draftOptions[index].isSelected =
                                        !draftOptions[index].isSelected;
                                  });
                                },
                                isSelected: item.isSelected,
                                title: item.name,
                              );
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.of(context).pop(draftOptions),
                          child: Text('Done'.localized(context)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    if (!mounted || selectedOptions == null) return;

    setState(() {
      _languageOptions = selectedOptions;
      _languagesController.text = _selectedDisplayValues(_languageOptions);
    });
  }

  Future<void> _pickFamilyEconomicCondition() async {
    final currentValue = _resolveFamilyEconomicConditionValue(
      _familyFinancialController.text,
    );
    final selected =
        await showModalBottomSheet<RegistrationFamilyEconomicCondition>(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Family Financial Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...RegistrationFamilyEconomicCondition.values.map((condition) {
                final isSelected = currentValue == condition.apiValue;
                return ListTile(
                  title: Text(condition.label),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () => Navigator.of(context).pop(condition),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _familyFinancialController.text = selected.label;
    });
  }
}
