module Types exposing (..)

type alias Model =
    { master1 : String
    , master2 : String
    , encrypt_input : String
    , encrypt_output : String
    , decrypt_input: String
    , decrypt_output: String
    , enc : Enc
    }

type alias Enc =
    { text : String
    , salt : Hex
    , iv : Hex
    }

type alias Hex = String

type Msg = Master1 String   -- master pass1 input handler
         | Master2 String   -- master pass2 input handler
         | Encrypt String   -- encrypt text input handler
         | Encryptor        -- encrypt button handler
         | Decrypt String   -- decrypt text input handler
         | Decryptor        -- decrypt button handler
         | Encrypted Enc    -- encrypted result object
         | Decrypted String -- decrypted result text
