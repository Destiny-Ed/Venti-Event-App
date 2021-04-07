import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:venti/Providers/database_provider.dart';

class AddEventPage extends StatefulWidget {
  final String id;
  final String path;
  final String eventName;
  final String location;
  final String desc;
  final String sendTo;
  final String date;
  AddEventPage(this.path,
      {this.date,
      this.id,
      this.eventName,
      this.location,
      this.sendTo,
      this.desc});
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _sendToController = TextEditingController();

  String selectedDate = "";
  String selectedTime = "";

  String formatedDate = "";

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isSaving = false;

  @override
  void initState() {
    setState(() {
      _eventController.text = widget.eventName;
      _locationController.text = widget.location;
      _descController.text = widget.desc;
      _sendToController.text = widget.sendTo;
      selectedDate = widget.date != null ? widget.date : "";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: widget.path == "add" ? Text("Add Event") : Text("Update Event"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              //Save the Event
              if (_eventController.text.isEmpty ||
                  selectedDate == "" ||
                  selectedTime == "") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Fields must not be empty")),
                );
              } else {
                setState(() {
                  isSaving = true;
                });

                final dateAndTime = selectedDate + " " + selectedTime;
                print(dateAndTime);

                if (widget.path == "add") {
                  final uid = _auth.currentUser.uid;

                  DatabaseClass(uid)
                      .addEvents(
                          eventName: _eventController.text.trim(),
                          location: _locationController.text.trim(),
                          done: false,
                          description: _descController.text.trim(),
                          sendingTo: _sendToController.text.trim() == ""
                              ? "Me"
                              : _sendToController.text.trim(),
                          date: dateAndTime)
                      .then((value) {
                    setState(() {
                      isSaving = false;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(value)),
                    );
                  });
                } else {
                  final uid = _auth.currentUser.uid;
                  DatabaseClass(uid)
                      .updateEvents(
                          id: widget.id,
                          eventName: _eventController.text.trim(),
                          done: false,
                          location: _locationController.text.trim(),
                          description: _descController.text.trim(),
                          sendingTo: _sendToController.text.trim() == ""
                              ? "Me"
                              : _sendToController.text.trim(),
                          date: dateAndTime)
                      .then((value) {
                    setState(() {
                      isSaving = false;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(value)),
                    );
                  });
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Column(
            children: [
              formFields(
                  context, "Event Name", _eventController, TextInputType.text),
              const SizedBox(
                height: 30,
              ),
              formFields(
                  context, "Location", _locationController, TextInputType.text),
              const SizedBox(
                height: 30,
              ),
              formFields(
                  context, "Description", _descController, TextInputType.text),
              const SizedBox(
                height: 30,
              ),
              formFields(context, "+234 859 4573 459 (Optional)", _sendToController,
                  TextInputType.phone),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Date",
                        style: TextStyle(fontSize: 20),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        // flex: 2,
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(
                                    color: Colors.purple, width: 2.0),
                              ),
                            ),
                            child: TextFormField(
                              readOnly: true,
                              onTap: () {
                                getDate(context);
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText: formatedDate == ""
                                      ? "Event Date"
                                      : formatedDate),
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              horizontal:
                                  BorderSide(color: Colors.purple, width: 2.0),
                            ),
                          ),
                          child: TextFormField(
                            onTap: () {
                              getTime(context);
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: selectedTime == ""
                                    ? "Event Time"
                                    : selectedTime),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  isSaving == false
                      ? Container()
                      : CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  getDate(BuildContext context) async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime.utc(2030),
    );

    if (date != null) {
      String realDate = DateFormat("yyyy-MM-dd").format(date);

      String fDate = DateFormat.yMMMd().format(date);

      setState(() {
        selectedDate = realDate;
        formatedDate = fDate;
      });
    }
  }

  //Time Picker
  Future getTime(BuildContext context) async {
    await showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        selectedTime = value.format(context);
      });
    });
  }
}

Widget formFields(BuildContext context, String text,
    TextEditingController controller, TextInputType type) {
  return Container(
    child: TextFormField(
      keyboardType: type,
      controller: controller,
      decoration: InputDecoration(hintText: text),
    ),
  );
}
