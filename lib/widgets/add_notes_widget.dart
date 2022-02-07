import 'package:flutter/material.dart';
import 'package:flutter_sqlite/sql_helper.dart';

addNotes(String ?id,String title,String description,BuildContext context) {

  TextEditingController titleController       = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  return showModalBottomSheet<dynamic>(
    context: context,
    elevation: 5,
    isScrollControlled: false,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    builder: (_) => Container(
      padding: EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
       bottom: MediaQuery.of(context).viewInsets.bottom + 120,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
             TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Title"
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  hintText: "Description"
              ),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: (){
                  SQLHelper.saveNotes(titleController.text.toString(), titleController.text.toString());
                  Navigator.of(context).pop(context);

                },
                child: Text(id == null ? "Add Note"  : "Update Note"),
              ),
            )
          ],
        ),
      ),
    )
  );

}