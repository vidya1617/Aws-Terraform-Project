import boto3
import csv
import os
import json
import uuid

s3_client = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')
secretsmanager_client = boto3.client('secretsmanager')
sqs_client = boto3.client('sqs')

# Environment variables
SECRET_NAME = os.environ['SECRET_NAME']
SQS_QUEUE_URL = os.environ['SQS_QUEUE_URL']

def get_table_name():
    secret_response = secretsmanager_client.get_secret_value(SecretId=SECRET_NAME)
    secret = json.loads(secret_response['SecretString'])
    return secret['table_name']

def lambda_handler(event, context):
    print("Event:", event)
    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        object_key = record['s3']['object']['key']
        
        # Get CSV file from S3
        response = s3_client.get_object(Bucket=bucket_name, Key=object_key)
        csv_content = response['Body'].read().decode('utf-8').splitlines()
        
        # Parse CSV
        reader = csv.DictReader(csv_content)
        table_name = get_table_name()
        table = dynamodb.Table(table_name)

        for row in reader:
            # Clean up row (strip whitespace)
            item = {k.strip(): v.strip() for k, v in row.items()}

            # Ensure Partition Key (ID) and Sort Key (Name) are present
            if not item.get('ID'):
                item['ID'] = str(uuid.uuid4())  # Generate a UUID if missing

            if not item.get('name'):
                # You can decide to skip, fail, or generate a name
                raise Exception(f"Missing required 'name' in row: {item}")

            # Now safe to insert into DynamoDB
            table.put_item(Item=item)

        # Send message to SQS to trigger file deletion
        sqs_client.send_message(
            QueueUrl=SQS_QUEUE_URL,
            MessageBody=json.dumps({
                'bucket': bucket_name,
                'key': object_key
            })
        )

    return {
        'statusCode': 200,
        'body': 'CSV processed and message sent to SQS.'
    }
