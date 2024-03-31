enum ActivityType<String> { policy, forum }

extension ActivityTypeValue on ActivityType {
  String get value {
    switch (this) {
      case ActivityType.policy:
        return 'Policy';
      case ActivityType.forum:
        return 'Forum';
    }
  }
}

enum InstantiationType<String> { consumption, date, order }

extension InstantiationTypeValue on InstantiationType {
  String get value {
    switch (this) {
      case InstantiationType.consumption:
        return 'Consumption';
      case InstantiationType.date:
        return 'Date';
      case InstantiationType.order:
        return 'Order';
    }
  }
}

enum SearchType<String> { policy, forum, service }

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
  addservice, // - Add Service (implies adding other services to forum)
  removeservice, // - Remove Service (implies removing other services from forum)
  createforum, // - Create Forum (implies removing forum)
  removeforum, // - Remove Forum (implies removing other services forums)
  createpost, // - Create Post (implies remove own post)
  removepost, // - Remove Post (implies remove other services posts)
  editpermissions, // - Edit Permissions (implies editing permissions for members)
}

extension MemberPermissionsTypeValue on MemberPermissions {
  String get value {
    switch (this) {
      case MemberPermissions.editforum:
        return 'Edit Forum';
      case MemberPermissions.addservice:
        return 'Add Service';
      case MemberPermissions.removeservice:
        return 'Remove Service';
      case MemberPermissions.createforum:
        return 'Create Forum';
      case MemberPermissions.removeforum:
        return 'Remove Forum';
      case MemberPermissions.createpost:
        return 'Create Post';
      case MemberPermissions.removepost:
        return 'Remove Post';
      case MemberPermissions.editpermissions:
        return 'Edit Permissions';
    }
  }
}

// Manager permissions managed by policy owner
enum ManagerPermissions<String> {
  editpolicy, // - Edit Policy
  addmanager, // - Add Service (implies adding other services to policy)
  removemanager, // - Remove Service (implies removing other services serving in policy)
  createrule, // - Create Rule (implies remove own rule)
  removerule, // - Remove Rule (implies removing other managers rules)
  addconsumer, // - Add Service (implies adding other services to policy)
  removeconsumer, // - Remove Service (implies removing other services serving in policy)
  editpermissions, // - Edit Permissions (implies editing permissions for managers)
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
      case ManagerPermissions.removerule:
        return 'Remove Rule';
      case ManagerPermissions.addconsumer:
        return 'Add Consumer';
      case ManagerPermissions.removeconsumer:
        return 'Remove Consumer';
      case ManagerPermissions.editpermissions:
        return 'Edit Permissions';
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
