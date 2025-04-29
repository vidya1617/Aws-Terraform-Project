import json
import boto3
import base64
import os
import uuid
from datetime import datetime

s3_client = boto3.client('s3')
BUCKET_NAME = os.environ.get('BUCKET_NAME')

def lambda_handler(event, context):
    try:
        file_content = event["body"]

        if event.get("isBase64Encoded", False):
            file_content = base64.b64decode(file_content)
        else:
            file_content = file_content.encode('utf-8')

        # Generate a unique filename
        filename = f"{datetime.utcnow().strftime('%Y%m%d%H%M%S')}_{uuid.uuid4().hex}.csv"

        s3_client.put_object(
            Bucket=BUCKET_NAME,
            Key=filename,
            Body=file_content,
            ContentType='text/csv'
        )

        return {
            "statusCode": 200,
            "body": json.dumps({"message": f"File uploaded as '{filename}' in {BUCKET_NAME}."})
        }

    except Exception as e:
        print(e)
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
