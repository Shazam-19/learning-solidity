import Web3 from "web3";
import fs from "fs";

const abi = JSON.parse(fs.readFileSync("./abi.json", "utf8"));

// DAI Stablecoin ABI
const INFURA_URL = "https://mainnet.infura.io/v3/4b4c67444e0c4f969fcff577e0e3ef52";

const web3 = new Web3(INFURA_URL);

// Address of DAI Stablecoin
const address = "0x6B175474E89094C44Da98b954EedeAC495271d0F";

async function main() {
    const contract = new web3.eth.Contract(abi, address);

    console.log("Subscribed to Transfer Event");

    contract.events.Transfer(
        {
            // Filter by sender
            filter: { src: "0x101253642682fA758034d9e123A0C64a56BA58D5"}
        },
        (error, log) => {
            if (error) {
                console.log("Error", error);
            }

            console.log("Log", log);
        }
    );

}

main();