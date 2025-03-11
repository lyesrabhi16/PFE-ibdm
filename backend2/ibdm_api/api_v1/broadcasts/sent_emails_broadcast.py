import logging
import time
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

from emails.models import sentEmail
from emails.serializers import SentEmailSerializer




def broadcast_sent_emails():
    start_func = time.time()
    channel_layer = get_channel_layer()
    start = time.time()
    data = sentEmail.objects.latest("temps_envoi")
    logging.info(f"broadcast_sent_emails: {data} retrieved in {time.time() - start} seconds")
    async_to_sync(channel_layer.group_send)(
        "sent_emails",
        {
            "type": "sent.emails",
            "data": SentEmailSerializer(data, context={ "request": None }).data,
        },
    )

    logging.info(f"broadcast_sent_emails: {data} done in {time.time() - start_func}")