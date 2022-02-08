import 'package:flutter/material.dart';
import 'package:flutter_sqlite/widgets/sql_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Map<String, dynamic>> _notesData= [];
  bool isLoading = true;

  void getAllItems() async{
    final data = await SQLTest.getAllData();
    setState(() {
      _notesData = data;
      isLoading  = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllItems();
  }

  addNotes(int ?id,String ?title,String ?des) {

    TextEditingController titleController       = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    if(title != null && des != null){
      titleController.text = title;
      descriptionController.text = des;
    }

    return showModalBottomSheet(
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
                      if(id == null){
                        SQLTest.insertData(titleController.text.toString(), descriptionController.text.toString()).then((value) => {
                          if(value != -1){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Data inserted successfully"),
                            ))
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Failed to insert Data"),
                            ))
                          }

                        });
                      }else{
                        SQLTest.updateData(id,titleController.text.toString(), descriptionController.text.toString());
                      }

                      Navigator.of(context).pop(context);
                      getAllItems();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _notesData.isEmpty ? const Center(
        child: Text("No Data Found",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
      ) : ListView.builder(
        itemCount: _notesData.length,
        itemBuilder: (context,position){
          return Container(
            child: Card(
              elevation: 4,
              child: ListTile(
                title: Text(_notesData[position]['title']),
                subtitle: Text(_notesData[position]['description']),
                trailing: Wrap(
                  spacing: 12,
                  children: [
                    GestureDetector(
                      onTap: (){
                        addNotes(_notesData[position]["id"],_notesData[position]["title"],_notesData[position]["description"]);
                      },
                        child: Icon(Icons.edit)
                    ),
                    GestureDetector(
                        onTap: (){
                          SQLTest.deleteData(_notesData[position]["id"]);
                          getAllItems();
                        },
                        child: Icon(Icons.delete)
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          addNotes(null,null,null);
        },
      ),
    );
  }
}

