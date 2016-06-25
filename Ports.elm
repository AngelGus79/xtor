port module Ports exposing (..)
import Types exposing (..)

port encrypt : (String, String) -> Cmd msg
port decrypt : (String, Enc) -> Cmd msg

port encrypted : (Enc -> msg) -> Sub msg
port decrypted : (String -> msg) -> Sub msg
