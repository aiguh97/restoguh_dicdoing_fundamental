import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class AddReviewPopup extends StatefulWidget {
  final String restaurantId;
  final VoidCallback onReviewAdded;

  const AddReviewPopup({
    super.key,
    required this.restaurantId,
    required this.onReviewAdded,
  });

  @override
  State<AddReviewPopup> createState() => _AddReviewPopupState();
}

class _AddReviewPopupState extends State<AddReviewPopup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final ok = await ApiService.postReview(
        widget.restaurantId,
        _nameController.text.trim(),
        _reviewController.text.trim(),
      );

      if (ok) {
        // Tutup popup dan refresh data
        if (mounted) {
          Navigator.pop(context);
          widget.onReviewAdded();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ulasan berhasil ditambahkan!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header
                  Row(
                    children: [
                      Text(
                        'Tambah Ulasan',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  const Divider(),

                  // Form
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        controller: controller,
                        children: [
                          const SizedBox(height: 16),

                          // Name Field
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nama Anda',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama harus diisi';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Review Field
                          TextFormField(
                            controller: _reviewController,
                            decoration: const InputDecoration(
                              labelText: 'Ulasan Anda',
                              prefixIcon: Icon(Icons.reviews),
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ulasan harus diisi';
                              }
                              if (value.length < 3) {
                                return 'Ulasan terlalu pendek';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _submitReview,
                              child: _isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Kirim Ulasan',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
