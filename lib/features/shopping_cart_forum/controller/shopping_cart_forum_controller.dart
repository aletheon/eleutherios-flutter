import 'package:reddit_tutorial/features/shopping_cart_forum/repository/shopping_cart_forum_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/models/shopping_cart_forum.dart';
import 'package:uuid/uuid.dart';

final getShoppingCartForumByIdProvider =
    Provider.family.autoDispose((ref, String shoppingCartForumId) {
  final shoppingCartForumRepository =
      ref.watch(shoppingCartForumRepositoryProvider);
  return shoppingCartForumRepository
      .getShoppingCartForumById(shoppingCartForumId);
});

final shoppingCartForumsProvider =
    StreamProvider.family.autoDispose((ref, String uid) {
  return ref
      .watch(shoppingCartForumControllerProvider.notifier)
      .getShoppingCartForums(uid);
});

final shoppingCartForumControllerProvider =
    StateNotifierProvider<ShoppingCartForumController, bool>((ref) {
  final shoppingCartForumRepository =
      ref.watch(shoppingCartForumRepositoryProvider);
  return ShoppingCartForumController(
      shoppingCartForumRepository: shoppingCartForumRepository, ref: ref);
});

class ShoppingCartForumController extends StateNotifier<bool> {
  final ShoppingCartForumRepository _shoppingCartForumRepository;
  final Ref _ref;
  ShoppingCartForumController(
      {required ShoppingCartForumRepository shoppingCartForumRepository,
      required Ref ref})
      : _shoppingCartForumRepository = shoppingCartForumRepository,
        _ref = ref,
        super(false);

  void createShoppingCartForum(
      String shoppingCartUserId, String forumId) async {
    state = true;
    String shoppingCartForumId = const Uuid().v1().replaceAll('-', '');

    ShoppingCartForum shoppingCartForum = ShoppingCartForum(
      shoppingCartForumId: shoppingCartForumId,
      shoppingCartUserId: shoppingCartUserId,
      forumId: forumId,
      services: [],
      members: [],
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    final res = await _shoppingCartForumRepository
        .createShoppingCartForum(shoppingCartForum);
    state = false;
  }

  Stream<List<ShoppingCartForum>> getShoppingCartForums(String uid) {
    return _shoppingCartForumRepository.getShoppingCartForums(uid);
  }

  Stream<ShoppingCartForum?> getShoppingCartForumById(
      String shoppingCartForumId) {
    return _shoppingCartForumRepository
        .getShoppingCartForumById(shoppingCartForumId);
  }
}
