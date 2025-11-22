#[test_only]
module solcipher::sol_cipher_tests {
    use solcipher::sol_cipher;
    use std::string;
    use aptos_framework::account;
    use aptos_framework::timestamp;

    #[test(account = @0x42)]
    fun test_encrypt_decrypt(account: &signer) {
        timestamp::set_time_has_started_for_testing(true);

        let key = x"00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff";
        let msg = string::utf8(b"GM Aptos — this message is encrypted on-chain!");

        sol_cipher::encrypt(account, msg, copy key);

        let recovered = sol_cipher::decrypt(account, key);
        assert!(recovered == msg, 1);
    }

    #[test(account = @0x43)]
    #[expected_failure(abort_code = 3)]
    fun test_wrong_key_fails(account: &signer) {
        timestamp::set_time_has_started_for_testing(true);

        let key = x"deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef";
        let wrong_key = x"beefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdead";

        sol_cipher::encrypt(account, string::utf8(b"secret"), copy key);
        let _ = sol_cipher::decrypt(account, wrong_key); // should abort
    }
}
