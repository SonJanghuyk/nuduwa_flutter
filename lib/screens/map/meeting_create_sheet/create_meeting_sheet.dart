import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nuduwa_flutter/models/meeting.dart';
import 'package:nuduwa_flutter/screens/map/meeting_create_sheet/cubit/create_meeting_cubit.dart';
import 'package:nuduwa_flutter/components/formz/category.dart';
import 'package:nuduwa_flutter/components/formz/description.dart';
import 'package:nuduwa_flutter/components/formz/max_members.dart';
import 'package:nuduwa_flutter/components/formz/meeting_time.dart';
import 'package:nuduwa_flutter/components/formz/place.dart';
import 'package:nuduwa_flutter/components/formz/title.dart';
import 'package:numberpicker/numberpicker.dart';

class CreateMeetingSheet extends StatelessWidget {
  const CreateMeetingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          color: Colors.blue,
        ),
      ),
      body: BlocListener<CreateMeetingCubit, CreateMeetingState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            Navigator.of(context).pop();
          } else if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                    content:
                        Text(state.errorMessage ?? 'Create Meeting Failure')),
              );
          }
        },
        child: GestureDetector(
          // 터치 이벤트 발생 시 키보드를 숨깁니다.
          onTap: FocusScope.of(context).unfocus,
          child: Container(
            padding: const EdgeInsets.all(5),
            color: const Color.fromARGB(29, 3, 168, 244),
            child: ListView(
              children: [
                const SizedBox(height: 5),

                // 모임 정보 컨테이너
                _SetContainer(
                  title: '모임정보',
                  content: Column(
                    children: [
                      BlocSelector<CreateMeetingCubit, CreateMeetingState,
                          TitleInput>(
                        selector: (state) => state.title,
                        builder: (context, titleInput) => setTextfiled(
                          input: titleInput,
                          hint: '모임 제목 입력',
                          onChaged: (title) => context
                              .read<CreateMeetingCubit>()
                              .titleChanged(title),
                        ),
                      ),
                      const SizedBox(height: 16),
                      BlocSelector<CreateMeetingCubit, CreateMeetingState,
                          DescriptionInput>(
                        selector: (state) => state.description,
                        builder: (context, descriptionInput) => setTextfiled(
                          input: descriptionInput,
                          hint: '모임 내용 입력',
                          onChaged: (description) => context
                              .read<CreateMeetingCubit>()
                              .descriptionChanged(description),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 모임 장소 컨테이너
                _SetContainer(
                  title: '장소',
                  content: Column(
                    children: [
                      BlocSelector<CreateMeetingCubit, CreateMeetingState,
                          PlaceInput>(
                        selector: (state) => state.place,
                        builder: (context, placeInput) => setTextfiled(
                          input: placeInput,
                          hint: '모임 상세장소 입력',
                          onChaged: (place) => context
                              .read<CreateMeetingCubit>()
                              .placeChanged(place),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 모임 시간 컨테이너
                _SetContainer(
                  title: '시간',
                  content: BlocSelector<CreateMeetingCubit, CreateMeetingState,
                      MeetingTimeInput>(
                    selector: (state) => state.meetingTime,
                    builder: setTimePicker,
                  ),
                ),
                const SizedBox(height: 20),

                // 최대 인원수 컨테이너
                _SetContainer(
                  title: '최대 인원수',
                  content: BlocSelector<CreateMeetingCubit, CreateMeetingState,
                      MaxMembersInput>(
                    selector: (state) => state.maxMembers,
                    builder: setMaxMembers,
                  ),
                ),
                const SizedBox(height: 20),

                // 카테고리 컨테이너
                _SetContainer(
                  title: '카테고리',
                  content: BlocSelector<CreateMeetingCubit, CreateMeetingState,
                      CategoryInput>(
                    selector: (state) => state.category,
                    builder: (context, categoryInput) {
                      return Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          for (final category in MeetingCategory.values)
                            pickButton(context, categoryInput, category),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () =>
            context.read<CreateMeetingCubit>().createMeetingFormSubmitted(),
        child: Text(
          '모임 생성'
        ),
      ),
    );
  }

  Padding pickButton(BuildContext context, CategoryInput categoryInput,
      MeetingCategory category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
      child: TextButton(
        onPressed: () => context
            .read<CreateMeetingCubit>()
            .categoryChanged(category),
        style: ButtonStyle(
          fixedSize: const MaterialStatePropertyAll<Size>(Size(80, 10)),
          foregroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
          backgroundColor: MaterialStatePropertyAll<Color>(
            categoryInput.value == category
                ? Colors.blue
                : Colors.grey,
          ),
        ),
        child: Text(
          category.displayName,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Row setMaxMembers(BuildContext context, MaxMembersInput maxMembers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '최대 인원수 : ',
          style: TextStyle(
            fontSize: 35,
            color: Colors.black,
          ),
        ),
        NumberPicker(
          itemHeight: 60,
          itemWidth: 100,
          minValue: 1,
          maxValue: 10,
          value: maxMembers.value,
          itemCount: 3,
          textStyle: const TextStyle(
            fontSize: 32,
            color: Colors.grey,
          ),
          selectedTextStyle: const TextStyle(
            fontSize: 40,
            color: Colors.blue,
          ),
          onChanged: context.read<CreateMeetingCubit>().maxMembersChanged,
        ),
        const Text(
          '명',
          style: TextStyle(
            fontSize: 35,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Column setTimePicker(BuildContext context, MeetingTimeInput timeInput) {
    final today = DateTime.now();
    final DateTime meetingTime = timeInput.value!;
    final isToday = today.day == meetingTime.day ? true : false;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            ElevatedButton(
              onPressed: () =>
                  context.read<CreateMeetingCubit>().timeChangedtoToday(),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(isToday ? Colors.blue : null)),
              child: Text(
                '오늘',
                style: TextStyle(
                  fontSize: 20,
                  color: isToday ? Colors.white : null,
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () =>
                  context.read<CreateMeetingCubit>().timeChangedtoTomorrow(),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(!isToday ? Colors.blue : null)),
              child: Text(
                '내일',
                style: TextStyle(
                  fontSize: 20,
                  color: !isToday ? Colors.white : null,
                ),
              ),
            ),
            const Spacer(flex: 2),
            TextButton(
              onPressed: () {
                final newTime = showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                        hour: meetingTime.hour, minute: meetingTime.minute));
                context.read<CreateMeetingCubit>().timeChanged(newTime);
              },
              child: Text(
                DateFormat("a h:mm").format(meetingTime),
                style: const TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          DateFormat("yyyy년 M월 d일 a h시 mm분").format(meetingTime),
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  // 텍스트 입력 필드
  TextField setTextfiled({
    required FormzInput input,
    required String hint,
    required Function(String)? onChaged,
  }) {
    return TextField(
      onChanged: onChaged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 20,
          color: Colors.grey,
        ),
        contentPadding: const EdgeInsets.all(10.0),
        errorText: input.displayError,
      ),
    );
  }
}

class _SetContainer extends StatelessWidget {
  const _SetContainer({
    required this.title,
    required this.content,
  });

  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final widthOfWidget = width > 830 ? 800.0 : width - 30;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(title),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          margin: const EdgeInsets.all(5.0),
          width: widthOfWidget - 10,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: 1,
              ),
            ],
          ),
          child: content,
        ),
      ],
    );
  }
}
