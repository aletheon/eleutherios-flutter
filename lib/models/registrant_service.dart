import 'package:reddit_tutorial/models/registrant.dart';
import 'package:reddit_tutorial/models/service.dart';

class RegistrantService {
  final Registrant registrant;
  final Service service;
  RegistrantService({
    required this.registrant,
    required this.service,
  });

  RegistrantService copyWith({
    Registrant? registrant,
    Service? service,
  }) {
    return RegistrantService(
      registrant: registrant ?? this.registrant,
      service: service ?? this.service,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'registrant': registrant.toMap(),
      'service': service.toMap(),
    };
  }

  factory RegistrantService.fromMap(Map<String, dynamic> map) {
    return RegistrantService(
      registrant: Registrant.fromMap(map['registrant'] as Map<String, dynamic>),
      service: Service.fromMap(map['service'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() =>
      'RegistrantService(registrant: $registrant, service: $service)';

  @override
  bool operator ==(covariant RegistrantService other) {
    if (identical(this, other)) return true;

    return other.registrant == registrant && other.service == service;
  }

  @override
  int get hashCode => registrant.hashCode ^ service.hashCode;
}
