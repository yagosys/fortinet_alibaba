"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.RouteFailover = void 0;
const pop_core_1 = __importDefault(require("@alicloud/pop-core"));
const net = __importStar(require("net")); // TCP health check.
const { ACCESS_KEY_ID, ACCESS_KEY_SECRET, ENDPOINT_ESS, ENDPOINT_ECS, REGION, PRIMARY_FORTIGATE_ID, SECONDARY_FORTIGATE_ID, PRIMARY_FORTIGATE_SEC_ENI, SECONDARY_FORTIGATE_SEC_ENI, PIN_TO // takes  instanceId or 'both'
 } = process.env, CLIENT_TIMEOUT = Number(process.env.CLIENT_TIMEOUT) || 5000, TCP_HEALTH_CHECK_TIMEOUT = Number(process.env.TCP_HEALTH_CHECK_TIMEOUT) || 3000, TCP_PROBE_PORT = Number(process.env.TCP_PROBE_PORT) || 22, ROUTE_TABLE_ID = (process.env.ROUTE_TABLE_ID && process.env.ROUTE_TABLE_ID.split(',')) || [], TIME_BETWEEN_ROUTE_TABLE_CALLS = Number(process.env.TIME_BETWEEN_ROUTE_TABLE_CALLS) || 1500;
