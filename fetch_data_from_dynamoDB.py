import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('CSV_DATA')

def lambda_handler(event, context):
    try:
        response = table.scan()
        tasks = response.get('Items', [])

        return {
            'statusCode': 200,
            'body': json.dumps(tasks),
            'headers': {
                'Content-Type': 'application/json'
            }
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
