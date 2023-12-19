from fastapi import FastAPI
from schemas import RemoteBase, DiscoveryRemotes
from snmp import get_modem_data, get_modems
from config import (
    REGEX_FILTER,
    NMS_IP,
    NMS_COMMUNITY
)
app = FastAPI(title="AXESS Proxy")


@app.get("/")
async def root():
    return {'FILTER': REGEX_FILTER,
            'NMS': NMS_IP,
            'COMMUNITY': NMS_COMMUNITY}


@app.get("/modems", response_model=DiscoveryRemotes)
async def modems():
    return await get_modems()


@app.get("/modem_data", response_model=RemoteBase)
async def modem_data(did: int):
    return await get_modem_data(did)
