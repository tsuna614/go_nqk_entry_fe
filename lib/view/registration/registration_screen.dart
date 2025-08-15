import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_nqk_entry_fe/bloc/subscribe-bloc/subscribe_bloc.dart';
import 'package:go_nqk_entry_fe/bloc/subscribe-bloc/subscribe_events.dart';
import 'package:go_nqk_entry_fe/bloc/subscribe-bloc/subscribe_states.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _onSubscribe() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();

      // Dispatch the subscription event
      context.read<SubscribeBloc>().add(SendSubcriptionEvent(email));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subcription invitation sent to: $email')),
      );
      _emailController.clear();
    }
  }

  void _onUnsubscribe() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();

      // Dispatch the unsubscription event
      context.read<SubscribeBloc>().add(SendUnsubscriptionEvent(email));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unsubscription request sent for: $email')),
      );
      _emailController.clear();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Registration",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: BlocConsumer<SubscribeBloc, SubscribeStates>(
        listener: (context, state) {
          if (state is SubscribeErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is SubscribeSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Subscription successful sent!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (constraints.maxWidth <= 700) ...[
                      Expanded(child: buildRegistrationForm()),
                    ] else if (constraints.maxWidth <= 1000) ...[
                      Expanded(flex: 1, child: const SizedBox()),
                      Expanded(flex: 2, child: buildRegistrationForm()),
                      Expanded(flex: 1, child: const SizedBox()),
                    ] else ...[
                      Expanded(flex: 1, child: const SizedBox()),
                      Expanded(flex: 1, child: buildRegistrationForm()),
                      Expanded(flex: 1, child: const SizedBox()),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your email to subscribe to our daily weather reports!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  final emailPattern = RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  );
                  if (!emailPattern.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _onSubscribe(),
                    child: Text("Subscribe"),
                  ),
                  SizedBox(width: 16),
                  // unsubscribe button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _onUnsubscribe(),
                    child: Text("Unsubscribe"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
