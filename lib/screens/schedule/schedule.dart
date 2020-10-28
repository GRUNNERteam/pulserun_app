import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulserun_app/bloc/schedule_bloc.dart';
import 'package:pulserun_app/components/widgets/error_widget.dart';
import 'package:pulserun_app/components/widgets/loading_widget.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/models/schedule.dart';
import 'package:pulserun_app/repository/plan_repository.dart';
import 'package:pulserun_app/services/generates/generate_schedule.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with TickerProviderStateMixin {
  CalendarController _calendarController;
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;

  Widget _buildEventList() {
    if (_selectedEvents == null) {
      return Text('No Event');
    }
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  void _onDaySelected(DateTime day, List events, List holiday) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  Widget _tableCalendar() {
    return TableCalendar(
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      initialCalendarFormat: CalendarFormat.week,
      calendarController: _calendarController,
      initialSelectedDay: DateTime.now(),
      locale: 'en_US',
      //onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
      builders: CalendarBuilders(
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    //_selectedEvents = _events[_selectedDay];
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        print(state);
        if (state is ScheduleInitial) {
          BlocProvider.of<ScheduleBloc>(context).add(GetScheduleList());
          return LoadingWidget();
        } else if (state is ScheduleLoading) {
          return LoadingWidget();
        } else if (state is ScheduleLoadded) {
          /// loaded from bloc
          this._events = state.mapCalendar;
          return Scaffold(
            appBar: AppBar(
              title: Text('Schedule Page'),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _tableCalendar(),
                SizedBox(height: 8.0),
                Expanded(child: _buildEventList()),
              ],
            ),
          );
        } else {
          return ShowErrorWidget();
        }
      },
    );
  }
}
