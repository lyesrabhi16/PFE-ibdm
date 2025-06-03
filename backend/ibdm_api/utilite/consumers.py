import json
from channels.generic.websocket import AsyncWebsocketConsumer
from api_v1.permissions import broadcastConnectionCheck
class UtiliteConsumer(AsyncWebsocketConsumer):
    
    connected_count = 0
    async def connect(self):
        self.group_name = "utilite"
        await broadcastConnectionCheck(self.scope, "utilite", ["can_view_utilite_page", "can_view_co2_page"])
        await self.accept()
        await self.channel_layer.group_add(self.group_name, self.channel_name)
        UtiliteConsumer.connected_count+=1
        await self.send(json.dumps({
            "type": "websocket.accept",
        }))

        

    async def disconnect(self, code):
        await self.channel_layer.group_discard(self.group_name, self.channel_name)
        UtiliteConsumer.connected_count-=1

    async def receive(self, text_data=None, bytes_data=None):
        # Send message to room group
        await self.channel_layer.group_send(
            self.group_name, {"type": "utilite.data", "data": text_data}
        )

    async def utilite_data(self, event):
        message = event["data"]
        await self.send(text_data=json.dumps({"data": message}))