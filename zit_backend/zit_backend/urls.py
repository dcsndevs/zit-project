from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import TokenObtainPairView
from django.contrib.auth.models import User
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

@api_view(['POST'])
def register(request):
    username = request.data.get('username')
    password = request.data.get('password')
    email = request.data.get('email', '')
    if not username or not password:
        return Response({'error': 'Username and password required'}, status=status.HTTP_400_BAD_REQUEST)
    if User.objects.filter(username=username).exists():
        return Response({'error': 'Username already exists'}, status=status.HTTP_400_BAD_REQUEST)
    User.objects.create_user(username=username, password=password, email=email)
    return Response({'message': 'User created'}, status=status.HTTP_201_CREATED)

urlpatterns = [
    path('admin/', admin.site.urls),

    path('api/products/', include('products.urls')),
    path('api/orders/', include('orders.urls')),

    path('api/login/', TokenObtainPairView.as_view()),
    path('api/register/', register),

]
