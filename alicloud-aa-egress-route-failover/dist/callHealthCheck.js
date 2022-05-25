"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const axios_1 = __importDefault(require("axios"));
const https_1 = __importDefault(require("https"));
const { FULL_URL, API_KEY } = process.env;
exports.callHealthCheck = async function (event, context, callback) {
    console.log('Timer Function Called');
    var url = FULL_URL;
    const agent = new https_1.default.Agent({
        rejectUnauthorized: false
    });
    var options = {
        httpsAgent: agent,
        headers: {
            Authorization: 'Bearer ' + API_KEY
        }
    };
    try {
        console.log(`Calling ${FULL_URL}`);
        await axios_1.default.get(url, options);
    }
    catch (err) {
        console.error(`Error in CallHealthCheck Function. Error : ${err} `);
        callback(err);
    }
    // Terminate function.
    callback(null, 'CallHealthCheck Terminated.');
};
if (module === require.main) {
    exports.callHealthCheck(console.log);
}
