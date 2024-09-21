enum ServiceType<String> {
  physical,
  nonphysical,
}

extension ServiceTypeValue on ServiceType {
  String get value {
    switch (this) {
      case ServiceType.physical:
        return 'Physical';
      case ServiceType.nonphysical:
        return 'Non Physical';
    }
  }
}

enum FrequencyUnit<String> {
  minute,
  hour,
  day,
  week,
  month,
  year,
}

extension FrequencyUnitValue on FrequencyUnit {
  String get value {
    switch (this) {
      case FrequencyUnit.minute:
        return 'MIN';
      case FrequencyUnit.hour:
        return 'HR';
      case FrequencyUnit.day:
        return 'DAY';
      case FrequencyUnit.week:
        return 'WK';
      case FrequencyUnit.month:
        return 'Mth';
      case FrequencyUnit.year:
        return 'Yr';
    }
  }
}

enum SizeUnit<String> {
  nanometer,
  millimeter,
  centimeter,
  meter,
  inch,
  foot,
  yard,
}

extension SizeUnitValue on SizeUnit {
  String get value {
    switch (this) {
      case SizeUnit.nanometer:
        return 'NM';
      case SizeUnit.millimeter:
        return 'MM';
      case SizeUnit.centimeter:
        return 'CM';
      case SizeUnit.meter:
        return 'M';
      case SizeUnit.inch:
        return 'IN';
      case SizeUnit.foot:
        return 'FT';
      case SizeUnit.yard:
        return 'YD';
    }
  }
}

enum WeightUnit<String> {
  picogram,
  nanogram,
  microgram,
  milligram,
  gram,
  kilogram,
  tonne,
}

extension WeightUnitValue on WeightUnit {
  String get value {
    switch (this) {
      case WeightUnit.picogram:
        return 'PG';
      case WeightUnit.nanogram:
        return 'NG';
      case WeightUnit.microgram:
        return 'MCG';
      case WeightUnit.milligram:
        return 'MG';
      case WeightUnit.gram:
        return 'GM';
      case WeightUnit.kilogram:
        return 'KG';
      case WeightUnit.tonne:
        return 'TN';
    }
  }
}

enum PaymentMethod<String> {
  stripe,
  paypal,
}

extension PaymentMethodValue on PaymentMethod {
  String get value {
    switch (this) {
      case PaymentMethod.stripe:
        return 'Stripe';
      case PaymentMethod.paypal:
        return 'Paypal';
    }
  }
}

enum RuleType<String> {
  single,
  multiple,
}

extension RuleTypeValue on RuleType {
  String get value {
    switch (this) {
      case RuleType.single:
        return 'Single';
      case RuleType.multiple:
        return 'Multiple';
    }
  }
}

enum InstantiationType<String> {
  consume,
  order,
  date,
}

extension InstantiationTypeValue on InstantiationType {
  String get value {
    switch (this) {
      case InstantiationType.consume:
        return 'Consume';
      case InstantiationType.order:
        return 'Order';
      case InstantiationType.date:
        return 'Date';
    }
  }
}

enum SearchType<String> {
  policy,
  forum,
  service,
}

extension SearchTypeValue on SearchType {
  String get value {
    switch (this) {
      case SearchType.policy:
        return 'Policy';
      case SearchType.forum:
        return 'Forum';
      case SearchType.service:
        return 'Service';
    }
  }
}

// Member permissions managed by forum owner
enum MemberPermissions<String> {
  editforum, // - Edit Forum
  addmember, // - Add Member (implies adding other services to forum)
  removemember, // - Remove Member (implies removing other services from forum)
  createforum, // - Create Forum (implies removing forum)
  removeforum, // - Remove Forum (implies removing other services forums)
  createpost, // - Create Post (implies remove own post)
  removepost, // - Remove Post (implies remove other services posts)
  addtocart, // - Add item (service) to cart
  removefromcart, // - Remove item (service) from cart
  editmemberpermissions, // - Edit Permissions (implies editing permissions for members)
}

extension MemberPermissionsTypeValue on MemberPermissions {
  String get value {
    switch (this) {
      case MemberPermissions.editforum:
        return 'Edit Forum';
      case MemberPermissions.addmember:
        return 'Add Member';
      case MemberPermissions.removemember:
        return 'Remove Member';
      case MemberPermissions.createforum:
        return 'Create Forum';
      case MemberPermissions.removeforum:
        return 'Remove Forum';
      case MemberPermissions.createpost:
        return 'Create Post';
      case MemberPermissions.removepost:
        return 'Remove Post';
      case MemberPermissions.addtocart:
        return 'Add To Cart';
      case MemberPermissions.removefromcart:
        return 'Remove From Cart';
      case MemberPermissions.editmemberpermissions:
        return 'Edit Permissions';
    }
  }
}

// Manager permissions managed by policy owner
enum ManagerPermissions<String> {
  editpolicy, // - Edit Policy
  addmanager, // - Add Manager (implies adding other services to policy)
  removemanager, // - Remove Manager (implies removing other services serving in policy)
  createrule, // - Create Rule (implies remove own rule)
  editrule, // - Edit Rule (implies editing rule)
  removerule, // - Remove Rule (implies removing other managers rules)
  addrulemember, // - Add Member (implies adding other services to rule)
  removerulemember, // - Remove Member (implies removing other services from rule)
  editrulememberpermissions, // - Edit Permissions (implies editing permissions for members)
  addconsumer, // - Add Service (implies adding other services to policy)
  removeconsumer, // - Remove Service (implies removing other services serving in policy)
  editmanagerpermissions, // - Edit Permissions (implies editing permissions for managers)
}

extension ManagerPermissionsTypeValue on ManagerPermissions {
  String get value {
    switch (this) {
      case ManagerPermissions.editpolicy:
        return 'Edit Policy';
      case ManagerPermissions.addmanager:
        return 'Add Manager';
      case ManagerPermissions.removemanager:
        return 'Remove Manager';
      case ManagerPermissions.createrule:
        return 'Create Rule';
      case ManagerPermissions.editrule:
        return 'Edit Rule';
      case ManagerPermissions.removerule:
        return 'Remove Rule';
      case ManagerPermissions.addrulemember:
        return 'Add Rule Member';
      case ManagerPermissions.removerulemember:
        return 'Remove Rule Member';
      case ManagerPermissions.editrulememberpermissions:
        return 'Edit Rule Member Permissions';
      case ManagerPermissions.addconsumer:
        return 'Add Consumer';
      case ManagerPermissions.removeconsumer:
        return 'Remove Consumer';
      case ManagerPermissions.editmanagerpermissions:
        return 'Edit Manager Permissions';
    }
  }
}

enum ThemeMode {
  dark,
  light,
}

enum ChatMessageType {
  sent,
  received,
}
