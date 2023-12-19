from asyncio import create_task, gather
from pysnmp.hlapi.asyncio import (
    getCmd as getCmdAsync,
    SnmpEngine as SnmpEngineAsync,
    UdpTransportTarget as UdpTransportTargetAsync
)
from pysnmp.hlapi import *
import re
from config import NMS_IP, NMS_COMMUNITY, REGEX_FILTER
from collections import ChainMap

import logging
FORMAT = '%(asctime)s :: %(name)s :: %(levelname)s :: %(message)s'
logging.basicConfig(format=FORMAT, datefmt="%Y-%m-%d %H:%M:%S",)
logger = logging.getLogger('snmp')
logger.setLevel("INFO")


async def get_modems():
    result = []
    iterator = bulkCmd(
        SnmpEngine(),
        CommunityData(NMS_COMMUNITY, mpModel=1),
        UdpTransportTarget((NMS_IP, 161)),
        ContextData(),
        0, 50,
        ObjectType(ObjectIdentity('1.3.6.1.4.1.13732.1.1.1.1.7')),
        lexicographicMode=False
    )
    MAX_REPS = 15000
    count = 0
    while (count < MAX_REPS):
        try:
            errorIndication, errorStatus, errorIndex, varBinds = next(iterator)
            did, name = varBinds[0].prettyPrint().split(' = ')
            match_re = re.search(f'{REGEX_FILTER}', name)
            if match_re:
                result.append(
                    {'did': did.split('.')[-1], 'name': name})
        except StopIteration:
            break

        count += 1

    return result


async def get_data(did, oid, key):
    errorIndication, errorStatus, errorIndex, varBinds = await getCmdAsync(
        SnmpEngineAsync(),
        CommunityData(NMS_COMMUNITY),
        UdpTransportTargetAsync((NMS_IP, 161), timeout=2.0, retries=3),
        ContextData(),
        ObjectType(ObjectIdentity(f'{oid}.{did}')),
        lexicographicMode=False
    )
    if errorIndication:
        err_msg = errorIndication
        return {key: f'{err_msg}'}
    elif errorStatus:
        err_msg = ('%s at %s' % (errorStatus.prettyPrint(),
                                 errorIndex and varBinds[int(errorIndex) - 1][0] or '?'))
        return {key: f'{err_msg}'}
    try:
        return {key: varBinds[0].prettyPrint().split(' = ')[-1]}
    except:
        logger.error(f'{errorIndication}')
        return {key: f'{errorIndication}'}


async def get_modem_data(did):
    oids = {
        'name': '1.3.6.1.4.1.13732.1.1.1.1.7',
        'bits_received': '1.3.6.1.4.1.13732.1.4.2.1.10',
        'bits_recieved_bcast': '1.3.6.1.4.1.13732.1.4.2.1.7',
        'bits_sent': '1.3.6.1.4.1.13732.1.4.2.1.14',
        'cpu_usage': '1.3.6.1.4.1.13732.1.4.3.1.47',
        'crc8errors': '.1.3.6.1.4.1.13732.1.4.3.1.20',
        'crc32errors': '.1.3.6.1.4.1.13732.1.4.3.1.21',
        'downsnr': '.1.3.6.1.4.1.13732.1.4.3.1.2',
        'memory_usage': '.1.3.6.1.4.1.13732.1.4.3.1.48',
        'modcod': '.1.3.6.1.4.1.13732.1.4.9.1.4',
        'ping': '1.3.6.1.4.1.13732.1.4.5.1.5',
        'satellite': '.1.3.6.1.4.1.13732.1.4.5.1.6',
        'state': '.1.3.6.1.4.1.13732.1.1.1.1.12',
        'state_01': '.1.3.6.1.4.1.13732.1.1.1.1.15',
        'temperature': '1.3.6.1.4.1.13732.1.4.3.1.8',
        'upstream_cno': '.1.3.6.1.4.1.13732.1.4.4.1.2',
        'upstream_tx_power': '1.3.6.1.4.1.13732.1.4.3.1.3',
        'uptime': '.1.3.6.1.4.1.13732.1.4.3.1.11',
    }
    result = {}
    tasks = []
    for key, oid in oids.items():
        tasks.append(create_task(get_data(did, oid, key)))
    results = await gather(*tasks)
    return dict(ChainMap(*results))
