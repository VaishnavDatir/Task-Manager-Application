import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../core/models/task_model.dart';
import '../../../core/routing/app_navigator.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../task/view/create_task_screen.dart';
import '../../task/view/task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "Today";

  final List<TaskModel> allTasks = [
    TaskModel(
      id: '1',
      title: 'Fix UI Bug',
      description: 'Resolve layout overflow on dashboard cards.',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      priority: TaskPriority.high,
      status: 'Past Due',
    ),
    TaskModel(
      id: '2',
      title: 'Team Meeting',
      description: 'Discuss project milestones and blockers.',
      dueDate: DateTime.now(),
      priority: TaskPriority.medium,
      status: 'Today',
    ),
    TaskModel(
      id: '3',
      title: 'Write Report',
      description: 'Summarize sprint achievements and blockers.',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: TaskPriority.low,
      status: 'Upcoming',
    ),
    TaskModel(
      id: '4',
      title: 'Code Review',
      description: 'Review PR #234 for new authentication module.',
      dueDate: DateTime.now(),
      priority: TaskPriority.medium,
      status: 'Today',
    ),
    TaskModel(
      id: '5',
      title: 'Plan Sprint',
      description: 'Plan next sprint goals with product team.',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      priority: TaskPriority.high,
      status: 'Upcoming',
    ),
    TaskModel(
      id: '6',
      title: 'Submit Design',
      description: 'Finalize and submit Figma designs to client.',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      priority: TaskPriority.high,
      status: 'Past Due',
    ),
    TaskModel(
      id: '7',
      title: 'Backup Data',
      description: 'Run full system backup before release.',
      dueDate: DateTime.now(),
      priority: TaskPriority.low,
      status: 'Completed',
    ),
  ];

  List<TaskModel> get filteredTasks {
    if (selectedFilter == "All") return allTasks;
    return allTasks.where((task) => task.status == selectedFilter).toList();
  }
  void onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  Widget _taskCard(TaskModel task) {
    return Hero(
      tag: 'task-card-${task.id}',
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: CircleAvatar(child: const Icon(Icons.task_alt)),
          title: Material(
            color: Colors.transparent,
            child: Text(
              task.title,
              style: AppTypography.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          subtitle: Text(
            'Due: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
          ),
          trailing: Icon(
            task.status == 'Completed' ? Icons.check_circle : Icons.schedule,
            color: task.status == 'Completed' ? Colors.green : Colors.orange,
          ),
        ),
      ),
    );
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
        floatingActionButton: OpenContainer(
          transitionType: ContainerTransitionType.fade,
          openColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor ??
              Theme.of(context).colorScheme.primary,
          closedColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor ??
              Theme.of(context).colorScheme.primary,
          closedShape: const CircleBorder(),
          closedElevation: 6,
          transitionDuration: const Duration(milliseconds: 750),
          closedBuilder: (context, openContainer) {
            return FloatingActionButton(
              onPressed: openContainer,
              backgroundColor: Theme.of(
                context,
              ).floatingActionButtonTheme.backgroundColor,
              child: const Icon(Icons.create),
            );
          },

          openBuilder: (context, closeContainer) {
            return const CreateTaskScreen();
          },
        ).fadeInUpBig(),
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
                            onPressed: () {
                              AppNavigator.pushToNamed(RouteNames.profile);
                            },
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
                                onPressed: () {
                                  AppNavigator.pushToNamed(RouteNames.profile);
                                },
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
                  key: ValueKey(selectedFilter), // 🔥 add this key
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
                child: Column(
                  children: filteredTasks.map((task) {
                    // Wrap each card in OpenContainer for morphing animation.
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: OpenContainer(
                        transitionDuration: const Duration(milliseconds: 500),
                        closedElevation: 0,
                        openElevation: 8,
                        closedColor: Colors.transparent,
                        openColor: Theme.of(context).scaffoldBackgroundColor,
                        closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        openBuilder: (context, _) {
                          return TaskDetailScreen(task: task);
                        },
                        closedBuilder: (context, open) {
                          return GestureDetector(
                            onTap: open,
                            child: _taskCard(task),
                          );
                        },
                      ),
                    );
                  }).toList(),
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
  final Key? key;

  _CategorySliverPersistentHeaderDelegate({required this.child, this.key});

  static const double _height = 64.0;

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
  bool shouldRebuild(_CategorySliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.key != key; // ✅ rebuild only when selectedFilter changes
  }
}
