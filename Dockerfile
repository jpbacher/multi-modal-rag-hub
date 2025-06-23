# start with this base image
FROM public.ecr.aws/lambda/python:3.10

# install dependencies
RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install -r requirements.txt

# copy the function code into container
# var/task is the default directory for Lambda functions
COPY handler.py  var/task/
COPY core/       var/tassk/core/
COPY loaders/    var/task/loaders/
COPY prompts/    var/task/prompts/

# invoke the Lambda function handler when the container starts
# the entry point for the Lambda function
CMD ["handler.lambda_handler"]
