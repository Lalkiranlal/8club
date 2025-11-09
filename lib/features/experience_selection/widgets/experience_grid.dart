// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:eightclub/core/models/models.dart';
// import 'package:flutter/material.dart';

// class ExperienceGrid extends StatelessWidget {
//   final List<Experience> experiences;
//   final Function(Experience) onExperienceSelected;

//   const ExperienceGrid({
//     super.key,
//     required this.experiences,
//     required this.onExperienceSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16.0,
//           mainAxisSpacing: 16.0,
//           childAspectRatio: 0.8,
//         ),
//         itemCount: experiences.length,
//         itemBuilder: (context, index) {
//           final experience = experiences[index];
//           return _ExperienceCard(experience: experience, onTap: () => onExperienceSelected(experience));
//         },
//       ),
//     );
//   }
// }

// class _ExperienceCard extends StatelessWidget {
//   final Experience experience;
//   final VoidCallback onTap;

//   const _ExperienceCard({
//     super.key,
//     required this.experience,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
//                 child: CachedNetworkImage(
//                   imageUrl: experience.imageUrl,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
//                   errorWidget: (context, url, error) => const Icon(Icons.error),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     experience.name,
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4.0),
//                   Text(
//                     experience.description,
//                     style: Theme.of(context).textTheme.bodySmall,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
