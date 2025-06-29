import 'dart:async';
import 'package:flutter/material.dart';
import 'package:balady_plus/app/features/health_certificate/presentation/core/models/profession.dart';
import 'package:balady_plus/app/features/health_certificate/presentation/core/services/repository/health_license_repository.dart';
import 'package:smart_advisor/app/core/utils/constants/language.dart';

class ProfessionSearchDropdown extends StatefulWidget {
  final ValueChanged<Profession?>? onChanged;
  final String? label;
  final String? hintText;
  final Profession? initialValue;

  const ProfessionSearchDropdown({
    Key? key,
    this.onChanged,
    this.label,
    this.hintText,
    this.initialValue,
  }) : super(key: key);
@override
ProfessionSearchDropdownState createState() => ProfessionSearchDropdownState();

}


class ProfessionSearchDropdownState extends State<ProfessionSearchDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final HealthLicenseRepository _repository = HealthLicenseRepository();
  
  List<Profession> _professions = [];
  Profession? _selectedProfession;
  bool _isLoading = false;
  bool _isDropdownOpen = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _selectedProfession = widget.initialValue;
    if (_selectedProfession != null) {
      _searchController.text = _selectedProfession!.name ?? '';
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        _isDropdownOpen = true;
      });
      _searchProfessions(_searchController.text);
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchProfessions(query);
    });
  }

  Future<void> _searchProfessions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _professions = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _repository.searchProfessions(
        query: query,
        page: 0,
        size: 10,
      );
      
      if (mounted) {
        setState(() {
          _professions = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Show error message if needed
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to load professions')),
        // );
      }
    }
  }


  void _selectProfession(Profession profession) {
    setState(() {
      _selectedProfession = profession;
      _searchController.text = profession.name ?? '';
      _isDropdownOpen = false;
    });
    widget.onChanged?.call(profession);
    FocusScope.of(context).unfocus();
  }

  void _clearSelection() {
    setState(() {
      _selectedProfession = null;
      _searchController.clear();
      _professions = [];
    });
    widget.onChanged?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isDropdownOpen 
                ? Theme.of(context).primaryColor 
                : Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              TextFormField(
                controller: _searchController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: widget.hintText ?? "Search_for_a_profession...".tr(),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: _selectedProfession != null
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: _clearSelection,
                        )
                      : const Icon(Icons.arrow_drop_down, size: 24),
                ),
                onChanged: (value) {
                  setState(() {
                    _isDropdownOpen = true;
                  });
                  _onSearchChanged(value);
                },
                onTap: () {
                  setState(() {
                    _isDropdownOpen = true;
                  });
                },
              ),
              if (_isDropdownOpen) ..._buildDropdownContent(),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDropdownContent() {
    if (_isLoading) {
      return [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (_professions.isEmpty && _searchController.text.isNotEmpty) {
      return [
         Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No_professions_found'.tr()),
        ),
      ];
    }

    if (_professions.isEmpty) {
      return [];
    }

    return [
      const Divider(height: 1, thickness: 1),
      Container(
        constraints: const BoxConstraints(maxHeight: 200),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _professions.length,
          itemBuilder: (context, index) {
            final profession = _professions[index];
            return ListTile(
              title: Text(profession.name ?? ''),
              onTap: () => _selectProfession(profession),
            );
          },
        ),
      ),
    ];
  }
}
