""" this is an example lambda function for lambda_terraform_template """

from os import environ

def lambda_handler(event, context):
    """ hello world function for the repo """
    # log something
    print(environ.get('THING_TO_SAY', "This is the default thing to say"))
    return True