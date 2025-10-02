import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/order_model.dart';

class OrdersPage extends StatefulWidget {
  final List<Order> orderHistory;

  const OrdersPage({super.key, required this.orderHistory});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String selectedFilter = 'all';

  List<Order> get filteredOrders {
    if (selectedFilter == 'all') return widget.orderHistory;
    
    OrderStatus status = OrderStatus.values.firstWhere(
      (e) => e.toString().split('.').last == selectedFilter
    );
    
    return widget.orderHistory.where((order) => order.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đơn hàng'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Tất cả', 'all'),
                  _buildFilterChip('Đang xử lý', 'processing'),
                  _buildFilterChip('Đã xác nhận', 'confirmed'),
                  _buildFilterChip('Đang giao', 'delivering'),
                  _buildFilterChip('Hoàn thành', 'delivered'),
                  _buildFilterChip('Đã hủy', 'cancelled'),
                ],
              ),
            ),
          ),
          
          // Orders list
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          selectedFilter == 'all' 
                              ? 'Chưa có đơn hàng nào' 
                              : 'Không có đơn hàng ${_getFilterDisplayName(selectedFilter)}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return _buildOrderCard(order);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedFilter = value;
          });
        },
        selectedColor: Colors.red.withOpacity(0.2),
        checkmarkColor: Colors.red,
        labelStyle: TextStyle(
          color: isSelected ? Colors.red : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showOrderDetail(order),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Order ID và Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Đơn hàng #${order.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: order.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.statusText,
                      style: TextStyle(
                        color: order.statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Ngày đặt
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year} - ${order.orderDate.hour.toString().padLeft(2, '0')}:${order.orderDate.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Danh sách sản phẩm (hiển thị tối đa 2 items)
              Column(
                children: order.items.take(2).map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            item.drink.image,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.drink.name,
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              Text(
                                '${item.getOptionsDescription()} • SL: ${item.quantity}',
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${item.getTotalPrice().toStringAsFixed(0)}đ',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              
              // Hiển thị thêm nếu có nhiều hơn 2 items
              if (order.items.length > 2)
                Text(
                  'và ${order.items.length - 2} món khác...',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12, fontStyle: FontStyle.italic),
                ),
              
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              
              // Tổng tiền và nút xem chi tiết
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tổng cộng: ${order.finalTotal.toStringAsFixed(0)}đ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                      ),
                      Text(
                        '${order.items.length} món • ${order.paymentMethod == 'cash' ? 'Tiền mặt' : 'Chuyển khoản'}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _showOrderDetail(order),
                    child: const Text('Xem chi tiết'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderDetail(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chi tiết đơn hàng #${order.id}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: order.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        order.statusText,
                        style: TextStyle(
                          color: order.statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thông tin giao hàng
                        _buildDetailSection(
                          'Thông tin giao hàng',
                          [
                            _buildDetailRow('Tên khách hàng', order.customerName),
                            _buildDetailRow('Số điện thoại', order.customerPhone),
                            _buildDetailRow('Địa chỉ', order.deliveryAddress),
                            if (order.note?.isNotEmpty == true)
                              _buildDetailRow('Ghi chú', order.note!),
                            _buildDetailRow('Phương thức thanh toán', 
                                order.paymentMethod == 'cash' ? 'Tiền mặt' : 'Chuyển khoản'),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Chi tiết sản phẩm
                        _buildDetailSection(
                          'Chi tiết sản phẩm',
                          order.items.map((item) => 
                            _buildProductRow(item)
                          ).toList(),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Tổng kết
                        _buildDetailSection(
                          'Tổng kết',
                          [
                            _buildDetailRow('Tạm tính', '${order.totalPrice.toStringAsFixed(0)}đ'),
                            _buildDetailRow('Phí giao hàng', '${order.shippingFee.toStringAsFixed(0)}đ'),
                            const Divider(),
                            _buildDetailRow('Tổng cộng', '${order.finalTotal.toStringAsFixed(0)}đ', 
                                isTotal: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(
              color: Colors.grey[600],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            )),
          ),
          Expanded(
            child: Text(value, style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.red : Colors.black,
              fontSize: isTotal ? 16 : 14,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(item.drink.image, width: 50, height: 50, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.drink.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(item.getOptionsDescription(), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text('Số lượng: ${item.quantity}', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Text('${item.getTotalPrice().toStringAsFixed(0)}đ', 
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _getFilterDisplayName(String filter) {
    switch (filter) {
      case 'processing': return 'đang xử lý';
      case 'confirmed': return 'đã xác nhận';
      case 'delivering': return 'đang giao hàng';
      case 'delivered': return 'đã hoàn thành';
      case 'cancelled': return 'đã hủy';
      default: return '';
    }
  }
}