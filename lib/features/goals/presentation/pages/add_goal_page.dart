import 'package:cashio/core/utils/snackbar.dart';
import 'package:cashio/core/utils/validators.dart';
import 'package:cashio/core/widgets/custom_button.dart';
import 'package:cashio/core/widgets/custom_date_picker.dart';
import 'package:cashio/core/widgets/custom_dropdown.dart';
import 'package:cashio/core/widgets/custom_input_field.dart';
import 'package:cashio/core/widgets/custom_loading.dart';
import 'package:cashio/features/auth/model/app_user.dart';
import 'package:cashio/features/auth/provider/user_profile_provider.dart';
import 'package:cashio/features/goals/model/goal.dart';
import 'package:cashio/features/goals/provider/goal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

enum PriorityLevel { high, low }

class AddGoalPage extends ConsumerWidget {
  const AddGoalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(profileProvider);

    return userAsync.when(
      error: (e, _) => Scaffold(body: Center(child: Text("User error: $e"))),
      loading: () => Scaffold(body: Center(child: CustomLoading())),
      data: (user) {
        return AddGoalsContent(user: user!);
      },
    );
  }
}

class AddGoalsContent extends ConsumerStatefulWidget {
  final AppUser user;
  const AddGoalsContent({super.key, required this.user});

  @override
  ConsumerState<AddGoalsContent> createState() => _AddGoalsContentState();
}

class _AddGoalsContentState extends ConsumerState<AddGoalsContent> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController targetAmountController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  PriorityLevel selectedPriorityLevel = PriorityLevel.high;
  DateTime? deadline = DateTime.now();

  String? errorMsg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Goal', style: GoogleFonts.outfit()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                CustomInputField(
                  hint: 'Title',
                  icon: Icons.title_rounded,
                  isNumber: false,
                  controller: titleController,
                  validator: Validators.required('Title'),
                ),
                CustomInputField(
                  hint: 'Target amount',
                  icon: Icons.attach_money_rounded,
                  isNumber: true,
                  controller: targetAmountController,
                  validator: Validators.numbers('Taget amount'),
                ),
                CustomInputField(
                  hint: 'Notes(optional)',
                  icon: Icons.notes_rounded,
                  isNumber: false,
                  controller: notesController,
                ),
                CustomDropdown(
                  valueChange: (value) =>
                      setState(() => selectedPriorityLevel = value),
                  hint: 'Priority level',
                  items: PriorityLevel.values,
                  labelBuilder: (e) => e.name,
                  value: PriorityLevel.high,
                ),
                CustomDatePicker(
                  initialDate: deadline!,
                  onDateSelected: (value) => setState(() => deadline = value),
                ),
                Visibility(
                  visible: errorMsg != null ? true : false,
                  child: Text(errorMsg.toString(), style: GoogleFonts.outfit()),
                ),

                CustomButton(
                  hint: 'Add',
                  onPressed: () async {
                    try {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      if (deadline == null) {
                        AppSnackBar.error(context, 'Input deadline');
                        return;
                      }
                      final amount = double.parse(targetAmountController.text);
                      await ref
                          .read(addGoalProvider)
                          .call(
                            Goal(
                              title: titleController.text,
                              userId: widget.user.userId,
                              targetAmount: amount,
                              priorityLevel: selectedPriorityLevel.name,
                              deadline: deadline!,
                            ),
                          );

                      if (!context.mounted) return;
                      AppSnackBar.success(context, 'Goal sucessfully added');
                      Navigator.pop(context);
                    } catch (e) {
                      debugPrint("Add goal error: $e");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
