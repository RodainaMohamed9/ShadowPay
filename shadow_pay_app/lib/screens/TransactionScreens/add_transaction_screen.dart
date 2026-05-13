import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/core/enums/category.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/screens/home/home_screen.dart';

class AddTransactionScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final Function(Map<String, dynamic>)? onAnalyze;

  const AddTransactionScreen({
    super.key,
    this.onBack,
    this.onAnalyze,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _zipController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _hour = 12;
  Category? _selectedCategory;

  void _analyzeAndNavigate() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.error_category),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }

      final Map<String, dynamic> transactionData = {
        'amount': double.parse(_amountController.text),
        'hour': _hour,
        'category': categoryToId(_selectedCategory!),
        'zipCode':
            _zipController.text.isEmpty ? 0 : int.parse(_zipController.text),
      };

      if (widget.onAnalyze != null) {
        widget.onAnalyze!(transactionData);
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final primaryColor =
        isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary;
    final backgroundColor =
        isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
    final surfaceColor =
        isDarkMode ? AppColors.darkSurface : AppColors.lightSurface;
    final inputColor =
        isDarkMode ? AppColors.darkProgressBg : AppColors.lightProgressBg;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final textSecondaryColor = isDarkMode ? Colors.white70 : Colors.grey[700];
    final hintColor = isDarkMode ? Colors.white38 : Colors.grey.shade500;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              (isDarkMode ? const Color(0xff1D293D) : Colors.grey.shade200)
                  .withOpacity(0.4),
            ),
            side: MaterialStateProperty.all(
              BorderSide(
                color:
                    textSecondaryColor?.withOpacity(0.5) ?? Colors.transparent,
                width: 1,
              ),
            ),
          ),
          iconSize: 25,

onPressed: () {
  if (widget.onBack != null) {
    widget.onBack!();
  } else {
    Navigator.pop(context);
  }
},
          icon: Transform.scale(
            scaleX: isRTL ? -1 : 1,
            child: Icon(Icons.arrow_back, color: textSecondaryColor),
          ),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: surfaceColor.withOpacity(0.85),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: primaryColor.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 25,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        localizations.enter_transaction_details,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Amount Field
                    Text(
                      localizations.transaction_amount,
                      style: TextStyle(
                        color: textSecondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(color: textColor, fontSize: 16),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      decoration: _inputDecoration(
                        localizations.amount_hint,
                        hintColor,
                        inputColor,
                        primaryColor,
                      ).copyWith(
                        prefixIcon:
                            Icon(Icons.attach_money, color: primaryColor),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 1, height: 30, color: hintColor),
                            IconButton(
                              icon: Icon(Icons.remove,
                                  color: textSecondaryColor, size: 20),
                              onPressed: () {
                                if (_amountController.text.isNotEmpty) {
                                  double currentValue =
                                      double.tryParse(_amountController.text) ??
                                          0;
                                  double newValue = currentValue - 1;
                                  if (newValue > 0) {
                                    _amountController.text =
                                        newValue.toStringAsFixed(2);
                                  } else {
                                    _amountController.text = "0.01";
                                  }
                                } else {
                                  _amountController.text = "0.01";
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.add,
                                  color: textSecondaryColor, size: 20),
                              onPressed: () {
                                double currentValue =
                                    double.tryParse(_amountController.text) ??
                                        0;
                                _amountController.text =
                                    (currentValue + 1).toStringAsFixed(2);
                              },
                            ),
                          ],
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return localizations.error_amount_empty;
                        if (double.tryParse(value) == null)
                          return localizations.error_amount_invalid;
                        if (double.parse(value) <= 0)
                          return localizations.error_amount_zero;
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Category Dropdown (from first version - using enum)
                    Text(
                      localizations.transaction_category,
                      style: TextStyle(
                          color: textSecondaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: Scrollbar(
                        thumbVisibility: true,
                        thickness: 6,
                        radius: const Radius.circular(10),
                        child: DropdownButtonFormField<Category>(
                          isExpanded: true,
                          dropdownColor: inputColor,
                          value: _selectedCategory,
                          style: TextStyle(color: textColor, fontSize: 14),
                          decoration: _inputDecoration(
                            localizations.category_hint,
                            hintColor,
                            inputColor,
                            primaryColor,
                          ).copyWith(
                            prefixIcon:
                                Icon(Icons.category, color: primaryColor),
                          ),
                          items: Category.values.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(
                                cat.displayName(localizations),
                                style:
                                    TextStyle(fontSize: 14, color: textColor),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          menuMaxHeight: 200,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Hour Slider (from first version - cleaner structure)
                    Text(
                      localizations.transaction_hour,
                      style: TextStyle(
                          color: textSecondaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("00",
                            style: TextStyle(color: hintColor, fontSize: 12)),
                        Text("06",
                            style: TextStyle(color: hintColor, fontSize: 12)),
                        Text("12",
                            style: TextStyle(color: hintColor, fontSize: 12)),
                        Text("18",
                            style: TextStyle(color: hintColor, fontSize: 12)),
                        Text("23",
                            style: TextStyle(color: hintColor, fontSize: 12)),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        showValueIndicator: ShowValueIndicator.always,
                        valueIndicatorColor: primaryColor,
                        valueIndicatorTextStyle: TextStyle(
                          color: isDarkMode ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overlayColor: primaryColor.withOpacity(0.2),
                        thumbColor: primaryColor,
                        activeTrackColor: primaryColor,
                        inactiveTrackColor: hintColor,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 14),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 28),
                      ),
                      child: Slider(
                        value: _hour.toDouble(),
                        min: 0,
                        max: 23,
                        divisions: 23,
                        label: _hour.toString(),
                        onChanged: (value) =>
                            setState(() => _hour = value.toInt()),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Zip Code Field
                    Text(
                      localizations.zip_code,
                      style: TextStyle(
                          color: textSecondaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _zipController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: textColor, fontSize: 14),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      decoration: _inputDecoration(
                        localizations.zip_code_hint,
                        hintColor,
                        inputColor,
                        primaryColor,
                      ).copyWith(
                        prefixIcon:
                            Icon(Icons.location_on, color: primaryColor),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        if (!RegExp(r'^\d+$').hasMatch(value))
                          return localizations.error_zip_invalid;
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Analyze Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 8,
                          shadowColor: primaryColor.withOpacity(0.5),
                        ),
                        onPressed: _analyzeAndNavigate,
                        child: Text(
                          localizations.analyze_transaction,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
      String hint, Color hintColor, Color fillColor, Color primaryColor) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: hintColor, fontSize: 14),
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
