import 'package:reddit_tutorial/models/member.dart';
import 'package:reddit_tutorial/models/service.dart';

class MemberService {
  final Member member;
  final Service service;
  MemberService({
    required this.member,
    required this.service,
  });

  MemberService copyWith({
    Member? member,
    Service? service,
  }) {
    return MemberService(
      member: member ?? this.member,
      service: service ?? this.service,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'member': member.toMap(),
      'service': service.toMap(),
    };
  }

  factory MemberService.fromMap(Map<String, dynamic> map) {
    return MemberService(
      member: Member.fromMap(map['member'] as Map<String, dynamic>),
      service: Service.fromMap(map['service'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() => 'MemberService(member: $member, service: $service)';

  @override
  bool operator ==(covariant MemberService other) {
    if (identical(this, other)) return true;

    return other.member == member && other.service == service;
  }

  @override
  int get hashCode => member.hashCode ^ service.hashCode;
}
