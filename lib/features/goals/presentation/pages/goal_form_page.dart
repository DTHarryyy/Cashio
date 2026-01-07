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

class GoalFormPage extends ConsumerWidget {
  final Goal? goal;
  const GoalFormPage({super.key, this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(profileProvider);

    return userAsync.when(
      error: (e, _) => Scaffold(body: Center(child: Text("User error: $e"))),
      loading: () => Scaffold(body: Center(child: CustomLoading())),
      data: (user) {
        return GoalFormPageContent(user: user!, goal: goal);
      },
    );
  }
}

class GoalFormPageContent extends ConsumerStatefulWidget {
  final AppUser user;
  final Goal? goal;
  const GoalFormPageContent({super.key, required this.user, this.goal});

  @override
  ConsumerState<GoalFormPageContent> createState() =>
      _GoalFormPageContentState();
}

class _GoalFormPageContentState extends ConsumerState<GoalFormPageContent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController targetAmountController;
  TextEditingController notesController = TextEditingController();

  PriorityLevel? selectedPriorityLevel;
  late DateTime? deadline;

  String? errorMsg;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.goal?.title ?? '');
    targetAmountController = TextEditingController(
      text: widget.goal?.targetAmount.toString() ?? '',
    );
    selectedPriorityLevel = widget.goal != null
        ? PriorityLevel.values.firstWhere(
            (e) => e.name == widget.goal!.priorityLevel,
            orElse: () => PriorityLevel.high,
          )
        : PriorityLevel.high;
    deadline = widget.goal?.deadline;
    notesController = TextEditingController(text: widget.goal?.notes ?? '');
  }

  Future<void> onSubmit() async {
    try {
      if (!_formKey.currentState!.validate()) return;

      final amount = double.parse(targetAmountController.text);

      final newGoal = Goal(
        goalId: widget.goal?.goalId,
        title: titleController.text.trim(),
        userId: widget.user.userId,
        targetAmount: amount,
        priorityLevel: selectedPriorityLevel!.name,
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
        deadline: deadline!,
      );
      if (widget.goal != null) {
        await ref.read(updateGoalProvider).call(newGoal);
      } else {
        await ref.read(addGoalProvider).call(newGoal);
      }
      if (!mounted) return;
      AppSnackBar.success(context, 'Goal sucessfully added');
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Goal form error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.goal == null ? 'Add goal' : 'Edit ${widget.goal?.title}',
          style: GoogleFonts.outfit(),
        ),
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
                  validator: Validators.numbers('Target amount'),
                ),
                CustomDropdown(
                  initialValue: selectedPriorityLevel,
                  valueChange: (value) =>
                      setState(() => selectedPriorityLevel = value),
                  hint: 'Please select priority level',
                  items: PriorityLevel.values,
                  labelBuilder: (e) => e.name,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a priority level';
                    }
                    return null;
                  },
                ),
                CustomInputField(
                  hint: 'Notes(optional)',
                  icon: Icons.notes_rounded,
                  isNumber: false,
                  controller: notesController,
                ),
                CustomDatePickerFormField(
                  initialDate: deadline,
                  validator: Validators.dateValidator('Deadline', false),
                  onDateSelected: (value) => setState(() => deadline = value),
                ),
                if (errorMsg != null)
                  Text(errorMsg!, style: GoogleFonts.outfit()),

                CustomButton(
                  hint: widget.goal == null ? 'Add' : 'Update',
                  onPressed: onSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
