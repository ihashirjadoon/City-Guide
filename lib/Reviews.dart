import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reviews extends StatefulWidget {
  const Reviews({super.key});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        backgroundColor: Colors.lightGreen[600], // Light green theme
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Example of calling the addReview method with sample data
                addReview('attraction_123', 'user_456', 5, 'Great experience!');
              },
              icon: const Icon(Icons.add_comment),
              label: const Text('Add Review'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: Colors.green,
                textStyle: const TextStyle(fontSize: 16),
                foregroundColor: Colors.white, // Set font color to white
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: getReviews('attraction_123'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No reviews available.'));
                  }

                  final reviews = snapshot.data!;

                  return ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      var timestamp = review['timestamp']?.toDate();
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.orange[700],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Rating: ${review['rating']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              review['comment'],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          trailing: timestamp == null
                              ? const Text('No timestamp')
                              : Text(
                                  timestamp.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addReview(
      String attractionId, String userId, int rating, String comment) async {
    final review = {
      'attractionId': attractionId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await FirebaseFirestore.instance.collection('reviews').add(review);
  }
}

Stream<List<Map<String, dynamic>>> getReviews(String attractionId) {
  return FirebaseFirestore.instance
      .collection('reviews')
      .where('attractionId', isEqualTo: attractionId)
      .orderBy('timestamp', descending: true) // Sorting requires an index
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
}
