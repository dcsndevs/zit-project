from django.core.mail import send_mail
from django.conf import settings


def send_order_emails(order, items):
    # Build item list text
    item_lines = ''
    for item in items:
        item_lines += f"- {item.product.name} x{item.quantity}\n"

    # Email to customer
    customer_subject = f'Zit Shop Order Confirmation - {f"ZIT{order.id:04d}"}'
    customer_message = (
        f"Hi {order.customer_name},\n\n"
        f"Thank you for your order!\n\n"
        f"Order Number: {f"ZIT{order.id:04d}"}\n"
        f"Items:\n{item_lines}\n"
        f"Total: ₦{order.total_price}\n\n"
        f"This is a Pay On Delivery order. We will deliver to:\n{order.address}\n\n"
        f"Thank you for shopping with ZIT!"
    )

    send_mail(
        customer_subject,
        customer_message,
        settings.DEFAULT_FROM_EMAIL,
        [order.email],
        fail_silently=True,
    )

    # Email to admin
    admin_subject = f'New Order Received - {f"ZIT{order.id:04d}"}'
    admin_message = (
        f"New order received!\n\n"
        f"Order Number: {f"ZIT{order.id:04d}"}\n"
        f"Customer: {order.customer_name}\n"
        f"Phone: {order.phone}\n"
        f"Email: {order.email}\n"
        f"Address: {order.address}\n\n"
        f"Items:\n{item_lines}\n"
        f"Total: ₦{order.total_price}"
    )

    send_mail(
        admin_subject,
        admin_message,
        settings.DEFAULT_FROM_EMAIL,
        [settings.ADMIN_EMAIL],
        fail_silently=True,
    )
