from rest_framework import serializers

from .models import Order, OrderItem


class OrderItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderItem
        fields = ['product', 'quantity']


class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True)

    class Meta:
        model = Order
        fields = ['id', 'user', 'created_at', 'total_price', 'items', 'customer_name', 'phone', 'email', 'address']
        read_only_fields = ['user']

    def create(self, validated_data):
        items_data = validated_data.pop('items')

        # Check stock for all items first
        for item in items_data:
            product = item['product']
            if product.stock < item['quantity']:
                raise serializers.ValidationError(
                    f"Not enough stock for {product.name}. Available: {product.stock}"
                )

        order = Order.objects.create(**validated_data)

        for item in items_data:
            OrderItem.objects.create(order=order, **item)
            product = item['product']
            product.stock -= item['quantity']
            product.save()

        return order
