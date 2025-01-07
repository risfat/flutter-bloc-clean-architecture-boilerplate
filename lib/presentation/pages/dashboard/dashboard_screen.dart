import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/config/routes.dart';
import '../../cubit/theme/theme_cubit.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return IconButton(
                  icon: Icon(
                    state is ThemeLight ? Icons.dark_mode : Icons.light_mode,
                  ),
                  onPressed: () {
                    context.read<ThemeCubit>().changeTheme();
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back, User!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ).animate().fadeIn(duration: 600.ms).slideX(),
                const SizedBox(height: 24),
                _buildStatCards(),
                const SizedBox(height: 24),
                _buildChart(),
                const SizedBox(height: 24),
                _buildCalendar(),
                const SizedBox(height: 24),
                _buildDailyActivities(),
              ],
            ),
          ),
        ));
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        _buildStatCard(
          'Total Users',
          '1,204',
          Icons.people,
          Colors.blue,
          onTap: () {
            // Callback
            context.pushNamed(AppRoutes.usersRouteName);
          },
        ),
        const SizedBox(width: 16),
        _buildStatCard('Revenue', '\$8,520', Icons.attach_money, Colors.green),
      ],
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2);
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color,
      {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 30),
                const SizedBox(height: 8),
                Text(title,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChart() {
    return SizedBox(
      height: 300,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Analytics Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildLineChart()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildBarChart()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 1000.ms).slideX();
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 3),
              const FlSpot(2.6, 2),
              const FlSpot(4.9, 5),
              const FlSpot(6.8, 3.1),
              const FlSpot(8, 4),
              const FlSpot(9.5, 3),
              const FlSpot(11, 4),
            ],
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            dotData: const FlDotData(show: false),
            belowBarData:
                BarAreaData(show: true, color: Colors.blue.withOpacity(0.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 13)]),
          BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 18)]),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calendar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TableCalendar(
              firstDay: DateTime(2023, 1, 1),
              lastDay: DateTime.now(),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(formatButtonVisible: false),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 1000.ms).slideY(begin: 0.2);
  }

  Widget _buildDailyActivities() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildActivityItem('Team Meeting', '10:00 AM', Icons.group),
            _buildActivityItem('Project Deadline', '2:00 PM', Icons.assignment),
            _buildActivityItem('Client Call', '4:30 PM', Icons.phone),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 1200.ms).slideY(begin: 0.2);
  }

  Widget _buildActivityItem(String title, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(time, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
