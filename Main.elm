import Html exposing (..)
import Html.App as App exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Ports exposing (..)

main =
    App.program
        { init = init
        , update = update
        , subscriptions = subs
        , view = view
        }

init : (Model, Cmd Msg)
init = ( { master1 = ""
         , master2 = ""
         , encrypt_input = ""
         , encrypt_output = ""
         , decrypt_input = ""
         , decrypt_output = ""
         , enc_obj = { text = "", salt = "", iv = "" }
         }
       , Cmd.none
       )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Master1 str -> { model | master1 = str } ! []
        Master2 str -> { model | master2 = str } ! []
        Encrypt -> model ! [ encrypt (model.master1, model.encrypt_input) ]
        Decrypt -> model ! [ decrypt (model.master1, model.enc_obj) ]
        Encrypted enc -> { model | enc_obj = enc, encrypt_output = enc.text } ! []
        Decrypted str -> { model | decrypt_output = str } ! []

subs : Model -> Sub Msg
subs model =
    Sub.batch
        [ encrypted Encrypted
        , decrypted Decrypted
        ]

view : Model -> Html Msg
view model = text ""