const client = new pop_core_1.default({
    accessKeyId: ACCESS_KEY_ID,
    accessKeySecret: ACCESS_KEY_SECRET,
    endpoint: ENDPOINT_ESS,
    apiVersion: '2016-04-28',
    opts: {
        timeout: CLIENT_TIMEOUT
    }
});
const ecsClient = new pop_core_1.default({
    accessKeyId: ACCESS_KEY_ID,
    accessKeySecret: ACCESS_KEY_SECRET,
    endpoint: ENDPOINT_ECS,
    apiVersion: '2014-05-26',
    opts: {
        timeout: CLIENT_TIMEOUT
    }
});
class RouteFailover {
    async getFortigateHealth(instanceId) {
        const getFortigateIp = await this.getInstanceIp(instanceId);
        try {
            await this.tcpCheck(getFortigateIp, TCP_PROBE_PORT, TCP_HEALTH_CHECK_TIMEOUT);
        }
        catch (err) {
            console.log(`${instanceId}  did not respond to health check
                TCPHealthCheck error: ${err}`);
            return false;
        }
        return true;
    }
    async getSecondaryEniHealth(instanceId) {
        let getSecondaryEniIp;
        try {
            getSecondaryEniIp = await this.getSecondaryEniIp(instanceId);
        }
        catch (err) {
            console.log(`Error in getSecondaryENIHhealth with instanceid ${instanceId} `, err);
        }
        if (!getSecondaryEniIp) {
            console.error(`getSecondaryEniIp returned falsy value. Returning false. For instanceId ${instanceId}.`);
            return false;
        }
        try {
            await this.tcpCheck(getSecondaryEniIp, TCP_PROBE_PORT, TCP_HEALTH_CHECK_TIMEOUT);
        }
        catch (err) {
            console.log(`${instanceId}  did not respond to health check
                TCPHealthCheck error: ${err}`);
            return false;
        }
        return true;
    }
    async updateRoute(route, newInstance, routeTableId) {
        // Delete the route
        await this.removeRoute(route.InstanceId, routeTableId, route.DestinationCidrBlock);
        let tempTime = Date.now();
        let currentTime;
        // Check to see if the route table is available to be updated.
        // Requests can not be done in parallel, or all at once.
        let isRouteTableAvailable = await this.getRouteTableStatus(routeTableId);
        while (!isRouteTableAvailable) {
            currentTime = Date.now();
            // Wait 1.5 seconds between calls
            if (currentTime > tempTime + TIME_BETWEEN_ROUTE_TABLE_CALLS) {
                tempTime = Date.now();
                isRouteTableAvailable = await this.getRouteTableStatus(routeTableId);
            }
        }
        isRouteTableAvailable = await this.getRouteTableStatus(routeTableId);
        tempTime = Date.now();
        // Wait for the route to become available. Updates can only happen in serial.
        while (!isRouteTableAvailable) {
            currentTime = Date.now();
            // Wait 1.5 seconds between calls
            if (currentTime > tempTime + TIME_BETWEEN_ROUTE_TABLE_CALLS) {
                tempTime = Date.now();
                isRouteTableAvailable = await this.getRouteTableStatus(routeTableId);
            }
        }
        if (isRouteTableAvailable) {
            try {
                await this.createRoute(routeTableId, newInstance, route.DestinationCidrBlock, route.RouteEntryName);
            }
            catch (err) {
                throw console.error(`Failed to add route ${route.DestinationCidrBlock} with instanceId ${newInstance} to ${ROUTE_TABLE_ID}`);
            }
        }
    }
    // Return true/false if route table is busy or free
    async getRouteTableStatus(routeId) {
        let getUpdatedRouteTable;
        try {
            getUpdatedRouteTable = await this.describeRouteTableList(routeId);
        }
        catch (err) {
            throw console.error('Error in checkState, failed to describe route table');
        }
        for (const item of getUpdatedRouteTable.RouteTables.RouteTable[0].RouteEntrys.RouteEntry) {
            if (item.Status !== 'Available') {
                return false;
            }
        }
        // Return true if no Status other than Available is found
        return true;
    }
    tcpCheck(fortigateIp, tcpProbePort, tcpHealthCheckTimeout) {
        return new Promise((resolve, reject) => {
            const socket = net.createConnection(tcpProbePort, fortigateIp, connected);
            const timeout = setTimeout(() => {
                socket.end();
                reject('timeout');
            }, tcpHealthCheckTimeout);
            socket.on('error', reject);
            function connected() {
                socket.end();
                clearTimeout(timeout);
                resolve();
            }
        });
    }
    async describeECSInstance(region) {
        const parameters = {
            RegionId: region
        };
        const options = {
            method: 'POST'
        };
        try {
            const clientData = await ecsClient.request('DescribeInstances', parameters, options);
            return clientData;
        }
        catch (err) {
            console.error(`Unable to fetch instances list from region: ${region}. Error: ${err}`);
            throw err;
        }
    }
    async getSecondaryEniIp(instanceId) {
        var _a, _b;
        console.log(`Getting Ip for Secondary ENI of ${instanceId}`);
        let getClientList;
        try {
            getClientList = await this.describeECSInstance(REGION);
        }
        catch (err) {
            console.error(`Unable to retrieve IP for secondary ENI of ${instanceId}`);
            throw err;
        }
        if ((_a = getClientList.Instances) === null || _a === void 0 ? void 0 : _a.Instance) {
            for (const item of getClientList.Instances.Instance) {
                if (item.InstanceId === instanceId) {
                    // Ensure we have a secondary nic or else raise an error.
                    if ((_b = item.NetworkInterfaces) === null || _b === void 0 ? void 0 : _b.NetworkInterface[1]) {
                        return item.NetworkInterfaces.NetworkInterface[1].PrimaryIpAddress;
                    }
                    else {
                        console.error(`Did not find second nic for ${instanceId} in ${REGION}.`);
                        return null;
                    }
                }
            }
            console.log(`Did not find instance ${instanceId} in ${REGION}. `);
            return '';
        }
        else {
            const err = new Error(`Error parsing Instance JSON in getSecondaryEniIp. instanceId: ${instanceId}.`);
            console.error(err.message);
            throw err;
        }
    }
    async getInstanceIp(instanceId) {
        var _a;
        console.log(`Getting Ip for instance ${instanceId}`);
        const getClientList = await this.describeECSInstance(REGION);
        if ((_a = getClientList.Instances) === null || _a === void 0 ? void 0 : _a.Instance) {
            for (const item of getClientList.Instances.Instance) {
                if (item.InstanceId === instanceId) {
                    console.log(item.NetworkInterfaces.NetworkInterface[0].PrimaryIpAddress);
                    return item.NetworkInterfaces.NetworkInterface[0].PrimaryIpAddress;
                }
            }
            throw console.error('error in getInstanceIp');
        }
        else {
            const err = new Error(`Error in GetInstanceIp, Could not parse data for ${instanceId}`);
            console.error(err);
            throw err;
        }
    }
    async removeAllTaggedRoutes(tag, routeId) {
        var _a, _b, _c;
        console.log(`Removing All routes with Tag ${tag}`);
        const getRoutesList = await this.describeRouteTableList(routeId);
        if ((_c = (_b = (_a = getRoutesList === null || getRoutesList === void 0 ? void 0 : getRoutesList.RouteTables) === null || _a === void 0 ? void 0 : _a.RouteTable[0]) === null || _b === void 0 ? void 0 : _b.RouteEntrys) === null || _c === void 0 ? void 0 : _c.RouteEntry) {
            for (const item of getRoutesList.RouteTables.RouteTable[0].RouteEntrys.RouteEntry) {
                if (item.RouteEntryName === tag) {
                    console.log(item.NextHopId, item.RouteTableId, item.DestinationCidrBlock);
                    // NextHopId in deleting is the InstanceId when fetching the list.
                    await this.removeRoute(item.InstanceId, item.RouteTableId, item.DestinationCidrBlock);
                }
            }
        }
    }
    async removeRoute(nextHopID, routeTableId, destinationCidrBlock) {
        let isRouteTableAvailable = await this.getRouteTableStatus(routeTableId);
        while (!isRouteTableAvailable) {
            await new Promise(resolve => setTimeout(resolve, TIME_BETWEEN_ROUTE_TABLE_CALLS));
            isRouteTableAvailable = await this.getRouteTableStatus(routeTableId);
        }
        const parameters = {
            RegionId: REGION,
            RouteTableId: routeTableId,
            DestinationCidrBlock: destinationCidrBlock,
            NextHopId: nextHopID
        };
        const options = {
            method: 'POST'
        };
        try {
            console.log(`Removing Route ${destinationCidrBlock}/${nextHopID} from ${routeTableId}`);
            await client.request('DeleteRouteEntry', parameters, options);
        }
        catch (err) {
            console.error(`Error in removeRoute. Error deleting route ${err.message || err}`);
        }
    }
    async describeRouteTableList(routeId) {
        console.log(`describing route table ${routeId}`);
        const parameters = {
            RegionId: REGION,
            RouteTableId: routeId
        };
        const options = {
            method: 'POST'
        };
        try {
            return await client.request('DescribeRouteTables', parameters, options);
        }
        catch (err) {
            console.error('Error in describeRouteTableList. Error deleting route ', err);
            throw err;
        }
    }
    async createRoute(routeTableId, nextHopID, destinationCidrBlock, tagName) {
        console.log(`Creating Route ${destinationCidrBlock} to ${nextHopID}`);
        const parameters = {
            RegionId: REGION,
            RouteTableId: routeTableId,
            NextHopId: nextHopID,
            NextHopType: 'NetworkInterface',
            DestinationCidrBlock: destinationCidrBlock,
            RouteEntryName: tagName // set the tag
        };
        const options = {
            method: 'POST'
        };
        try {
            await client.request('CreateRouteEntry', parameters, options);
        }
        catch (err) {
            console.error('Error in createRoute. ', err);
        }
    }
    // Called ModifyRouteEntry in AliCloud, this will change the Label/name given to a route
    async changeRouteEntryTitle() {
        const parameters = {
            RegionId: REGION
        };
        const options = {
            method: 'POST'
        };
        try {
            console.log('Modifing route');
            await client.request('ModifyRouteEntry', parameters, options);
        }
        catch (err) {
            console.error('Error in modifyRoute. ', err);
        }
    }
}
exports.RouteFailover = RouteFailover;
exports.main = async (request, response) => {
    console.log('Function Started');
    let getRoutesList;
    const handleFailOver = new RouteFailover();
    // Check both instances to see if they are healthy since the Link status monitor does not
    // Show the calling instance ID or IP
    const [primaryHealthOK, secondaryHealthOK] = await Promise.all([
        handleFailOver.getSecondaryEniHealth(PRIMARY_FORTIGATE_ID),
        handleFailOver.getSecondaryEniHealth(SECONDARY_FORTIGATE_ID)
    ]);
    if (!primaryHealthOK && !secondaryHealthOK) {
        console.error('Neither Instance reported healthy.');
        // TODO: add probe until back up?
        console.error('Stopping check');
    }
    else if (primaryHealthOK && secondaryHealthOK) {
        console.log('Both Instances reported healthy');
        // If PIN_TO_INSTANCE enabled and both instances are healthy switch any routes to that instance.
        if (PIN_TO) {
            // If healthy and PIN_TO_INSTANCE is set to 'both'
            if (PIN_TO.toLowerCase() === 'both') {
                console.log('PIN_TO is set to both. Checking routes');
                // check each route table
                for (const routeId of ROUTE_TABLE_ID) {
                    getRoutesList = await handleFailOver.describeRouteTableList(routeId);
                    await changeRoutePinToBoth(getRoutesList, routeId);
                }
            }
            else if (PIN_TO === PRIMARY_FORTIGATE_SEC_ENI || SECONDARY_FORTIGATE_SEC_ENI) {
                console.log(`PIN_TO is set to ${PIN_TO} checking routes.`);
                for (const routeId of ROUTE_TABLE_ID) {
                    getRoutesList = await handleFailOver.describeRouteTableList(routeId);
                    await changeRoutePinToInstance(getRoutesList, routeId);
                }
            }
        }
        response.setStatusCode(200);
        response.setHeader('content-type', 'application/json');
        response.send('');
    }
    else if (primaryHealthOK && !secondaryHealthOK) {
        console.log(`Fortigate ${PRIMARY_FORTIGATE_ID} reported healthy
                            ${SECONDARY_FORTIGATE_ID} reported unhealthy
                 `);
        for (const routeId of ROUTE_TABLE_ID) {
            console.log(`checking route ${routeId}`);
            getRoutesList = await handleFailOver.describeRouteTableList(routeId);
            for (const item of getRoutesList.RouteTables.RouteTable[0].RouteEntrys.RouteEntry) {
                if (item.InstanceId === SECONDARY_FORTIGATE_SEC_ENI) {
                    console.log(`Changing Route for destination ${item.DestinationCidrBlock}`);
                    // If secondaryRoute is found within Route table, change to be primary
                    try {
                        await handleFailOver.updateRoute(item, PRIMARY_FORTIGATE_SEC_ENI, routeId);
                    }
                    catch (err) {
                        console.error(`Errror  Updating route:${err}`);
                    }
                }
            }
        }
        //Response is a buffer, expects a string.
        //Sending the response should start the termination of the function, which is the main goal.
        response.setStatusCode(200);
        response.setHeader('content-type', 'application/json');
        response.send('');
    }
    else if (!primaryHealthOK && secondaryHealthOK) {
        console.log(`Fortigate ${PRIMARY_FORTIGATE_ID} reported unhealthy
                           ${SECONDARY_FORTIGATE_ID} reported healthy
                `);
        for (const routeId of ROUTE_TABLE_ID) {
            console.log(`checking route ${routeId}`);
            getRoutesList = await handleFailOver.describeRouteTableList(routeId);
            for (const item of getRoutesList.RouteTables.RouteTable[0].RouteEntrys.RouteEntry) {
                console.log(PRIMARY_FORTIGATE_SEC_ENI, item.InstanceId);
                if (item.InstanceId === PRIMARY_FORTIGATE_SEC_ENI) {
                    console.log(`Changing Route for destination ${item.DestinationCidrBlock}`);
                    // If primary is found within Route table, change to be secondary
                    try {
                        await handleFailOver.updateRoute(item, SECONDARY_FORTIGATE_SEC_ENI, routeId);
                        await handleFailOver.updateRoute(item, PRIMARY_FORTIGATE_SEC_ENI, routeId);
                    }
                    catch (err) {
                        console.error(`Error Updating route: ${err}`);
                    }
                }
            }
        }
        response.setStatusCode(200);
        response.setHeader('content-type', 'application/json');
        response.send('');
    }
    // Change Routes for PIN_TO = 'both'
    // This is the default single custom route per AZ approach. Each FortiGate acts as an egress point.
    // On return to a healthy state the both FortiGates will handle egress traffic.
    async function changeRoutePinToBoth(routesList, routeId) {
        var _a, _b, _c;
        if ((_c = (_b = (_a = routesList === null || routesList === void 0 ? void 0 : routesList.RouteTables) === null || _a === void 0 ? void 0 : _a.RouteTable[0]) === null || _b === void 0 ? void 0 : _b.RouteEntrys) === null || _c === void 0 ? void 0 : _c.RouteEntry) {
            // Serialized because AliCloud can not handle more than one operation on a route
            // Table at a time.
            // The updateRoute/createRoute/removeRoute funcitons all have checks to see if a route is being operated on
            for (const item of routesList.RouteTables.RouteTable[0].RouteEntrys.RouteEntry) {
                if (item.RouteEntryName !== item.InstanceId) {
                    // Check to see if the Name is == to a defined Primary or secondary
                    // if so change that route. This will also avoid overwriting any non-FortiGate related values.
                    if (item.RouteEntryName === PRIMARY_FORTIGATE_SEC_ENI) {
                        console.log(`Changing route ${item.DestinationCidrBlock} back to ${PRIMARY_FORTIGATE_SEC_ENI}`);
                        await handleFailOver.updateRoute(item, PRIMARY_FORTIGATE_SEC_ENI, routeId);
                    }
                    else if (item.RouteEntryName === SECONDARY_FORTIGATE_SEC_ENI) {
                        console.log(`Changing route ${item.DestinationCidrBlock} back to ${SECONDARY_FORTIGATE_SEC_ENI}`);
                        // Handle each request individually and wait for it to finish.
                        // Requests can not run in parallel.
                        await handleFailOver.updateRoute(item, SECONDARY_FORTIGATE_SEC_ENI, routeId);
                    }
                }
            }
        }
    }
    // Change Routes when PIN_TO is set to a single instance
    async function changeRoutePinToInstance(routesList, routeId) {
        for (const item of routesList.RouteTables.RouteTable[0].RouteEntrys.RouteEntry) {
            // Compare to ENI to make sure we only change FortiGate specific routes i.e no system generated routes
            if (item.InstanceId !== PIN_TO &&
                (item.InstanceId === PRIMARY_FORTIGATE_SEC_ENI ||
                    item.InstanceId === SECONDARY_FORTIGATE_SEC_ENI)) {
                console.log(JSON.stringify(item));
                console.log(`PIN_TO is set,Changing Route for destination ${item.DestinationCidrBlock}
                to ${PIN_TO}
                `);
                // Serialized because AliCloud can not handle more than one operation on a route
                // Table at a time.
                // The updateRoute/createRoute/removeRoute funcitons all have checks to see if a route is being operated on
                await handleFailOver.updateRoute(item, PIN_TO, routeId);
            }
        }
    }
};
if (module === require.main) {
    exports.main(console.log);
}
