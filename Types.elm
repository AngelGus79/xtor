module Types exposing (..)

type alias Model =
    { master1 : String
    , master2 : String
    , encrypt_input : String
    , encrypt_output : String
    , decrypt_input: String
    , decrypt_output: String
    , enc_obj : Enc
    }

type alias Enc =
    { text : String
    , salt : Hex
    , iv : Hex
    }

type alias Hex = String

type Msg = Master1 String
         | Master2 String
         | Encrypt
         | Decrypt
         | Encrypted Enc
         | Decrypted String
