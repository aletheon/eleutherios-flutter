enum PaymentMethod<String> { stripe, paypal }

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

enum ServiceType<String> { api, data, product, service }

extension ServiceTypeValue on ServiceType {
  String get value {
    switch (this) {
      case ServiceType.api:
        return 'API';
      case ServiceType.data:
        return 'Data';
      case ServiceType.product:
        return 'Product';
      case ServiceType.service:
        return 'Service';
    }
  }
}

enum InstantiationType<String> { consume, order, date }

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
  addpotentialmember, // - Add Member (implies adding other services to rule)
  removepotentialmember, // - Remove Member (implies removing other services from rule)
  editpotentialmemberpermissions, // - Edit Permissions (implies editing permissions for potential members)
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
      case ManagerPermissions.addpotentialmember:
        return 'Add Member';
      case ManagerPermissions.removepotentialmember:
        return 'Remove Member';
      case ManagerPermissions.editpotentialmemberpermissions:
        return 'Edit Member Permissions';
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
