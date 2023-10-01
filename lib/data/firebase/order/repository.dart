import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:sober_driver_analog/domain/db/usecases/db_query.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_status.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_with_id.dart';
import 'package:sober_driver_analog/domain/firebase/order/repository/repository.dart';
import 'package:sober_driver_analog/presentation/utils/app_operation_mode.dart';

import '../../../presentation/utils/status_enum.dart';
import '../../db/repository/repository.dart';

class OrderRepositoryImpl extends OrderRepository {
  final _orderCollection = 'Orders';
  final _instance = firestore.FirebaseFirestore.instance;

  @override
  Future<String> createOrder(Order order) async {
    final doc =
        await _instance.collection(_orderCollection).add(order.toJson());
    print('created order id  -${doc.id}');

    return doc.id;
  }

  Future<Order?> updateOrderById(String id, Order order) async {
    final coll = _instance.collection(_orderCollection).doc(id);
    final doc = await coll.get();
    if (doc.exists) {
      coll.update(order.toJson());
      return order;
    }
  }

  @override
  Future<Order?> getOrderById(String id) async {
    final coll = _instance.collection(_orderCollection).doc(id);
    final doc = await coll.get();
    if (doc.exists) {
      return Order.fromJson(doc.data()!);
    }
  }

  @override
  Future<List<OrderWithId>> getYourOrders() async {
    final coll = _instance.collection(_orderCollection);
    final datas = coll.where(
        AppOperationMode.mode == AppOperationModeEnum.user
            ? 'employerId'
            : 'driverId',
        isEqualTo:
            (await DBQuery(DBRepositoryImpl()).call('user')).first['userId']);
    return (await datas.get())
        .docs
        .map((e) => OrderWithId(Order.fromJson(e.data()), e.id))
        .toList();
  }

  @override
  Future<Status> deleteOrderById(String id) async {
    try {
      final coll = _instance.collection(_orderCollection);
      await coll.doc(id).delete();
      return Status.Success;
    } catch (_) {
      return Status.Failed;
    }
  }

  @override
  Stream<Order?> setOrderChangesListener(String orderId) {
    return _instance.collection(_orderCollection).snapshots().map((event) {
      final changedDoc = event.docChanges
          .where((element) => element.doc.id == orderId)
          .toList();
      if (changedDoc.isNotEmpty) {
        return Order.fromJson(changedDoc.first.doc.data()!);
      }
      return null;
    });
  }

  Stream<List<OrderWithId>> getListOfOrders(String locality) {
    final coll = _instance.collection(_orderCollection);
    return coll
        .where('orderStatus',
            isEqualTo: WaitingForOrderAcceptanceOrderStatus().toString())
        .snapshots()
        .map((event) => event.docs
            .map((e) => OrderWithId(Order.fromJson(e.data()), e.id))
            .toList()
            .where((element) => element.order.from.locality == locality || element.order.to.locality == locality )
            .toList());
  }
}
