import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/core/enums/category.dart' as my_enum;

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _zipController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _hour = 12;
  my_enum.Category? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D111F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D111F),
        elevation: 0,
        leading: IconButton(
          icon: Transform.scale(
            scaleX: isRTL ? -1 : 1,
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Title فوق الـ box
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text(
                localizations.add_transaction,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Container بتاع الفورم
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFF141A2B),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
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
                      // العنوان الداخلي (اتجاهه حسب اللغة)
                      Align(
                        alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(
                          localizations.enter_transaction_details,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// 💰 Amount
                      Align(
                        alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(
                          localizations.transaction_amount,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        textDirection: TextDirection.ltr, // الأرقام LTR
                        textAlign: TextAlign.left,
                        decoration: _inputDecoration(localizations.amount_hint).copyWith(
                          prefixIcon: const Icon(
                            Icons.attach_money,
                            color: Color(0xFF00D8A2),
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 1,
                                height: 30,
                                color: Colors.white24,
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove, color: Colors.white70, size: 20),
                                onPressed: () {
                                  if (_amountController.text.isNotEmpty) {
                                    double currentValue = double.tryParse(_amountController.text) ?? 0;
                                    double newValue = currentValue - 1;
                                    if (newValue > 0) {
                                      _amountController.text = newValue.toStringAsFixed(2);
                                    } else if (newValue == 0) {
                                      _amountController.text = "0.01";
                                    }
                                  } else {
                                    _amountController.text = "0.01";
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.white70, size: 20),
                                onPressed: () {
                                  double currentValue = double.tryParse(_amountController.text) ?? 0;
                                  double newValue = currentValue + 1;
                                  _amountController.text = newValue.toStringAsFixed(2);
                                },
                              ),
                            ],
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return localizations.error_amount_empty;
                          }
                          if (double.tryParse(value) == null) {
                            return localizations.error_amount_invalid;
                          }
                          if (double.parse(value) <= 0) {
                            return localizations.error_amount_zero;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      /// ⏰ Hour Slider
                      Align(
                        alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(
                          localizations.transaction_hour,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "0",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "23",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          showValueIndicator: ShowValueIndicator.always,
                          valueIndicatorColor: const Color(0xFF00D8A2),
                          valueIndicatorTextStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overlayColor: const Color(0xFF00D8A2).withOpacity(0.2),
                          thumbColor: const Color(0xFF00D8A2),
                          activeTrackColor: const Color(0xFF00D8A2),
                          inactiveTrackColor: Colors.white24,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                        ),
                        child: Slider(
                          value: _hour.toDouble(),
                          min: 0,
                          max: 23,
                          divisions: 23,
                          label: _hour.toString(),
                          onChanged: (value) {
                            setState(() {
                              _hour = value.toInt();
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// 🏷 Category Dropdown
                      Align(
                        alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(
                          localizations.transaction_category,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 6,
                          radius: const Radius.circular(10),
                          child: DropdownButtonFormField<my_enum.Category>(
                            isExpanded: true,
                            dropdownColor: const Color(0xFF1F2A44),
                            value: _selectedCategory,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(localizations.category_hint).copyWith(
                              prefixIcon: const Icon(
                                Icons.category,
                                color: Color(0xFF00D8A2),
                              ),
                            ),
                            items: my_enum.Category.values.map((cat) {
                              return DropdownMenuItem(
                                value: cat,
                                child: Text(
                                  cat.displayName,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            },
                            menuMaxHeight: 200,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF00D8A2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// 📍 Zip Code
                      Align(
                        alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(
                          localizations.zip_code,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _zipController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        decoration: _inputDecoration(localizations.zip_code_hint).copyWith(
                          prefixIcon: const Icon(
                            Icons.location_on,
                            color: Color(0xFF00D8A2),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return localizations.error_zip_invalid;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      /// 🔘 Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00D8A2),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 5,
                            shadowColor: const Color(0xFF00D8A2).withOpacity(0.5),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_selectedCategory == null) {
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
                              
                              // البيانات كلها بالإنجليزي للـ API
                              print("Amount: ${_amountController.text}");
                              print("Hour: $_hour");
                              print("Category: $_selectedCategory");
                              print("Zip: ${_zipController.text}");
                            }
                          },
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
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFF1F2A44),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF00D8A2),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
  
}

