#!/usr/bin/env python3
'''
Simple MFA authenticator for AWS IAM USER
creates new provile with name based on main profile mfa_#PROFILE#
'''
import argparse, boto3,os ,configparser

#Get Parameters
parser = argparse.ArgumentParser()
parser.add_argument("serial",help="Serial number of Assigned MFA device i.e.: arn:aws:iam::0123456677:mfa/some_name")
parser.add_argument("token",default="default",help="Token from MFA")
parser.add_argument("--profile",default="default",help="Name of profile that will use that access")
args=parser.parse_args()

# Get Token:
session = boto3.session.Session(profile_name=args.profile)
client = session.client('sts')
token = client.get_session_token(
    SerialNumber=args.serial,
    TokenCode=args.token
)

# Save Config
config_path = os.path.expanduser("~") + "/.aws/credentials"
config = configparser.ConfigParser()
config.read(config_path)

mfa_profile = "mfa_"+args.profile
config[mfa_profile] = {
    'aws_access_key_id': token['Credentials']['AccessKeyId'],
    'aws_secret_access_key': token['Credentials']['SecretAccessKey'],
    'aws_session_token': token['Credentials']['SessionToken']
}
with open(config_path, 'w') as configfile:
    config.write(configfile)
print ('Access Granted. Config written to file')