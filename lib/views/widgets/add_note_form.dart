import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/constants.dart';
import 'package:note_app/cubits/add_note_cubit/add_note_cubit.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/views/widgets/colors_list_view.dart';
import 'package:note_app/views/widgets/custom_button.dart';
import 'package:note_app/views/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

class AddNoteForm extends StatefulWidget {
  const AddNoteForm({
    super.key,
  });

  @override
  State<AddNoteForm> createState() => _AddNoteFormState();
}

class _AddNoteFormState extends State<AddNoteForm> {
  final GlobalKey<FormState> formKey = GlobalKey();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  String? title, content;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
            onSaved: (
              value,
            ) {
              title = value;
            },
            maxLines: 1,
            hint: 'Note Title',
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextField(
            onSaved: (
              value,
            ) {
              content = value;
            },
            hint: 'Note Content',
            maxLines: 5,
          ),
          const SizedBox(
            height: 20,
          ),
          const ColorItemList(),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<AddNoteCubit, AddNoteState>(
            builder: (context, state) {
              return CustomButton(
                isLoading: state is AddNoteLoading ? true : false,
                onTap: () {
                  onTap(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void onTap(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var currentTime = DateTime.now();
      var formattedCurrentTime =
          DateFormat('dd-MM-yyyy HH:mm').format(currentTime);

      var noteModel = NoteModel(
        title: title!,
        content: content!,
        dateTime: formattedCurrentTime,
        color: kPrimaryColor.value,
      );
      BlocProvider.of<AddNoteCubit>(context).AddNote(noteModel);
    } else {
      autovalidateMode = AutovalidateMode.always;
      setState(() {});
    }
  }
}
