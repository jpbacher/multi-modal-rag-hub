# start with this base image
FROM public.ecr.aws/lambda/python:3.10

# install dependencies
RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install -r requirements.txt

