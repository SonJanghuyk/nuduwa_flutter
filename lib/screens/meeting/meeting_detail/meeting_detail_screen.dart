import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nuduwa_flutter/components/assets.dart';
import 'package:nuduwa_flutter/models/member.dart';
import 'package:nuduwa_flutter/repository/meeting_repository.dart';
import 'package:nuduwa_flutter/screens/map/meeting_info_sheet/meeting_info_sheet.dart';
import 'package:nuduwa_flutter/screens/meeting/meeting_detail/bloc/meeting_detail_bloc.dart';
import 'package:nuduwa_flutter/screens/meeting/meeting_detail/bloc/meeting_edit_cubit.dart';
import 'package:nuduwa_flutter/screens/meeting/meeting_list/bloc/meeting_bloc.dart';

class MeetingDetailScreen extends StatelessWidget {
  const MeetingDetailScreen({
    required this.meetingBloc,
    super.key,
  });

  final MeetingBloc meetingBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: meetingBloc,
        ),
        BlocProvider(
          create: (context) => MeetingDetailBloc(
              meetingRepository: context.read<MeetingRepository>(),
              meetingId: meetingBloc.meetingId,),
        ),
        BlocProvider(
          create: (context) => MeetingEditCubit(
            meetingRepository: context.read<MeetingRepository>(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: _appBar(context),
        body: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: BlocBuilder<MeetingBloc, MeetingState>(
                      builder: (context, state) {
                        final meeting = state.meeting;
                        context.read<MeetingEditCubit>().updateMeeting(meeting);
                        return BlocSelector<MeetingDetailBloc,
                            MeetingDetailState, MeetingDetailStatus>(
                          selector: (state) => state.status,
                          builder: (context, status) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    // ------- HostImage -------
                                    // Meeting이 null 이면 Assets.imageLoading
                                    // Meeting이 null이 아닌데 hostImageUrl가 null이면 Assets.imageNoImage
                                    // 둘 다 아니면 meeting.hostImageUrl 보여주기
                                    CircleAvatar(
                                      radius: 30,
                                      foregroundImage: meeting == null
                                          ? null
                                          : meeting.hostImageUrl != null
                                              ? NetworkImage(
                                                      meeting.hostImageUrl!)
                                                  as ImageProvider
                                              : const AssetImage(
                                                  Assets.imageNoImage),
                                      backgroundImage: const AssetImage(Assets
                                          .imageLoading), // 로딩 중일 때 보여줄 배경색
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ------- HostName -------
                                        SizedBox(
                                          height: 22,
                                          child: Text(meeting?.hostName ?? '',
                                              style: const TextStyle(
                                                  fontSize: 17)),
                                        ),
                                        const SizedBox(height: 5),

                                        // ------- PublishedTime -------
                                        if (meeting != null)
                                          Text(
                                            '${DateFormat("y년 M월 d일 a h:mm").format(meeting.publishedTime)}에 생성됨',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                // ------- Title -------
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: EditTextField(
                                    status: status,
                                    content: meeting?.title ?? '',
                                    size: 50,
                                    maxLines: 2,
                                    selector: (state) => state.title,
                                    onChaged: (context, title) => context
                                        .read<MeetingEditCubit>()
                                        .titleChanged(title),
                                  ),
                                ),
                                const SizedBox(height: 40),

                                // ------- Description -------
                                EditTextField(
                                  status: status,
                                  content: meeting?.description ?? '',
                                  icon: Icons.edit_outlined,
                                  size: 22,
                                  maxLines: 10,
                                  selector: (state) => state.description,
                                  onChaged: (context, description) => context
                                      .read<MeetingEditCubit>()
                                      .descriptionChanged(description),
                                ),
                                const SizedBox(height: 40),

                                // ------- Place -------
                                EditTextField(
                                  status: status,
                                  content: meeting?.place ?? '',
                                  icon: Icons.location_on_outlined,
                                  size: 22,
                                  maxLines: 3,
                                  selector: (state) => state.place,
                                  onChaged: (context, place) => context
                                      .read<MeetingEditCubit>()
                                      .placeChanged(place),
                                ),

                                const SizedBox(height: 40),

                                // ------- MeetingTime -------
                                RowMeetingInfo(
                                  text: meeting != null
                                      ? '${DateFormat("M월 d일 a h:mm").format(meeting.meetingTime)}에 만나요!'
                                      : '?월 ?일 ?? ?:??에 만나요!',
                                  icon: Icons.calendar_month,
                                ),
                                const SizedBox(height: 30),

                                // Members
                BlocSelector<MeetingDetailBloc, MeetingDetailState, bool>(
                  selector: (state) =>
                      state.status == MeetingDetailStatus.notEditing,
                  builder: (context, isNotEdit) {
                    if (!isNotEdit) return const Center();
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            spreadRadius: 2.5,
                          )
                        ],
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          const Text('참여자'),
                          BlocSelector<MeetingDetailBloc, MeetingDetailState,
                              List<Member>>(
                            selector: (state) => state.members.values.toList(),
                            builder: (context, members) {
                              return Wrap(
                                children: [
                                  for (final member in members)
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconButton(
                                        onPressed: () => (),
                                        icon: CircleAvatar(
                                          radius: 20,
                                          foregroundImage: member.name == null
                                              ? null
                                              : member.imageUrl != null
                                                  ? NetworkImage(
                                                          member.imageUrl!)
                                                      as ImageProvider
                                                  : const AssetImage(
                                                      Assets.imageNoImage),
                                          backgroundImage: const AssetImage(Assets
                                              .imageLoading), // 로딩 중일 때 보여줄 배경색
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                
                BlocSelector<MeetingDetailBloc, MeetingDetailState, bool>(
                    selector: (state) =>
                        state.status == MeetingDetailStatus.notEditing,
                    builder: (context, isNotEdit) {
                      if (!isNotEdit) return const Center();
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue),
                                fixedSize: MaterialStateProperty.all(
                                    const Size(200, 45))),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_outlined, color: Colors.white),
                                SizedBox(width: 5, height: 50),
                                Text(
                                  '채팅 참가',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      // backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(''),
      leading: BlocSelector<MeetingDetailBloc, MeetingDetailState, bool>(
          selector: (state) => state.status == MeetingDetailStatus.editing,
          builder: (context, isEdit) {
            if (isEdit) {
              // 수정 중일때 - 수정취소 버튼
              return IconButton(
                onPressed: () => context
                    .read<MeetingDetailBloc>()
                    .add(MeetingDetailCanceledEditing()),
                icon: const Row(children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.red,
                    size: 28,
                  ),
                  Text(
                    '수정 취소',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ]),
                color: Colors.blue,
              );
            } else {
              // 뒤로가기 버튼
              return IconButton(
                onPressed: () => context.pop(),
                icon: const Row(children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    size: 28,
                    color: Colors.blue,
                  ),
                  Text(
                    '내 모임',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                ]),
              );
            }
          }),
      leadingWidth: 130,
      actions: [
        BlocSelector<MeetingDetailBloc, MeetingDetailState,
            ({bool isEdit, bool isLoading})>(
          selector: (state) => (
            isEdit: state.status == MeetingDetailStatus.editing,
            isLoading: state.status == MeetingDetailStatus.editLoading
          ),
          builder: (context, status) {
            final isEdit = status.isEdit;
            final isLoading = status.isLoading;
            if (isLoading) {
              // 수정 로딩중일때
              return const Center(child: CircularProgressIndicator());
            } else if (isEdit) {
              // 수정 중일때 - 수정완료 버튼
              return IconButton(
                onPressed: () => context
                    .read<MeetingDetailBloc>()
                    .add(MeetingDetailFinishedEditing()),
                icon: const Text(
                  '수정 완료',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
                color: Colors.blue,
                iconSize: 80,
              );
            } else {
              // 메뉴 버튼
              return BlocSelector<MeetingBloc, MeetingState, bool>(
                selector: (state) =>
                    state.meeting?.hostUid ==
                    FirebaseAuth.instance.currentUser?.uid,
                builder: (context, isHost) {
                  return PopupMenuButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.blue,
                    ),
                    iconSize: 30,
                    elevation: 1,
                    padding: EdgeInsets.zero,
                    offset: const Offset(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    itemBuilder: (BuildContext context) {
                      if (isHost) {
                        return <PopupMenuEntry<String>>[
                          //
                          // 모임 Host일때
                          //
                          menuItem(
                            text: '모임 수정',
                            icon: Icons.change_circle_outlined,
                            color: Colors.black,
                            ontap: () => context
                                .read<MeetingDetailBloc>()
                                .add(MeetingDetailWasEditing()),
                          ),
                          menuItem(
                            text: '모임 삭제',
                            icon: Icons.delete_forever_outlined,
                            color: Colors.red,
                            ontap: () => {},
                          ),
                        ];
                      } else {
                        return [
                          //
                          // 모임 Host 아닐때
                          //
                          menuItem(
                            text: '모임 나가기',
                            icon: Icons.exit_to_app,
                            color: Colors.red,
                            ontap: () => context.pop(),
                          ),
                        ];
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }

  PopupMenuItem<String> menuItem(
      {required String text,
      required IconData icon,
      required Color color,
      required VoidCallback ontap}) {
    return PopupMenuItem<String>(
      onTap: ontap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 5),
          Icon(
            icon,
            color: color,
          ),
        ],
      ),
    );
  }
}

class EditTextField extends StatelessWidget {
  const EditTextField({
    required this.status,
    required this.content,
    this.icon,
    this.size = 17,
    this.maxLines = 1,
    required this.selector,
    required this.onChaged,
    super.key,
  });

  final MeetingDetailStatus status;
  final String content;
  final IconData? icon;
  final double size;
  final int maxLines;

  final FormzInput Function(MeetingEditState) selector;
  final Function(BuildContext, String) onChaged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Icon(
            icon,
            size: size,
          ),
        const SizedBox(width: 5),
        Expanded(
          child: status == MeetingDetailStatus.notEditing
              ? Text(
                  content,
                  style: TextStyle(fontSize: size),
                  overflow: TextOverflow.ellipsis,
                  maxLines: maxLines,
                )
              : BlocSelector<MeetingEditCubit, MeetingEditState, FormzInput>(
                  selector: selector,
                  builder: (context, input) {
                    return TextField(
                      onChanged: (text) => onChaged(context, text),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        labelText: content,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
