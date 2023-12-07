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
  addforum, // - Add Forum (implies removing forum)
  deleteforum, // - Delete Forum (implies removing other services forums)
  createpost, // - Create Post (implies delete own post)
  deletepost, // - Delete Post (implies delete other services posts)
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
      case RegistrantPermissions.addforum:
        return 'Add Forum';
      case RegistrantPermissions.deleteforum:
        return 'Delete Forum';
      case RegistrantPermissions.createpost:
        return 'Create Post';
      case RegistrantPermissions.deletepost:
        return 'Delete Post';
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
