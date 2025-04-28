import boto3
import json

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    print("Event:", event)

    for record in event['Records']:
        message = json.loads(record['body'])  
        
        bucket_name = message['bucket']
        object_key = message['key']

        response = s3_client.delete_object(Bucket=bucket_name, Key=object_key)
        print(f"Deleted {object_key} from {bucket_name}")
    
    return {
        'statusCode': 200,
        'body': 'Files deleted successfully.'
    }
