module solcipher::sol_cipher {
    use std::error;
    use std::signer;
    use std::vector;
    use std::string::{Self, String};
    use aptos_framework::timestamp;

    /// Errors
    const E_NO_MESSAGE: u64 = 1;
    const E_INVALID_KEY: u64 = 2;
    const E_DECRYPTION_FAILED: u64 = 3;

    /// Stored encrypted message (owned resource)
    struct EncryptedMessage has key {
        ciphertext: vector<u8>,
        created_at: u64,
    }

    /// Encrypt and store message on-chain
    public entry fun encrypt(
        account: &signer,
        message: String,
        key: vector<u8>
    ) {
        let bytes = string::bytes(&message);
        assert!(!vector::is_empty(&key), error::invalid_argument(E_INVALID_KEY));
        assert!(vector::length(bytes) <= 1024, error::invalid_argument(4));

        let ciphertext = xor_with_key(bytes, &key);

        let addr = signer::address_of(account);
        if (exists<EncryptedMessage>(addr)) {
            let msg = move_from<EncryptedMessage>(addr);
            let EncryptedMessage { ciphertext: _, created_at: _ } = msg;
        };

        move_to(account, EncryptedMessage {
            ciphertext,
            created_at: timestamp::now_seconds(),
        });
    }

    /// Decrypt your own message
    public fun decrypt(
        account: &signer,
        key: vector<u8>
    ): String acquires EncryptedMessage {
        let addr = signer::address_of(account);
        assert!(exists<EncryptedMessage>(addr), error::not_found(E_NO_MESSAGE));

        let msg = borrow_global<EncryptedMessage>(addr);
        let plaintext_bytes = xor_with_key(&msg.ciphertext, &key);

        // Basic integrity: if it's not valid UTF-8, probably wrong key
        if (!string::is_valid_utf8(&plaintext_bytes)) {
            abort error::invalid_argument(E_DECRYPTION_FAILED)
        };

        string::utf8(plaintext_bytes)
    }

    /// View ciphertext (public)
    public fun view_ciphertext(addr: address): vector<u8> acquires EncryptedMessage {
        assert!(exists<EncryptedMessage>(addr), error::not_found(E_NO_MESSAGE));
        borrow_global<EncryptedMessage>(addr).ciphertext
    }

    /// Internal: streaming XOR (same for encrypt/decrypt)
    fun xor_with_key(data: &vector<u8>, key: &vector<u8>): vector<u8> {
        let result = vector::empty<u8>();
        let key_len = vector::length(key);
        let mut i = 0;
        let data_len = vector::length(data);

        while (i < data_len) {
            let key_byte = *vector::borrow(key, i % key_len);
            let data_byte = *vector::borrow(data, i);
            vector::push_back(&mut result, data_byte ^ key_byte);
            i = i + 1;
        };
        result
    }

    // Optional: burn the message forever
    public entry fun burn(account: &signer) acquires EncryptedMessage {
        let addr = signer::address_of(account);
        if (exists<EncryptedMessage>(addr)) {
            let EncryptedMessage { ciphertext: _, created_at: _ } = move_from<EncryptedMessage>(addr);
        }
    }
}
