import { AptosClient, AptosAccount, FaucetClient, BCS, TxnBuilderTypes } from "aptos";

const client = new AptosClient("https://fullnode.mainnet.aptoslabs.com/v1");
const account = AptosAccount.fromAptosAccountObject({ ... });

async function encryptMessage(message: string, keyHex: string) {
  const payload = new TxnBuilderTypes.TransactionPayloadEntryFunction(
    TxnBuilderTypes.EntryFunction.natural(
      "0xYOUR_PUBLISHED_ADDRESS::sol_cipher",
      "encrypt",
      [],
      [BCS.bcsSerializeStr(message), BCS.bcsSerializeBytes(Buffer.from(keyHex, "hex"))]
    )
  );

  const txn = await client.generateSignSubmitTransaction(account, payload);
  console.log("Encrypted:", txn.hash);
}
