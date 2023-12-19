from dotenv import load_dotenv
import os

load_dotenv()

REGEX_FILTER = os.environ.get("REGEX_FILTER")
NMS_IP = os.environ.get("NMS_IP")
NMS_COMMUNITY = os.environ.get("NMS_COMMUNITY")
