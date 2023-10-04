"""Enrich Headers Lambda Handler, the entry point of the lambda function"""

import os
import json
import boto3

from spine_aws_common import SNSApplication
from aws_lambda_powertools.utilities.data_classes.sns_event import SNSEventRecord
from requests import post


budget_sns_topic_arn = os.environ["BUDGET_SNS_TOPIC_ARN"]
budget_webhook_ssm_name = os.environ["BUDGET_WEBHOOK_SSM_NAME"]
cloudwatch_sns_topic_arn = os.environ["CLOUDWATCH_SNS_TOPIC_ARN"]
cloudwatch_webhook_ssm_name = os.environ["CLOUDWATCH_WEBHOOK_SSM_NAME"]


client = boto3.client("ssm")
response = client.get_parameter(Name=budget_webhook_ssm_name, WithDecryption=True)
budget_webhook = response["Parameter"]["Value"]

response = client.get_parameter(Name=cloudwatch_webhook_ssm_name, WithDecryption=True)
cloudwatch_webhook = response["Parameter"]["Value"]


class MsTeams(SNSApplication):
    """
    Send messages to Microsoft Teams
    """

    def process_record(self, record: SNSEventRecord):
        print(record)
        if record.sns.topic_arn == budget_sns_topic_arn:
            print("budget alarm")
            budget_alarm = self.generate_budget_teams_alarm(record)
            self.send_message_to_teams(budget_alarm, budget_webhook)
        elif record.sns.topic_arn == cloudwatch_sns_topic_arn:
            print("Cloudwatch Alarm")
            message = json.loads(record.sns.message)
            cloudwatch_alarm = self.generate_cloudwatch_teams_alert(message)
            self.send_message_to_teams(cloudwatch_alarm, cloudwatch_webhook)
        else:
            print("not recognized alarm")

    def generate_budget_teams_alarm(self, record: SNSEventRecord) -> dict:
        """Generate a teams alert based on a budget alert

        Args:
            sns (dict): The SNS record
        """
        print("started budget teams message")
        subject = record.sns.subject
        message = record.sns.message

        card = {
            "@type": "MessageCard",
            "@context": "https://schema.org/extensions",
            "themeColor": "0076D7",
            "summary": subject,
            "sections": [
                {
                    "activityTitle": subject,
                    "activitySubtitle": "Notify a Patient",
                    "facts": [
                        {"name": "status", "value": "\U0001F534"},
                        {"name": "reason", "value": message},
                    ],
                    "markdown": True,
                }
            ],
        }

        return card

    def generate_cloudwatch_teams_alert(self, message: dict) -> None:
        """Generate a teams alert based on a cloudwatch alert

        Args:
            message (dict): the SNS message content
        """
        print("started cloudwatch teams message")
        alarm_name = message["AlarmName"]
        alarm_description = message["AlarmDescription"]
        old_state = message["OldStateValue"]
        new_state = message["NewStateValue"]
        reason = message["NewStateReason"]

        state_colour = {"alarm": "\U0001F534", "ok": "\U0001F7E2"}  # Red Circle `` # Green Circle

        card = {
            "@type": "MessageCard",
            "@context": "https://schema.org/extensions",
            "themeColor": "0076D7",
            "summary": alarm_name,
            "sections": [
                {
                    "activityTitle": alarm_name,
                    "activitySubtitle": "Notify a Patient",
                    "facts": [
                        {"name": "new status", "value": state_colour[new_state.lower()]},
                        {"name": "old status", "value": state_colour[old_state.lower()]},
                        {"name": "reason", "value": reason},
                    ],
                    "markdown": True,
                }
            ],
            "potentialAction": [
                {
                    "@type": "OpenUri",
                    "name": "Playbook",
                    "targets": [{"os": "default", "uri": alarm_description}],
                }
            ],
        }

        return card

    def send_message_to_teams(self, message: dict, url: str) -> None:
        """Send a message to teams

        Args:
            message (dict): The message to be sent
            url (str): the url to send to
        """
        post(url=url, json=message, timeout=10)


msteams = MsTeams()


def lambda_handler(event: dict, context: dict) -> str:
    """Lambda handler function for Enrich Headers
    Args:
        event (dict): s3 put event from bulked messages bucket
        context (dict): aws lambda context
    """
    return msteams.main(event, context)
