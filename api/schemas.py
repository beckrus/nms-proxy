from pydantic import BaseModel, RootModel
from typing import List


class RemoteBase(BaseModel):
    name: str
    bits_received: str | None = None
    bits_recieved_bcast: str | None = None
    bits_sent: str | None = None
    cpu_usage: str | None = None
    crc8errors: str | None = None
    crc32errors: str | None = None
    downsnr: str | None = None
    memory_usage: str | None = None
    modcod: str | None = None
    ping: str | None = None
    satellite: str | None = None
    state: str | None = None
    state_01: str | None = None
    temperature: str | None = None
    upstream_cno: str | None = None
    upstream_tx_power: str | None = None
    uptime: str | None = None


class DiscoveryBase(BaseModel):
    did: int
    name: str


class DiscoveryRemotes(RootModel):
    root: List[DiscoveryBase] = []
