import json


def lambda_handler(event, context):
    """
    AWS Lambda function handler to process S3 events.
    """
    record = event["Records"][0]

    # Extract bucket name and object key from the event structure.
    bucket_name = record["s3"]["bucket"]["name"]
    object_key = record["s3"]["object"]["key"]

    # For debug, print out what we received:
    print(f"Triggered by bucket: {bucket_name}, key: {object_key}")

    return {
        "statusCode": 200,
        "body": json.dumps({
            "bucket": bucket_name,
            "key": object_key
        })
    }
