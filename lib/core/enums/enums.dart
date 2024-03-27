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

// Registrant permissions managed by forum owner
enum RegistrantPermissions<String> {
  editforum, // - Edit Forum
  addservice, // - Add Service (implies adding other services to forum)
  removeservice, // - Remove Service (implies removing other services from forum)
  createforum, // - Create Forum (implies removing forum)
  removeforum, // - Remove Forum (implies removing other services forums)
  createpost, // - Create Post (implies remove own post)
  removepost, // - Remove Post (implies remove other services posts)
  editpermissions, // - Edit Permissions (implies editing permissions for members)
}

extension RegistrantPermissionsTypeValue on RegistrantPermissions {
  String get value {
    switch (this) {
      case RegistrantPermissions.editforum:
        return 'Edit Forum';
      case RegistrantPermissions.addservice:
        return 'Add Service';
      case RegistrantPermissions.removeservice:
        return 'Remove Service';
      case RegistrantPermissions.createforum:
        return 'Create Forum';
      case RegistrantPermissions.removeforum:
        return 'Remove Forum';
      case RegistrantPermissions.createpost:
        return 'Create Post';
      case RegistrantPermissions.removepost:
        return 'Remove Post';
      case RegistrantPermissions.editpermissions:
        return 'Edit Permissions';
    }
  }
}

// Manager permissions managed by policy owner
enum ManagerPermissions<String> {
  editpolicy, // - Edit Policy
  addmanager, // - Add Service (implies adding other services to policy)
  removemanager, // - Remove Service (implies removing other services serving in policy)
  addconsumer, // - Add Service (implies adding other services to policy)
  removeconsumer, // - Remove Service (implies removing other services serving in policy)
  addrule, // - Add Rule (implies remove own rule)
  removerule, // - Remove Rule (implies removing other managers rules)
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
      case ManagerPermissions.addconsumer:
        return 'Add Consumer';
      case ManagerPermissions.removeconsumer:
        return 'Remove Consumer';
      case ManagerPermissions.addrule:
        return 'Add Rule';
      case ManagerPermissions.removerule:
        return 'Remove Rule';
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
