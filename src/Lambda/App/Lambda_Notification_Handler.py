import boto3
import json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('WebSocketConnections')
api_gateway = boto3.client('apigatewaymanagementapi', endpoint_url='https://api-id.execute-api.region.amazonaws.com/production')

def lambda_handler(event, context):
    # Parse the incoming message
    message = json.loads(event['body'])
    
    # Get all connected WebSocket clients
    response = table.scan()
    connections = response['Items']

    # Send the notification to each client
    for connection in connections:
        connection_id = connection['connectionId']
        try:
            api_gateway.post_to_connection(
                ConnectionId=connection_id,
                Data=json.dumps(message)
            )
        except Exception as e:
            # Handle disconnected clients
            print(f"Failed to send message to {connection_id}: {e}")
            table.delete_item(Key={'connectionId': connection_id})

    return {'statusCode': 200}