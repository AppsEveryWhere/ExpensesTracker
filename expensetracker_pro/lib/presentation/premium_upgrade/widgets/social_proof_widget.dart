import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialProofWidget extends StatelessWidget {
  final List<Map<String, dynamic>> testimonials;

  const SocialProofWidget({
    super.key,
    required this.testimonials,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What Our Users Say',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),

        // App Store rating summary
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Star rating
              Row(
                children: List.generate(5, (index) {
                  return CustomIconWidget(
                    iconName: 'star',
                    color: AppTheme.warningColor,
                    size: 5.w,
                  );
                }),
              ),
              SizedBox(width: 3.w),

              // Rating text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '4.9 out of 5',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Based on 2,847 reviews',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),

        // Testimonials
        SizedBox(
          height: 25.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: testimonials.length,
            separatorBuilder: (context, index) => SizedBox(width: 4.w),
            itemBuilder: (context, index) {
              final testimonial = testimonials[index];
              return _buildTestimonialCard(context, testimonial);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonialCard(
      BuildContext context, Map<String, dynamic> testimonial) {
    final String name = testimonial['name'] as String;
    final int rating = testimonial['rating'] as int;
    final String comment = testimonial['comment'] as String;
    final String avatar = testimonial['avatar'] as String;

    return Container(
      width: 70.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: avatar,
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: List.generate(rating, (index) {
                        return CustomIconWidget(
                          iconName: 'star',
                          color: AppTheme.warningColor,
                          size: 3.w,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Comment
          Expanded(
            child: Text(
              comment,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
