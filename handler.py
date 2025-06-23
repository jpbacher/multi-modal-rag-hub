def lambda_handler(event, context):
    """
    Entry point for AWS Lambda. 
    ‘event’ will contain S3 notification payload,
    and ‘context’ has metadata about the invocation.
    """
    # logic to process event will go here
    print("Received event:", event)
    return {
        "statusCode": 200,
        "body": "Ingest process started successfully."
    }
