import os

import boto3

print("Hello !!")

print("Hii")
def lambda_handler(event, context):
    s3 = boto3.client("s3")
    BUCKET_NAME = os.environ.get("AWS_S3_BUCKET_NAME", "listingproject")
    SOURCE_PREFIX = event.get(
        "AWS_S3_SMARTY_DATASET_BUCKET_PREFIX",
        os.environ.get("AWS_S3_SMARTY_DATASET_BUCKET_PREFIX", "smarty_dataset/"),
    )
    N = event.get("MAX_FILES", 10)
    response = s3.list_objects_v2(Bucket=BUCKET_NAME, Prefix=SOURCE_PREFIX)
    files = [
        obj["Key"]
        for obj in response.get("Contents", [])
        if obj["Key"].endswith(".json")
    ]
    files = files[:N]
    return {"hasFiles": len(files) > 0, "files": files}
