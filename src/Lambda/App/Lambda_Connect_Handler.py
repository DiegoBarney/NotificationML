import boto3
import json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('WebSocketConnections')

def lambda_handler(event, context):
    # Store the connection ID in DynamoDB
    connection_id = event['requestContext']['connectionId']
    table.put_item(Item={'connectionId': connection_id})
    return {'statusCode': 200}