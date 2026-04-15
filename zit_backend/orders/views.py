from rest_framework import generics
from .models import Order
from .serializers import OrderSerializer
from rest_framework.permissions import AllowAny
from .emails import send_order_emails


class OrderListCreateView(generics.ListCreateAPIView):
    queryset = Order.objects.all()
    serializer_class = OrderSerializer
    permission_classes = [AllowAny]

    def get_queryset(self):
        if self.request.user.is_authenticated:
            return Order.objects.filter(user=self.request.user)
        return Order.objects.none()


    def perform_create(self, serializer):
        if self.request.user.is_authenticated:
            order = serializer.save(user=self.request.user)
        else:
            order = serializer.save()

        order_items = order.items.all()
        send_order_emails(order, order_items)

