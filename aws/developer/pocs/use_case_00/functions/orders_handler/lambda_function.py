import json


def lambda_handler(event, context):
    body = {
        "orderId": 1,
        "orderName": "Coca cola",
        "orderQuantity": 5,
        "orderPrice": 50,
        "orderStatus": "confirmed",
        "version": "2.0.0",
    }
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body),
    }
