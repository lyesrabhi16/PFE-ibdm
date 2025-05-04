import json
from channels.generic.websocket import AsyncWebsocketConsumer


class broadcastConsumer(AsyncWebsocketConsumer):
    
    connected_count = 0
    async def connect(self):
        self.group_name = "broadcast"
        await self.accept()
        await self.channel_layer.group_add(self.group_name, self.channel_name)
        broadcastConsumer.connected_count+=1
        await self.send(json.dumps({
            "type": "websocket.accept",
        }))

        

    async def disconnect(self, code):
        await self.channel_layer.group_discard(self.group_name, self.channel_name)
        broadcastConsumer.connected_count-=1

    async def receive(self, text_data=None, bytes_data=None):
        # Send message to room group
        await self.channel_layer.group_send(
            self.group_name, {"type": "broadcast.data", "data": text_data}
        )

    async def broadcast_data(self, event):
        message = event["data"]
        await self.send(text_data=json.dumps({"data": message}))