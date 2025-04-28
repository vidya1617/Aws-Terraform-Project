import json
import boto3
import base64
import os

s3_client = boto3.client('s3')
BUCKET_NAME = os.environ.get('BUCKET_NAME')

def lambda_handler(event, context):
    try:
        file_content = event["body"]
        
        if event.get("isBase64Encoded", False):
            # Decode if base64-encoded
            file_content = base64.b64decode(file_content)
        else:
            # Otherwise, treat as plain text
            file_content = file_content.encode('utf-8')

        filename = event["headers"].get("filename", "uploaded.csv")
        
        s3_client.put_object(
            Bucket=BUCKET_NAME,
            Key=filename,
            Body=file_content,
            ContentType='text/csv'  
        )

        return {
            "statusCode": 200,
            "body": json.dumps({"message": f"File '{filename}' uploaded successfully to {BUCKET_NAME}."})
        }

    except Exception as e:
        print(e)
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
