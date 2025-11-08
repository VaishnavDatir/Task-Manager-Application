import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:wowtask/core/routing/app_navigator.dart';
import 'package:wowtask/core/routing/route_names.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "Today";

  final allTasks = [
    {"title": "Fix UI Bug", "due": "Yesterday", "status": "Past Due"},
    {"title": "Team Meeting", "due": "Today", "status": "Today"},
    {"title": "Team Meeting", "due": "Today", "status": "Today"},
    {"title": "Team Meeting", "due": "Today", "status": "Today"},
    {"title": "Team Meeting", "due": "Today", "status": "Today"},
    {"title": "Team Meeting", "due": "Today", "status": "Today"},
    {"title": "Team Meeting", "due": "Today", "status": "Today"},
    {"title": "Team Meeting", "due": "Today", "status": "Today"},
    {"title": "Team Meeting", "due": "Today", "status": "Today"},
    {"title": "Team Meeting", "due": "Today", "status": "Today"},
    {"title": "Write Report", "due": "Tomorrow", "status": "Upcoming"},
    {"title": "Code Review", "due": "Today", "status": "Today"},
    {"title": "Plan Sprint", "due": "Next Week", "status": "Upcoming"},
    {"title": "Submit Design", "due": "Yesterday", "status": "Past Due"},
    {"title": "Backup Data", "due": "Today", "status": "Completed"},
  ];

  List<Map<String, dynamic>> get filteredTasks {
    if (selectedFilter == "All") return allTasks;
    return allTasks.where((task) => task["status"] == selectedFilter).toList();
  }

  void onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  Widget _buildFilterChip(String label, IconData icon, Color color) {
    final bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => onFilterSelected(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // hides keyboard + removes focus
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => AppNavigator.pushToNamed(RouteNames.createTask),
          backgroundColor: Theme.of(
            context,
          ).floatingActionButtonTheme.backgroundColor,
          shape: CircleBorder(),
          child: Icon(Icons.create),
        ).fadeInUp(),
        body: NotificationListener<ScrollNotification>(
          onNotification: (_) => true,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              // --- Sliver App Bar ---
              SliverLayoutBuilder(
                builder: (context, constraints) {
                  final scrollOffset = constraints.scrollOffset;
                  final bool isCollapsed = scrollOffset > 70;
      
                  final double fadeStart = 30;
                  final double fadeEnd = 100;
                  final double opacity =
                      ((scrollOffset - fadeStart) / (fadeEnd - fadeStart))
                          .clamp(0.0, 1.0);

                  return SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: isCollapsed ? 2 : 0,
                    pinned: true,
                    expandedHeight: 150,
                    toolbarHeight: 70,
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: opacity,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.account_circle),
                            iconSize: AppSpacing.xxl,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Hello, ',
                                  style: AppTypography.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Vaishnav!',
                                  style: AppTypography.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 20,
                          top: 70,
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.account_circle),
                                iconSize: AppSpacing.xxl,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Hello, ',
                                          style: AppTypography.poppins(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Vaishnav!',
                                          style: AppTypography.poppins(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Have a productive day',
                                    style: AppTypography.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      
              // --- Sticky Search Bar ---
              // SliverPersistentHeader(
              //   pinned: true,
              //   delegate: _CategorySliverPersistentHeaderDelegate(
              //     child: Container(
              //       color: Theme.of(context).scaffoldBackgroundColor,
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 16,
              //         vertical: 8,
              //       ),
              //       child: TextField(
              //         enableSuggestions: true,
              //         decoration: InputDecoration(
              //           prefixIcon: const Icon(Icons.search),
              //           hintText: "Find your task...",
              //           hintStyle: Theme.of(context).textTheme.bodyMedium,
              //           border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(30),
              //             borderSide: BorderSide(color: Colors.grey.shade300),
              //           ),
              //           enabledBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(30),
              //             borderSide: BorderSide(color: Colors.grey.shade300),
              //           ),
              //           focusedBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(30),
              //             borderSide: BorderSide(
              //               color: Theme.of(context).colorScheme.primary,
              //               width: 1.5,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              // --- Task Filter Row ---
              SliverPersistentHeader(
                pinned: true,
                delegate: _CategorySliverPersistentHeaderDelegate(
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: SizedBox(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildFilterChip(
                            "Past Due",
                            Icons.warning_amber_rounded,
                            Colors.redAccent,
                          ),
                          _buildFilterChip(
                            "Today",
                            Icons.calendar_today,
                            Colors.orangeAccent,
                          ),
                          _buildFilterChip(
                            "Upcoming",
                            Icons.upcoming,
                            Colors.blueAccent,
                          ),
                          _buildFilterChip(
                            "Completed",
                            Icons.check_circle,
                            Colors.green,
                          ),
                        ],
                      ).fadeInDownBig(),
                    ),
                  ),
                ),
              ),

              // --- Animated Task List ---
              SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Column(
                    key: ValueKey(selectedFilter),
                    children: filteredTasks.map((task) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent.withOpacity(
                                0.15,
                              ),
                              child: const Icon(
                                Icons.task_alt,
                                color: Colors.blueAccent,
                              ),
                            ),
                            title: Text(
                              task["title"],
                              style: AppTypography.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "Due: ${task["due"]}",
                              style: AppTypography.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: Icon(
                              task["status"] == "Completed"
                                  ? Icons.check_circle
                                  : Icons.schedule,
                              color: task["status"] == "Completed"
                                  ? Colors.green
                                  : Colors.orangeAccent,
                            ),
                          ),
                        ).fadeInUp(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Custom Delegate for Sticky Search Bar ---
class _CategorySliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final Widget child;
  _CategorySliverPersistentHeaderDelegate({required this.child});

  static const double _height = 64.0; // fixed safe height to avoid extent error

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => _height;
  @override
  double get minExtent => _height;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
