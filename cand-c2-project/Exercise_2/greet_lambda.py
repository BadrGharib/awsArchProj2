import os

def lambda_handler(event, context):
    info("{} from Lambda!".format(os.environ['greeting']))
    return "{} from Lambda!".format(os.environ['greeting'])
