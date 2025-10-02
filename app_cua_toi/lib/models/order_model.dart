import 'package:flutter/material.dart';
import 'category.dart';

class Order {
  final String id;
  final DateTime orderDate;
  final List<CartItem> items;
  final double totalPrice;
  final double shippingFee;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String? note;
  final String paymentMethod;
  final OrderStatus status;

  Order({
    required this.id,
    required this.orderDate,
    required this.items,
    required this.totalPrice,
    required this.shippingFee,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    this.note,
    required this.paymentMethod,
    this.status = OrderStatus.processing,
  });

  double get finalTotal => totalPrice + shippingFee;
  
  String get statusText {
    switch (status) {
      case OrderStatus.processing:
        return "Đang xử lý";
      case OrderStatus.confirmed:
        return "Đã xác nhận";
      case OrderStatus.preparing:
        return "Đang chuẩn bị";
      case OrderStatus.delivering:
        return "Đang giao hàng";
      case OrderStatus.delivered:
        return "Đã giao hàng";
      case OrderStatus.cancelled:
        return "Đã hủy";
    }
  }
  
  Color get statusColor {
    switch (status) {
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.delivering:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.teal;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}

enum OrderStatus {
  processing,
  confirmed,
  preparing,
  delivering,
  delivered,
  cancelled,
}