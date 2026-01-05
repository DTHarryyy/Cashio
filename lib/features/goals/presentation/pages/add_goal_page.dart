import 'package:cashio/core/widgets/custom_button.dart';
import 'package:cashio/core/widgets/custom_date_picker.dart';
import 'package:cashio/core/widgets/custom_dropdown.dart';
import 'package:cashio/features/budgets/presentation/pages/add_budget_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum PriorityType { high, low }

class AddGoalPage extends StatefulWidget {
  const AddGoalPage({super.key});

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController targetAmountController = TextEditingController();
    TextEditingController notesController = TextEditingController();
    DateTime date = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Goal', style: GoogleFonts.outfit()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              CustomInputField(
                hint: 'Title',
                icon: Icons.title_rounded,
                isNumber: false,
                controller: titleController,
              ),
              CustomInputField(
                hint: 'Target amount',
                icon: Icons.attach_money_rounded,
                isNumber: true,
                controller: targetAmountController,
              ),
              CustomInputField(
                hint: 'Notes(optional)',
                icon: Icons.notes_rounded,
                isNumber: false,
                controller: notesController,
              ),
              CustomDropdown(
                valueChange: (e) {},
                hint: 'Priority level',
                items: PriorityType.values,
                labelBuilder: (e) => e.name,
                value: PriorityType.high,
              ),
              CustomDatePicker(
                initialDate: date,
                onDateSelected: (value) => setState(() => date = value),
              ),

              CustomButton(hint: 'Add', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
