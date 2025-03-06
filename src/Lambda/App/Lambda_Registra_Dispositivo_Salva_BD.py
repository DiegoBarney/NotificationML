import boto3
import json

# inicializa SNS e DynamoDB
sns_client = boto3.client('sns')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('UserDevices')

def lambda_handler(event, context):
    # Parse input from API Gateway
    body = json.loads(event['body'])
    device_token = body['device_token']
    user_id = body['user_id']

    # Registra dispositivo no serviço SNS (Pode ser uma lambda, APNS, FCM.... )
    platform_application_arn = 'arn:aws:sns:us-east-1:123456789012:app/APNS/my-app'
    response = sns_client.create_platform_endpoint(
        PlatformApplicationArn=platform_application_arn,
        Token=device_token
    )
    endpoint_arn = response['EndpointArn']

    # armazena dados no DynamoDB
    table.put_item(
        User={
            "user_id": user_id,
            "registered-devices-tokens":[ "token-device-1-FCM-example-skaksdkas",
                                           "token-device-2-APNS-example-skaksdkas"
            ],
            "endpoint_arn": [endpoint_arn],
            "user-data": {
               .......
            },
  
            "opt_out": False
        }
    )

    # Retorna successo 
    return {
        'statusCode': 200,
        'body': json.dumps({'endpoint_arn': endpoint_arn})
    }