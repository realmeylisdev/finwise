import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/achievements/presentation/bloc/achievements_bloc.dart';
import 'package:finwise/features/achievements/presentation/widgets/badge_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: BlocBuilder<AchievementsBloc, AchievementsState>(
        builder: (context, state) {
          if (state.status == AchievementsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AchievementsStatus.failure) {
            return Center(
              child: Text(state.failureMessage ?? 'Something went wrong'),
            );
          }

          return CustomScrollView(
            slivers: [
              // Progress header
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingL),
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF6366F1),
                          Color(0xFF818CF8),
                          Color(0xFFA5B4FC),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emoji_events,
                              color: Colors.amber,
                              size: 28.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '${state.unlockedCount} of ${state.totalCount} unlocked',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: LinearProgressIndicator(
                            value: state.totalCount > 0
                                ? state.unlockedCount / state.totalCount
                                : 0,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.amber,
                            ),
                            minHeight: 10.h,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        if (state.currentStreak > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                color: Colors.orange.shade300,
                                size: 20.w,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${state.currentStreak} day streak',
                                style: TextStyle(
                                  color:
                                      Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Achievement grid
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 0.78,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final achievement = state.achievements[index];
                      return BadgeWidget(achievement: achievement);
                    },
                    childCount: state.achievements.length,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: SizedBox(height: 40.h),
              ),
            ],
          );
        },
      ),
    );
  }
}
