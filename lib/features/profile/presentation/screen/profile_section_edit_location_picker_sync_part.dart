// ignore_for_file: invalid_use_of_protected_member

part of 'profile_section_edit_screen.dart';

extension _ProfileSectionEditLocationPickerSyncPart
    on _ProfileSectionEditScreenState {
  void _setPreferredAgeRange(RangeValues values) {
    setState(() {
      _prefAgeStart = values.start.round().clamp(
            _ProfileSectionEditScreenState._prefAgeMinLimit,
            _ProfileSectionEditScreenState._prefAgeMaxLimit,
          );
      _prefAgeEnd = values.end.round().clamp(
            _ProfileSectionEditScreenState._prefAgeMinLimit,
            _ProfileSectionEditScreenState._prefAgeMaxLimit,
          );
      if (_prefAgeStart > _prefAgeEnd) {
        final temp = _prefAgeStart;
        _prefAgeStart = _prefAgeEnd;
        _prefAgeEnd = temp;
      }
      _prefAgeMinController.text = _prefAgeStart.toString();
      _prefAgeMaxController.text = _prefAgeEnd.toString();
    });
  }

  void _setPreferredHeightRange(RangeValues values) {
    setState(() {
      _prefHeightStart = values.start.round().clamp(
            _ProfileSectionEditScreenState._prefHeightMinLimit,
            _ProfileSectionEditScreenState._prefHeightMaxLimit,
          );
      _prefHeightEnd = values.end.round().clamp(
            _ProfileSectionEditScreenState._prefHeightMinLimit,
            _ProfileSectionEditScreenState._prefHeightMaxLimit,
          );
      if (_prefHeightStart > _prefHeightEnd) {
        final temp = _prefHeightStart;
        _prefHeightStart = _prefHeightEnd;
        _prefHeightEnd = temp;
      }
      _prefHeightMinController.text = _prefHeightStart.toString();
      _prefHeightMaxController.text = _prefHeightEnd.toString();
    });
  }

  Future<void> _setCountrySearchQuery(String value) async {
    final normalized = value.trim();
    if (_countrySearchQuery == normalized) {
      return;
    }

    _countrySearchQuery = normalized;
    await _syncCountryOptions(reset: true);
  }

  Future<void> _setCitySearchQuery(String value) async {
    final normalized = value.trim();
    if (_citySearchQuery == normalized) {
      return;
    }

    _citySearchQuery = normalized;
    final selectedCountry = _countryController.text.trim();
    if (selectedCountry.isEmpty) {
      return;
    }
    await _syncCityOptionsForCountry(selectedCountry, reset: true);
  }

  Future<void> _loadMoreCountries() async {
    if (!_hasMoreCountries || _isCountryLoading || _isCountryLoadingMore) {
      return;
    }
    await _syncCountryOptions(reset: false);
  }

  Future<void> _loadMoreCities() async {
    final selectedCountry = _countryController.text.trim();
    if (selectedCountry.isEmpty ||
        !_hasMoreCities ||
        _isCityLoading ||
        _isCityLoadingMore) {
      return;
    }
    await _syncCityOptionsForCountry(selectedCountry, reset: false);
  }

  Future<void> _loadMorePreferredCities() async {
    final selectedCountry = _prefCountryController.text.trim();
    if (selectedCountry.isEmpty ||
        !_hasMoreCities ||
        _isCityLoading ||
        _isCityLoadingMore) {
      return;
    }
    await _syncCityOptionsForCountry(
      selectedCountry,
      reset: false,
      usePreferenceSelection: true,
    );
  }

  void _togglePreferredCitySelection(String cityName) {
    final normalized = cityName.trim();
    if (normalized.isEmpty) {
      return;
    }

    setState(() {
      final existingIndex = _preferredCitySelections.indexWhere(
        (item) => item.toLowerCase() == normalized.toLowerCase(),
      );
      if (existingIndex >= 0) {
        _preferredCitySelections.removeAt(existingIndex);
      } else {
        _preferredCitySelections.add(normalized);
      }
      _prefCityController.text = _preferredCitySelections.join(', ');
    });
  }

  Future<void> _syncCountryOptions({required bool reset}) async {
    try {
      if (reset) {
        _countryPage = 1;
        _hasMoreCountries = true;
        _countryDropdownItems = <String>[];
        _isCountryLoading = true;
        _isCountryLoadingMore = false;
      } else {
        _isCountryLoadingMore = true;
      }
      if (mounted) {
        setState(() {});
      }

      final result = await _locationRepository.getCountriesPage(
        page: _countryPage,
        keyword: _countrySearchQuery,
      );

      final merged =
          reset ? <String>[] : List<String>.from(_countryDropdownItems);
      for (final country in result.items) {
        if (!merged.any(
          (item) => item.toLowerCase() == country.name.toLowerCase(),
        )) {
          merged.add(country.name);
        }
      }

      _countryDropdownItems = merged;
      _hasMoreCountries = result.hasNextPage;
      if (_hasMoreCountries) {
        _countryPage++;
      }
    } catch (_) {
      if (reset) {
        _countryDropdownItems = <String>[];
      }
      _hasMoreCountries = false;
    } finally {
      _isCountryLoading = false;
      _isCountryLoadingMore = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _syncCityOptionsForCountry(
    String country, {
    required bool reset,
    bool usePreferenceSelection = false,
  }) async {
    final normalizedCountry = country.trim();
    if (normalizedCountry.isEmpty) {
      _cityDropdownItems = <String>[];
      _hasMoreCities = false;
      _selectedCityCountry = null;
      _cityPage = 1;
      if (mounted) {
        setState(() {});
      }
      return;
    }

    try {
      final shouldReset = reset ||
          _selectedCityCountry?.toLowerCase() !=
              normalizedCountry.toLowerCase();

      if (shouldReset) {
        _selectedCityCountry = normalizedCountry;
        _cityPage = 1;
        _hasMoreCities = true;
        _cityDropdownItems = <String>[];
        _isCityLoading = true;
        _isCityLoadingMore = false;
      } else {
        _isCityLoadingMore = true;
      }
      if (mounted) {
        setState(() {});
      }

      final result = await _locationRepository.getCitiesByCountryPage(
        country: normalizedCountry,
        page: _cityPage,
        keyword: _citySearchQuery,
      );

      final merged =
          shouldReset ? <String>[] : List<String>.from(_cityDropdownItems);
      for (final city in result.items) {
        if (!merged.any((item) => item.toLowerCase() == city.toLowerCase())) {
          merged.add(city);
        }
      }

      _cityDropdownItems = merged;
      _hasMoreCities = result.hasNextPage;
      if (_hasMoreCities) {
        _cityPage++;
      }
    } catch (_) {
      if (reset) {
        _cityDropdownItems = <String>[];
      }
      _hasMoreCities = false;
    } finally {
      _isCityLoading = false;
      _isCityLoadingMore = false;
      if (_cityController.text.trim().isNotEmpty && !usePreferenceSelection) {
        final selectedCity = _cityController.text.trim().toLowerCase();
        final exists = _cityDropdownItems.any(
          (item) => item.toLowerCase() == selectedCity,
        );
        if (!exists) {
          _cityController.clear();
        }
      }

      if (usePreferenceSelection) {
        _preferredCitySelections.removeWhere(
          (city) => !_cityDropdownItems.any(
            (item) => item.toLowerCase() == city.toLowerCase(),
          ),
        );
        _prefCityController.text = _preferredCitySelections.join(', ');
      }
      if (mounted) {
        setState(() {});
      }
    }
  }
}
