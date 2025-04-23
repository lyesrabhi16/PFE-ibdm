from logs.logging import logger as logging
import time
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

from emails.models import sentEmail
from emails.serializers import SentEmailSerializer
from api_v1.utils import get_or_none


last_sent = None
def broadcast_sent_emails():
    global last_sent
    start_func = time.time()
    channel_layer = get_channel_layer()
    start = time.time()
    data : sentEmail = get_or_none(sentEmail, sentEmail.objects.latest, args=("temps_envoi",))
    if data is None:
        logging.info(f"broadcast_sent_emails# No data found in {time.time() - start} seconds")
        return
     
    logging.info(f"broadcast_sent_emails# {data} retrieved in {time.time() - start} seconds")
    if last_sent is not None and data.pk == last_sent.pk:
        return
    send_data = SentEmailSerializer(data, context={ "request": None }).data
    async_to_sync(channel_layer.group_send)(
        "sent_emails",
        {
            "type": "sent.emails",
            "data": send_data,
        },
    )
    """ async_to_sync(channel_layer.group_send)(
        "broadcast",
        {
            "type": "broadcast.data",
            "data": {
                "type": "sent-emails",
                "data": send_data,
            },
        },
    ) """
    last_sent = data
    logging.info(f"broadcast_sent_emails# {data} done in {time.time() - start_func}")