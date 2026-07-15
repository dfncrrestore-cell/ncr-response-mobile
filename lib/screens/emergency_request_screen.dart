import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class EmergencyRequestScreen extends StatefulWidget {
  static const routeName = '/emergency-request';

  const EmergencyRequestScreen({super.key});

  @override
  State<EmergencyRequestScreen> createState() => _EmergencyRequestScreenState();
}

class _EmergencyRequestScreenState extends State<EmergencyRequestScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final List<String> _photos = [];
  String _location = '';
  bool _submitted = false;

  void _nextStep() {
    if (_currentStep == 0 && !_formKey.currentState!.validate()) return;
    if (_currentStep == 2 && _location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a location before continuing.')),
      );
      return;
    }
    setState(() {
      if (_currentStep < 3) {
        _currentStep += 1;
      }
    });
  }

  void _backStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep -= 1;
      }
    });
  }

  void _addPhoto() {
    setState(() {
      final index = _photos.length + 1;
      _photos.add('Photo $index');
    });
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  void _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _currentStep = 0;
      });
      return;
    }

    final requestData = {
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'notes': _notesController.text.trim(),
      'photos': _photos,
      'location': _location,
    };

    try {
      await FirebaseService().saveEmergencyRequest(requestData);
      setState(() {
        _submitted = true;
        _currentStep = 3;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Emergency request saved to Firebase.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit request: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NCR Response™ Emergency Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '🚨 Request Emergency Service',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: _currentStep < 3 ? _nextStep : null,
                onStepCancel: _backStep,
                controlsBuilder: (context, details) {
                  final isLastStep = _currentStep == 3;
                  return Row(
                    children: [
                      if (!isLastStep)
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text(_currentStep == 2 ? 'Submit Request' : 'Next'),
                        ),
                      if (_currentStep > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Back'),
                          ),
                        ),
                    ],
                  );
                },
                steps: [
                  Step(
                    title: const Text('Customer Information'),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: 'Full Name'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(labelText: 'Phone Number'),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Phone number is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _addressController,
                            decoration: const InputDecoration(labelText: 'Address'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Address is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _notesController,
                            decoration: const InputDecoration(
                              labelText: 'Incident details',
                              alignLabelWithHint: true,
                            ),
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                  ),
                  Step(
                    title: const Text('Upload Photos'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _addPhoto,
                          icon: const Icon(Icons.photo_camera),
                          label: const Text('Add Photo'),
                        ),
                        const SizedBox(height: 12),
                        if (_photos.isEmpty)
                          const Text('No photos uploaded yet. You can add images of the incident.'),
                        for (var i = 0; i < _photos.length; i++)
                          ListTile(
                            title: Text(_photos[i]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removePhoto(i),
                            ),
                          ),
                      ],
                    ),
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                  ),
                  Step(
                    title: const Text('Location'),
                    content: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Location details',
                            hintText: 'Enter your current location or incident location',
                          ),
                          onChanged: (value) => setState(() {
                            _location = value;
                          }),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _location = 'Use current GPS location';
                            });
                          },
                          icon: const Icon(Icons.my_location),
                          label: const Text('Use current location'),
                        ),
                        if (_location.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text('Selected location: $_location'),
                        ],
                      ],
                    ),
                    isActive: _currentStep >= 2,
                    state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                  ),
                  Step(
                    title: const Text('Submit Request'),
                    content: _submitted
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Your emergency request has been submitted.'),
                              SizedBox(height: 8),
                              Text('Saved to Firebase'),
                              SizedBox(height: 4),
                              Text('Office Dashboard Receives Alert'),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Review the request details and submit.
Your request will be saved and sent to the office dashboard.',
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _submitRequest,
                                child: const Text('Submit Emergency Request'),
                              ),
                            ],
                          ),
                    isActive: _currentStep >= 3,
                    state: _submitted ? StepState.complete : StepState.indexed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
