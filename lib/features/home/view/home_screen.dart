import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../core/models/task_model.dart';
import '../../../core/routing/app_navigator.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/ui_utils.dart';
import '../../task/view/create_task_screen.dart';
import '../../task/view/task_detail_screen.dart';
import '../view_model/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "Today";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().fetchTasks();
    });
  }

  void onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  Widget _taskCard(TaskModel task) {
    return Hero(
      tag: 'task-card-${task.objectId}',
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: const CircleAvatar(child: Icon(Icons.task_alt)),
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
            UiUtils.formatDueDate(task.dueDate)
          ),
          trailing: Icon(
            task.status == 'Completed' ? Icons.check_circle : Icons.schedule,
            color: UiUtils.getStatusColor(task, selectedFilter),
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
    final taskVM = context.watch<HomeViewModel>();
    final filteredTasks = taskVM.getFilteredTasks(selectedFilter);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
          onClosed: (createdTask) {
            if (createdTask != null) {
              taskVM.fetchTasks();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Task Created Successfully")),
              );
            }
          },
          openBuilder: (context, closeContainer) {
            return const CreateTaskScreen();
          },
        ).fadeInUpBig(),
        body: RefreshIndicator(
          onRefresh: () => taskVM.fetchTasks(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              _buildFilterHeader(),
              SliverToBoxAdapter(
                child: _buildTaskList(context, taskVM, filteredTasks),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final scrollOffset = constraints.scrollOffset;
        final bool isCollapsed = scrollOffset > 70;

        final double fadeStart = 30;
        final double fadeEnd = 100;
        final double opacity =
            ((scrollOffset - fadeStart) / (fadeEnd - fadeStart)).clamp(
              0.0,
              1.0,
            );

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
    );
  }

  Widget _buildFilterHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _CategorySliverPersistentHeaderDelegate(
        key: ValueKey(selectedFilter),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                _buildFilterChip("Upcoming", Icons.upcoming, Colors.blueAccent),
                _buildFilterChip("Completed", Icons.check_circle, Colors.green),
              ],
            ).fadeInDownBig(),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(
    BuildContext context,
    HomeViewModel taskVM,
    List<TaskModel> tasks,
  ) {
    if (taskVM.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (taskVM.error != null) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            'Error: ${taskVM.error}',
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      );
    }
    if (tasks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text("No tasks found")),
      );
    }

    return Column(
      children: tasks.map((task) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: OpenContainer(
            transitionDuration: const Duration(milliseconds: 500),
            closedElevation: 0,
            openElevation: 8,
            closedColor: Colors.transparent,
            openColor: Theme.of(context).scaffoldBackgroundColor,
            closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            openBuilder: (context, _) => TaskDetailScreen(task: task),
            closedBuilder: (context, open) =>
                GestureDetector(onTap: open, child: _taskCard(task)),
            onClosed: (createdTask) {
              if (createdTask != null) {
                taskVM.fetchTasks();
              }
            },
          ),
        );
      }).toList(),
    );
  }
}

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
    return oldDelegate.key != key;
  }
}
