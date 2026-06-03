import Web3 from "web3";
import fs from "fs";

const abi = JSON.parse(fs.readFileSync("./abi.json", "utf8"));

// DAI Stablecoin ABI
const INFURA_URL = "https://mainnet.infura.io/v3/4b4c67444e0c4f969fcff577e0e3ef52";

const web3 = new Web3(INFURA_URL)

// Address of DAI Stablecoin
const address = "0x6B175474E89094C44Da98b954EedeAC495271d0F"

async function main() {
    const latest = await web3.eth.getBlockNumber();

    console.log("Latest Block: ", Number(latest));

    const contract = new web3.eth.Contract(abi, address);

    const logs = await contract.getPastEvents("Transfer", {
        fromBlock: latest - 100n,
        toBlock: latest,

        // filter by sender
        // filter: { src: "0x101253642682fA758034d9e123A0C64a56BA58D5" }

        // filter by receiver
        // filter: { dst: "0x0DAA66339ceE9Be0c838b8c21FFbfC10Ab6B3239" }
    });

    // console.log("Logs", logs, `${logs.length} logs`)

    
    // Print senders
    
    console.log(
       "Senders",
       logs.map(log => log.returnValues.src),
       `${logs.length} logs`
    );
    

    // Print receiver
    /*
    console.log(
        "Receivers",
        logs.map(log => log.returnValues.dst),
        `${logs.length} logs`
    );
    */
}

main();
