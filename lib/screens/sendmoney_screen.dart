import 'package:digital_wallett_system/models/sendmoney_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'output_screen.dart';

class SendmoneyScreen extends StatefulWidget {
  const SendmoneyScreen({super.key});

  @override
  State<SendmoneyScreen> createState() => _SendmoneyScreenState();
}

class _SendmoneyScreenState extends State<SendmoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobilenumController = TextEditingController();
  final _amountController = TextEditingController();
  final _remarksController = TextEditingController();
  var uuid = Uuid();
  // String? _selectedCity;

  final List<SendMoneyModel> _lstSendMoney = [];

  // final List<DropdownMenuItem<String>> _cities = [
  //   // Dropdown items
  //   DropdownMenuItem(value: "Chitwan", child: Text("Chitwan")),
  //   DropdownMenuItem(value: "Kathmandu", child: Text("Kathmandu")),
  //   DropdownMenuItem(value: "Pokhara", child: Text("Pokhara")),
  // ];

  @override
  void dispose() {
    _mobilenumController.dispose();
    _amountController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Send Money',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
        ),

        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Container(
              //   padding: const EdgeInsets.only(top: 30),
              //   alignment: Alignment.center,
              //   child: SvgPicture.asset(
              //     // "assets/images/logonovacash.svg", //  SVG file
              //     "assets/icons/transactionout.svg", //  SVG file
              //     height: 150, // adjust size as needed
              //   ),
              // ),

              // const SizedBox(height: 20),
              Text(
                "Mobile Number",
                style: TextStyle(
                  color: Color.fromARGB(255, 216, 121, 32),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                maxLength: 10,
                controller: _mobilenumController,
                decoration: InputDecoration(
                  hintText: 'Enter mobile number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 235, 230, 230),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                "Amount (NPR)",
                style: TextStyle(
                  color: Color.fromARGB(255, 216, 121, 32),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 235, 230, 230),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Text(
                "Remarks",
                style: TextStyle(
                  color: Color.fromARGB(255, 216, 121, 32),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _remarksController,
                decoration: InputDecoration(
                  hintText: 'Enter remarks',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 235, 230, 230),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter remarks';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          //Add student code goes here
                          // Student ko object banaune

                          SendMoneyModel newSendMoney = SendMoneyModel(
                            id: uuid.v4(),
                            mobilenumber: _mobilenumController.text,
                            amount: double.parse(_amountController.text),
                            remarks: _remarksController.text,
                            // city: _selectedCity!,
                          );

                          setState(() {
                            _lstSendMoney.add(newSendMoney);
                          });
                        }
                      },

                      label: const Text('CONTINUE'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color.fromARGB(
                          255,
                          216,
                          121,
                          32,
                        ),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OutputScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text('View Send Money Details'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _lstSendMoney.isEmpty
                  ? const Text(
                      'No send money details added yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )
                  // Recycle view
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _lstSendMoney.length,
                      itemBuilder: (context, index) {
                        final sendmoney = _lstSendMoney[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(sendmoney.mobilenumber[0]),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fund Transfer -',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                sendmoney.mobilenumber,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          subtitle: Text('BALANCE: ${sendmoney.amount}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min, // important!
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _lstSendMoney.removeAt(index);
                                  });
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
