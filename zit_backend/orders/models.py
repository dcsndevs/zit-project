from django.db import models
from django.contrib.auth.models import User
from products.models import Product


class Order(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    customer_name = models.CharField(max_length=200, default='')
    phone = models.CharField(max_length=20, default='')
    email = models.EmailField(default='')
    address = models.TextField(default='')    
    total_price = models.DecimalField(max_digits=16, decimal_places=2)


class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.IntegerField()
